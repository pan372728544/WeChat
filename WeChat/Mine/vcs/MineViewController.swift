//
//  MineViewController.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/10.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class MineViewController: UIViewController {

    fileprivate let headerVM = MeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    
        self.navigationItem.title = ""
        let rightButton = UIButton(type: .custom)
        rightButton.setImage(UIImage(named: "ChatRomm_ToolPanel_Icon_Video_Normal"), for: .normal)
        rightButton.imageView?.contentMode = .scaleAspectFill
        rightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        rightButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -10)
        rightButton.backgroundColor = UIColor.clear
        rightButton.addTarget(self, action: #selector(btnSetingTheme), for: .touchUpInside)
        let right = UIBarButtonItem(customView: rightButton)
        
        navigationItem.rightBarButtonItem = right
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        setup()
    }

    @objc func btnSetingTheme()  {
        
        self.present(ThemeSelectViewController(), animated: true, completion: nil)
    }
}

extension MineViewController {
    
    func setup()  {
        
        headerVM.loadData()
        headerVM.bindView(view: self.view)
    }
    
}
