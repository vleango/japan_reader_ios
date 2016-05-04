//
//  KeInf.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/4/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import Foundation
import SwiftyJSON

class KeInf {
    
    var text:String!
    
    convenience init(json: JSON) {
        self.init()
        self.text = json["text"].stringValue
    }
    
}

