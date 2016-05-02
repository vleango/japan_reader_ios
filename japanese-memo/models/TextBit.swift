//
//  TextBit.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/1/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class TextBit: Object {
    
    dynamic var word = ""
    dynamic var furigana:String? = ""
    dynamic var position = 0
    
    
    convenience init(bits:JSON) {
        self.init()
        self.word        = bits["word"].stringValue
        self.furigana    = bits["furigana"].stringValue
        self.position    = bits["position"].intValue
    }
    
}