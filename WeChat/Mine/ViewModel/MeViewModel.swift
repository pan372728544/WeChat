//
//  MeViewModel.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/15.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit
import RealmSwift

class MeViewModel: NSObject, MeProtocol{
    
    // tableView
    fileprivate lazy var tableView : UITableView = {
        let tableView =  UITableView(frame: CGRect(x: 0,
                                                   y: 0,
                                                   width: Screen_W,
                                                   height: Screen_H),
                                     style: UITableView.Style.grouped)
        tableView.backgroundColor = UIColor.orange
        return tableView
    }()
    
    fileprivate var view : UIView = UIView()
    
    fileprivate var sectionAry : [Any] = [Any]()
    
    fileprivate var dataAry : [MeModel] = [MeModel]()
    
    fileprivate var cellVM = MeHeaderCellViewModel()
    
    fileprivate var cellOhterVM =  MeOtherViewModel()
    
    fileprivate var dbUsers : Results<DBUser>?
    
    fileprivate var model = MeModel()
    
    fileprivate var headArray : [MeHeaderCellViewModel] = [MeHeaderCellViewModel]()
    
    fileprivate var otherArray : [Any] = [Any]()
    
    func bindView(view: UIView) {
        
        self.view = view
        self.setupMainView()
        
        
        
    }
    
    override init() {

        super.init()

    }
    func loadData()  {

        let sectionHead = ["head-head"]
        let sectionPay = ["支付-WeChat_Pay_Normal"]
        let sectionOther = ["收藏-MoreMyFavorites_Normal","相册-MoreMyAlbum_Normal","卡包-MoreMyBankCard_Normal","表情-MoreExpressionShops_Normal"]
        let sectionSet = ["设置-MoreSetting_Normal"]

        sectionAry.append(sectionHead)
        sectionAry.append(sectionPay)
        sectionAry.append(sectionOther)
        sectionAry.append(sectionSet)
        
        
        for item  in sectionAry {
            
            let tempAry = item as! [String]
            

            var vmAry  = [MeOtherViewModel]()
            
            for strItem in tempAry {
                
                let splitArray = strItem.split{$0 == "-"}.map(String.init)
                let model = MeModel()
                model.name = splitArray[0]
                model.img = splitArray[1]
                let otheVM = MeOtherViewModel()
                otheVM.model = model
                vmAry.append(otheVM)
            }

             otherArray.append(vmAry)

        }

        
        dbUsers =  RealmTool.getDBUser()
        
        cellVM.dbUser = dbUsers?.first
        
        headArray = [cellVM]
        
    }

}


extension MeViewModel {
    
    
    func setupMainView()   {
        
        self.tableView.register(MeHeaderTableViewCell.self, forCellReuseIdentifier: "MeHeaderTableViewCell")
        self.tableView.register(MeOtherTableViewCell.self, forCellReuseIdentifier: "MeOtherTableViewCell")
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.tableViewBackGroundColor()
        self.tableView.sectionHeaderHeight = 0.1
        self.tableView.sectionFooterHeight = 0.1
        self.tableView.separatorStyle = .none
        view.addSubview(self.tableView)
        
        self.tableView.contentInset = UIEdgeInsets(top: -NavaBar_H, left: 0, bottom: 0, right: 0)

       
        let whiteView = UIView(frame: CGRect(x: 0, y: -Screen_H, width: Screen_W, height: Screen_H))
        whiteView.backgroundColor = .white
        self.tableView.addSubview(whiteView)
        
    }
    
}

extension MeViewModel : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionAry.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let tempAry : [String] = sectionAry[section] as! [String]
        
        return tempAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tempAry : [String] = sectionAry[indexPath.section] as! [String]
        if tempAry[0] == "head-head" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeHeaderTableViewCell") as! MeHeaderTableViewCell
            cell.selectionStyle = .none
            let cellVM = headArray[indexPath.section]
            cellVM.bindView(view: cell)
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeOtherTableViewCell") as! MeOtherTableViewCell
            cell.selectionStyle = .none
            cell.indexPath = indexPath
            let tempAry : [MeOtherViewModel] = otherArray[indexPath.section] as! [MeOtherViewModel]
            let vm = tempAry[indexPath.row]
            
            vm.bindView(view: cell)
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let tempAry : [String] = sectionAry[indexPath.section] as! [String]
        
        if tempAry[0] == "head-head" {
            return 130+NavaBar_H
        } else {
            return MeCellH
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let tempAry : [String] = sectionAry[section] as! [String]
        if tempAry[0] == "head-head" {
            return 0.01
        } else {
            return 8
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
}
