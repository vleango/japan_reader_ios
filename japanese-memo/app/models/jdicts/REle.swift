//
//  REle.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/4/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import Foundation
import SwiftyJSON

class REle {
    
    struct constants {
        static let reb = "reb"
    }
    
    var reb:String = ""
    
    convenience init(json:JSON) {
        self.init()
        self.reb = json[REle.constants.reb].stringValue
    }
    
}