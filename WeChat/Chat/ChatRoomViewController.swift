//
//  ChatRoomViewController.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/13.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit
import RealmSwift

class ChatRoomViewController: BaseViewController {

    
    // tableView
    open lazy var tableView : UITableView = {
        let tableView =  UITableView(frame: CGRect(x: 0,
                                                   y: 0,
                                                   width: Screen_W,
                                                   height: Screen_H),
                                     style: UITableView.Style.grouped)
        
        return tableView
    }()

    open var dbUsers : Results<DBUser>?
    
    fileprivate var chatRoomVM : ChatRoomViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = dbUsers?.first?.name
        
        effectView!.alpha = 0.9

        viewLine1.isHidden = false
       
        self.view.backgroundColor = UIColor.white
        setup()
    }
    
    
    init(dbUsers : Results<DBUser>) {
        
        super .init(nibName: nil, bundle: nil)
        self.dbUsers = dbUsers
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


}

extension ChatRoomViewController {
    
    func setup()  {
        
        self.view.insertSubview(self.tableView, belowSubview: self.effectView!)
        chatRoomVM = ChatRoomViewModel()
        chatRoomVM?.bingData(data: (self.dbUsers?.first)!)
        chatRoomVM?.loadDataRequest()
        chatRoomVM!.bindVC(vc: self)
        chatRoomVM?.bindTablView(tableView: self.tableView)
        
        
    }
   
    
}
