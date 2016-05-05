//
//  SettingIndexController.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/5/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import UIKit

class SettingIndexController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        // Set Default Language
        let languageCell = tableView.cellForRowAtIndexPath(NSIndexPath.init(forRow: 0, inSection: 0))
        languageCell?.textLabel?.text = Default.getLanguage().name
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
