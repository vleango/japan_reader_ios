//
//  Gloss.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/4/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import Foundation
import SwiftyJSON

class Gloss {
    
    var lang:String = "eng"
    var text:String!
    
    convenience init(json: JSON) {
        self.init()
        self.lang = json["lang"].stringValue
        self.text = json["text"].stringValue
    }
    
}
