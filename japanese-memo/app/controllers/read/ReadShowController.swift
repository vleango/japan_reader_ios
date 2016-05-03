//
//  ReadShowController.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/1/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import UIKit

class ReadShowController: UIViewController, UITextViewDelegate {

    var article:Article!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        
        // setup page
        self.title = article.title
        
        
        // still need to get body
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 40

        let attributes = [ NSFontAttributeName: UIFont(name: "Hiragino Sans W3", size: 28.0)!, NSParagraphStyleAttributeName : paragraphStyle ]
        //let attributedString = NSMutableAttributedString(string: article.bitsAsString(article.bodyBits), attributes: attributes)
        
        let attributedString = NSMutableAttributedString(string: article.title, attributes: attributes)
        
        
        // add clickable events
//        for index in 0 ..< article.bodyBits.count {
//            let bit = article.bodyBits[index]
//            if (bit.furigana) != "" {
//                attributedString.addAttribute(NSLinkAttributeName, value: "http://thaleang.com/\(index)", range: NSMakeRange(bit.position, bit.word.characters.count))
//            }
//        }

        textView.attributedText = attributedString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        textView.scrollEnabled = false
    }
    
    override func viewDidAppear(animated: Bool) {
        textView.scrollEnabled = true
    }
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        let index = Int(URL.lastPathComponent!)
        let bit = article.bodyBits[index!]
        return false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
