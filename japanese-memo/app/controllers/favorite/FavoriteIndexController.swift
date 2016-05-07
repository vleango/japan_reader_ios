//
//  FavoriteIndexController.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/7/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import UIKit
import SwiftyJSON

// TODO: pretty much the same as SearchIndex but without the Searchbar...

class FavoriteIndexController: UITableViewController {

    var entries:[Entry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Network
    func loadData() {
        NetworkManager.favorites { (success, object) in
            if success {
                self.entries.removeAll()
                if let rawJSON = object {
                    let json = JSON(rawJSON)
                    let entriesJson = json["entries"]
                    for (_, entry):(String, JSON) in entriesJson {
                        self.entries.append(Entry.init(json: entry))
                    }
                }
                
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("favoritesSubtitleCell", forIndexPath: indexPath) as! SearchCell
        cell.configureCell(entries[indexPath.row])
        return cell
    }
    
}
