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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "WAWeb_Menu_Video_Dark_Normal", target: self, action: #selector(btnSetingTheme))
        
        
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
