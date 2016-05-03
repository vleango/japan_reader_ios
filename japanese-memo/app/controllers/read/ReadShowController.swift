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

    var article:Article!
    var image:UIImage?
    @IBOutlet weak var textView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        let artibutedArticle = ArtibutedArticle.init(article: article, image: image)
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
    
    // Mark - Network
    
    private func loadData() {
        NetworkManager.read(article.id) { (success, object) in
            if success {
                if let rawJSON = object {
                    self.article = Article.init(json: JSON(rawJSON))
                    let artibutedArticle = ArtibutedArticle.init(article: self.article, image: self.image)
                    self.textView.attributedText = artibutedArticle.attributedString
                }
            }
        }
    }
    
    // Mark - TextViewDelegate Methods
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        let index = Int(URL.lastPathComponent!)
        let bit = article.titleBits[index!]
        return false
    }

}
