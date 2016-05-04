//
//  Sense.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/4/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import Foundation
import SwiftyJSON

class Sense {
    
    var ants:[Ant]          = []
    var dials:[Dial]        = []
    var fields:[Field]      = []
    var glosses:[Gloss]     = []
    var lsources:[LSource]  = []
    var miscs:[Misc]        = []
    var poses:[Pos]         = []
    var s_infs:[SInf]       = []
    var stagks:[Stagk]      = []
    var stagrs:[Stagr]      = []
    var xrefs:[Xref]        = []
    
    
    convenience init(json:JSON) {
        self.init()
        let antsJson = json["ants"]
        for (_, ant):(String, JSON) in antsJson {
            self.ants.append(Ant.init(json: ant))
        }
        let dialsJson = json["dials"]
        for (_, dial):(String, JSON) in dialsJson {
            self.dials.append(Dial.init(json: dial))
        }
        let fieldsJson = json["fields"]
        for (_, field):(String, JSON) in fieldsJson {
            self.fields.append(Field.init(json: field))
        }
        let glossesJson = json["glosses"]
        for (_, gloss):(String, JSON) in glossesJson {
            self.glosses.append(Gloss.init(json: gloss))
        }
        let lsourcesJson = json["lsources"]
        for (_, lsource):(String, JSON) in lsourcesJson {
            self.lsources.append(LSource.init(json: lsource))
        }
        let miscsJson = json["miscs"]
        for (_, misc):(String, JSON) in miscsJson {
            self.miscs.append(Misc.init(json: misc))
        }
        let posesJson = json["poses"]
        for (_, pos):(String, JSON) in posesJson {
            self.poses.append(Pos.init(json: pos))
        }
        let s_infsJson = json["s_infs"]
        for (_, s_inf):(String, JSON) in s_infsJson {
            self.s_infs.append(SInf.init(json: s_inf))
        }
        let stagksJson = json["stagks"]
        for (_, stagk):(String, JSON) in stagksJson {
            self.stagks.append(Stagk.init(json: stagk))
        }
        let stagrsJson = json["stagrs"]
        for (_, stagr):(String, JSON) in stagrsJson {
            self.stagrs.append(Stagr.init(json: stagr))
        }
        let xrefsJson = json["xrefs"]
        for (_, xref):(String, JSON) in xrefsJson {
            self.xrefs.append(Xref.init(json: xref))
        }
    }
    
    func glossesAsString() -> String {
        var glossTexts:[String] = []
        for gloss in glosses {
            glossTexts.append(gloss.text)
        }
        
        return glossTexts.joinWithSeparator(", ")
    }
    
    func infosAsString() -> String {
        var arr:[String] = []
        for item in ants {
            arr.append(item.text)
        }
        
        for item in dials {
            arr.append(item.text)
        }
        
        for item in fields {
            arr.append(item.text)
        }
        
        for item in lsources {
            arr.append(item.text)
        }
        
        for item in miscs {
            arr.append(item.text)
        }
        
        for item in poses {
            arr.append(item.text)
        }
        
        for item in s_infs {
            arr.append(item.text)
        }
        
        for item in stagks {
            arr.append(item.text)
        }
        
        for item in stagrs {
            arr.append(item.text)
        }
        
        for item in xrefs {
            arr.append(item.text)
        }

        return arr.joinWithSeparator(", ")
    }
    
}
