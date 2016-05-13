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

    private func headerString(kanji:String, reading:String) -> NSMutableAttributedString {
        let string = NSMutableAttributedString(
            string: "\(kanji)「\(reading)」",
            attributes: attributes(
                paragraphStyle(.Left),
                font: UIFont.init(name: "Hiragino Sans W3", size: 18.0)
            )
        )
        string.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(20), range: NSMakeRange(0, kanji.characters.count))
        string.appendAttributedString(newLine(2))
        return string
    }
    
    private func sensesString() -> NSMutableAttributedString {
        
        let string = NSMutableAttributedString.init()
        let attrs = attributes(
            paragraphStyle(.Left),
            font: UIFont.init(name: "Hiragino Sans W3", size: 12.0)
        )
        if showSense {
            if entries.count > 0 {
                for entry in entries {
                    var index = 1

                    let header = headerString(entry.kElesAsString(), reading: entry.rEleAsString())
                    string.appendAttributedString(header)
                    
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
                string.appendAttributedString(defaultString("not found", attrs: attrs))
            }
        }
        else {
            string.appendAttributedString(defaultString(attrs: attrs))
        }

        return string
    }
    
    private func defaultString(msg:String = "loading...", attrs:[String : AnyObject]?) -> NSMutableAttributedString {
        let string = NSMutableAttributedString.init()
        let header = headerString(bit.word, reading: bit.furigana!)
        string.appendAttributedString(header)
        let attrStr = NSAttributedString(string: msg, attributes: attrs)
        string.appendAttributedString(attrStr)
        return string
    }
    
}