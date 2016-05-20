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
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        saveCell = tableView.cellForRowAtIndexPath(NSIndexPath.init(forRow: 2, inSection: 0))
        if article.favoriteId != "" {
            saveCell.accessoryType = .Checkmark
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - tableViewDelegate methods
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        switch rows(rawValue: indexPath.row)! {
        case .share:
            share()
        case .like:
            like()
        case .save:
            save()
        }
    }
    
    private func share() {
        let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
        content.contentURL = NSURL(string: article.appSource)
        content.contentTitle = article.title
        content.contentDescription = article.body
        FBSDKShareDialog.showFromViewController(self, withContent: content, delegate: nil)
    }
    
    private func like() {
        
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
    
}
