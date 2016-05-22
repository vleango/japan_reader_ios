//
//  SignUpController.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/21/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import UIKit
import SwiftyJSON

class SignUpController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var passwordConfirmationErrorLabel: UILabel!
    
    enum errorLabels:String { case name, email, password, password_confirmation }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        resetErrorLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelBtnClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func signUpBtnClicked(sender: AnyObject) {
        let params:[String:AnyObject] = [
            "user[name]" : nameTextField.text!,
            "user[email]" : emailTextField.text!,
            "user[password]" : passwordTextField.text!,
            "user[password_confirmation]" : passwordConfirmationTextField.text!
        ]
        NetworkManager.register(params) { (success, object) in
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
                        self.resetErrorLabels()
                        let errors = json["errors"]
                        for (key, error):(String, JSON) in errors {
                            let messages = error.arrayValue.map { $0.string!}
                            let messagesString = messages.joinWithSeparator(", ")

                            switch errorLabels(rawValue: key)! {
                            case .name:
                                self.nameErrorLabel.text = messagesString
                            case .email:
                                self.emailErrorLabel.text = messagesString
                            case .password:
                                self.passwordErrorLabel.text = messagesString
                            case .password_confirmation:
                                self.passwordConfirmationErrorLabel.text = messagesString
                            }
                            
                        }
                        
                    }
                }
            }
        }
    }
    
    // MARK: Private methods
    
    private func resetErrorLabels() {
        nameErrorLabel.text = ""
        emailErrorLabel.text = ""
        passwordErrorLabel.text = ""
        passwordConfirmationErrorLabel.text = ""
    }
    
    
}
