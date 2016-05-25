//
//  ReadWordController.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/4/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReadWordController: UIViewController, UITextViewDelegate {
    
    var artibutedWord:ArtibutedWord!
    @IBOutlet weak var textView: UITextView!
    let learnMoreSegue = "sToExitSearchVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        self.preferredContentSize = CGSizeMake(200, 200)
        reloadArtibutedString()
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func loadData() {
        if artibutedWord.bit.entryIdsString != "" {
            let params:[String:AnyObject] = [
                "entry[ids]" : artibutedWord.bit.entryIdsString
            ]
            NetworkManager.entries(params, callback: { (success, object) in
                if success {
                    if let rawJSON = object {
                        let json = JSON(rawJSON)
                        let entriesJson = json["entries"]
                        for (_, entry):(String, JSON) in entriesJson {
                            self.artibutedWord.entries.append(Entry.init(json: entry))
                        }
                    }
                    self.reloadArtibutedString(true)
                }
            })
        }
        else {
            reloadArtibutedString(true)
        }
        
    }
    
    private func reloadArtibutedString(showSense:Bool = false) {
        self.artibutedWord.showSense = showSense
        self.textView.attributedText = self.artibutedWord.attributedString
    }
    
    @IBAction func learnMoreBtnClicked(sender: AnyObject) {
        self.performSegueWithIdentifier(learnMoreSegue, sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == learnMoreSegue {
            let searchVC = segue.destinationViewController as! SearchIndexController
            searchVC.entries = artibutedWord.entries
            searchVC.searchBarTextFromSearchVC = artibutedWord.bit.word
        }
    }
    
    // Mark - TextView Delegate Methods
    
    // Disables scroll so that the textView isn't in the middle after the text is loaded
    override func viewWillAppear(animated: Bool) {
        textView.scrollEnabled = false
    }
    
    // Reenables scrolling for viewWillAppear purpose
    override func viewDidAppear(animated: Bool) {
        textView.scrollEnabled = true
    }
    
    @IBAction func closeBtnClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
