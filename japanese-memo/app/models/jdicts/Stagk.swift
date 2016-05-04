//
//  Stagk.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/4/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import Foundation
import SwiftyJSON

class Stagk {
    
    var text:String!
    
    convenience init(json: JSON) {
        self.init()
        self.text = json["text"].stringValue
    }
    
    func toString() -> String {
        return self.text
    }

}
