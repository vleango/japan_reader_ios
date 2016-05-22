//
//  Default.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/5/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import Foundation
import UIKit

let UserDefault = Default()

final class Default {
    
    struct constants {
        static let languageName = "language_name"
        static let languageId = "language_id"
        static let accessToken = "access_token"
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    private let defaultLanguage = (id: "eng", name: "English")
    
    func getLanguage() -> Language {
        let languageName = defaults.objectForKey(Default.constants.languageName)
        let languageId = defaults.objectForKey(Default.constants.languageId)
        
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
        defaults.setObject(language.name, forKey: Default.constants.languageName)
        defaults.setObject(language.id, forKey: Default.constants.languageId)
    }
    
    func getUserAccessToken() -> String? {
        return defaults.stringForKey(Default.constants.accessToken)
    }
    
    func setUserAccessToken(token:String?) {
        defaults.setObject(token, forKey: Default.constants.accessToken)
    }

}