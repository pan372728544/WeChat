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
        let image = UIImage.from(color: UIColor.white)
        
//        self.navigationController?.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
   self.navigationController?.navigationBar.isOpaque = true
        view.backgroundColor = UIColor.white
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

extension ContactDetailViewController : UIScrollViewDelegate {
    
    func setup()  {
        
        self.view.addSubview(self.tableView)
        detailVM = ContactDetailViewModel()
        detailVM?.bingData(data: self.userId!)
        detailVM?.loadDataRequest()
        detailVM!.bindView(view: self.tableView)
        detailVM!.bindVC(vc: self)

    }
    
    override func willMove(toParent parent: UIViewController?) {
//        super.willMove(toParent: parent)
            let image = UIImage.from(color: UIColor.red)
//                self.navigationController?.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        
        print("willMove---\(parent)")
    }
    
  
}
