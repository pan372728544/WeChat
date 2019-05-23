//
//  ContactsViewController.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/10.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {

    fileprivate let contactVM = ContactsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

        contactVM.loadData()
        contactVM.bindView(view: self.view)
        contactVM.bingViewController(vc: self)
    }
    

    
    

}
