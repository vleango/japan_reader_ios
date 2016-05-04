//
//  ArtibutedWord.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/4/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import Foundation
import UIKit

class ArtibutedWord:ArtibutedBase {
    
    var bit:TextBit
    var entries:[Entry] = []

    var attributedString:NSMutableAttributedString {
        get {
            let string = NSMutableAttributedString.init()
            string.appendAttributedString(headerString())
            string.appendAttributedString(newLine(2))
            string.appendAttributedString(sensesString())
            return string
        }
    }
    
    var showSense:Bool
    
    init(bit: TextBit) {
        self.bit = bit
        showSense = false
    }
    
    // Mark - private methods
    
    private func headerString() -> NSMutableAttributedString {
        let string = NSMutableAttributedString(
            string: "\(bit.word)「\(bit.furigana!)」",
            attributes: attributes(
                paragraphStyle(.Left),
                font: UIFont.init(name: "Hiragino Sans W3", size: 18.0)
            )
        )
        string.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(20), range: NSMakeRange(0, bit.word.characters.count))
        return string
    }
    
    private func sensesString() -> NSMutableAttributedString {
        
        let string = NSMutableAttributedString.init()
        if showSense {
            let attrs = attributes(
                paragraphStyle(.Left),
                font: UIFont.init(name: "Hiragino Sans W3", size: 12.0)
            )
            
            if entries.count > 0 {
                for entry in entries {
                    var index = 1
                    for sense in entry.senses {
                        let text = sense.glossesAsString()
                        let senseStr = "\(index): \(text)\n"
                        let attrStr = NSAttributedString(string: senseStr, attributes: attrs)
                        string.appendAttributedString(attrStr)
                        index += 1
                    }
                    
                    // add horizontal line to separate entries
                    string.appendAttributedString(NSAttributedString(string: "ーーーーーーーー\n", attributes: attrs))
                    
                }
            }
            else {
                let attrStr = NSAttributedString(string: "not found", attributes: attrs)
                string.appendAttributedString(attrStr)
            }
        }

        return string
    }
    
}