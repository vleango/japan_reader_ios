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
        static let re_nokanji = "re_nokanji"
    }
    
    var reb:String!
    var re_nokanji = false
    var re_infs:[ReInf] = []
    var re_pris:[RePri] = []
    var re_restr:[ReRestr] = []
    
    convenience init(json:JSON) {
        self.init()
        self.reb        = json[REle.constants.reb].stringValue
        self.re_nokanji = json[REle.constants.re_nokanji].boolValue
        let re_infsJson = json["re_infs"]
        for (_, re_inf):(String, JSON) in re_infsJson {
            self.re_infs.append(ReInf.init(json: re_inf))
        }
        let re_prisJson = json["re_pris"]
        for (_, re_pri):(String, JSON) in re_prisJson {
            self.re_pris.append(RePri.init(json: re_pri))
        }
        let re_restrsJson = json["re_restrs"]
        for (_, re_restr):(String, JSON) in re_restrsJson {
            self.re_restr.append(ReRestr.init(json: re_restr))
        }
    }
    
    func infsAndPrisAsString() -> String {
        var arr:[String] = []
        for re_inf in re_infs {
            arr.append(re_inf.toString())
        }
        for re_pri in re_pris {
            arr.append(re_pri.toString())
        }
        return Array(Set(arr)).joinWithSeparator(", ")
    }
    
}