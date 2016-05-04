//
//  Sense.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/4/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import Foundation
import SwiftyJSON

class Sense {
    
    struct constants {
        static let text = "text"
        static let lang = "lang"
    }
    
    var text:String = ""
    var lang:String = "eng"
    
    convenience init(json:JSON) {
        self.init()
        self.text = json[Sense.constants.text].stringValue
        self.lang = json[Sense.constants.lang].stringValue
    }
    
}
