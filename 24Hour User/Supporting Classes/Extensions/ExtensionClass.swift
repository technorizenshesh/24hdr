//
//  ExtensionClass.swift
//  Solviepro Hire
//
//  Created by mac on 28/05/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import MBProgressHUD

class ExtensionClass: NSObject {

}

//MARK: UIVIEW
extension UIView {
    
    func takeScreenshot() -> UIImage {
        // Begin context
        //UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        /*
         UIGraphicsBeginImageContext(self.view!.window!.bounds.size)
         self.view!.window!.layer.renderInContext(UIGraphicsGetCurrentContext())
         let screenshot = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndImageContext()
         */
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
    
    var snapshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        defer { UIGraphicsEndImageContext() }
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

//MARK: STRING
extension String {
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    func isOnlyNumber() -> Bool {
        let charcterSet  = NSCharacterSet(charactersIn: "0123456789").inverted
        let inputString = self.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return self == filtered
    }
    
    func isOnlyString() -> Bool {
        let RegEx = "^[a-zA-Z]+$"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: self)
    }
    
    func converDate(_ from:String, _ to:String) -> String {
        if self.count == 0 {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = from
        let myDate:Date? = dateFormatter.date(from: self)
        
        dateFormatter.dateFormat = to
        
        if myDate == nil {
            return ""
        } else {
            return dateFormatter.string(from: myDate!)
        }
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    func capFirstLetter() -> String {
        let first = String(self.prefix(1)).capitalized
        let other = String(self.dropFirst())
        return first + other
    }
    
    func encodeEmoji() -> String {
        let data = self.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
    
    func decodeEmoji() -> String? {
        let data = self.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII)
    }
    
}

//TABLEVIEW
extension UITableView {
    func reloadData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
        { _ in completion() }
    }
    
    func scrollToBottom(animated: Bool = true) {
                DispatchQueue.main.async {

        let section = self.numberOfSections
        if section > 0 {
            let row = self.numberOfRows(inSection: section - 1)
            if row > 0 {
                self.scrollToRow(at: NSIndexPath(row: row - 1, section: section - 1) as IndexPath, at: .bottom, animated: animated)
            }
        }
        }
    }
//    func scrollToBottom(animated: Bool){
//        
//        DispatchQueue.main.async {
//            let indexPath = IndexPath(
//                row: self.numberOfRows(inSection:  self.numberOfSections - 1) - 1,
//                section: self.numberOfSections - 0)
//            self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
//        }
//    }
    
    func scrollToTop(animated: Bool) {
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: animated)
        }
    }
}


//UICOLOR
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    class func hexColor(rgbValue:UInt32, alpha:Double=1.0) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}

extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}





/*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-UI EXTENTIONS-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-*/


extension UIView {
    func showHUD(_ message: String) {
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud.label.text = message
        hud.isUserInteractionEnabled = false
    }
    
    func hideHUD() {
        MBProgressHUD.hide(for: self, animated: true)
    }
}

extension UIButton {
    func getCircleRadius() {
        self.layer.cornerRadius = self.bounds.size.height/2
    }
}

extension UIView {
    func getVwCircleRadius() {
        self.layer.cornerRadius = self.bounds.size.height/2
    }
}

class View : UIView {
    @IBInspectable open var isBorder: Bool = false
    
    @IBInspectable open var border: Int = 0
    
    @IBInspectable open var radious: Int = 0
    
    @IBInspectable open var borderColor: UIColor? = nil
    
    @IBInspectable open var isShadow: Bool = false
    
    @IBInspectable open var shadow_Color: UIColor? = UIColor.darkGray
    
    @IBInspectable open var ls_Opacity:CGFloat = 0.5
    @IBInspectable open var ls_Radius:Int = 0
    
    @IBInspectable open var lsOff_Width:CGFloat = 2.0
    @IBInspectable open var lsOff_Height:CGFloat = 2.0
    
    @IBInspectable open var isStrokeColor: Bool = false
    
