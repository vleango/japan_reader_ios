//
//  UserDefault.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/5/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import Foundation
import UIKit

let Default = UserDefault()

final class UserDefault {
    
    struct constants {
        static let languageName = "language_name"
        static let languageId = "language_id"
    }
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let defaultLanguage = (id: "eng", name: "English")
    
    func getLanguage() -> Language {
        let languageName = defaults.objectForKey(UserDefault.constants.languageName)
        let languageId = defaults.objectForKey(UserDefault.constants.languageId)
        
        if languageName != nil && languageId != nil {
            return Language.init(id: languageId! as! String, name: languageName! as! String)
        }
        else {
            let language = Language.init(id: defaultLanguage.id, name: defaultLanguage.name)
            setLanguage(language)
            return language
        }
    }
    
    func setLanguage(language:Language) {
        defaults.setObject(language.name, forKey: UserDefault.constants.languageName)
        defaults.setObject(language.id, forKey: UserDefault.constants.languageId)
    }
    
    

}