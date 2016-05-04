//
//  SearchShowController.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/4/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import UIKit

class SearchShowController: UITableViewController {

    var entry:Entry!
    private enum sections:Int { case k_eles, r_eles, senses }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            title = "Meaning"
        }
        return title
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ShowCell", forIndexPath: indexPath)

        var text = ""
        switch sections(rawValue: indexPath.section)! {
        case .k_eles:
            let k_ele = entry.k_eles[indexPath.row]
            text = k_ele.keb
        case .r_eles:
            let r_ele = entry.r_eles[indexPath.row]
            text = r_ele.reb
        case .senses:
            let sense = entry.senses[indexPath.row]
            text = sense.text
        }
        
        cell.textLabel?.text = text
        
        return cell
    }

}
