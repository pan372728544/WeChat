//
//  ThemeSelectViewController.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/14.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class ThemeSelectViewController: UIViewController {

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
    
    
    fileprivate var imgsList : [String] = [String]()
        fileprivate var titlesList : [String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "选择主题"
        view.backgroundColor = UIColor.white
        // 初始化View
        setupMainView()
        // Do any additional setup after loading the view.
        
        imgsList = ["0.jpg","1.jpg","2.jpg","3.jpg"]
        titlesList = ["白黑主题","黑白主题","白绿主题","黑红主题"]
    }
    
    func setupMainView()   {
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.white
        self.tableView.separatorStyle = .none
        view.addSubview(self.tableView)
    }

}

extension ThemeSelectViewController : UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return imgsList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        
        let imgName = imgsList[indexPath.section]

        let imgV = UIImageView(frame: CGRect(x: 10, y: 0, width: Screen_W-20, height: 80))
        imgV.image = UIImage.init(named: imgName)
        imgV.contentMode = .scaleAspectFit
        cell?.contentView.addSubview(imgV)
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return titlesList[section]
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        Theme.share.themeSet(index: indexPath.section)
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
