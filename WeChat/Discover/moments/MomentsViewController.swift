//
//  MomentsViewController.swift
//  WeChat
//
//  Created by panzhijun on 2019/6/18.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class MomentsViewController: BaseViewController {

    fileprivate let momentVM = MomentsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "朋友圈"
        view.backgroundColor = .white
        effectView?.alpha = 1

        setup()
    }
    

}

extension MomentsViewController {
    
    func setup()  {
        momentVM.loadData()
        momentVM.bindView(view: self.view)
        momentVM.bindViewController(vc: self)
    }
    
}
