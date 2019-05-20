//
//  BaseTabBarController.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/10.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = UIColor.ThemeGreenColor()
        
        self.tabBar.barStyle = UIBarStyle.default
        
        
        addChildViewControllers()

    }
    
    private func addChildViewControllers() {
        
        
        addChildViewController(ChatViewController(), title: "微信", imageName: "tabbar_mainframe_Normal", selectedImageName: "tabbar_mainframeHL_Normal")
        addChildViewController(ContactsViewController(), title: "通讯录", imageName: "tabbar_contacts_Normal", selectedImageName: "tabbar_contactsHL_Normal")
        addChildViewController(DiscoverViewController(), title: "发现", imageName: "tabbar_discover_Normal", selectedImageName: "tabbar_discoverHL_Normal")
        addChildViewController(MineViewController(), title: "我", imageName: "tabbar_me_Normal", selectedImageName: "tabbar_meHL_Normal")
    }
    func addChildViewController(_ childController: UIViewController, title: String, imageName: String, selectedImageName: String) {

        
        childController.tabBarItem.image = UIImage(named: imageName)?.withRenderingMode(UIImage.RenderingMode.automatic)
        childController.tabBarItem.selectedImage = UIImage(named: selectedImageName)?.withRenderingMode(UIImage.RenderingMode.automatic)
        childController.title = title


        let nav = BaseNavigationController(rootViewController: childController)
        addChild(nav)
        
    }

    

}
