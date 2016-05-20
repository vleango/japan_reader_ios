//
//  ReadShowController.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/1/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import UIKit
import SwiftyJSON
import FBSDKShareKit

class ReadShowController: UIViewController, UITextViewDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var actionBtn: UIBarButtonItem!
    @IBOutlet weak var prevArticleBtn: UIBarButtonItem!
    @IBOutlet weak var nextArticleBtn: UIBarButtonItem!
    
    var artibutedArticle:ArtibutedArticle!
    var previousArticle:ArtibutedArticle?
    var nextArticle:ArtibutedArticle?
    
    private let wordSegue = "sToReadWordSegue"
    private let actionsSegue = "sToReadActionsSegue"
    
    enum wordKeys:String { case textBit, rect }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.attributedText = artibutedArticle.attributedString
        
        // Add NotificationCenter Observer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(favoriteKeyUpdated), name: Constants.notificationObservers.updateActionFavoriteIdNotificationKey, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Disables scroll so that the textView isn't in the middle after the text is loaded
    override func viewWillAppear(animated: Bool) {
        textView.scrollEnabled = false
        loadData()
    }
    
    // Reenables scrolling for viewWillAppear purpose
    override func viewDidAppear(animated: Bool) {
        textView.scrollEnabled = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == wordSegue {
            let popoverViewController = segue.destinationViewController as! ReadWordController
            popoverViewController.modalPresentationStyle = .Popover
            popoverViewController.popoverPresentationController!.delegate = self
            let presentingVC = popoverViewController.popoverPresentationController
            
            if let validSender = sender {
                let dict = validSender as! [String: AnyObject]
                let rectString = dict[wordKeys.rect.rawValue]
                presentingVC!.sourceView = self.view;
                presentingVC!.sourceRect = CGRectFromString(rectString as! String)
                let bit = dict[wordKeys.textBit.rawValue] as! TextBit
                popoverViewController.artibutedWord = ArtibutedWord.init(bit: bit)
            }
        }
        else if segue.identifier == actionsSegue {
            let popoverViewController = segue.destinationViewController as! ReadActionsController
            popoverViewController.modalPresentationStyle = .Popover
            popoverViewController.popoverPresentationController!.delegate = self
            popoverViewController.article = artibutedArticle.article
        }
    }
    
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    // Mark - Network
    
    private func loadData() {
        
        self.prevArticleBtn.enabled = false
        self.nextArticleBtn.enabled = false
        
        NetworkManager.read(artibutedArticle.article.id) { (success, object) in
            if success {
                if let rawJSON = object {
                    let json = JSON(rawJSON)
                    self.artibutedArticle.article = Article.init(json: json)
                    
                    // grab previous and next
                    let previousJson = json["prev_article"]
                    if previousJson != nil {
                        self.previousArticle = ArtibutedArticle.init(article: Article.init(json: previousJson), coverImage: nil)
                        self.prevArticleBtn.enabled = true
                    }
                    else {
                        self.prevArticleBtn.enabled = false
                    }
                    
                    let nextJson = json["next_article"]
                    if nextJson != nil {
                        self.nextArticle = ArtibutedArticle.init(article: Article.init(json: nextJson), coverImage: nil)
                        self.nextArticleBtn.enabled = true
                    }
                    else {
                        self.nextArticleBtn.enabled = false
                    }
                    
                    if self.artibutedArticle.article.favoriteId != "" {
                        NSNotificationCenter.defaultCenter().postNotificationName(Constants.notificationObservers.updateActionFavoriteIdNotificationKey, object: self.artibutedArticle.article.favoriteId)
                    }
                    
                    // set because translations are ready
                    self.textView.attributedText = self.artibutedArticle.attributedString
                    
                    for articleImage in self.artibutedArticle.article.images {
                        NetworkManager.downloadImage(articleImage.url, callback: { (image) in
                            
                            if let index = self.artibutedArticle.article.images.indexOf(articleImage) {
                                self.artibutedArticle.images[index] = image
                                self.imageLoaded()
                            }
                        })
                    }
                    
                }
            }
        }
    }
    
    private func imageLoaded() {
        if artibutedArticle.allImagesDownloaded() {
            // reset because the image is ready
            self.textView.attributedText = self.artibutedArticle.attributedString
        }
    }
    
    // Mark - TextViewDelegate Methods
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        let index = Int(URL.lastPathComponent!)
        var sender = [String: AnyObject]()
        
        // Check if real source
        if (URL.host! != ArtibutedArticle.parts.title.rawValue) && (URL.host! != ArtibutedArticle.parts.body.rawValue) {
            return true
        }
        
        switch ArtibutedArticle.parts(rawValue: URL.host!)! {
        case .title:
            sender[wordKeys.textBit.rawValue] = artibutedArticle.article.titleBits[index!]
        case .body:
            sender[wordKeys.textBit.rawValue] = artibutedArticle.article.bodyBits[index!]
        }
        
        let beginning = textView.beginningOfDocument
        let start = textView.positionFromPosition(beginning, offset: characterRange.location)
        let end = textView.positionFromPosition(start!, offset: characterRange.length)
        let textRange = textView.textRangeFromPosition(start!, toPosition: end!)
        let rect = textView.firstRectForRange(textRange!)
        let posRect = textView.convertRect(rect, toView: textView.inputView)
        sender[wordKeys.rect.rawValue] = NSStringFromCGRect(posRect)
        
        performSegueWithIdentifier(wordSegue, sender: sender)
        
        return false
    }
    
    // Mark - NSNotification Methods
    
    func favoriteKeyUpdated(sender:NSNotification) {
        let favoriteId = sender.object as! String
        artibutedArticle.article.favoriteId = favoriteId
    }
    
    @IBAction func shuffleBtnClicked(sender: AnyObject) {
        NetworkManager.randomArticle { (success, object) in
            if let rawJSON = object {
                let json = JSON(rawJSON)
                let article = Article.init(json: json)
                let randomArticle = ArtibutedArticle.init(article: article, coverImage: nil)
                self.replaceArticle(randomArticle)
            }
        }
    }
    
    @IBAction func previousBtnClicked(sender: AnyObject) {
        if let validPrevious = previousArticle {
            replaceArticle(validPrevious)
        }
    }
    
    @IBAction func nextBtnClicked(sender: AnyObject) {
        if let validNext = nextArticle {
            replaceArticle(validNext)
        }
    }
    
    private func replaceArticle(article:ArtibutedArticle) {
        artibutedArticle = article
        previousArticle = nil
        nextArticle = nil
        textView.attributedText = artibutedArticle.attributedString
        textView.setContentOffset(CGPointMake(0, -64), animated: true)
        loadData()
    }
    
}
