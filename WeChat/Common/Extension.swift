//
//  UIColor-Extension.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/14.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIColor 扩展
extension UIColor {
    convenience init(r : CGFloat, g : CGFloat, b : CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
    
    // 随机色
    class func randomColor() -> UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
    // 标准红
    class func commonColor() -> UIColor {
        return UIColor(r: CGFloat(211), g: CGFloat(61), b: CGFloat(61))
    }
    
    // 聊天背景颜色
    class func tableViewBackGroundColor() -> UIColor {
        return UIColor(r: CGFloat(236), g: CGFloat(236), b: CGFloat(236))
    }
    
    // 输入框颜色
    class func inputViewColor() -> UIColor {
        return UIColor(r: CGFloat(245), g: CGFloat(245), b: CGFloat(245))
    }
    
    // 昵称颜色
    class func textNameColor() -> UIColor {
        return UIColor(r: CGFloat(120), g: CGFloat(120), b: CGFloat(120))
    }
    
    
    
    
    // MARK: -- 默认主题黑色 取色软件ColorSlurp
    class func ThemeDefaultColor() -> UIColor {
        return UIColor(r: CGFloat(0), g: CGFloat(0), b: CGFloat(0))
    }
    
    // MARK: -- 微信绿
    class func ThemeGreenColor() -> UIColor {
        return UIColor(r: CGFloat(3), g: CGFloat(193), b: CGFloat(96))

    }
    
    // MARK: -- 白色
    class func ThemeWhiteColor() -> UIColor {
        return UIColor(r: CGFloat(255), g: CGFloat(255), b: CGFloat(255))
        
    }
    // MARK: -- 红色
    class func ThemeRedColor() -> UIColor {
        return UIColor(r: CGFloat(255), g: CGFloat(0), b: CGFloat(0))
        
    }
    
    // MARK: -- 红色
    class func Gray237Color() -> UIColor {
        return UIColor(r: CGFloat(237), g: CGFloat(237), b: CGFloat(237))
        
    }
    // MARK: -- 红色
    class func Gray213Color() -> UIColor {
        return UIColor(r: CGFloat(213), g: CGFloat(213), b: CGFloat(213))
        
    }
    
    
    /**
     UIColor with hex string
     
     - parameter hexString: #000000
     - parameter alpha:     alpha value
     
     - returns: UIColor
     */
    convenience init(_ hexString: String, alpha: Double = 1.0) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(255 * alpha) / 255)
    }
    
}


extension UIBarButtonItem {
    convenience init(imageName : String, target : AnyObject, action : Selector) {
        self.init()
        let Btn = UIButton()
        Btn.setImage(UIImage(named :imageName), for: .normal)
        Btn.setImage(UIImage(named : imageName), for: .highlighted)
        Btn.addTarget(target, action: action, for: UIControl.Event.touchUpInside)
        Btn.sizeToFit()
        self.customView = Btn
    }
}


extension AppDelegate {
    
    func switchRootVC()   {
        
        window?.rootViewController = UIViewController()
        window?.makeKeyAndVisible()
        // 获取用户数据
        let dbUser  = RealmTool.getDBUser()
        
        if dbUser.first == nil {
            window?.rootViewController = WelComeViewController()
            
        } else {
            window?.rootViewController = BaseTabBarController()
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
//                Toast.showCenterWithText(text: "自动登录成功")
                self.loadFriendList()
                // 加入房间
                socketClient.sendJoinRoom()
            }
            
            
        }
        window?.makeKeyAndVisible()
    }
    
    func loadFriendList()  {
        
        socketClient.sendLoadFriends()
    }
    
}


/// MARK - UIView
extension UIView {
    
    // MARK: - 常用位置属性
    public var left:CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newLeft) {
            var frame = self.frame
            frame.origin.x = newLeft
            self.frame = frame
        }
    }
    
    public var top:CGFloat {
        get {
            return self.frame.origin.y
        }
        
        set(newTop) {
            var frame = self.frame
            frame.origin.y = newTop
            self.frame = frame
        }
    }
    
    public var width:CGFloat {
        get {
            return self.frame.size.width
        }
        
        set(newWidth) {
            var frame = self.frame
            frame.size.width = newWidth
            self.frame = frame
        }
    }
    
    public var height:CGFloat {
        get {
            return self.frame.size.height
        }
        
        set(newHeight) {
            var frame = self.frame
            frame.size.height = newHeight
            self.frame = frame
        }
    }
    
    public var right:CGFloat {
        get {
            return self.left + self.width
        }
    }
    
    public var bottom:CGFloat {
        get {
            return self.top + self.height
        }
    }
    
    public var centerX:CGFloat {
        get {
            return self.center.x
        }
        
        set(newCenterX) {
            var center = self.center
            center.x = newCenterX
            self.center = center
        }
    }
    
    public var centerY:CGFloat {
        get {
            return self.center.y
        }
        
        set(newCenterY) {
            var center = self.center
            center.y = newCenterY
            self.center = center
        }
    }
}

extension String {
    func toRange(_ range: NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: range.location, limitedBy: utf16.endIndex) else { return nil }
        guard let to16 = utf16.index(from16, offsetBy: range.length, limitedBy: utf16.endIndex) else { return nil }
        guard let from = String.Index(from16, within: self) else { return nil }
        guard let to = String.Index(to16, within: self) else { return nil }
        return from ..< to
    }
    
    /*
     *去掉首尾空格
     */
    var removeHeadAndTailSpace:String {
        let whitespace = NSCharacterSet.whitespaces
        return self.trimmingCharacters(in: whitespace)
    }
    /*
     *去掉首尾空格 包括后面的换行 \n
     */
    var removeHeadAndTailSpacePro:String {
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        return self.trimmingCharacters(in: whitespace)
    }
    /*
     *去掉所有空格
     */
    var removeAllSapce: String {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
    /*
     *去掉首尾空格 后 指定开头空格数
     */
    func beginSpaceNum(num: Int) -> String {
        var beginSpace = ""
        for _ in 0..<num {
            beginSpace += " "
        }
        return beginSpace + self.removeHeadAndTailSpacePro
    }
}
extension UIImage {
    
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    
    static func from(color: UIColor,width: CGFloat,height: CGFloat) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    func fixOrientation() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }
        var transform = CGAffineTransform.identity
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: .pi)
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -.pi / 2)
            break
        default:
            break
        }
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1)
            break
        default:
            break
        }
        let ctx = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: self.cgImage!.colorSpace!, bitmapInfo: self.cgImage!.bitmapInfo.rawValue)
        ctx?.concatenate(transform)
        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(self.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.height), height: CGFloat(size.width)))
            break
        default:
            ctx?.draw(self.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.width), height: CGFloat(size.height)))
            break
        }
        let cgimg: CGImage = (ctx?.makeImage())!
        let img = UIImage(cgImage: cgimg)
        return img
    }
}





