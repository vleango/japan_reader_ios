//
//  FavoriteIndexController.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/7/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import UIKit
import SwiftyJSON
import DZNEmptyDataSet

class FavoriteIndexController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    var entries:[Entry] = []
    var articles:[Article] = []
    let tableViewImageCache = TableViewImageCacher.init()
    let searchSegue = "sToSearchShowSegue"
    let readSegue = "sToReadShowSegue"
    
    enum sections:Int {case read, search}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // auto height for cells
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160.0
        
        // DZNEmptyDataSet hide footer lines
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToFavoriteIndexVC(segue: UIStoryboardSegue) { }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.tableView.emptyDataSetSource == nil {
            // DZNEmptyDataSet init
            self.tableView.emptyDataSetSource = self
            self.tableView.emptyDataSetDelegate = self
            self.tableView.tableFooterView = UIView()
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Network
    func loadData() {
        NetworkManager.favorites { (success, object) in
            self.entries.removeAll()
            self.articles.removeAll()
            if success {
                self.entries.removeAll()
                if let rawJSON = object {
                    let json = JSON(rawJSON)
                    let entriesJson = json["entries"]
                    for (_, entry):(String, JSON) in entriesJson {
                        self.entries.append(Entry.init(json: entry))
                    }
                    let articlesJson = json["articles"]
                    for (_, article):(String, JSON) in articlesJson {
                        self.articles.append(Article.init(json: article))
                    }
                }
                
                self.tableView.reloadData()
                
                let articleImageURLs = self.articles.map({article in article.image_url})
                self.tableViewImageCache.start(articleImageURLs, callback: { (downloadedURL) -> Void in
                    for visibleCell in self.tableView.visibleCells {
                        if self.tableView.indexPathForCell(visibleCell)!.section == sections.read.rawValue {
                            let readIndexCell = visibleCell as! ReadIndexCell
                            if readIndexCell.article.image_url == downloadedURL {
                                self.tableViewImageCache.setImageFor(downloadedURL, imageView: readIndexCell.coverImageView)
                            }
                        }
                    }
                })
                
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == searchSegue {
            let showVC = segue.destinationViewController as! SearchShowController
            showVC.entry = sender as! Entry
        }
        else if segue.identifier == readSegue {
            let showVC = segue.destinationViewController as! ReadShowController
            let article = sender as! Article
            showVC.artibutedArticle = ArtibutedArticle.init(article: article, coverImage: tableViewImageCache.imageCache[article.image_url!])
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var sectionCount = 0
        if entries.count > 0 || articles.count > 0 {
            sectionCount = 2
        }
        return sectionCount
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections(rawValue: section)! {
        case .search:
            return entries.count
        case .read:
            return articles.count
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch sections(rawValue: section)! {
        case .search:
            return "Search"
        case .read:
            return "Read"
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch sections(rawValue: indexPath.section)! {
        case .search:
            let cell = tableView.dequeueReusableCellWithIdentifier("favoritesSubtitleCell", forIndexPath: indexPath) as! SearchCell
            cell.configureCell(entries[indexPath.row])
            return cell
        case .read:
            let cell = tableView.dequeueReusableCellWithIdentifier("favoriteArticleCell", forIndexPath: indexPath) as! ReadIndexCell
            
            let article = articles[indexPath.row]
            cell.configureCell(article)
            
            if let validURL = article.image_url {
                if (tableViewImageCache.imageCache[validURL] != nil) {
                    cell.coverImageView.image = tableViewImageCache.imageCache[validURL]
                }
            }
            
            return cell
            
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var identifier = ""
        var sender:AnyObject?
        switch sections(rawValue: indexPath.section)! {
        case .search:
            identifier = searchSegue
            sender = entries[indexPath.row]
        case .read:
            identifier = readSegue
            sender = articles[indexPath.row]
        }
        performSegueWithIdentifier(identifier, sender: sender)
    }
    
    
    
    // MARK: - DZNEmptyDataSet Methods

    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let attrs = [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(18),
            NSForegroundColorAttributeName: UIColor.darkGrayColor()
        ]
        
        return NSAttributedString(string: "No Favorites found...", attributes: attrs)
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
        
        return NSAttributedString(string: "The articles that you read, or the new words that you learn can be saved for later use. Click on the upper-right Save button when you found something that you link.", attributes: attrs)
    }
    
}
