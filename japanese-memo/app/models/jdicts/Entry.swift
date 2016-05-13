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
    
    var id:String!
    var priority:Int?
    var favoriteId:String = ""
    
    convenience init(json: JSON) {
        self.init()
        self.id = json["id"].stringValue
        self.priority = json["priority"].int
        self.favoriteId = json["favorite_id"].stringValue
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
    
    func kElesAsString(separator:String = ", ") -> String {
        var k_eleText:[String] = []
        for k_ele in k_eles {
            k_eleText.append(k_ele.keb)
        }
        return k_eleText.joinWithSeparator(separator)
    }
    
    func rEleAsString(separator:String = ", ") -> String {
        var r_eleText:[String] = []
        for r_ele in r_eles {
            r_eleText.append(r_ele.reb)
        }
        return r_eleText.joinWithSeparator(separator)
    }
    
    func glossAsString(separator:String = ", ") -> String {
        var senseText:[String] = []
        for sense in senses {
            senseText.append(sense.glossesAsString())
        }
        return senseText.joinWithSeparator(separator)
    }
    
}