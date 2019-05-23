//
//  ContactDetailViewModel.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/22.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit
import RealmSwift

class ContactDetailViewModel: NSObject,MeProtocol {

    
    fileprivate var tableView : UITableView?
    fileprivate var viewHead : UIView?
    fileprivate var sectionAry : [Any] = [Any]()
        fileprivate var dbUsers : Results<DBUser>?
    fileprivate var userId : String?
        fileprivate var vc : UIViewController?
    fileprivate var cellOhterVM =  ContactDetailOtherViewModel()
    
    fileprivate var cellVideoVM =  ContactDetailVideoViewModel()
    
    fileprivate var vmDetailHeaderAry : [ContactDetailHeaderViewModel] = [ContactDetailHeaderViewModel]()
    
    fileprivate var vmDetailOtherAry : [ContactDetailOtherViewModel] = [ContactDetailOtherViewModel]()
    
    fileprivate var vmDetailVideoAry : [ContactDetailVideoViewModel] = [ContactDetailVideoViewModel]()
    func bindView(view: UIView) {
        
        self.tableView = view as? UITableView
        setupMainView()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(requsetSuccess(nofi:)),
                                               name: NSNotification.Name(rawValue: "FriendDetailSuccess"),
                                               object: nil)
    }
    
    func bingData(data: Any) {
        self.userId = data as? String
    }
    
    func bindVC(vc: UIViewController)  {
        self.vc = vc
        self.vc?.view.addSubview(viewHead!)
    }
    func loadDataRequest() {
        

        let que = "objectId = \'\(self.userId!)\'"
        dbUsers =  RealmTool.getDBUserById(que)
        if dbUsers?.first != nil {
            self.loadData()
        } else {
            socketClient.sendFridenDetail(phone: self.userId!)
        }
    }
    
    func loadData()  {
        
        // 获取用户数据
        let que = "objectId = \'\(self.userId!)\'"
        
        dbUsers =  RealmTool.getDBUserById(que)
        

        print("")
        
        let sections = [["设置备注和标签"],["朋友圈","更多信息"],["发消息","音视频通话"]]

        sectionAry = sections

        var count = 0
        
        for item in sectionAry {
            
            let temp = item as! [String]
            for str in temp {
                let model = ContactModel()
                model.name = str
                
                
                switch count {
                case 0:
                    let headVM = ContactDetailHeaderViewModel()
                    headVM.model = model
                    headVM.dbUser = dbUsers?.first
                    vmDetailHeaderAry.append(headVM)
                case 1:
                    let otherVM = ContactDetailOtherViewModel()
                    otherVM.model = model
                    vmDetailOtherAry.append(otherVM)
                case 2:
                    let videoVM = ContactDetailVideoViewModel()
                    videoVM.model = model
                    vmDetailVideoAry.append(videoVM)
                    
                default:
                    print("")
                    
                }
                
                
            }
            
            count += 1
        }
        
        
        self.tableView?.reloadData()
        
        print(sectionAry)
    }
}

extension ContactDetailViewModel {
    
    
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

        viewHead = UIView(frame: CGRect(x: 0, y: 0, width: Screen_W, height: NavaBar_H))
        viewHead?.backgroundColor = UIColor.white
        
        
    }
    
    @objc func requsetSuccess(nofi : Notification){
        
        self.loadData()
    }
    
}

extension ContactDetailViewModel : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionAry.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let tempAry : [String] = sectionAry[section] as! [String]
        
        return tempAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tempAry : [String] = sectionAry[indexPath.section] as! [String]
        if tempAry[0] == "设置备注和标签" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactDetailTableViewCell") as! ContactDetailTableViewCell
            cell.selectionStyle = .none
            let cellVM = vmDetailHeaderAry[indexPath.section]
            cellVM.bindView(view: cell)
            
            return cell
            
        } else if tempAry[0] == "朋友圈" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactDetailOtherTableViewCell") as! ContactDetailOtherTableViewCell
            cell.selectionStyle = .none
            cell.indexPath = indexPath
            let cellVM = vmDetailOtherAry[indexPath.row]
            cellVM.bindView(view: cell)
    
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactDetailVideoTableViewCell") as! ContactDetailVideoTableViewCell
            cell.selectionStyle = .none
            
            let cellVM = vmDetailVideoAry[indexPath.row]
            cell.indexPath = indexPath
            cellVM.bindView(view: cell)
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let tempAry : [String] = sectionAry[indexPath.section] as! [String]

        if tempAry[0] == "设置备注和标签" {
            return 90+NavaBar_H
        } else if tempAry[indexPath.row] == "朋友圈"{
    
            return 99
        }
        else {
            return 56
        }

    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let tempAry : [String] = sectionAry[section] as! [String]
        if tempAry[0] == "设置备注和标签" {
            return 0.01
        }
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print(scrollView.contentOffset.y)
        
        let offsetY = scrollView.contentOffset.y+NavaBar_H
        if offsetY < 0 {
            viewHead?.frame.size.height = NavaBar_H-offsetY
       
        }
        
    }
    
}

