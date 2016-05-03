//
//  ReadShowController.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/1/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReadShowController: UIViewController, UITextViewDelegate {

    var artibutedArticle:ArtibutedArticle!
    @IBOutlet weak var textView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.attributedText = artibutedArticle.attributedString
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Disables scroll so that the textView isn't in the middle after the text is loaded
    override func viewWillAppear(animated: Bool) {
        textView.scrollEnabled = false
    }
    
    // Reenables scrolling for viewWillAppear purpose
    override func viewDidAppear(animated: Bool) {
        textView.scrollEnabled = true
    }
    
    // reload the attributed string (since bounds needs to be recalculated)
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition(nil) { (UIViewControllerTransitionCoordinatorContext) in
            self.textView.attributedText = self.artibutedArticle.attributedString
        }
    }
    
    // Mark - Network
    
    private func loadData() {
        NetworkManager.read(artibutedArticle.article.id) { (success, object) in
            if success {
                if let rawJSON = object {
                    self.artibutedArticle.article = Article.init(json: JSON(rawJSON))
                    self.textView.attributedText = self.artibutedArticle.attributedString
                }
            }
        }
    }
    
    // Mark - TextViewDelegate Methods
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        let index = Int(URL.lastPathComponent!)
        let bit = artibutedArticle.article.titleBits[index!]
        return false
    }

    // Toggle furigana
    @IBAction func switchedChanged(enableFurigana: UISwitch) {
        if enableFurigana.on {
            artibutedArticle.enableFurigana = true
        }
        else {
            artibutedArticle.enableFurigana = false
        }
        textView.attributedText = artibutedArticle.attributedString
    }
}
