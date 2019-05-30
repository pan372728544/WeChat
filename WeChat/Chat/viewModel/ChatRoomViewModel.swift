//
//  ChatRoomViewModel.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/30.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit
import RealmSwift


class ChatRoomViewModel: NSObject {

    
    fileprivate var dbUser :DBUser?
    fileprivate var vc : UIViewController?
    fileprivate var tableView : UITableView?
    func bingData(data: DBUser)  {
        self.dbUser = data
    }
    
    
    func loadDataRequest()  {
        
    }
    
    func bindVC(vc: BaseViewController)  {
        self.vc = vc
    }
    func bindTablView(tableView: UITableView)  {
        self.tableView = tableView
           setupMainView()
    }
    
}


extension ChatRoomViewModel : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    
        
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactDetailTableViewCell") as! ContactDetailTableViewCell
            cell.selectionStyle = .none
   cell.backgroundColor = UIColor.randomColor()
            
            return cell
            
       
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
       return 100
        
    }


    
}



extension ChatRoomViewModel {
    
    
    func setupMainView()   {
        
        self.tableView!.register(ContactDetailTableViewCell.self, forCellReuseIdentifier: "ContactDetailTableViewCell")
        self.tableView!.register(ContactDetailOtherTableViewCell.self, forCellReuseIdentifier: "ContactDetailOtherTableViewCell")
        self.tableView!.register(ContactDetailVideoTableViewCell.self, forCellReuseIdentifier: "ContactDetailVideoTableViewCell")
        
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView!.backgroundColor = UIColor.tableViewBackGroundColor()
        self.tableView!.sectionHeaderHeight = 0.1
        self.tableView!.sectionFooterHeight = 0.1
        self.tableView!.separatorStyle = .none
        
        
        
    }
    

    
}
