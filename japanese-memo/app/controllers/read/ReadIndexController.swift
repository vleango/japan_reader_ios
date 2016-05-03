//
//  ReadIndexController.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/1/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReadIndexController: UITableViewController {

    var articles = [Article]()
    let showSegue = "sToReadShowSegue"
    let tableViewImageCache = TableViewImageCacher.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // auto height for cells
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        
        // add refresh control
        // TODO: add refreshed time at to attributed string
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(ReadIndexController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        // load the data from network
        loadData()
    }
    
    func refresh(sender:AnyObject) {
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == showSegue {
            let showVC = segue.destinationViewController as! ReadShowController
            let article = sender as! Article
            showVC.artibutedArticle = ArtibutedArticle.init(article: article, image: tableViewImageCache.imageCache[article.image_url!])
        }
    }
    
    // MARK: - Network
    private func loadData() {
        NetworkManager.reads({ (success, object) -> Void in
            if success {
                if let rawJSON = object {
                    let json = JSON(rawJSON)
                    let articlesJson = json["articles"]
                    for (_, article):(String, JSON) in articlesJson {
                        self.articles.append(Article.init(json: article))
                    }
                    self.tableView.reloadData()

                    let articleImageURLs = self.articles.map({article in article.image_url})
                    self.tableViewImageCache.start(articleImageURLs, callback: { (downloadedURL) -> Void in
                        for visibleCell in self.tableView.visibleCells {
                            let readIndexCell = visibleCell as! ReadIndexCell
                            if readIndexCell.article.image_url == downloadedURL {
                                self.tableViewImageCache.setImageFor(downloadedURL, imageView: readIndexCell.coverImageView)
                            }
                        }
                    })

                }
            }
            else {
                UtilManager.displayAlertView("Network Error", message: "An error has occurred", viewController: self)
            }
            
            self.refreshControl?.endRefreshing()
        })
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("artileCell", forIndexPath: indexPath) as! ReadIndexCell
        
        let article = articles[indexPath.row]
        cell.configureCell(article)

        if let validURL = article.image_url {
            if (tableViewImageCache.imageCache[validURL] != nil) {
                cell.coverImageView.image = tableViewImageCache.imageCache[validURL]
            }
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier(showSegue, sender: articles[indexPath.row])
    }

}
