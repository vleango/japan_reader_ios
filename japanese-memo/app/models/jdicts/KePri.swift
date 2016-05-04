//
//  KePri.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/4/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import Foundation
import SwiftyJSON

class KePri {
    
    var text:String!
    var localized_text:String!
    
    convenience init(json: JSON) {
        self.init()
        self.text = json["text"].stringValue
        self.localized_text = json["localized_text"].stringValue
    }
    
    func toString() -> String {
        return self.localized_text
    }
    
}

