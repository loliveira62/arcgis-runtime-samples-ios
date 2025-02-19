//
// Copyright 2016 Esri.
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
import ArcGIS

class MapPackagesListViewController: UITableViewController, MapPackageCellDelegate {
    private var mapPackagesInBundle = [AGSMobileMapPackage]()
    private var mapPackagesInDocumentsDir = [AGSMobileMapPackage]()
    
    private var selectedRowIndexPath: IndexPath!
    private var selectedMap: AGSMap!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add the source code button item to the right of navigation bar
        (self.navigationItem.rightBarButtonItem as! SourceCodeBarButtonItem).filenames = ["MapPackagesListViewController", "MobileMapViewController", "MapPackageCell"]
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        self.fetchMapPackages()
    }
    
    func fetchMapPackages() {
        // Load map packages from the bundle.
        if let bundleMobileMapPackageURLs = Bundle.main.urls(forResourcesWithExtension: "mmpk", subdirectory: nil) {
            // Create map packages from the URLs.
            mapPackagesInBundle = bundleMobileMapPackageURLs.map(AGSMobileMapPackage.init(fileURL:))
        }
        
        // load map packages from the documents directory
        // added using iTunes
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let subpaths = FileManager.default.subpaths(atPath: documentDirectoryURL.path)!
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", ".*mmpk$")
        let mmpks = subpaths.filter { predicate.evaluate(with: $0) }
        let documentMobileMapPackageURLs = mmpks.map { documentDirectoryURL.appendingPathComponent($0) }
        
        // create map packages from the paths
        mapPackagesInDocumentsDir = documentMobileMapPackageURLs.map(AGSMobileMapPackage.init(fileURL:))
        
        self.tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return mapPackagesInBundle.count
        } else {
            return mapPackagesInDocumentsDir.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MapPackageCell", for: indexPath) as! MapPackageCell
        
        let mapPackage: AGSMobileMapPackage
        
        if indexPath.section == 0 {
            mapPackage = mapPackagesInBundle[indexPath.row]
        } else {
            mapPackage = mapPackagesInDocumentsDir[indexPath.row]
        }
        
        cell.mapPackage = mapPackage
        cell.isCollapsed = self.selectedRowIndexPath != indexPath
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "From the bundle" : "From the documents directory"
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // collapse previously expanded cell
        var indexPathsArray = [IndexPath]()
        indexPathsArray.append(indexPath)
        
        if self.selectedRowIndexPath != nil {
            if self.selectedRowIndexPath == indexPath {
                // collapse
                self.selectedRowIndexPath = nil
            } else {
                indexPathsArray.append(self.selectedRowIndexPath)
                self.selectedRowIndexPath = indexPath
            }
        } else {
            self.selectedRowIndexPath = indexPath
        }
        
        tableView.reloadRows(at: indexPathsArray, with: .automatic)
    }
    
    // MARK: - MapPackageCellDelegate
    
    func mapPackageCell(_ mapPackageCell: MapPackageCell, didSelectMap map: AGSMap) {
        self.selectedMap = map
        self.performSegue(withIdentifier: "MobileMapVCSegue", sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MobileMapVCSegue" {
            let controller = segue.destination as! MobileMapViewController
            controller.map = self.selectedMap
            
            var mapPackage: AGSMobileMapPackage!
            
            if self.selectedRowIndexPath.section == 0 {
                mapPackage = self.mapPackagesInBundle[self.selectedRowIndexPath.row]
            } else {
                mapPackage = self.mapPackagesInDocumentsDir[self.selectedRowIndexPath.row]
            }
            
            controller.locatorTask = mapPackage.locatorTask
            controller.title = mapPackage.item?.title
        }
    }
}
