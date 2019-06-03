//
//  ChatViewController.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/10.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    // tableView
    fileprivate lazy var tableView : UITableView = {
        let tableView =  UITableView(frame: CGRect(x: 0,
                                                   y: 0,
                                                   width: self.view.frame.size.width,
                                                   height: self.view.frame.size.height),
                                     style: UITableView.Style.plain)
        tableView.backgroundColor = UIColor.orange
        return tableView
    }()
    
    // 聊天列表数组
    fileprivate var msgArray : [DBChat] = [DBChat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        
        // 初始化View
        setupMainView()
        
        searchAndReload()
        
        registerNotification()
    }
    

    func setupMainView()   {
        
        self.tableView.register(ChatGoupListTableViewCell.self, forCellReuseIdentifier: "ChatGoupListTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.white
        self.tableView.separatorStyle = .none
        view.addSubview(self.tableView)
        

    }

}

extension ChatViewController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatGoupListTableViewCell") as! ChatGoupListTableViewCell
        
        cell.textMes = msgArray[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let receiver : DBChat = msgArray[indexPath.row]
        
        let que = "objectId = \'\(receiver.recipientId)\'"
        let dbUsers =  RealmTool.getDBUserById(que)
        
        let chatVc = ChatRoomViewController(dbUsers: dbUsers)
        self.navigationController?.pushViewController(chatVc, animated: true)

    }
    
}


extension ChatViewController {
    
    
    // 查询数据并且刷新列表
    func searchAndReload() {
        // 查询聊天列表数据
        msgArray.removeAll()
        msgArray =  IMDataManager.share.searchRealmGroupList()
        self.tableView.reloadData()
    }
    
    @objc func updateGroupList(nofification:Notification)  {
        
        searchAndReload()
    }
    
}

extension ChatViewController {
    
    // 通知
    func registerNotification(){
        
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateGroupList(nofification:)),
                                               name: NSNotification.Name(rawValue: "GroupListSuccess"),
                                               object: nil)
    }
}
