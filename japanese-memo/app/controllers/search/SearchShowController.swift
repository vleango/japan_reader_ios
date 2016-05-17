//
//  SearchShowController.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/4/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchShowController: UITableViewController {

    @IBOutlet weak var saveBtn: UIBarButtonItem!
    var entry:Entry!
    private enum sections:Int { case k_eles, r_eles, senses }
    private enum saveBtnStates:String { case Save, Unsave }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // auto height for cells
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // need to resync with app
        let params:[String:AnyObject] = [
            "user[resource_type]" : "Jdict::Entry",
            "user[resource_id]" : entry.id
        ]
        NetworkManager.isFavorite(params) { (success, object) in
            if success {
                if let rawJSON = object {
                    let json = JSON(rawJSON)
                    let favoriteJson = json["favorite"]
                    self.entry.favoriteId = favoriteJson["id"].stringValue
                    if self.entry.favoriteId != "" {
                        // if the entry was saved, then we do remove
                        self.saveBtn.title = saveBtnStates.Unsave.rawValue
                    }
                    else {
                        // if the entry was NOT saved, then we do save
                        self.saveBtn.title = saveBtnStates.Save.rawValue
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        switch sections(rawValue: section)! {
        case .k_eles:
            count = entry.k_eles.count
        case .r_eles:
            count = entry.r_eles.count
        case .senses:
            count = entry.senses.count
        }
        return count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title:String?
        switch sections(rawValue: section)! {
        case .k_eles:
            title = "Kanji"
        case .r_eles:
            title = "Reading"
        case .senses:
            title = "Definition"
        }
        return title
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        var string:String?
        if section == sections.senses.rawValue && entry.userGenerated {
            string = "User generated entry"
        }
        return string
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchSubtitleCell", forIndexPath: indexPath) as! SubtitleCell

        var title = ""
        var subtitle = ""
        switch sections(rawValue: indexPath.section)! {
        case .k_eles:
            let k_ele = entry.k_eles[indexPath.row]
            title = k_ele.keb
            subtitle = k_ele.infsAndPrisAsString()
        case .r_eles:
            let r_ele = entry.r_eles[indexPath.row]
            title = r_ele.reb
            subtitle = r_ele.infsAndPrisAsString()
        case .senses:
            let sense = entry.senses[indexPath.row]
            title = sense.glossesAsString()
            subtitle = sense.infosAsString()
        }
        
        cell.configureCell(title, subtitle: subtitle)
        
        return cell
    }

    @IBAction func SaveBtnClicked(sender: AnyObject) {
        let toggle = saveBtn.title == saveBtnStates.Save.rawValue
        LoginManager.toggleEntry(toggle, entry: entry, fromViewController: self) { (success, object) in
            if success {
                if let rawJSON = object {
                    let json = JSON(rawJSON)
                    if json["status"].stringValue == "create" {
                        // entry saved
                        self.saveBtn.title = saveBtnStates.Unsave.rawValue
                        self.entry.favoriteId = json["favorite_id"].stringValue
                    }
                    else {
                        if json["user_generated"].boolValue {
                            self.navigationController?.popViewControllerAnimated(true)
                        }
                        else {
                            // entry removed
                            self.saveBtn.title = saveBtnStates.Save.rawValue
                        }
                    }
                }
            }
        }
    }
}
