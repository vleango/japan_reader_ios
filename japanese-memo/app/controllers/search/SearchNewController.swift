//
//  SearchNewController.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/10/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchNewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var kanjiTextField: UITextField!
    @IBOutlet weak var readingTextField: UITextField!
    @IBOutlet weak var definitionTextField: UITextField!
    
    enum sections:Int { case kanji, reading, definition }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveBtnClicked(sender: AnyObject) {
        
        LoginManager.addNewEntry(params(), fromViewController: self) { (success, object) in
            if success {
                if let rawJSON = object {
                    let json = JSON(rawJSON)
                    let status = json["status"].boolValue
                    if status {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    else {
                        UtilManager.displayAlertView("Error", message: "Something went wrong...", viewController: self)
                    }
                }
            }
        }
    }
    
    // MARK - UITextFieldDelegate methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK - TableViewDelegate Methods
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch sections(rawValue: indexPath.section)! {
        case .kanji:
            kanjiTextField.becomeFirstResponder()
        case .reading:
            readingTextField.becomeFirstResponder()
        case .definition:
            definitionTextField.becomeFirstResponder()
        }
    }
    
    // MARK - Private Methods
    
    private func params() -> [String: AnyObject] {
        var params:[String:AnyObject] = [:]
        if kanjiTextField.text != "" {
            params["entry[k_eles_attributes][][keb]"] = kanjiTextField.text
        }
        if readingTextField.text != "" {
            params["entry[r_eles_attributes][][reb]"] = readingTextField.text
        }
        if definitionTextField.text != "" {
            params["entry[senses_attributes][][glosses_attributes][][text]"] = definitionTextField.text
            params["entry[senses_attributes][][glosses_attributes][][lang]"] = UserDefault.getLanguage().id
        }
        return params
    }
    
}
