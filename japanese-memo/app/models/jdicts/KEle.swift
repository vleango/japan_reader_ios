
//
//  KEle.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/4/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import Foundation
import SwiftyJSON

class KEle {
    
    struct constants {
        static let keb = "keb"
    }
    
    var keb:String = ""
    
    convenience init(json:JSON) {
        self.init()
        self.keb = json[KEle.constants.keb].stringValue
    }
    
}
