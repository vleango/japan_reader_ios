//
//  ReadIndexController.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/1/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import UIKit
import SwiftyJSON
import UIScrollView_InfiniteScroll

class ReadIndexController: UITableViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var articles = [Article]()
    let showSegue = "sToReadShowSegue"
    let tableViewImageCache = TableViewImageCacher.init()
    var nextPage:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide on swipe configs
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.hidesBarsWhenKeyboardAppears = true
        
        // auto height for cells
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160.0
        
        // configure infinite scrolling
        configureInfiniteScroll()
        
        // add refresh control
        // TODO: add refreshed time at to attributed string
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(ReadIndexController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        // load the data from network
        loadData()
    }
    
    // used with hidesBarsOnSwipe
    override func prefersStatusBarHidden() -> Bool {
        return navigationController?.navigationBarHidden ?? false
    }
    
    func refresh(sender:AnyObject) {
        nextPage = nil
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
    
    private func configureInfiniteScroll() {
        tableView.addInfiniteScrollWithHandler { (scrollView) -> Void in
            let tableView = scrollView as! UITableView
            self.loadData(tableView)
        }
    }
    
    // MARK: - Network
    private func loadData(infiniteScrollView:UITableView? = nil) {
        let selectedType = Article.articleTypes(rawValue: segmentedControl.selectedSegmentIndex)!
        
        var params:[String : AnyObject] = [:]
        if let validNextPage = nextPage {
            params["page"] = validNextPage
        }
        
        NetworkManager.reads(selectedType, params: params, callback: { (success, object) -> Void in
            
            // stop spinning if this is passed in
            if let validInfiniteScrollView = infiniteScrollView {
                validInfiniteScrollView.finishInfiniteScroll()
            }
            
            if success {
                if let rawJSON = object {
                    if infiniteScrollView == nil {
                        self.articles.removeAll() // clean up the data holder
                    }
                    let json = JSON(rawJSON)
                    let articlesJson = json["articles"]
                    for (_, article):(String, JSON) in articlesJson {
                        self.articles.append(Article.init(json: article))
                    }
                    
                    self.nextPage = (json["page"].intValue) + 1
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
        let cell = tableView.dequeueReusableCellWithIdentifier("articleCell", forIndexPath: indexPath) as! ReadIndexCell
        
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

    @IBAction func segmentedControlValueChanged(sender: UISegmentedControl) {
        nextPage = nil
        articles.removeAll()
        tableView.reloadData()
        loadData()
    }
    
}
