//
//  Theme.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/14.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit


enum ThemeColor {
//    case 
}

class Theme: NSObject {
    
    static let share = Theme()
    open func themeSet(index : Int) {
        
        let tabC : BaseTabBarController = UIApplication.shared.keyWindow?.rootViewController as! BaseTabBarController
        
        switch index {
        case 0:
            tabC.tabBar.barStyle = .default
            tabC.tabBar.tintColor = UIColor.ThemeDefaultColor()
            let dict : NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor.ThemeDefaultColor(),NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]
            for  vc in tabC.children {
                let nav = vc as! BaseNavigationController
                nav.navigationBar.barStyle = .default
                nav.navigationBar.tintColor = UIColor.ThemeDefaultColor()
                nav.navigationBar.titleTextAttributes = dict as? [NSAttributedString.Key : AnyObject]
            }
            
        case 1:
            tabC.tabBar.barStyle = .black
            tabC.tabBar.tintColor = UIColor.ThemeWhiteColor()
            let dict : NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor.ThemeWhiteColor(),NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]
            for  vc in tabC.children {
                let nav = vc as! BaseNavigationController
                
                nav.navigationBar.barStyle = .black
                nav.navigationBar.tintColor = UIColor.ThemeWhiteColor()
                nav.navigationBar.titleTextAttributes = dict as? [NSAttributedString.Key : AnyObject]
            }
        case 2:
            tabC.tabBar.barStyle = .default
            tabC.tabBar.tintColor = UIColor.ThemeGreenColor()
            
            let dict : NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]
            
            for  vc in tabC.children {
                let nav = vc as! BaseNavigationController
                
                nav.navigationBar.barStyle = .default
                nav.navigationBar.tintColor = UIColor.black
                nav.navigationBar.titleTextAttributes = dict as? [NSAttributedString.Key : AnyObject]
            }
        case 3:
            tabC.tabBar.barStyle = .black
            tabC.tabBar.tintColor = UIColor.ThemeRedColor()
            let dict : NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor.ThemeRedColor(),NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]
            for  vc in tabC.children {
                let nav = vc as! BaseNavigationController
                
                nav.navigationBar.barStyle = .black
                nav.navigationBar.tintColor = UIColor.ThemeRedColor()
                nav.navigationBar.titleTextAttributes = dict as? [NSAttributedString.Key : AnyObject]
            }
        default:
            tabC.tabBar.barStyle = .default
            tabC.tabBar.tintColor = UIColor.ThemeDefaultColor()
            let dict : NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor.ThemeDefaultColor(),NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]
            for  vc in tabC.children {
                let nav = vc as! BaseNavigationController
                
                nav.navigationBar.barStyle = .default
                nav.navigationBar.tintColor = UIColor.ThemeDefaultColor()
                //标题颜色
                nav.navigationBar.titleTextAttributes = dict as? [NSAttributedString.Key : AnyObject]
            }
        }
        
    }
    
}
