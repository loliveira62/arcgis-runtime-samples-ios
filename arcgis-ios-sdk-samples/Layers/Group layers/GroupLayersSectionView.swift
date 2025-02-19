// Copyright 2019 Esri.
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

import UIKit

final class GroupLayersSectionView: UITableViewHeaderFooterView {
    @IBOutlet var layerNameLabel: UILabel!
    @IBOutlet var layerVisibilitySwitch: UISwitch?
    weak var delegate: GroupLayersSectionViewDelegate?
    
    static let reuseIdentifier = "\(GroupLayersSectionView.self)"
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }

    @IBAction func toggleSwitch(_ sender: UISwitch) {
        delegate?.didToggleSwitch(self, isOn: sender.isOn)
    }
}

protocol GroupLayersSectionViewDelegate: AnyObject {
    func didToggleSwitch(_ sectionView: GroupLayersSectionView, isOn: Bool)
}
