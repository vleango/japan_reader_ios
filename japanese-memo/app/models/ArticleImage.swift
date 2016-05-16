//
//  ArticleImage.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/16/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class ArticleImage: Object {
    
    dynamic var url = ""
    dynamic var position = 0
    dynamic var length = 0
    
    var range:NSRange {
        get {
            return NSMakeRange(position, length)
        }
    }
    
    convenience init(json:JSON) {
        self.init()
        self.url = json["url"].stringValue
        self.position = json["position"].intValue
        self.length = json["length"].intValue
    }

}