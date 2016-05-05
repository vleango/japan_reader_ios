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

    var artibutedArticle:ArtibutedArticle!
    @IBOutlet weak var textView: UITextView!
    private let wordSegue = "sToReadWordSegue"
    
    enum wordKeys:String { case textBit, rect }

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
                    self.artibutedArticle.article = Article.init(json: JSON(rawJSON))
                    self.textView.attributedText = self.artibutedArticle.attributedString
                }
            }
        }
    }
    
    // Mark - TextViewDelegate Methods
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        let index = Int(URL.lastPathComponent!)
        var sender = [String: AnyObject]()
        
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
}
