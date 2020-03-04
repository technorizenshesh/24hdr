//
//  PredefinedConstants.swift
//  Social Ride
//
//  Created by mac on 05/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

let keyUserInfo = "userInfo"

class PredefinedConstants: NSObject {
    static let ScreenWidth =  UIScreen.main.bounds.width
    static let ScreenHeight =  UIScreen.main.bounds.height
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let userDeviceId = UIDevice.current.identifierForVendor!.uuidString
    static let deviceOSVersion = NSString(string: UIDevice.current.systemVersion).floatValue
    static let appVersion: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?
    static var localTimeZoneName: String { return TimeZone.current.identifier }
    

    static func appColor() -> UIColor {
        return UIColor(red:157.0/255.0, green:612.0/255.0, blue:631.0/255.0, alpha:1)
    }
    
    static func statusBarColor() -> UIColor {
        return UIColor(red:61.0/255.0, green:142.0/255.0, blue:171.0/255.0, alpha:1)
    }
    
}

func getCurrentDate(_ dateFormatter: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormatter
    return formatter.string(from: Date())
}


func string (_ dict:NSDictionary, _ key:String) -> String {
    if let title = dict[key] as? String {
        return "\(title)"
    } else if let title = dict[key] as? NSNumber {
        return "\(title)"
    } else {
        return ""
    }
}

func number (_ dict:NSDictionary, _ key:String) -> NSNumber {
    if let title = dict[key] as? NSNumber {
        return title
    } else if let title0 = dict[key] as? String {
        let title = title0.trimmingCharacters(in: .whitespacesAndNewlines)
        if let title1 = Int(title) as Int? {
            return NSNumber(value: title1)
        } else if let title1 = Float(title) as Float? {
            return NSNumber(value: title1)
        } else if let title1 = Double(title) as Double? {
            return NSNumber(value: title1)
        } else if let title1 = Bool(title) as Bool? {
            return NSNumber(value: title1)
        }
        
        return 0
    } else {
        return 0
    }
}

func bool (_ dict:NSDictionary, _ key:String) -> Bool {
    if let title = dict[key] as? Bool {
        return title
    } else {
        return false
    }
}

func callPhoneNumber(_ phoneNumber:String) {
    
    if let url = URL(string: "tel://\(phoneNumber)") {
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url as URL)
        }
    } else {
        Http.alert("", "Phone call not available.")
    }
}
