//
//  IndexViewController.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/1/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import UIKit
import SwiftyJSON


class SearchIndexController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var entries:[Entry] = []
    let showSegue = "sToSearchShowSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // auto height for cells
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToSearchVC(segue: UIStoryboardSegue) {
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == showSegue {
            let showVC = segue.destinationViewController as! SearchShowController
            showVC.entry = sender as! Entry
        }
    }
    
    // MARK: - UISearchBarDelegate methods
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        search(searchBar.text!)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    private func search(query:String) {
        NetworkManager.search(["search": ["query" : query]]) { (success, object) in
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
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath)
        
        let entry = entries[indexPath.row]
        
        var k_eleText:[String] = []
        for k_ele in entry.k_eles {
            k_eleText.append(k_ele.keb)
        }
        
        var r_eleText:[String] = []
        for r_ele in entry.r_eles {
            r_eleText.append(r_ele.reb)
        }
        
        cell.textLabel?.attributedText = NSAttributedString(string: "\(k_eleText.joinWithSeparator(", "))「\(r_eleText.joinWithSeparator(", "))」")
        var senseText:[String] = []
        for sense in entry.senses {
            senseText.append(sense.text)
        }
        cell.detailTextLabel?.attributedText = NSAttributedString(string: senseText.joinWithSeparator(", "))
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier(showSegue, sender: entries[indexPath.row])
    }

}