    override func draw(_ rect: CGRect) {
        if isStrokeColor {
            let c = UIGraphicsGetCurrentContext()
            c!.addRect(CGRect(x: 10.0, y: 10.0, width: 80.0, height: 80.0))
            c!.setStrokeColor(UIColor.red.cgColor)
            c!.strokePath()
        }
    }
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isShadow {
            if shadowLayer == nil {
                let color = self.backgroundColor
                self.backgroundColor = UIColor.clear
                
                shadowLayer = CAShapeLayer()
                shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: CGFloat(radious)).cgPath
                shadowLayer.fillColor = color?.cgColor
                
                shadowLayer.shadowColor = shadow_Color?.cgColor
                shadowLayer.shadowPath = shadowLayer.path
                shadowLayer.shadowOffset = CGSize(width: lsOff_Width, height: lsOff_Height)
                shadowLayer.shadowOpacity = Float(ls_Opacity)
                shadowLayer.shadowRadius = CGFloat(ls_Radius)
                
                layer.insertSublayer(shadowLayer, at: 0)
            }
        } else if isBorder {
            border1(borderColor, CGFloat(radious), CGFloat(border))
        }
    }
    
    func layoutSubviews11() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            let color = self.backgroundColor
            self.backgroundColor = UIColor.clear
            
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: CGFloat(self.tag)).cgPath
            shadowLayer.fillColor = color?.cgColor
            
            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.5
            shadowLayer.shadowRadius = 2
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    
    func border1 (_ color:UIColor?, _ cornerRadius:CGFloat, _ borderWidth:CGFloat) {
        self.layer.masksToBounds = true
        if (color != nil) { self.layer.borderColor = color?.cgColor }
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
    }
}

class Label : UILabel {
    @IBInspectable open var isBorder: Bool = false
    
    @IBInspectable open var border: Int = 0
    
    @IBInspectable open var radious: Int = 0
    
    @IBInspectable open var borderColor: UIColor? = nil
    
    @IBInspectable open var isShadow: Bool = false
    
    @IBInspectable open var shadow_Color: UIColor? = UIColor.darkGray
    
    @IBInspectable open var ls_Opacity:CGFloat = 0.5
    @IBInspectable open var ls_Radius:Int = 0
    
    @IBInspectable open var lsOff_Width:CGFloat = 2.0
    @IBInspectable open var lsOff_Height:CGFloat = 2.0
    
    @IBInspectable open var isStrokeColor: Bool = false
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isShadow {
            if shadowLayer == nil {
                let color = self.backgroundColor
                self.backgroundColor = UIColor.clear
                
                shadowLayer = CAShapeLayer()
                shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: CGFloat(radious)).cgPath
                shadowLayer.fillColor = color?.cgColor
                
                shadowLayer.shadowColor = shadow_Color?.cgColor
                shadowLayer.shadowPath = shadowLayer.path
                shadowLayer.shadowOffset = CGSize(width: lsOff_Width, height: lsOff_Height)
                shadowLayer.shadowOpacity = Float(ls_Opacity)
                shadowLayer.shadowRadius = CGFloat(ls_Radius)
                
                layer.insertSublayer(shadowLayer, at: 0)
            }
        } else if isBorder {
            border1(borderColor, CGFloat(radious), CGFloat(border))
        }
    }
    
    func layoutSubviews11() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            let color = self.backgroundColor
            self.backgroundColor = UIColor.clear
            
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: CGFloat(self.tag)).cgPath
            shadowLayer.fillColor = color?.cgColor
            
            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.5
            shadowLayer.shadowRadius = 2
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    
    func border1 (_ color:UIColor?, _ cornerRadius:CGFloat, _ borderWidth:CGFloat) {
        self.layer.masksToBounds = true
        if (color != nil) { self.layer.borderColor = color?.cgColor }
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
    }
}


class ImageView : UIImageView {
    @IBInspectable open var isBorder: Bool = false
    
    @IBInspectable open var border: Int = 0
    
    @IBInspectable open var radious: Int = 0
    
    @IBInspectable open var borderColor: UIColor? = nil
    
    @IBInspectable open var isShadow: Bool = false
    
    @IBInspectable open var shadow_Color: UIColor? = UIColor.darkGray
    
    @IBInspectable open var ls_Opacity:CGFloat = 0.5
    @IBInspectable open var ls_Radius:Int = 0
    
    @IBInspectable open var lsOff_Width:CGFloat = 2.0
    @IBInspectable open var lsOff_Height:CGFloat = 2.0
    
