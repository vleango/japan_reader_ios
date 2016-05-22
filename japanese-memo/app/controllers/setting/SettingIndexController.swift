//
//  SettingIndexController.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/5/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import UIKit
import FBSDKShareKit
import Toast_Swift

class SettingIndexController: UITableViewController, FBSDKAppInviteDialogDelegate {

    enum sections:Int { case language, contact, invite }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorColor = UIColor.clearColor()
        
        // Add NotificationCenter Observer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(sentInquiryCompleted), name: Constants.notificationObservers.sentInquiryNotificationKey, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        // Set Default Language
        let languageCell = tableView.cellForRowAtIndexPath(NSIndexPath.init(forRow: 0, inSection: sections.language.rawValue))
        languageCell?.textLabel?.text = UserDefault.getLanguage().name
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - TableViewDelegate Methods
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == sections.invite.rawValue {
            let content = FBSDKAppInviteContent()
            content.appLinkURL = NSURL(string: "https://fb.me/1691136201139509")
            content.appInvitePreviewImageURL = NSURL(string: "https://dl.dropboxusercontent.com/u/65072172/japan_reader.png")
            FBSDKAppInviteDialog.showFromViewController(self, withContent: content, delegate: self)
        }
    }
    
    // MARK - NSNotification Methods
    
    func sentInquiryCompleted(sender:NSNotification) {
        self.view.makeToast("Thank you! Your message has been sent!", duration: 4, position: .Center)
    }
    
    // MARK - AppInviteDialogDelegate Methods
    
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        if results != nil {
            if !results.values.contains({ (item) -> Bool in
                String(item) == "cancel"
            }) {
                self.view.makeToast("Thank you for sharing!", duration: 4, position: .Center)
            }
        }
    }

    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: NSError!) {
        print(error)
    }

}
