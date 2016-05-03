//  Created by Tony Mann on 3/22/15.
//  Copyright (c) 2015 7Actions. All rights reserved.
//
//  Adapted from http://ossh.com.au/design-and-technology/software-development/implementing-rich-text-with-images-on-os-x-and-ios/

import UIKit

class ImageAttachment: NSTextAttachment {
    var reduction: CGFloat = 0.8

    convenience init(_ image: UIImage, reduction: CGFloat = 1.0) {
        self.init()
        self.image = image
        self.reduction = reduction
    }
    
    override func attachmentBoundsForTextContainer(textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        var scale: CGFloat = 1.0;
        let imageSize = image!.size

        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = (screenSize.width * reduction)
        scale = screenWidth / imageSize.width

        //return CGRect(x: 0, y: verticalOffset, width: imageSize.width * scale, height: imageSize.height * scale)
        return CGRectMake(0, 0, imageSize.width * scale, imageSize.height * scale)
    }
}