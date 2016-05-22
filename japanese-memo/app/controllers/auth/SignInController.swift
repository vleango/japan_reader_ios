//
//  SignInController.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/21/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import UIKit
import SwiftyJSON

class SignInController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToSignInVC(segue: UIStoryboardSegue) { }

    @IBAction func cancelBtnClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func signInBtnClicked(sender: AnyObject) {
        let params:[String:AnyObject] = [
            "user[login]" : emailTextField.text!,
            "user[password]" : passwordTextField.text!
        ]
        NetworkManager.signIn(params) { (success, object) in
            if success {
                
                if let rawJSON = object {
                    let json = JSON(rawJSON)
                    if json["status"].boolValue {
                        let user = json["user"]
                        if let validAccessToken = user["access_token"].string {
                            UserDefault.setUserAccessToken(validAccessToken)
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                    }
                    else {
                        UtilManager.displayAlertView("Error", message: json["error_messages"].stringValue, viewController: self)
                    }
                }
            }
        }
    }

}
