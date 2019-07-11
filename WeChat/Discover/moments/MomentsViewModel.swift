//
//  MomentsViewModel.swift
//  WeChat
//
//  Created by panzhijun on 2019/7/9.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class MomentsViewModel: NSObject,MeProtocol {

    // tableView
    fileprivate lazy var tableView : UITableView = {
        let tableView =  UITableView(frame: CGRect(x: 0,
                                                   y: 0,
                                                   width: Screen_W,
                                                   height: Screen_H),
                                     style: UITableView.Style.plain)
        tableView.backgroundColor = UIColor.orange
        return tableView
    }()

    // 数据源
    fileprivate var dataAry: [momnets] = Array()
    
    // cellVM数组
    fileprivate var aryCellVM: [MomentsCellViewModel] = Array()
    
    // 绑定的控制器view
    fileprivate var view: UIView = UIView()
    // 绑定的控制器
    fileprivate var vc :UIViewController = UIViewController()
    // cell
    fileprivate var cellVM: MomentsCellViewModel = MomentsCellViewModel()
    
    func bindView(view: UIView) {
        self.view = view
        // 初始化视图
        self.setupMainView()
    }
    
    func bindViewController(vc: UIViewController) {
        
        self.vc = vc
    }
    
    override init() {
        super.init()
    }
    
    func loadData()  {
        
        // 本地json数据
        let returnData = readLocalData(fileNameStr: "momnets", type: "json")
        // 获取朋友圈模型数据
        let moment = try! JSONDecoder().decode(Moment.self, from: returnData as! Data)
        // 朋友圈数组
        for item in moment.momnetsList {
            
            let cellVM = MomentsCellViewModel()
            cellVM.model = item
            aryCellVM.append(cellVM)
        }
    }

}

extension MomentsViewModel {
    
    func setupMainView()   {
        
        // 添加tableview
        self.tableView.register(MomentsTableViewCell.self, forCellReuseIdentifier: "MomentsTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.white
        self.tableView.sectionHeaderHeight = 0.1
        self.tableView.sectionFooterHeight = 0.1
        self.tableView.separatorStyle = .none
        self.tableView.contentInsetAdjustmentBehavior = .never
        self.tableView.contentInset = UIEdgeInsets(top: NavaBar_H, left: 0, bottom: 0, right: 0)
        view.addSubview(self.tableView)
    }
    
}

extension MomentsViewModel : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return aryCellVM.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MomentsTableViewCell") as! MomentsTableViewCell
        cell.selectionStyle = .none
        let cellVM = aryCellVM[indexPath.section]
        cellVM.actionClickLinkBlock = { [weak vc] linkStr in
            
            let webVC = WebViewController(url: linkStr)
            
            vc!.navigationController?.pushViewController(webVC, animated: true)
        }
        
        // 手机号
        cellVM.actionClickPhoneBlock = { [weak vc] phone in
            
            // 实例化
            let alertSheet = UIAlertController(title: "", message: "\(phone)可能是一个电话号码,你可以", preferredStyle: UIAlertController.Style.actionSheet)
            // （样式：退出Cancel，警告Destructive-按钮标题为红色，默认Default）
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
            let callAction = UIAlertAction(title: "呼叫", style: UIAlertAction.Style.default, handler: nil)
            let copyAction = UIAlertAction(title: "复制号码", style: UIAlertAction.Style.default, handler: nil)
            let addAction = UIAlertAction(title: "添加到手机通讯录", style: UIAlertAction.Style.default, handler: {
                action in
                print("OK")
            })
            alertSheet.addAction(cancelAction)
            alertSheet.addAction(callAction)
            alertSheet.addAction(copyAction)
            alertSheet.addAction(addAction)
            //  跳转
            vc!.present(alertSheet, animated: true, completion: nil)
            
        }
        cellVM.bindView(view: cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellVM = aryCellVM[indexPath.section]
        return cellVM.getCellHeight()
    }
   
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
}


extension MomentsViewModel {
    
    func readLocalData(fileNameStr:String,type:String) -> Any? {
        
        //读取本地的文件
        let path = Bundle.main.path(forResource: fileNameStr, ofType: type);
        let url = URL(fileURLWithPath: path!)
        do {
            
            // 返回本地数据
            let data = try Data(contentsOf: url)
            return data;
            
        } catch let error {
            return error.localizedDescription;
        }
    }
    
}
