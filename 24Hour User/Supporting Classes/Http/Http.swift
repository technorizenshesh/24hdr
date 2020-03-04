//
//  Http.swift
//  Social Ride
//
//  Created by mac on 05/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import Alamofire

class Http: NSObject {

    class func hexStringToUIColor (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func currTime () -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"//.SSSZ"
        let date = Date()
        let str = dateFormatter.string(from: date)
        
        return str
    }
    
    class func alert (_ ttl:String?, _ msg:String?) {
        if (msg != nil) {
            if (msg?.count)! > 0 {
                DispatchQueue.main.async {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    let alertController:UIAlertController
                    
                    var ttl = ttl
                    
                    if (ttl == nil) {
                        ttl = ""
                    }
                    
                    alertController = UIAlertController(title: ttl, message: msg, preferredStyle: .alert)
                    
                    let defaultActionq = UIAlertAction(title: "Ok", style: .default, handler: { (_ action:UIAlertAction) in
                        
                    })
                    
                    alertController.addAction(defaultActionq)
                    
                    appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: { })
                }
            }
        }
    }
    class func alert12 (_ ttl:String?, _ msg:String?,view:UIViewController) {
        if (msg != nil) {
            if (msg?.count)! > 0 {
                DispatchQueue.main.async {
                    
                    let alertController:UIAlertController
                    
                    var ttl = ttl
                    
                    if (ttl == nil) {
                        ttl = ""
                    }
                    
                    alertController = UIAlertController(title: ttl, message: msg, preferredStyle: .alert)
                    
                    let defaultActionq = UIAlertAction(title: "Ok", style: .default, handler: { (_ action:UIAlertAction) in
                        
                    })
                    
                    alertController.addAction(defaultActionq)
                    
                    view.present(alertController, animated: true, completion: { })
                }
            }
        }
    }
    func alert (_ ttl:String?, _ msg:String?) {
        Http.alert(ttl, msg)
    }
    
    class func alert (_ ttl:String?, _ msg:String?, _ btns:[Any]) {
        if (msg != nil) {
            if (msg?.count)! > 0 {
                DispatchQueue.main.async {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    let alertController:UIAlertController
                    
                    var ttl = ttl
                    
                    if (ttl == nil) {
                        ttl = ""
                    }
                    
                    alertController = UIAlertController(title: ttl, message: msg, preferredStyle: .alert)
                    
                    if btns.count >= 2 {
                        alertController.addAction(self.alertAction(btns, 0))
                    }
                    
                    if btns.count >= 3 {
                        alertController.addAction(self.alertAction(btns, 1))
                    }
                    appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: { })
                }
            }
        }
    }
    
    class func alertAction (_ btns:[Any], _ index:Int) -> UIAlertAction {
        let action = UIAlertAction(title: (btns[index + 1] as? String)!, style: .default, handler: { (_ action:UIAlertAction) in
            
            let vc = btns[0] as? UIViewController
            
            if index == 0 {
                vc?.alertZero()
            } else if index == 1 {
                vc?.alertOne()
            }
        })
        
        return action
    }
    
    class func instance () -> Http {
        return Http()
    }
    
    
    func json(_ api: String, _ params: NSMutableDictionary? = nil, _ ai: Bool, _ loadMsg: String? = nil, _ vw: UIView,  _ images: NSMutableArray? = nil,   _ audios: NSMutableArray? = nil,   _ videos: NSMutableArray? = nil, completionHandler: @escaping (NSDictionary) -> Swift.Void) {
        
        if ai {
            if loadMsg != nil {
                vw.showHUD(loadMsg!)
            } else {
                vw.showHUD("Loading...")
            }
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if images != nil {
                for i in 0..<images!.count {
                    if let dict = images!.object(at: i) as? NSDictionary {
                        let paramName = string(dict, "name")
                        if let image = dict.object(forKey: "image") as? UIImage {
                            multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: paramName, fileName: "\(paramName).jpeg", mimeType: "image/jpeg")
                        }
                    }
                }
            }
            
            if audios != nil {
                for i in 0..<audios!.count {
                    if let dict = audios!.object(at: i) as? NSDictionary {
                        let paramName = string(dict, "name")
                        if let audio = dict.object(forKey: "audio") as? Data {
                            multipartFormData.append(audio, withName: paramName, fileName: "\(paramName).mp3", mimeType: "audio/m4a")
                        }
                    }
                }
            }
            
            if videos != nil {
                for i in 0..<videos!.count {
                    if let dict = videos!.object(at: i) as? NSDictionary {
                        let paramName = string(dict, "name")
                        if let video = dict.object(forKey: "video") as? Data {
                            multipartFormData.append(video, withName: paramName, fileName: "\(paramName).mp4", mimeType: "video/mp4")
                        } else if let video = dict.object(forKey: "video") as? URL {
                            multipartFormData.append(video, withName: paramName, fileName: "\(paramName).mp4", mimeType: "video/mp4")
                        }
                    }
                }
            }
            
            if params != nil {
                for (key, value) in params! {
                    let key1 = key as! String
                    //let val1 = value as! String
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key1)
                }
            }
        }, to: api)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                    print("progress-\(progress)-")
                })
                
                upload.responseJSON { response in
                    DispatchQueue.main.async {
                        if ai {
                            vw.hideHUD()
                        }
                        print("url-\(api)-")
                        print("params-\(params))-")
                        
                        if let json = response.result.value as? NSDictionary {
                            print("responce-\(json)-")
                            DispatchQueue.main.async {
                                completionHandler(json)
                            }
                        } else {
                            Http.alert("", response.error?.localizedDescription)
                        }
                    }
                }
            case .failure(let encodingError):
                if ai {
                    vw.hideHUD()
                }
                Http.alert("", encodingError.localizedDescription)
                //print("responce-\(encodingError.localizedDescription)-")
            }
        }
    }
    
}


extension UIViewController {
    @objc func alertZero () {
        
    }
    
    @objc func alertOne () {
        
    }
}
