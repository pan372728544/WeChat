//
//  DiscoverViewController.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/10.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {
    // tableView
    fileprivate lazy var tableView : UITableView = {
        let tableView =  UITableView(frame: CGRect(x: 0,
                                                   y: 0,
                                                   width: Screen_W,
                                                   height: Screen_H),
                                     style: UITableView.Style.grouped)
        return tableView
    }()
    
    fileprivate   var  effectView : UIVisualEffectView?
    fileprivate var viewLine1: UIView = UIView()

    fileprivate var sectionAry : [Any] = [Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        
        loadData()
        
        // 初始化View
        setupMainView()

    }
    
    
    func setupMainView()   {
        
        self.tableView.register(DiscoverTableViewCell.self, forCellReuseIdentifier: "DiscoverTableViewCell")
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
    
    func loadData()  {
        
        sectionAry = [["朋友圈-discover_0_0"],
                      ["扫一扫-discover_1_0","摇一摇-discover_1_1"],
                      ["搜一搜-discover_2_0"],
                      ["附近的人-discover_2_1"],
                      ["京东购物-discover_3_0","游戏-discover_3_1"],
                      ["小程序-discover_4_0"]]
        print("")
    }
    
}

extension DiscoverViewController : UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionAry.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let array : [Any] = sectionAry[section] as! [Any]
        

        
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverTableViewCell") as! DiscoverTableViewCell
        cell.backgroundColor = UIColor.white
        let array : [String] = sectionAry[indexPath.section] as! [String]
        
        
        let splitArray = array[indexPath.row].split{$0 == "-"}.map(String.init)
        
        cell.imageIcon.image = UIImage(named: splitArray[1])
        cell.nameLabel.text = splitArray[0]
        cell.indexPath = indexPath
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let tempAry : [String] = sectionAry[section] as! [String]
        if tempAry[0] == "朋友圈-discover_0_0" {
            return 0.01
        } else {
            return 8
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Screen_W, height: 8))
        view.backgroundColor = UIColor.tableViewBackGroundColor()
        return view
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return DiscoverCellH
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            let vc = MomentsViewController()
            tableView.deselectRow(at: indexPath, animated: false)
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let scrollsetOffY = scrollView.contentOffset.y + NavaBar_H
        changeNavigation(scrollsetOffY)
        
    }
   
}


extension DiscoverViewController {
    
    
    
    func changeNavigation(_ offset : CGFloat)  {
        effectView?.alpha = 0.9*(offset/5)
        
        viewLine1.isHidden = offset <= 0
        
    }
    
    
}

extension DiscoverViewController {
    
   
    
}



extension DiscoverViewController  {
    

    
    
}
