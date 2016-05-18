//
//  SettingIndexController.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/5/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Toast_Swift

class SettingIndexController: UITableViewController {

    enum sections:Int { case language, contact, facebook }
    
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
        
        // Facebook Login Button
        let loginButton:FBSDKLoginButton = {
            let button = FBSDKLoginButton()
            //button.readPermissions = ["email", "public_profile"]
            return button
        }()
        if let loginCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: sections.facebook.rawValue)) {
            let size = loginCell.frame.size
            loginButton.center = CGPointMake(size.width/2, size.height/2)
            loginCell.addSubview(loginButton)
        }
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - NSNotification Methods
    
    func sentInquiryCompleted(sender:NSNotification) {
        self.view.makeToast("Thank you! Your message has been sent!", duration: 4, position: .Center)
    }

}
