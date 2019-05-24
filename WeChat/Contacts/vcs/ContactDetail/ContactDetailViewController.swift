//
//  ContactDetailViewController.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/22.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {

    fileprivate var userId : String?
    // tableView
    fileprivate lazy var tableView : UITableView = {
        let tableView =  UITableView(frame: CGRect(x: 0,
                                                   y: 0,
                                                   width: Screen_W,
                                                   height: Screen_H),
                                     style: UITableView.Style.grouped)
        
        return tableView
    }()
    
    fileprivate var detailVM : ContactDetailViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        view.backgroundColor = UIColor.white
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as UIGestureRecognizerDelegate
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
        
        
        let img = UIImage(named: "barbuttonicon_more_black_Normal")
        let itemRight = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(more))
        self.navigationItem.rightBarButtonItems = [itemRight]
        
            
        
        setup()
    }
    
    init(userId: String) {
        
       super.init(nibName: nil, bundle: nil)
        self.userId = userId
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


}

extension ContactDetailViewController : UIScrollViewDelegate,UIGestureRecognizerDelegate {
    
    func setup()  {
        
        self.view.addSubview(self.tableView)
        detailVM = ContactDetailViewModel()
        detailVM?.bingData(data: self.userId!)
        detailVM?.loadDataRequest()
        detailVM!.bindView(view: self.tableView)
        detailVM!.bindVC(vc: self)

    }
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func more() {

    }
    
//    override func willMove(toParent parent: UIViewController?) {

//    }
//    override func didMove(toParent parent: UIViewController?) {
//    }
    
  
}
