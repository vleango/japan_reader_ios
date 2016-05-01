//
//  Article.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/1/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Article: Object {
    
    struct constants {
        static let id = "id"
        static let provider = "provider"
        static let news_id = "news_id"
        static let title = "title"
        static let subtitle = "subtitle"
        static let body = "body"
        static let published_date = "published_date"
        static let title_with_ruby = "title_with_ruby"
        static let subtitle_with_ruby = "subtitle_with_ruby"
        static let body_with_ruby = "body_with_ruby"
        static let source = "source"
    }
    
    dynamic var id = ""
    dynamic var provider = ""
    dynamic var news_id = ""
    dynamic var title = ""
    dynamic var subtitle = ""
    dynamic var body = ""
    dynamic var published_date = ""
    dynamic var image_url = ""
    dynamic var title_with_ruby = ""
    dynamic var subtitle_with_ruby = ""
    dynamic var body_with_ruby = ""
    dynamic var source = ""
    
    convenience init(json:JSON) {
        self.init()
        self.id = json[Article.constants.id].stringValue
        self.provider = json[Article.constants.provider].stringValue
        self.news_id = json[Article.constants.news_id].stringValue
        self.title = json[Article.constants.title].stringValue
        self.subtitle = json[Article.constants.subtitle].stringValue
        self.body = json[Article.constants.body].stringValue
        self.published_date = json[Article.constants.published_date].stringValue
        self.title_with_ruby = json[Article.constants.title_with_ruby].stringValue
        self.subtitle_with_ruby = json[Article.constants.subtitle_with_ruby].stringValue
        self.body_with_ruby = json[Article.constants.body_with_ruby].stringValue
        self.source = json[Article.constants.source].stringValue
        
        self.image_url = json["image"]["url"].stringValue
    }

}
