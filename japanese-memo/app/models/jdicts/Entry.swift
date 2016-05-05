//
//  Entry.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/4/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import Foundation
import SwiftyJSON

class Entry {
    
    var k_eles:[KEle] = []
    var r_eles:[REle] = []
    var senses:[Sense] = []
    
    var id:Int!
    var priority:Int?
    
    convenience init(json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.priority = json["priority"].int
        let k_eleJson = json["k_eles"]
        for (_, k_ele):(String, JSON) in k_eleJson {
            self.k_eles.append(KEle.init(json: k_ele))
        }
        let r_eleJson = json["r_eles"]
        for (_, r_ele):(String, JSON) in r_eleJson {
            self.r_eles.append(REle.init(json: r_ele))
        }
        let sensesJson = json["senses"]
        for (_, sense):(String, JSON) in sensesJson {
            self.senses.append(Sense.init(json: sense))
        }
    }
    
}