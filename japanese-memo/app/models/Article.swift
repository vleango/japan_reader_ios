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
        static let image_url = "image_url"
        static let published_date = "published_date"
        static let source = "source"
        static let title_bits = "title_bits"
        static let subtitle_bits = "subtitle_bits"
        static let body_bits = "body_bits"
    }
    
    dynamic var id = ""
    dynamic var provider = ""
    dynamic var news_id = ""
    dynamic var published_date = ""
    dynamic var image_url:String? = ""
    dynamic var source = ""
    dynamic var title = ""
    dynamic var subtitle = ""
    dynamic var body = ""
    
    let titleBits = List<TextBit>()
    let subtitleBits = List<TextBit>()
    let bodyBits = List<TextBit>()
    
    convenience init(json:JSON) {
        self.init()
        self.id = json[Article.constants.id].stringValue
        self.provider = json[Article.constants.provider].stringValue
        self.news_id = json[Article.constants.news_id].stringValue
        self.title = json[Article.constants.title].stringValue
        self.subtitle = json[Article.constants.subtitle].stringValue
        self.body = json[Article.constants.body].stringValue
        
        let titleBitsArray = json[Article.constants.title_bits].arrayValue
        for bit in titleBitsArray {
            self.titleBits.append(TextBit.init(bits: bit))
        }
        
        let subtitleBitsArray = json[Article.constants.subtitle_bits].arrayValue
        for bit in subtitleBitsArray {
            self.subtitleBits.append(TextBit.init(bits: bit))
        }
        
        let bodyBitsArray = json[Article.constants.body_bits].arrayValue
        for bit in bodyBitsArray {
            self.bodyBits.append(TextBit.init(bits: bit))
        }

        let imageUrl = json[Article.constants.image_url].stringValue
        if imageUrl != "" {
            self.image_url = "\(Constants.app.domain)\(imageUrl)"
        }
        self.published_date = json[Article.constants.published_date].stringValue
        self.source = json[Article.constants.source].stringValue
    }
    
    func bitsAsString(list:List<TextBit>) -> String {
        let strings = list.map {
            (bit) -> String in
            return bit.word
        }
        return strings.joinWithSeparator("")
    }
}
