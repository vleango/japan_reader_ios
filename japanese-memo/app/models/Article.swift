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
    
    enum articleTypes:Int { case all, easy, normal }
    
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
        static let body_bits = "body_bits"
        static let favorite_id = "favorite_id"
        static let images = "images"
        static let app_source = "app_source"
    }
    
    dynamic var id = ""
    dynamic var provider = ""
    dynamic var news_id = ""
    dynamic var published_date = ""
    dynamic var image_url:String? = ""
    dynamic var source = ""
    dynamic var appSource = ""
    dynamic var title = ""
    dynamic var body = ""
    dynamic var favoriteId:String = ""
    
    let titleBits = List<TextBit>()
    let bodyBits = List<TextBit>()
    let images = List<ArticleImage>()
    
    convenience init(json:JSON) {
        self.init()
        self.id = json[Article.constants.id].stringValue
        self.provider = json[Article.constants.provider].stringValue
        self.news_id = json[Article.constants.news_id].stringValue
        self.title = json[Article.constants.title].stringValue
        self.body = json[Article.constants.body].stringValue
        
        self.favoriteId = json[Article.constants.favorite_id].stringValue
        
        let titleBitsArray = json[Article.constants.title_bits].arrayValue
        for bit in titleBitsArray {
            self.titleBits.append(TextBit.init(json: bit))
        }
        
        let bodyBitsArray = json[Article.constants.body_bits].arrayValue
        for bit in bodyBitsArray {
            self.bodyBits.append(TextBit.init(json: bit))
        }

        let imageUrl = json[Article.constants.image_url].stringValue
        if imageUrl != "" {
            self.image_url = "\(Constants.app.domain)\(imageUrl)"
        }
        self.published_date = json[Article.constants.published_date].stringValue
        self.source = json[Article.constants.source].stringValue
        self.appSource = json[Article.constants.app_source].stringValue
        
        let imagesArr = json[Article.constants.images].arrayValue
        for image in imagesArr {
            self.images.append(ArticleImage.init(json: image))
        }
    }
    
    func bitsAsString(list:List<TextBit>) -> String {
        let strings = list.map {
            (bit) -> String in
            return bit.word
        }
        return strings.joinWithSeparator("")
    }
    
    func prettyPublishedDate(format:String = "yy-MM-dd hh:mm") -> String? {
        var string:String?
        let date = UtilManager.dateFromString(published_date)
        if let validDate = date {
            string = UtilManager.stringFromDate(validDate, format: format)
        }
        return string
    }
}
