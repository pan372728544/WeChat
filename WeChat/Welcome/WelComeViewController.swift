//
//  WelComeViewController.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/15.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class WelComeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let viewImg = UIImageView(frame: CGRect(x: 0, y: 0, width: Screen_W, height: Screen_H))
        viewImg.image = getLaunchImage()
        view.addSubview(viewImg)
        
        let w = (Screen_W-15*3)*0.5
        
        let loginBtn = UIButton(frame: CGRect(x: 15, y: Screen_H-Bottom_H-50-50, width: w, height: 50))
        loginBtn.setTitle("登录", for: UIControl.State.normal)
        loginBtn.backgroundColor = UIColor.white
        loginBtn.layer.cornerRadius = 4
        loginBtn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        loginBtn.addTarget(self, action: #selector(btnClick), for: UIControl.Event.touchUpInside)
        view.addSubview(loginBtn)
        
        
        let regisBtn = UIButton(frame: CGRect(x: loginBtn.frame.size.width+loginBtn.frame.origin.x+15, y: Screen_H-Bottom_H-50-50, width: w, height: 50))
        regisBtn.setTitle("注册", for: UIControl.State.normal)
        regisBtn.backgroundColor = UIColor.ThemeGreenColor()
        regisBtn.layer.cornerRadius = 4
        regisBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        view.addSubview(regisBtn)
        
        
        let language = UILabel(frame: CGRect(x: Screen_W-15-100, y: StatusBar_H + 10, width: 100, height: 50))
        language.textAlignment = NSTextAlignment.right
        language.text = "语言"
        language.textColor = UIColor.white
        view.addSubview(language)
        
    }
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


extension WelComeViewController {
    
    @objc func btnClick() {
        let loginVC = LoginViewController()
        present(loginVC, animated: true) {
            
        }
        
    }
    
}


extension WelComeViewController {
    
    func getLaunchImage() -> UIImage {
        let viewOr = "Portrait"//垂直
        var launchImageName = ""
        let tmpLaunchImages = Bundle.main.infoDictionary!["UILaunchImages"] as? [Any]
        for dict in tmpLaunchImages! {
            if let someDict = dict as? [String: Any] {
                let imageSize = NSCoder.cgSize(for: someDict["UILaunchImageSize"] as! String)
                let viewSize = UIApplication.shared.keyWindow?.bounds.size
                
                if __CGSizeEqualToSize(viewSize!, imageSize) && viewOr == someDict["UILaunchImageOrientation"] as! String {
                    launchImageName = someDict["UILaunchImageName"] as! String
                }
            }
        }
        let launchImage = UIImage(named: launchImageName)

        return launchImage!
        
    }
    
}
