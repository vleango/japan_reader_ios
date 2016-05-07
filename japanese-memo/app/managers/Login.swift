//
//  Login.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/6/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit

let LoginManager = Login()

final class Login {
    
    func isUserLoggedIn() -> Bool {
        return FBSDKAccessToken.currentAccessToken() != nil
    }
    
    func AccessTokenUserId() -> String? {
        var string:String?
        if isUserLoggedIn() {
            string = FBSDKAccessToken.currentAccessToken().userID
        }
        return string
    }
    
    func canPerformAction(fromViewController:UIViewController,
                          callback: (success:Bool) -> Void) {
        
        if isUserLoggedIn() {
            callback(success: true)
        }
        else { // Attempt to login
            let manager = FBSDKLoginManager()
            //let permissions = ["email", "public_profile"]
            manager.logInWithReadPermissions(nil, fromViewController: fromViewController, handler: { (result, error) in
                if error != nil {
                    callback(success: false)
                } else if result.isCancelled {
                    callback(success: false)
                } else {
                    callback(success: true)
                }
            })
        }
    }
    
    func toggleEntry(save:Bool, entry:Entry, fromViewController:UIViewController, callback: ((success:Bool, object:AnyObject?) -> Void)?) {
        canPerformAction(fromViewController) { (success) in
            if success {
                if save {
                    let params = ["user[entry]": String(entry.id)]
                    NetworkManager.saveEntry(params, callback: callback)
                }
                else {
                    NetworkManager.removeEntry(entry, callback: callback)
                }
            }
            else if let validCallback = callback {
                validCallback(success: false, object: nil)
            }
        }
    }
}