//
// Copyright © 2017 Esri.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit

protocol DownloadProgressViewDelegate: AnyObject {
    func downloadProgressViewDidCancel(_ downloadProgressView: DownloadProgressView)
}

class DownloadProgressView: UIView {
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var progressLabel: UILabel!
    @IBOutlet private var statusLabel: UILabel!
    
    private var newWindow: UIWindow!
    private var transparentShapeLayer: CAShapeLayer!
    private var shapeLayer: CAShapeLayer!
    private var bezierPath: UIBezierPath!
    private var radius: CGFloat = 30
    
    private var progress: CGFloat = 0.0
    
    weak var delegate: DownloadProgressViewDelegate?
    /// The progress object to use for updating the download progress view.
    var observedProgress: Progress? {
        willSet {
            fractionCompletedObservation = nil
        }
        didSet {
            fractionCompletedObservation = observedProgress?.observe(\.fractionCompleted) { [weak self] (progress, _) in
                DispatchQueue.main.async {
                    self?.updateProgress(progress: CGFloat(progress.fractionCompleted), animated: false)
                }
            }
        }
    }
    
    private var fractionCompletedObservation: NSKeyValueObservation?
    
    private var nibView: UIView!
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = .clear
        
        self.nibView = self.loadViewFromNib()
        
        self.nibView.frame = self.bounds
        nibView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.addSubview(self.nibView)
        
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.setupProgressView()
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "DownloadProgressView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }
    
    private func setupProgressView() {
        self.containerView.layer.cornerRadius = 14
        
        self.bezierPath = UIBezierPath(arcCenter: CGPoint(x: self.radius, y: self.radius), radius: self.radius, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi * 1.5, clockwise: true)
        
        self.transparentShapeLayer = CAShapeLayer()
        self.transparentShapeLayer.frame = CGRect(x: 0, y: 0, width: 2 * self.radius, height: 2 * self.radius)
        self.transparentShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: self.radius, y: self.radius), radius: self.radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true).cgPath
        self.transparentShapeLayer.fillColor = UIColor.clear.cgColor
        self.transparentShapeLayer.strokeColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
        self.transparentShapeLayer.lineWidth = 3
        
        self.progressLabel.layer.addSublayer(self.transparentShapeLayer)
        
        self.shapeLayer = CAShapeLayer()
        self.shapeLayer.frame = CGRect(x: 0, y: 0, width: 2 * self.radius, height: 2 * self.radius)
        self.shapeLayer.path = self.bezierPath.cgPath
        self.shapeLayer.fillColor = UIColor.clear.cgColor
        self.shapeLayer.strokeColor = UIColor.green.cgColor
        self.shapeLayer.lineWidth = 3
        self.shapeLayer.strokeEnd = 0
        
        self.progressLabel.layer.addSublayer(self.shapeLayer)
    }
    
    func show(withStatus status: String, progress: CGFloat) {
        self.statusLabel.text = status
        
        self.updateProgress(progress: progress, animated: false)
        
        self.show()
    }
    
    private func show() {
        self.frame = UIScreen.main.bounds
        
        if let newWindow = UIApplication.shared.windows.first(where: \.isKeyWindow) {
            newWindow.addSubview(self)
        }
    }
    
    func dismiss() {
        self.removeFromSuperview()
    }
    
    @IBAction private func cancelAction() {
        self.dismiss()
        self.delegate?.downloadProgressViewDidCancel(self)
    }
    
    func updateProgress(progress: CGFloat, animated: Bool) {
        if progress > 1 {
            self.progress = 1
        } else if progress < 0 {
            self.progress = 0
        } else {
            self.progress = progress
        }
        
        self.shapeLayer.removeAllAnimations()
        
        if animated {
            // create animation
            let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
            animation.duration = 0.2
            animation.fromValue = self.shapeLayer.strokeEnd
            animation.toValue = self.progress
            
            self.shapeLayer.strokeEnd = self.progress
            
            self.shapeLayer.add(animation, forKey: "strokeEnd")
        } else {
            self.shapeLayer.strokeEnd = self.progress
        }
        
        // progress label
        self.progressLabel.text = "\(Int(self.progress * 100))%"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let newCenter = CGPoint(x: self.shapeLayer.frame.width / 2 - self.progressLabel.frame.width / 2,
                                y: self.shapeLayer.frame.height / 2 - self.progressLabel.frame.height / 2)
        
        let newFrame = CGRect(x: -newCenter.x, y: -newCenter.y, width: 2 * self.radius, height: 2 * self.radius)
        self.shapeLayer.frame = newFrame
        self.transparentShapeLayer.frame = newFrame
    }
    
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            let locations: [CGFloat] = [0, 1]
            
            let colors: [CGColor] = [UIColor.black.withAlphaComponent(0).cgColor, UIColor.black.withAlphaComponent(0.75).cgColor]
            
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)!
            
            let center = self.center
            let radius = min(self.bounds.height, self.bounds.width)
            context.drawRadialGradient(gradient, startCenter: center, startRadius: 0, endCenter: center, endRadius: radius, options: CGGradientDrawingOptions.drawsAfterEndLocation)
        }
    }
}
