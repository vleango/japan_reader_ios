//
//  RubyView.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/3/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import UIKit

class RubyView: UIView {
    
    private var string:String!
    private var ruby:String!
    
    init(frame: CGRect, string:String, ruby:String) {
        super.init(frame: frame)
        self.string = string
        self.ruby = ruby
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func drawRect(rect: CGRect) {
        
        
        var text = [.passRetained(ruby) as Unmanaged<CFStringRef>?, .None, .None, .None]
        let annotation = CTRubyAnnotationCreate(.Auto, .Auto, 0.5, &text)
        
        let textSize = CGFloat.abs(30.0)
        
        let attributed = NSAttributedString(string: string, attributes: [
            NSFontAttributeName: UIFont(name: "HiraMinProN-W6", size: textSize)!,
            //NSForegroundColorAttributeName: UIColor(red: 0.788, green: 0.522, blue: 0.337, alpha: 1.0),
            NSForegroundColorAttributeName: UIColor.blackColor(),
            kCTRubyAnnotationAttributeName as String: annotation,
            ])

        let size = attributed.boundingRectWithSize(
            CGSizeZero,
            options: .UsesLineFragmentOrigin,
            context: nil)
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0)
        // CGContextSetRGBFillColor(context, 0.984, 0.922, 0.69, 1.0)
        CGContextAddRect(context, rect)
        CGContextFillPath(context)
        
        //CGContextTranslateCTM(context, (rect.width - size.width) / 2.0, 200.0)
        CGContextTranslateCTM(context, (rect.width - size.width) / 2.0, textSize + 15)
        
        CGContextScaleCTM(context, 1.0, -1.0)
        
        let line = CTLineCreateWithAttributedString(attributed)
        CTLineDraw(line, context!)
    }

}
