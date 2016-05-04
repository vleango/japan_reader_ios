//
//  LSource.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/4/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import Foundation
import SwiftyJSON

class LSource {
    
    var lang:String = "eng"
    var ls_type:Int = 0
    var ls_wasei = false
    var text:String!
    
    convenience init(json: JSON) {
        self.init()
        self.lang       = json["lang"].stringValue
        self.ls_type    = json["ls_type"].intValue
        self.ls_wasei   = json["ls_wasei"].boolValue
        self.text       = json["text"].stringValue
    }
    
    func toString() -> String {
        return self.text
    }

}