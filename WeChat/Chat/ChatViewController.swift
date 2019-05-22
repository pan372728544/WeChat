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
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        

        // Do any additional setup after loading the view.
        
        // 初始化View
        setupMainView()
    }
    

    func setupMainView()   {
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.white
        view.addSubview(self.tableView)
        

    }

}

extension ChatViewController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")

        cell?.imageView?.image = UIImage.init(named: "QQ20190513")
        cell?.backgroundColor = UIColor.black
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


    }
    
}
