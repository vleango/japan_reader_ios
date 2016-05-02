//
//  TableViewImageCacher.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/3/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import UIKit

class TableViewImageCacher {
    
    var imageCache = Dictionary<String, UIImage>()
    
    func start(urls:[String?], callback:(downloadedURL: String) -> Void) {
        for url in urls {
            if let validURL = url {
                if imageCache[validURL] == nil {
                    NetworkManager.downloadImage(validURL, callback: { (image) -> Void in
                        if let downloadedImage = image {
                            self.imageCache[validURL] = downloadedImage
                            callback(downloadedURL: validURL)
                        }
                    })
                }
            }
        }
    }
    
    func setImageFor(url:String, imageView:UIImageView) {
        if (imageCache[url] != nil) {
            imageView.alpha = 0.0
            imageView.image = imageCache[url]
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                imageView.alpha = 1.0
            })
        }
    }
}
