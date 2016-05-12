//
//  IndexViewController.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/1/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import UIKit
import SwiftyJSON
import DZNEmptyDataSet

class SearchIndexController: UITableViewController, UISearchBarDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var entries:[Entry] = []
    var searchBarTextFromSearchVC:String?
    let showSegue = "sToSearchShowSegue"
    let newSegue = "sToEntryNewVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let searchBarText = searchBarTextFromSearchVC {
            searchBar.text = searchBarText
        }
        
        // auto height for cells
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.tableView.emptyDataSetSource == nil {
            
            // DZNEmptyDataSet init
            self.tableView.emptyDataSetSource = self
            self.tableView.emptyDataSetDelegate = self
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToSearchVC(segue: UIStoryboardSegue) {
        if searchBar != nil {
            searchBar.text = searchBarTextFromSearchVC
        }
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == showSegue {
            let showVC = segue.destinationViewController as! SearchShowController
            showVC.entry = sender as! Entry
        }
        else if segue.identifier == newSegue {
            let navVC = segue.destinationViewController as! UINavigationController
            let newVC = navVC.topViewController as! SearchNewController
            newVC.title = sender as? String
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
                self.searchBar.resignFirstResponder()
                
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

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath) as! SearchCell
        cell.configureCell(entries[indexPath.row])
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier(showSegue, sender: entries[indexPath.row])
    }
    
    // MARK: - DZNEmptyDataSet Methods
    
    func emptyDataSetShouldDisplay(scrollView: UIScrollView!) -> Bool {
        return searchBar.text != ""
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let attrs = [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(18),
            NSForegroundColorAttributeName: UIColor.darkGrayColor()
        ]
        
        return NSAttributedString(string: "Nothing Found...", attributes: attrs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragraph.alignment = NSTextAlignment.Center
        
        let attrs = [
            NSFontAttributeName: UIFont.systemFontOfSize(14),
            NSForegroundColorAttributeName: UIColor.lightGrayColor(),
            NSParagraphStyleAttributeName: paragraph
        ]
        
        return NSAttributedString(string: "The dictionary did not find anything matching your search. Would you like to add a new entry?", attributes: attrs)
    }
    
    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
        let attrs = [
            NSForegroundColorAttributeName: UIColor.blueColor()
        ]
        return NSAttributedString(string: "Add New", attributes: attrs)
    }
    
    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
        performSegueWithIdentifier(newSegue, sender: searchBar.text)
    }

}
