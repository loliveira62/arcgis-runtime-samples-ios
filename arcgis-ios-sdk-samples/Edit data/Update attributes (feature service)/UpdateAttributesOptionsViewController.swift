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

protocol UpdateAttributesOptionsViewControllerDelegate: AnyObject {
    func optionsViewController(_ optionsViewController: UpdateAttributesOptionsViewController, didSelectOptionAtIndex index: Int)
    func optionsViewControllerDidCancel(_ optionsViewController: UpdateAttributesOptionsViewController)
}

class UpdateAttributesOptionsViewController: UITableViewController {
    var options = [String]()
    weak var delegate: UpdateAttributesOptionsViewControllerDelegate?
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EAOptionsCell", for: indexPath)
        
        cell.textLabel?.text = options[indexPath.row]
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.optionsViewController(self, didSelectOptionAtIndex: indexPath.row)
    }
    
    // MARK: - Actions
    
    @IBAction func cancel() {
        delegate?.optionsViewControllerDidCancel(self)
    }
}
