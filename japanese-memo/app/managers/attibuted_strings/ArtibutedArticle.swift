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
    var image:UIImage?
    
    enum parts:String {case title, body}
    
    var attributedString:NSMutableAttributedString {
        get {
            let string = NSMutableAttributedString.init()
            string.appendAttributedString(imageString())
            string.appendAttributedString(newLine(2))
            string.appendAttributedString(titleString())
            string.appendAttributedString(newLine(2))
            string.appendAttributedString(publishedString())
            string.appendAttributedString(sourceString())
            string.appendAttributedString(newLine(3))
            string.appendAttributedString(bodyString())
            return string
        }
    }
    
    init(article: Article, image:UIImage?) {
        self.article = article
        self.image = image
    }
    
    // MARK - private methods
    
    private func imageString() -> NSMutableAttributedString {
        var string = NSMutableAttributedString.init()
        if let validImage = image {
            let attachment = ImageAttachment.init(validImage, reduction: 0.8)
            let image = NSMutableAttributedString.init(attributedString: NSAttributedString.init(attachment: attachment))
            image.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle(), range: NSMakeRange(0, 1))
            string = image
        }
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
        string.addAttribute(NSLinkAttributeName, value: article.source, range: NSMakeRange(0, text.characters.count))
        return string
    }
    
    
    private func bodyString() -> NSMutableAttributedString {
        if article.bodyBits.count != 0 {
            return BitStringFrom(parts.body, text: article.body, bits: article.bodyBits, attributes: attributes(paragraphStyle(.Justified)))
        }
        else {
            return NSMutableAttributedString(
                string: article.body,
                attributes: attributes(paragraphStyle(.Justified))
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

