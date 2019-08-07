//
//  MiniProgramView.swift
//  WeChat
//
//  Created by panzhijun on 2019/8/7.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class MiniProgramView: UIView {
    var topView = UIView()
    var titleTop = UILabel()
    // tableView
    fileprivate lazy var tableView : UITableView = {
        let tableView =  UITableView(frame: CGRect(x: 0,
                                                   y: 0,
                                                   width: Screen_W,
                                                   height: Screen_H),
                                     style: UITableView.Style.plain)
        return tableView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupMainView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupMainView()  {
        self.tableView.register(MiniTableViewCell.self, forCellReuseIdentifier: "MiniTableViewCell")
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.orange
        self.tableView.sectionHeaderHeight = 0.1
        self.tableView.sectionFooterHeight = 0.1
        self.tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: NavaBar_H, left: 0, bottom: 0, right: 0)
        self.addSubview(self.tableView)
        
      
        
        
        // 导航添加
        topView = UIView(frame: CGRect(x: 0, y: 0, width: Screen_W, height: NavaBar_H))
        topView.backgroundColor = UIColor.clear
     
        titleTop.frame = CGRect(x: 0, y: StatusBar_H , width: Screen_W, height: 44)
        titleTop.text = "小程序"
        titleTop.textAlignment = .center
        titleTop.textColor = UIColor.white
        titleTop.font = UIFont.boldSystemFont(ofSize: 16)
        topView.addSubview(titleTop)
        self.addSubview(topView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topView.frame = CGRect(x: 0, y: 0, width: Screen_W, height: NavaBar_H)
        titleTop.frame = CGRect(x: 0, y: StatusBar_H , width: Screen_W, height: 44)
        let mimiImgV = UIImageView(frame: CGRect(x: 0, y: 0, width: Screen_W, height: self.height))
        mimiImgV.image = UIImage(named: "bg1.jpg")
        mimiImgV.contentMode = .scaleAspectFill
        self.tableView.backgroundView = mimiImgV
    }
}

extension MiniProgramView : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MiniTableViewCell") as! MiniTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        return cell

        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Screen_W, height: 10))
        view.backgroundColor = UIColor.clear
        let head = UILabel()
        
        head.frame = CGRect(x: 20, y: 0 , width: 100, height: 10)
        head.text = "最近使用"
        head.textColor = UIColor.lightGray
        head.font = UIFont.boldSystemFont(ofSize: 14)
        view.addSubview(head)
        
        return view
        
    }
}
