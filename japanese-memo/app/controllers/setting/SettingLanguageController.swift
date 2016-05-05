//
//  SettingLanguageController.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/5/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import UIKit
import SwiftyJSON

class SettingLanguageController: UITableViewController {
    
    var languages:[Language] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Network
    
    func loadData() {
        NetworkManager.availableLanguages { (success, object) in
            if success {
                self.languages.removeAll()
                if let rawJSON = object {
                    let json = JSON(rawJSON)
                    let articlesJson = json["available_languages"]
                    for (_, language):(String, JSON) in articlesJson {
                        self.languages.append(Language.init(json: language))
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("languageCell", forIndexPath: indexPath)

        let language = languages[indexPath.row]
        cell.textLabel?.text = language.name
        
        if language.isEqual(Default.getLanguage()) {
            cell.accessoryType = .Checkmark
        }
        else {
            cell.accessoryType = .None
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        Default.setLanguage(languages[indexPath.row])
        self.navigationController?.popViewControllerAnimated(true)
    }

}
