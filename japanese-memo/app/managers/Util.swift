//
//  Util.swift
//  japanese-memo
//
//  Created by Tha Leang on 5/3/16.
//  Copyright © 2016 Tha Leang. All rights reserved.
//

import Foundation
import UIKit
import Toast_Swift

let UtilManager = Util()

final class Util {
    
    private let dateFormatter = NSDateFormatter()
    
    func showToastActivity(view:UIView, position:ToastPosition = .Center) {
        view.makeToastActivity(position)
        view.userInteractionEnabled = false
    }
    
    func finishToastActivity(view:UIView) {
        view.hideToastActivity()
        view.userInteractionEnabled = true
    }
    
    func dateFromString(dateString:String, format:String? = Constants.format.dateTimeFormat) -> NSDate? {
        dateFormatter.dateFormat = format
        return dateFormatter.dateFromString(dateString)
    }
    
    func stringFromDate(date:NSDate, format:String? = "yyyy-MM-dd") -> String {
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(date)
    }
    
    func numberOfDaysBetween(start:NSDate, end:NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day], fromDate: start, toDate: end, options: [])
        return components.day
    }
    
    func addDays(date: NSDate, additionalDays: Int) -> NSDate {
        let components = NSDateComponents()
        components.day = additionalDays
        let futureDate = NSCalendar.currentCalendar()
            .dateByAddingComponents(components, toDate: date, options: NSCalendarOptions(rawValue: 0))
        return futureDate!
    }
    
    /// Truncates the string to length number of characters and
    /// appends optional trailing string if longer
    func truncate(length: Int, text: String, trailing: String = "…") -> String {
        if text.characters.count > length {
            return text.substringToIndex(text.startIndex.advancedBy(length)) + trailing
        } else {
            return text
        }
    }
    
    func displayAlertView(title:String?, message:String?, cancelText:String? = "Cancel",confirmText:String? = "OK", viewController:UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: confirmText, style: .Default, handler: nil))
        alert.addAction(UIAlertAction(title: cancelText, style: .Cancel, handler: nil))
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    func selectNextTextField(textFields:[UITextField!], selectedTextField:UITextField, finishCallback: ((object:UITextField) -> Void)?) {
        let index = textFields.indexOf({$0 === selectedTextField})
        if let value = index {
            if (value + 1) >= textFields.count {
                if let callback = finishCallback {
                    callback(object: selectedTextField)
                }
            }
            else {
                textFields[value+1].becomeFirstResponder()
            }
        }
    }
}
