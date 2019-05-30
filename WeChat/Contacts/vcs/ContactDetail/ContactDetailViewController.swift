//
//  ContactDetailViewController.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/22.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class ContactDetailViewController: BaseViewController {

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
        
        // Do any additional setup after loading the view.

        view.backgroundColor = UIColor.white
        
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
//    @objc func back() {
//        self.navigationController?.popViewController(animated: true)
//    }
//    
    @objc func more() {

    }
    
//    override func willMove(toParent parent: UIViewController?) {

//    }
//    override func didMove(toParent parent: UIViewController?) {
//    }
    
  
}
