//
//  ReadShowController.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/1/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReadShowController: UIViewController, UITextViewDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    var artibutedArticle:ArtibutedArticle!
    private let wordSegue = "sToReadWordSegue"
    
    enum wordKeys:String { case textBit, rect }
    private enum saveBtnStates:String { case Save, Unsave }

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.attributedText = artibutedArticle.attributedString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    // used with hidesBarsOnSwipe
//    override func prefersStatusBarHidden() -> Bool {
//        return navigationController?.navigationBarHidden ?? false
//    }
    
    // Disables scroll so that the textView isn't in the middle after the text is loaded
    override func viewWillAppear(animated: Bool) {
        textView.scrollEnabled = false
        loadData()
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == wordSegue {
            let popoverViewController = segue.destinationViewController as! ReadWordController
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
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
    }
    
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    // Mark - Network
    
    private func loadData() {
        NetworkManager.read(artibutedArticle.article.id) { (success, object) in
            if success {
                if let rawJSON = object {
                    let json = JSON(rawJSON)
                    self.artibutedArticle.article = Article.init(json: json)

                    // need to resync with app
                    if self.artibutedArticle.article.favoriteId != "" {
                        // if the entry was saved, then we do remove
                        self.saveBtn.title = saveBtnStates.Unsave.rawValue
                    }
                    else {
                        // if the entry was NOT saved, then we do save
                        self.saveBtn.title = saveBtnStates.Save.rawValue
                    }
                    
                    // set because translations are ready
                    self.textView.attributedText = self.artibutedArticle.attributedString
                    
                    if let validURL = self.artibutedArticle.article.image_url {
                        NetworkManager.downloadImage(validURL, callback: { (image) -> Void in
                            if let downloadedImage = image {
                                self.artibutedArticle.image = downloadedImage
                            }
                            
                            // reset because the image is ready
                            self.textView.attributedText = self.artibutedArticle.attributedString
                        })
                    }
                }
            }
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
    
    @IBAction func saveBtnClicked(sender: AnyObject) {
        let toggle = saveBtn.title == saveBtnStates.Save.rawValue
        LoginManager.toggleArticle(toggle, article: artibutedArticle.article, fromViewController: self) { (success, object) in
            if success {
                if let rawJSON = object {
                    let json = JSON(rawJSON)
                    if json["status"].stringValue == "create" {
                        // entry saved
                        self.saveBtn.title = saveBtnStates.Unsave.rawValue
                        self.artibutedArticle.article.favoriteId = json["favorite_id"].stringValue
                    }
                    else {
                        // entry removed
                        self.saveBtn.title = saveBtnStates.Save.rawValue
                    }
                }
            }
        }
    }
    
}
