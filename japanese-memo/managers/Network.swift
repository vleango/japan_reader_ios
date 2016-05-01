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
    
    func search(params:[String : AnyObject], callback: ((success:Bool, object:AnyObject?) -> Void)?) {
        let url = "searches"
        execute(url, method: .POST, params:params, callback: callback)
    }
    
    private func execute(
        url:String,
        method:Alamofire.Method = .GET,
        params:[String : AnyObject]?,
        callback: ((success:Bool, response:AnyObject?) -> Void)?) {
        
        if isLoading == false {
            isLoading = true
            var header:[String: String]?
            
            Alamofire.request(method, "http://localhost:3000/jdict/\(url)", parameters: params, headers: header)
                .responseJSON { response in
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
    
}