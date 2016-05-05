//
//  Language.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/5/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import Foundation
import SwiftyJSON

class Language {
    
    var id:String!
    var name:String!
    
    convenience init(id:String, name:String) {
        self.init()
        self.id = id
        self.name = name
    }
    
    convenience init(json: JSON) {
        self.init()
        self.id     = json["id"].stringValue
        self.name   = json["name"].stringValue
    }
    
    func isEqual(language:Language) -> Bool {
        return (self.name == language.name && self.id == language.id)
    }

}