//
//  ArtibutedBase.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/4/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import Foundation
import UIKit

class ArtibutedBase {
    
    // returns the number of new_lines as attributedString
    internal func newLine(value: Int32 = 1) -> NSAttributedString {
        var newLineStrs = ""
        for _ in 1...value { newLineStrs += "\n" }
        return NSAttributedString.init(string: newLineStrs)
    }
    
    // default attributes
    internal func attributes(paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle(), font:UIFont? = UIFont.init(name: "Hiragino Sans W3", size: 24.0)) -> [String : AnyObject]? {
        return [
            NSFontAttributeName: font!,
            NSParagraphStyleAttributeName : paragraphStyle
        ]
    }
    
    // centered NSParagraph with lineSpacing option
    internal func paragraphStyle(alignment:NSTextAlignment = .Center, lineSpacing:CGFloat = 0.0) -> NSMutableParagraphStyle {
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