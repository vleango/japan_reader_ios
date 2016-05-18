//
//  SettingContactController.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/18/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import UIKit
import SwiftyJSON

class SettingContactController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    let defaultText = "Enter comments..."
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveBtn.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - TextViewDelegate methods
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == defaultText {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        let whiteSpace = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        let text = textView.text.stringByTrimmingCharactersInSet(whiteSpace)
        if text.characters.count == 0 || textView.text == defaultText {
            saveBtn.enabled = false
        }
        else {
            saveBtn.enabled = true
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            textView.text = defaultText
            textView.textColor = UIColor.lightGrayColor()
            saveBtn.enabled = false
        }
        else {
            saveBtn.enabled = true
        }
    }
    @IBAction func saveBtnClicked(sender: AnyObject) {
        let params:[String:AnyObject] = [
            "inquiry[name]" : nameTextField.text!,
            "inquiry[email]" : emailTextField.text!,
            "inquiry[body]" : bodyTextView.text
        ]
        NetworkManager.sendInquiry(params) { (success, object) in
            if success {
                if let rawJSON = object {
                    let json = JSON(rawJSON)
                    let errorMsg = json["error_messages"].stringValue
                    if errorMsg == "" {
                        self.navigationController?.popViewControllerAnimated(true)
                        NSNotificationCenter.defaultCenter().postNotificationName(Constants.notificationObservers.sentInquiryNotificationKey, object: nil)
                    }
                    else {
                        UtilManager.displayAlertView("Error", message: errorMsg, viewController: self)
                    }
                }
            }
        }
    }

}
