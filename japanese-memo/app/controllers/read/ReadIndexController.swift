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

    var articles = [Article]()
    private let showSegue = "sToReadShowSegue"
    private let tableViewImageCache = TableViewImageCacher.init()
    private var nextPage:Int?
    private let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set activityIndicator to NavItem
        activityIndicator.activityIndicatorViewStyle = .White
        let activityItem = UIBarButtonItem.init(customView: activityIndicator)
        let refreshItem = UIBarButtonItem.init(barButtonSystemItem: .Refresh, target: self, action: #selector(ReadIndexController.refresh(_:)))
        navigationItem.setLeftBarButtonItems([refreshItem, activityItem], animated: true)
        
        // auto height for cells
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160.0

        // configure infinite scrolling
        configureInfiniteScroll()

        // load the data from network
        loadData()
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
            showVC.artibutedArticle = ArtibutedArticle.init(article: article, coverImage: tableViewImageCache.imageCache[article.image_url!])
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
        //let selectedType = Article.articleTypes(rawValue: segmentedControl.selectedSegmentIndex)!
        
        var params:[String : AnyObject] = [:]
        if let validNextPage = nextPage {
            params["page"] = validNextPage
        }
        
        activityIndicator.startAnimating()
        NetworkManager.reads(params: params, callback: { (success, object) -> Void in
            
            // stop spinning if this is passed in
            if let validInfiniteScrollView = infiniteScrollView {
                validInfiniteScrollView.finishInfiniteScroll()
            }
            
            self.activityIndicator.stopAnimating()
            
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
        })
    }
    
    @IBAction func segmentedControlValueChanged(sender: UISegmentedControl) {
        nextPage = nil
        articles.removeAll()
        tableView.reloadData()
        loadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let article = articles[indexPath.row]
        
        let identifier = article.image_url == "" ? "articleNoCoverCell" : "articleCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! ReadIndexCell
        
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
    
    @IBAction func shuffleBtnClicked(sender: AnyObject) {
        NetworkManager.randomArticle { (success, object) in
            if let rawJSON = object {
                let json = JSON(rawJSON)
                let article = Article.init(json: json)
                self.performSegueWithIdentifier(self.showSegue, sender: article)
            }
        }
    }

}
