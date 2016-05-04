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
    
    var senses:[Sense] = []
    
    convenience init(json: JSON) {
        self.init()
        let sensesJson = json["senses"]
        for (_, sense):(String, JSON) in sensesJson {
            self.senses.append(Sense.init(json: sense))
        }
    }
    
}