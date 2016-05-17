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
    
    func addNewEntry(params:[String:AnyObject], fromViewController:UIViewController, callback: ((success:Bool, object:AnyObject?) -> Void)?) {
        canPerformAction(fromViewController) { (success) in
            if success {
                NetworkManager.createEntry(params, callback: callback)
            }
            else if let validCallback = callback {
                validCallback(success: false, object: nil)
            }
        }
    }
    
    func toggleEntry(save:Bool, entry:Entry, fromViewController:UIViewController, callback: ((success:Bool, object:AnyObject?) -> Void)?) {
        canPerformAction(fromViewController) { (success) in
            if success {
                if save {
                    let params = [
                        "user[resource_id]": String(entry.id),
                        "user[resource_type]": "Jdict::Entry"
                    ]
                    NetworkManager.addFavorite(params, callback: callback)
                }
                else {
                    NetworkManager.removeFavorite(entry.favoriteId, callback: callback)
                }
            }
            else if let validCallback = callback {
                validCallback(success: false, object: nil)
            }
        }
    }
    
    func toggleArticle(save:Bool, article:Article, fromViewController:UIViewController, callback: ((success:Bool, object:AnyObject?) -> Void)?) {
        canPerformAction(fromViewController) { (success) in
            if success {
                if save {
                    let params = [
                        "user[resource_id]": String(article.id),
                        "user[resource_type]": "JpReader::Article"
                    ]
                    NetworkManager.addFavorite(params, callback: callback)
                }
                else {
                    NetworkManager.removeFavorite(article.favoriteId, callback: callback)
                }
            }
            else if let validCallback = callback {
                validCallback(success: false, object: nil)
            }
        }
    }
}