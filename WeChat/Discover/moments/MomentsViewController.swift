//
//  MomentsViewController.swift
//  WeChat
//
//  Created by panzhijun on 2019/6/18.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class MomentsViewController: ViewController {

    fileprivate let momentVM = MomentsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "朋友圈"
        view.backgroundColor = .white
        
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
        

        setup()
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    

}

extension MomentsViewController {
    
    func setup()  {
        momentVM.loadData()
        momentVM.bindView(view: self.view)
        momentVM.bindViewController(vc: self)
    }
    
}