    @IBInspectable open var isStrokeColor: Bool = false
    
    override func draw(_ rect: CGRect) {
        if isStrokeColor {
            let c = UIGraphicsGetCurrentContext()
            c!.addRect(CGRect(x: 10.0, y: 10.0, width: 80.0, height: 80.0))
            c!.setStrokeColor(UIColor.red.cgColor)
            c!.strokePath()
        }
    }
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isShadow {
            if shadowLayer == nil {
                let color = self.backgroundColor
                self.backgroundColor = UIColor.clear
                
                shadowLayer = CAShapeLayer()
                shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: CGFloat(radious)).cgPath
                shadowLayer.fillColor = color?.cgColor
                
                shadowLayer.shadowColor = shadow_Color?.cgColor
                shadowLayer.shadowPath = shadowLayer.path
                shadowLayer.shadowOffset = CGSize(width: lsOff_Width, height: lsOff_Height)
                shadowLayer.shadowOpacity = Float(ls_Opacity)
                shadowLayer.shadowRadius = CGFloat(ls_Radius)
                
                layer.insertSublayer(shadowLayer, at: 0)
            }
        } else if isBorder {
            border1(borderColor, CGFloat(radious), CGFloat(border))
        }
    }
    
    func border1 (_ color:UIColor?, _ cornerRadius:CGFloat, _ borderWidth:CGFloat) {
        self.layer.masksToBounds = true
        if (color != nil) { self.layer.borderColor = color?.cgColor }
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
    }
}

// MARK: Button

class Button : UIButton {
    @IBInspectable open var isBorder: Bool = false
    
    @IBInspectable open var border: Int = 0
    
    @IBInspectable open var radious: Int = 0
    
    @IBInspectable open var borderColor: UIColor? = nil
    
    @IBInspectable open var isShadow: Bool = false
    
    @IBInspectable open var shadow_Color: UIColor? = UIColor.darkGray
    
    @IBInspectable open var ls_Opacity:CGFloat = 0.5
    @IBInspectable open var ls_Radius:Int = 0
    
    @IBInspectable open var lsOff_Width:CGFloat = 2.0
    @IBInspectable open var lsOff_Height:CGFloat = 2.0
    
    @IBInspectable open var isStrokeColor: Bool = false
    
    override func draw(_ rect: CGRect) {
        if isStrokeColor {
            let c = UIGraphicsGetCurrentContext()
            c!.addRect(CGRect(x: 10.0, y: 10.0, width: 80.0, height: 80.0))
            c!.setStrokeColor(UIColor.red.cgColor)
            c!.strokePath()
        }
    }
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isShadow {
            if shadowLayer == nil {
                let color = self.backgroundColor
                self.backgroundColor = UIColor.clear
                
                shadowLayer = CAShapeLayer()
                shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: CGFloat(radious)).cgPath
                shadowLayer.fillColor = color?.cgColor
                
                shadowLayer.shadowColor = shadow_Color?.cgColor
                shadowLayer.shadowPath = shadowLayer.path
                shadowLayer.shadowOffset = CGSize(width: lsOff_Width, height: lsOff_Height)
                shadowLayer.shadowOpacity = Float(ls_Opacity)
                shadowLayer.shadowRadius = CGFloat(ls_Radius)
                
                layer.insertSublayer(shadowLayer, at: 0)
            }
        } else if isBorder {
            border1(borderColor, CGFloat(radious), CGFloat(border))
        }
    }
    
    func border1 (_ color:UIColor?, _ cornerRadius:CGFloat, _ borderWidth:CGFloat) {
        self.layer.masksToBounds = true
        if (color != nil) { self.layer.borderColor = color?.cgColor }
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
    }
}


class TextView : UITextView {
    @IBInspectable open var isBorder: Bool = false
    
    @IBInspectable open var border: Int = 0
    
    @IBInspectable open var radious: Int = 0
    
    @IBInspectable open var borderColor: UIColor? = nil
    
    @IBInspectable open var isShadow: Bool = false
    
    @IBInspectable open var shadow_Color: UIColor? = UIColor.darkGray
    
    @IBInspectable open var ls_Opacity:CGFloat = 0.5
    @IBInspectable open var ls_Radius:Int = 0
    
