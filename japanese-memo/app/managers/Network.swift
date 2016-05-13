//
//  Network.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/1/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import Foundation
import Alamofire

let NetworkManager = Network()

final class Network {
    
    private init() {
        // do nothing - required to stop other instances being
        // created by code in other files
    }
    private var isLoading:Bool = false
    
    func downloadImage(url:String, callback: (UIImage? -> Void)) {
        Alamofire.request(.GET, url).responseData { response -> Void in
            if let imageData = response.data {
                callback(UIImage(data: imageData))
            }
        }
    }
    
    func search(params:[String : AnyObject], callback: ((success:Bool, object:AnyObject?) -> Void)?) {
        let url = "searches"
        execute(url, method: .POST, params:addLang(params), callback: callback)
    }
    
    // Setting Lang to the params
    private func addLang(params:[String:AnyObject]?) -> [String:AnyObject] {
        if let validParams = params {
            var paramsWithLang = validParams
            paramsWithLang["search[lang]"] = Default.getLanguage().id
            return paramsWithLang
        }
        else {
            return ["lang": Default.getLanguage().id]
        }
    }
    
    func reads(type:Article.articleTypes = .all, params:[String : AnyObject], callback: ((success:Bool, object:AnyObject?) -> Void)?) {
        var url = "articles"
        switch type {
        case .all: break
        case .easy:
            url = url.stringByAppendingString("/easys")
        case .normal:
            url = url.stringByAppendingString("/normals")
        }
        
        execute(url, params:params, callback: callback)
    }
    
    func read(articleId: String, callback: ((success:Bool, object:AnyObject?) -> Void)?) {
        let url = "articles/\(articleId)"
        execute(url, params:nil, callback: callback)
    }
    
    func translation(params:[String : AnyObject], callback: ((success:Bool, object:AnyObject?) -> Void)?) {
        let url = "searches"
        execute(url, method: .POST, params:addLang(params), callback: callback)
    }
    
    func favorites(callback: ((success:Bool, object:AnyObject?) -> Void)?) {
        let url = "users/favorites"
        execute(url, params: addLang(nil), callback: callback)
    }
    
    func isFavorite(params:[String:AnyObject], callback: ((success:Bool, object:AnyObject?) -> Void)?) {
        let url = "users/favorites/contains"
        execute(url, params: params, callback: callback)
    }
    
    func availableLanguages(callback: ((success:Bool, object:AnyObject?) -> Void)?) {
        let url = "settings/languages"
        execute(url, method: .GET, params:nil, callback: callback)
    }
    
    private func execute(
        url:String,
        method:Alamofire.Method = .GET,
        params:[String : AnyObject]?,
        callback: ((success:Bool, response:AnyObject?) -> Void)?) {
        
        if isLoading == false {
            isLoading = true
            var header:[String: String]?
            if let userID = LoginManager.AccessTokenUserId() {
                header = ["AUTHORIZATION" : "Bearer \(userID)"]
            }

            Alamofire.request(method, "\(Constants.app.apiUrl)\(url)", parameters: params, headers: header)
                .responseJSON { response in
                    self.isLoading = false
                    if let block = callback {
                        switch response.result {
                        case .Success:
                            block(success:true, response: response.result.value)
                        default:
                            block(success:false, response: response.result.value)
                            break
                        }
                    }
            }
        }
        
    }
    
    // MARK - Special Conditioned Methods
    
    // should not be called on it's own, should use LoginManager.addEntry / .addArticle
    func addFavorite(params:[String : AnyObject], callback: ((success:Bool, object:AnyObject?) -> Void)?) {
        let url = "users/favorites"
        execute(url, method: .POST, params: params, callback: callback)
    }
    
    // should not be called on it's own, should use LoginManager.removeEntry / .removeArticle
    func removeFavorite(resourceId:String, callback: ((success:Bool, object:AnyObject?) -> Void)?) {
        let url = "users/favorites/\(resourceId)"
        execute(url, method: .DELETE, params: nil, callback: callback)
    }
}