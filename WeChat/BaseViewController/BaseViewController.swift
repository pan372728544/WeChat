//
//  BaseViewController.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/30.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {


  open  var  effectView : UIVisualEffectView?
  open  var viewLine1: UIView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        // 返回按钮
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "kinda_actionbar_icon_dark_back"), for: .normal)
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -18, bottom: 0, right: 0)
        backButton.backgroundColor = UIColor.clear
        // 设置frame
        backButton.frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        let backView = UIBarButtonItem(customView: backButton)
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        backButton.width = -15 // iOS 11 失效
        navigationItem.leftBarButtonItems = [barButtonItem, backView]
        
        
        
        // 添加毛玻璃效果
        let blur = UIBlurEffect(style: UIBlurEffect.Style.light)
        
        effectView = UIVisualEffectView(effect: blur)
        effectView?.frame = CGRect(x: 0, y: 0, width: Screen_W, height: NavaBar_H)
        effectView?.backgroundColor = UIColor.Gray237Color()
        effectView?.alpha = 0
        self.view.addSubview(effectView!)
        
        let viewH = 1/UIScreen.main.scale
        
        viewLine1 = UIView(frame: CGRect(x: 0, y: NavaBar_H-viewH, width: Screen_W, height: viewH))
        viewLine1.backgroundColor = UIColor.Gray213Color()
        viewLine1.isHidden = true
        self.view.addSubview(viewLine1)
        
    }
    


    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
