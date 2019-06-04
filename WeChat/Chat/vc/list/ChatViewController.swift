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
                                                   width: Screen_W,
                                                   height: Screen_H),
                                     style: UITableView.Style.plain)
        return tableView
    }()
    
    fileprivate   var  effectView : UIVisualEffectView?
    fileprivate var viewLine1: UIView = UIView()
    // 聊天列表数组
    fileprivate var msgArray : [DBChat] = [DBChat]()
    fileprivate var searchController : SearchViewController = {
        
        let searchController = SearchViewController.init(searchResultsController: ContactSearchViewController())
        return searchController
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white

 
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)

        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let rightButton = UIButton(type: .custom)
        rightButton.setImage(UIImage(named: "Fav_List_Add_Icon_Normal"), for: .normal)
        rightButton.imageView?.contentMode = .scaleAspectFill
        rightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        rightButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        rightButton.backgroundColor = UIColor.clear
        rightButton.addTarget(self, action: #selector(more), for: .touchUpInside)
        let right = UIBarButtonItem(customView: rightButton)
        
        navigationItem.rightBarButtonItem = right
        
        // 初始化View
        setupMainView()
        
        searchAndReload()
        
        registerNotification()
    }
    

    func setupMainView()   {
        
        self.tableView.register(ChatGoupListTableViewCell.self, forCellReuseIdentifier: "ChatGoupListTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorStyle = .none
        self.tableView.sectionHeaderHeight = 0.1
        self.tableView.sectionFooterHeight = 0.1
        self.tableView.separatorStyle = .none
        self.tableView.estimatedSectionFooterHeight = 0
        self.tableView.estimatedSectionHeaderHeight = 0
        self.tableView.estimatedRowHeight = 0
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.contentInsetAdjustmentBehavior = .never
        self.tableView.contentInset = UIEdgeInsets(top: NavaBar_H, left: 0, bottom: Tabbar_H, right: 0)
        view.addSubview(self.tableView)
        self.tableView.tableHeaderView = searchController.searchBar
        
        
        let viewNew = UIView(frame: self.tableView.bounds)
        viewNew.backgroundColor = UIColor.Gray237Color()
        self.tableView.backgroundView = viewNew
        
        // 添加毛玻璃效果
        let blur = UIBlurEffect(style: UIBlurEffect.Style.light)

        effectView = UIVisualEffectView(effect: blur)
        effectView?.frame = CGRect(x: 0, y: 0, width: Screen_W, height: NavaBar_H)
        effectView?.backgroundColor =  UIColor(red: 237/255.0, green: 237/255.0, blue: 237/255.0, alpha: 0.6)
        effectView?.alpha = 0.0
        self.view.addSubview(effectView!)

        let viewH = 1/UIScreen.main.scale

        viewLine1 = UIView(frame: CGRect(x: 0, y: NavaBar_H-viewH, width: Screen_W, height: viewH))
        viewLine1.backgroundColor = UIColor.Gray213Color()
        viewLine1.isHidden = true
        self.view.addSubview(viewLine1)

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
        
        let chatVc = ChatRoomViewController(dbUsers: dbUsers,type: .chatlist)
        self.navigationController?.pushViewController(chatVc, animated: true)

    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        let tableHeadH : CGFloat = tableView.tableHeaderView?.height ?? 0.0
        
        let scrollsetOffY = scrollView.contentOffset.y + NavaBar_H - tableHeadH
        changeNavigation(scrollsetOffY)
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
    
    
    func changeNavigation(_ offset : CGFloat)  {
        
        let tableHeadH : CGFloat = tableView.tableHeaderView?.height ?? 0.0
        let new : CGFloat = offset + tableHeadH 
        
        effectView?.alpha = 0.9*CGFloat(new/tableHeadH)
        
        viewLine1.isHidden = offset <= -tableHeadH
        
        
    }
}



extension ChatViewController  {
    
    
    @objc func more() {
        
    }
    
    
    
}
