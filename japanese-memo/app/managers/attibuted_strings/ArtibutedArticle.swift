//
//  ArtibutedArticle.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/3/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class ArtibutedArticle:ArtibutedBase {
    
    var article:Article
    var coverImage:UIImage?
    
    enum parts:String {case title, body}
    
    // index of articleImage / image
    var images:[Int:UIImage?] = Dictionary()
    
    var attributedString:NSMutableAttributedString {
        get {
            let string = NSMutableAttributedString.init()
            string.appendAttributedString(newLine(1))
            string.appendAttributedString(titleString())
            string.appendAttributedString(newLine(2))
            string.appendAttributedString(publishedString())
            string.appendAttributedString(sourceString())
            string.appendAttributedString(newLine(3))
            string.appendAttributedString(bodyString())
            return string
        }
    }
    
    init(article: Article, coverImage:UIImage?) {
        self.article = article
        self.coverImage = coverImage
    }
    
    func allImagesDownloaded() -> Bool {
        return images.count == article.images.count
    }
    
    // MARK - private methods
    
    private func imageString(image:UIImage?, extraLength:Int) -> NSMutableAttributedString {
        var string = NSMutableAttributedString.init()
        if let validImage = image {
            let attachment = ImageAttachment.init(validImage, reduction: 0.8)
            let image = NSMutableAttributedString.init(attributedString: NSAttributedString.init(attachment: attachment))
            image.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle(), range: NSMakeRange(0, 1))
            string = image
        }
        
        // adding extra length
        var extra = ""
        for _ in 1...extraLength-1 { extra += " " }
        
        string.appendAttributedString(NSAttributedString.init(string: extra)) // need to add extra spaces because it replaces <%0%> -1
        return string
    }
    
    private func titleString() -> NSMutableAttributedString {
        if article.titleBits.count != 0 {
            return BitStringFrom(parts.title, text: article.title, bits: article.titleBits, attributes: attributes(paragraphStyle()))
        }
        else {
            return NSMutableAttributedString(
                string: article.title,
                attributes: attributes(paragraphStyle())
            )
        }
    }
    
    private func publishedString() -> NSMutableAttributedString {
        let string = NSMutableAttributedString.init()
        if let validPublishedDate = article.prettyPublishedDate() {
            let attrs = attributes(paragraphStyle(), font: UIFont.systemFontOfSize(14))
            string.appendAttributedString(NSAttributedString.init(string: validPublishedDate, attributes: attrs))
            string.appendAttributedString(newLine(2))
        }
        return string
    }
    
    private func sourceString() -> NSMutableAttributedString {
        let text = "Source"
        let attrs = attributes(paragraphStyle(), font: UIFont.systemFontOfSize(14))
        let string = NSMutableAttributedString.init(string: text, attributes: attrs)
        string.addAttribute(NSLinkAttributeName, value: article.appSource, range: NSMakeRange(0, text.characters.count))
        return string
    }
    
    private func bodyString() -> NSMutableAttributedString {
        if article.bodyBits.count != 0 {
            let string = BitStringFrom(parts.body, text: article.body, bits: article.bodyBits, attributes: attributes(paragraphStyle(.Natural)))
            for index in images.keys {
                if let image = images[index] {
                    let articleImage = article.images[index]
                    string.replaceCharactersInRange(articleImage.range, withAttributedString: imageString(image, extraLength: articleImage.length))
                }
            }
            
            return string
        }
        else {
            return NSMutableAttributedString(
                string: article.body,
                attributes: attributes(paragraphStyle(.Natural))
            )
        }
    }
    
    // string from bits
    private func BitStringFrom(type:parts, text:String, bits: List<TextBit>, attributes: [String : AnyObject]?) -> NSMutableAttributedString {
        let string = NSMutableAttributedString.init(string: text, attributes: attributes)
        for index in 0 ..< bits.count {
            let bit = bits[index]
            if (bit.furigana) != "" {
                string.addAttribute(NSLinkAttributeName, value: "http://\(type)/\(index)", range: NSMakeRange(bit.position, bit.word.characters.count))
            }
        }
        return string
    }
    
}

