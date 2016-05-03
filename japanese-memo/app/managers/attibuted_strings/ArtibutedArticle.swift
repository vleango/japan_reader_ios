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

class ArtibutedArticle {
    
    var article:Article
    var image:UIImage?
    
    var attributedString:NSMutableAttributedString {
        get {
            let string = NSMutableAttributedString.init()
            string.appendAttributedString(imageString())
            string.appendAttributedString(newLine(2))
            string.appendAttributedString(titleString())
            string.appendAttributedString(newLine(2))
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
            return BitStringFrom(article.title, bits: article.titleBits, attributes: attributes(paragraphStyle()))
        }
        else {
            return NSMutableAttributedString(
                string: article.title,
                attributes: attributes(paragraphStyle())
            )
        }
    }
    
    private func bodyString() -> NSMutableAttributedString {
        if article.bodyBits.count != 0 {
            return BitStringFrom(article.body, bits: article.bodyBits, attributes: attributes(paragraphStyle(.Justified)))
        }
        else {
            return NSMutableAttributedString(
                string: article.body,
                attributes: attributes(paragraphStyle(.Justified))
            )
        }
    }
    
    // string from bits
    private func BitStringFrom(text:String, bits: List<TextBit>, attributes: [String : AnyObject]?) -> NSMutableAttributedString {
        let string = NSMutableAttributedString.init(string: text, attributes: attributes)
        for index in 0 ..< bits.count {
            let bit = bits[index]
            if (bit.furigana) != "" {
                string.addAttribute(NSLinkAttributeName, value: "http://thaleang.com/\(index)", range: NSMakeRange(bit.position, bit.word.characters.count))
            }
        }
        return string
    }
    
    // returns the number of new_lines as attributedString
    private func newLine(value: Int32 = 1) -> NSAttributedString {
        var newLineStrs = ""
        for _ in 1...value { newLineStrs += "\n" }
        return NSAttributedString.init(string: newLineStrs)
    }
    
    // default attributes
    private func attributes(paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()) -> [String : AnyObject]? {
        let font = UIFont.init(name: "Hiragino Sans W3", size: 24.0)
        return [
            NSFontAttributeName: font!,
            NSParagraphStyleAttributeName : paragraphStyle
        ]
    }
    
    // centered NSParagraph with lineSpacing option
    private func paragraphStyle(alignment:NSTextAlignment = .Center, lineSpacing:CGFloat = 0.0) -> NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.lineSpacing = lineSpacing
        
        paragraphStyle.firstLineHeadIndent = 20
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let indent = CGFloat.abs(20)
        paragraphStyle.headIndent = indent
        paragraphStyle.tailIndent = screenSize.width - indent
        
        return paragraphStyle
    }
    
}