    @IBInspectable open var lsOff_Width:CGFloat = 2.0
    @IBInspectable open var lsOff_Height:CGFloat = 2.0
    
    @IBInspectable open var isStrokeColor: Bool = false
    
    override func draw(_ rect: CGRect) {
        if isStrokeColor {
            let c = UIGraphicsGetCurrentContext()
            c!.addRect(CGRect(x: 10.0, y: 10.0, width: 80.0, height: 80.0))
            c!.setStrokeColor(UIColor.red.cgColor)
            c!.strokePath()
        }
    }
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isShadow {
            if shadowLayer == nil {
                let color = self.backgroundColor
                self.backgroundColor = UIColor.clear
                
                shadowLayer = CAShapeLayer()
                shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: CGFloat(radious)).cgPath
                shadowLayer.fillColor = color?.cgColor
                
                shadowLayer.shadowColor = shadow_Color?.cgColor
                shadowLayer.shadowPath = shadowLayer.path
                shadowLayer.shadowOffset = CGSize(width: lsOff_Width, height: lsOff_Height)
                shadowLayer.shadowOpacity = Float(ls_Opacity)
                shadowLayer.shadowRadius = CGFloat(ls_Radius)
                
                layer.insertSublayer(shadowLayer, at: 0)
            }
        } else if isBorder {
            border1(borderColor, CGFloat(radious), CGFloat(border))
        }
    }
    
    func border1 (_ color:UIColor?, _ cornerRadius:CGFloat, _ borderWidth:CGFloat) {
        self.layer.masksToBounds = true
        if (color != nil) { self.layer.borderColor = color?.cgColor }
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
    }
}


// MARK: extension UITextField

extension UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

//MARK: UIVIEW INNER COLOR
extension UIView
{
    // different inner shadow styles
    public enum innerShadowSide
    {
        case all, left, right, top, bottom, topAndLeft, topAndRight, bottomAndLeft, bottomAndRight, exceptLeft, exceptRight, exceptTop, exceptBottom
    }
    
    // define function to add inner shadow
    public func addInnerShadow(onSide: innerShadowSide, shadowColor: UIColor, shadowSize: CGFloat, cornerRadius: CGFloat = 0.0, shadowOpacity: Float)
    {
        // define and set a shaow layer
        let shadowLayer = CAShapeLayer()
        shadowLayer.frame = bounds
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        shadowLayer.shadowOpacity = shadowOpacity
        shadowLayer.shadowRadius = shadowSize
        shadowLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        // define shadow path
        let shadowPath = CGMutablePath()
        
        // define outer rectangle to restrict drawing area
        let insetRect = bounds.insetBy(dx: -shadowSize * 2.0, dy: -shadowSize * 2.0)
        
        // define inner rectangle for mask
        let innerFrame: CGRect = { () -> CGRect in
            switch onSide
            {
            case .all:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height)
            case .left:
                return CGRect(x: 0.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 4.0)
            case .right:
                return CGRect(x: -shadowSize * 2.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 4.0)
            case .top:
                return CGRect(x: -shadowSize * 2.0, y: 0.0, width: frame.size.width + shadowSize * 4.0, height: frame.size.height + shadowSize * 2.0)
            case.bottom:
                return CGRect(x: -shadowSize * 2.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 4.0, height: frame.size.height + shadowSize * 2.0)
            case .topAndLeft:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .topAndRight:
                return CGRect(x: -shadowSize * 2.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .bottomAndLeft:
                return CGRect(x: 0.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .bottomAndRight:
                return CGRect(x: -shadowSize * 2.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .exceptLeft:
                return CGRect(x: -shadowSize * 2.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height)
            case .exceptRight:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height)
            case .exceptTop:
                return CGRect(x: 0.0, y: -shadowSize * 2.0, width: frame.size.width, height: frame.size.height + shadowSize * 2.0)
            case .exceptBottom:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height + shadowSize * 2.0)
            }
        }()
        
        // add outer and inner rectangle to shadow path
        shadowPath.addRect(insetRect)
        shadowPath.addRect(innerFrame)
        
        // set shadow path as show layer's
        shadowLayer.path = shadowPath
        
        // add shadow layer as a sublayer
        layer.addSublayer(shadowLayer)
        
        // hide outside drawing area
        clipsToBounds = true
    }
}






