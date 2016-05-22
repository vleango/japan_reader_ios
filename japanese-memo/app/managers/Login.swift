//
//  Login.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/6/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import Foundation
import UIKit

let LoginManager = Login()

final class Login {
    
    func isUserLoggedIn() -> Bool {
        return UserDefault.getUserAccessToken() != nil
    }

    func canPerformAction(fromViewController:UIViewController,
                          callback: (success:Bool) -> Void) {
        
        if isUserLoggedIn() {
            callback(success: true)
        }
        else {
            presentSignInVC(fromViewController)
        }
    }
    
    func presentSignInVC(fromViewController:UIViewController) {
        let signInVC = UIStoryboard.init(name: "Auth", bundle: nil).instantiateViewControllerWithIdentifier("SignInNavVC")
        fromViewController.presentViewController(signInVC, animated: true, completion: nil)
    }
    
    func signOutUser(callback: ((success:Bool, object:AnyObject?) -> Void)?) {
        NetworkManager.singOut { (success, object) in
            if success {
                UserDefault.setUserAccessToken(nil)
            }
            if let validCallback = callback {
                validCallback(success: success, object: nil)
            }
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