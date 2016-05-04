
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
    
    var keb:String!
    var ke_infs:[KeInf] = []
    var ke_pris:[KePri] = []
    
    convenience init(json:JSON) {
        self.init()
        self.keb = json[KEle.constants.keb].stringValue
        let ke_infsJson = json["ke_infs"]
        for (_, ke_inf):(String, JSON) in ke_infsJson {
            self.ke_infs.append(KeInf.init(json: ke_inf))
        }
        let ke_prisJson = json["ke_pris"]
        for (_, ke_pri):(String, JSON) in ke_prisJson {
            self.ke_pris.append(KePri.init(json: ke_pri))
        }
    }
    
    func infsAndPrisAsString() -> String {
        var arr:[String] = []
        for ke_inf in ke_infs {
            arr.append(ke_inf.text)
        }
        for ke_pri in ke_pris {
            arr.append(ke_pri.text)
        }
        return Array(Set(arr)).joinWithSeparator(", ")
    }
    
}
