//
//  ReadActionsController.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/20/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import UIKit
import FBSDKShareKit
import SwiftyJSON

class ReadActionsController: UITableViewController {
    
    enum rows:Int {case share, like, save }
    var article:Article!
    private var saveCell:UITableViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSizeMake(200, 200)
        
        // DZNEmptyDataSet hide footer lines
        self.tableView.tableFooterView = UIView()
        
        // Add NotificationCenter Observer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(favoriteFromShowUpdated), name: Constants.notificationObservers.updateActionFavoriteIdNotificationKey, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        saveCell = tableView.cellForRowAtIndexPath(NSIndexPath.init(forRow: rows.save.rawValue, inSection: 0))
        if article.favoriteId != "" {
            saveCell.accessoryType = .Checkmark
        }
        
        // Share Button
        if let shareCell = tableView.cellForRowAtIndexPath(NSIndexPath.init(forRow: rows.share.rawValue, inSection: 0)) {
            
            let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
            content.contentURL = NSURL(string: article.appSource)
            content.contentTitle = article.title
            content.contentDescription = article.body
            let shareButton = FBSDKShareButton()
            shareButton.shareContent = content
            let size = shareCell.frame.size
            shareButton.center = CGPointMake(size.width/2, size.height/2)
            shareCell.addSubview(shareButton)
        }

        // Like Button
        if let likeCell = tableView.cellForRowAtIndexPath(NSIndexPath.init(forRow: rows.like.rawValue, inSection: 0)) {
            let likeButton = FBSDKLikeControl()
            likeButton.likeControlStyle = .BoxCount
            likeButton.objectID = article.appSource
            let size = likeCell.frame.size
            likeButton.center = CGPointMake(size.width/2, size.height/2)
            likeCell.addSubview(likeButton)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - tableViewDelegate methods
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row == rows.save.rawValue {
            save()
        }
    }
    
    private func save() {
        let toggle = article.favoriteId == ""
        LoginManager.toggleArticle(toggle, article: article, fromViewController: self) { (success, object) in
            if success {
                if let rawJSON = object {
                    let json = JSON(rawJSON)
                    if json["status"].stringValue == "create" {
                        // entry saved
                        self.article.favoriteId = json["favorite_id"].stringValue
                        self.saveCell.accessoryType = .Checkmark
                    }
                    else {
                        // entry removed
                        self.article.favoriteId = ""
                        self.saveCell.accessoryType = .None
                    }
                    NSNotificationCenter.defaultCenter().postNotificationName(Constants.notificationObservers.updateFavoriteIdNotificationKey, object: self.article.favoriteId)
                }
            }
        }

    }
    
    // MARK - NSNotification Methods
    
    func favoriteFromShowUpdated(sender:NSNotification) {
        if article != nil {
            let favoriteId = sender.object as! String
            article.favoriteId = favoriteId
            if favoriteId != "" {
                saveCell.accessoryType = .Checkmark
            }
            else {
                saveCell.accessoryType = .None
            }
        }
    }
    
}
