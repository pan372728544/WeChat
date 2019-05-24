//
//  ContactsViewModel.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/16.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class ContactsViewModel: NSObject,MeProtocol {

    // tableView
    fileprivate lazy var tableView : UITableView = {

        let tableView =  UITableView(frame: CGRect(x: 0,
                                                   y: 0,
                                                   width: Screen_W,
                                                   height: Screen_H),
                                     style: UITableView.Style.plain)
        return tableView
    }()
    
    fileprivate lazy var indexView : IndexView = {
        let indexView =  IndexView(frame: CGRect(x: Screen_W-30,
                                                   y: NavaBar_H,
                                                   width: 30,
                                                   height: Screen_H-NavaBar_H-Tabbar_H))
        indexView.delegate = self
        indexView.dataSource = self
        indexView.backgroundColor = UIColor.clear
        return indexView
    }()
    
    fileprivate var searchController : SearchViewController = {

        let searchController = SearchViewController.init(searchResultsController: ContactSearchViewController())
        return searchController
    }()
    
    fileprivate var cellArray : [ContactCellViewModel] = [ContactCellViewModel]()
    
    fileprivate lazy var labelSelectColor : (r : CGFloat, g : CGFloat, b : CGFloat) = self.getRGBWithColor(UIColor.ThemeGreenColor())
    
    fileprivate lazy var labelNormalColor : (r : CGFloat, g : CGFloat, b : CGFloat) = self.getRGBWithColor(UIColor.init(r: 0, g: 0, b: 0))

    fileprivate lazy var viewSelectColor : (r : CGFloat, g : CGFloat, b : CGFloat) = self.getRGBWithColor(UIColor.init(r: 255, g: 255, b: 255))
    
    fileprivate lazy var viewNormalColor : (r : CGFloat, g : CGFloat, b : CGFloat) = self.getRGBWithColor(UIColor.tableViewBackGroundColor())

    
    var cell : ContactsTableViewCell?
    fileprivate var cellVM = ContactCellViewModel()
    fileprivate var view : UIView = UIView()
    fileprivate var vc : UIViewController = UIViewController()
    fileprivate var keysAry : [String] = [String]()
    var dicAll = [String : Array<Any>]()
    
    fileprivate var countAll : Int?
    fileprivate var contactArray : [Any] = [Any]()
    fileprivate var arraySectionH : [CGFloat] = [CGFloat]()
    fileprivate var arraySectionNewH : [CGFloat] = [CGFloat]()
    func bindView(view: UIView) {
        
        self.view = view
        self.setupMainView()
    }
    
    func bingViewController(vc: UIViewController) {
        self.vc = vc

        self.vc.extendedLayoutIncludesOpaqueBars = true

    }
    
    func loadData()  {
        let dbFriends = RealmTool.getFriendList()
        
        dicAll = [String : Array<Any>]()
        
        countAll = dbFriends.count-4
        for item in dbFriends {
            
            let cellVM = ContactCellViewModel()
            cellVM.dbFriend = item

            let key = item.section

            var temp = Array<Any>()
            
            if dicAll[key] == nil {
                
                temp.append(cellVM)
                dicAll[key] = temp
            } else {
                temp = dicAll[key]!
                temp.append(cellVM)
                dicAll.updateValue(temp, forKey: key)
            }
            
            print("")
        }
        
        for key in dicAll.keys {
            keysAry.append(key)
        }
        
        keysAry.sort { (s1, s2) -> Bool in
    
            return s1 < s2
        }

        if  keysAry.last == UITableView.indexSearch {
            keysAry.remove(at: keysAry.count-1)
            keysAry.insert(UITableView.indexSearch, at: 0)
        }
        if  keysAry[1] == "#" {
            keysAry.remove(at: 1)
            keysAry.insert("#", at: keysAry.count)
        }

        
        for item  in keysAry {
        
            let array = dicAll[item]
            contactArray.append(array as Any)
        }
        
        
        // 获取section高度
        for index in 0..<keysAry.count {
            let key =  keysAry[index]
            let ary  = dicAll[key]
            
            let cellCount = ary?.count
            
            let headH = self.tableView(self.tableView, heightForHeaderInSection: index)
            let cellH = ContactCellH
            
            let sectionH = headH + CGFloat(cellCount!)*cellH
            
            arraySectionNewH.append(sectionH)
            if index == 0 {
                arraySectionH.append(sectionH)
            } else {
                arraySectionH.append(sectionH+arraySectionH[index-1])
            }

            
        }
        
        
        let viewBottom = UIView(frame: CGRect(x: 0, y: 0, width: Screen_W, height: 44))
        viewBottom.backgroundColor  = UIColor.white
        let labCount = UILabel(frame: CGRect(x: 0, y: 0, width: Screen_W, height: 44))
        labCount.text = "\(countAll!)位联系人"
        labCount.textAlignment = .center
        labCount.textColor = UIColor.textNameColor()
        labCount.font = UIFont.systemFont(ofSize: 18)
        labCount.backgroundColor = UIColor.white
        viewBottom.addSubview(labCount)
        
        let viewH = 1/UIScreen.main.scale
        
        let viewLine1 = UIView(frame: CGRect(x: 0, y: 0, width: Screen_W, height: viewH))
        viewLine1.backgroundColor = UIColor.Gray213Color()
        viewBottom.addSubview(viewLine1)
        
        
        self.tableView.tableFooterView = viewBottom

        
    }
    
    
    
    
    
}


extension ContactsViewModel {
    
    
    func setupMainView()   {
        
        self.tableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: "ContactsTableViewCell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.clear
        
        self.tableView.separatorStyle = .none
        view.addSubview(self.tableView)
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.contentInsetAdjustmentBehavior = .automatic
        
        self.view.addSubview(self.indexView)
        self.indexView.setSelectionIndex(index: 1)
        self.indexView.vibrationOn = true

        self.tableView.tableHeaderView = searchController.searchBar

        // 解决下拉有其他view 背景颜色问题
        let viewNew = UIView(frame: self.tableView.bounds)
        viewNew.backgroundColor = UIColor.Gray237Color()
        self.tableView.backgroundView = viewNew
        

    }
    
}

extension ContactsViewModel : UITableViewDelegate,UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return keysAry.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let key = keysAry[section]
        
        let array = dicAll[key]
        
        
        return array!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsTableViewCell") as! ContactsTableViewCell
        cell.selectionStyle = .none
        cell.indexPath = indexPath
        let array = contactArray[indexPath.section] as! [ContactCellViewModel]
        let vm = array[indexPath.row]
        vm.bindView(view: cell)
        vm.bingData(data: array)
    
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return ContactCellH
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
        if section == 0 {
            return 0
        }
        return 30
    }
    
  
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Screen_W, height: 30))
        view.backgroundColor = UIColor.tableViewBackGroundColor()
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: Screen_W, height: 30))
        view.tag = section
        view.addSubview(label)
        let title = keysAry[section]
        label.text = title
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.black
        let viewLine2 = UIView(frame: CGRect(x: 0, y: 30, width: Screen_W, height: 1/UIScreen.main.scale))
        viewLine2.backgroundColor = UIColor.Gray213Color()
        view.addSubview(viewLine2)
        
        return view

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            Toast.showCenterWithText(text: "没有可跳转的页面")
        } else {
            let array = contactArray[indexPath.section] as! [ContactCellViewModel]
            let vm = array[indexPath.row]
            let vc = ContactDetailViewController(userId: (vm.dbFriend?.friendId)!)
            self.vc.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        print("\(section)--willDisplayHeaderView")
        

    }
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
//                print("\(section)--didEndDisplayingHeaderView")
    }
 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        
        let tableHeadH : CGFloat = tableView.tableHeaderView?.height ?? 0.0
        
        let scrollsetOffY = scrollView.contentOffset.y + NavaBar_H - tableHeadH
        changeNavigation(scrollsetOffY)

        print("scrollViewDidScroll=== \(scrollsetOffY)")
        // 设置底部颜色
        if scrollsetOffY >= 0 {
            self.tableView.backgroundView?.backgroundColor = UIColor.white
        } else {
            self.tableView.backgroundView?.backgroundColor = UIColor.Gray237Color()
        }
        
        for index in 1..<keysAry.count {
            
            // 设置seciton
            if scrollsetOffY  >= arraySectionH[index-1] && scrollsetOffY  <= arraySectionH[index]  {
                
                self.indexView.tableViewDidEndDisplayingHeaderView(tableView: self.tableView, view: UIView(), section: index)
                
            }
            
            // 设置颜色
            if scrollsetOffY  >= arraySectionH[index-1]-30 && scrollsetOffY  <= arraySectionH[index]+30 {
                let scrolla = arraySectionH[index-1]-30
                let  progress : CGFloat = (scrollsetOffY-scrolla) / 30
                changeColor(min(progress, 1), index: index)
                
            } else {
                changeColor(0, index: index)
            }

        }
        self.indexView.scrollViewDidScroll(scrollow: scrollView)
    }


}

extension ContactsViewModel: IndexViewDelegate,IndexViewDataSource {
    func selectedSectionIndexTitle(title: String, index: Int) {
        
        if  index == 0 {
            self.tableView.setContentOffset(CGPoint(x: 0, y: -NavaBar_H), animated: false)
            return
        }
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: index), at: UITableView.ScrollPosition.top, animated: false)
    }
    
    func addIndicatorView(view: UIView) {
        self.view.addSubview(view)
    }
    
    // 返回字母数组
    func sectionIndexTitles() -> [String] {
        return keysAry
    }
    
}

extension ContactsViewModel {
    
    fileprivate func getRGBWithColor(_ color : UIColor) -> (CGFloat, CGFloat, CGFloat) {
        guard let components = color.cgColor.components else {
            fatalError("请使用RGB方式赋值颜色")
        }
        
        return (components[0] * 255, components[1] * 255, components[2] * 255)
    }
    
    func changeColor(_ progress : CGFloat,index: Int)   {
        
        let viewHead = self.tableView.viewWithTag(index)
        let colorDeltaView = (viewNormalColor.0 - viewSelectColor.0, viewNormalColor.1 - viewSelectColor.1, viewNormalColor.2 - viewSelectColor.2)
        viewHead?.backgroundColor = UIColor(r: viewNormalColor.0 - colorDeltaView.0 * progress, g: viewNormalColor.1 - colorDeltaView.1 * progress, b: viewNormalColor.2 - colorDeltaView.2 * progress)
        
        
        
        let label = viewHead?.subviews.first as? UILabel
        let colorDeltaLabel = (labelNormalColor.0 - labelSelectColor.0, labelNormalColor.1 - labelSelectColor.1, labelNormalColor.2 - labelSelectColor.2)
        label?.textColor = UIColor(r: labelNormalColor.0 - colorDeltaLabel.0 * progress, g: labelNormalColor.1 - colorDeltaLabel.1 * progress, b: labelNormalColor.2 - colorDeltaLabel.2 * progress)
        if progress > 0 {
//            label?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.init(1*progress))
            label?.font = UIFont.boldSystemFont(ofSize: (15+0.5*progress))
        } else {
            label?.font = UIFont.systemFont(ofSize: 15)
        }
        

    }
    
    func changeNavigation(_ offset : CGFloat)  {

        let tableHeadH : CGFloat = tableView.tableHeaderView?.height ?? 0.0
        let new = offset + tableHeadH
        
        self.vc.navigationController?.navigationBar.setBackgroundImage(new > 0 ? nil : UIImage(), for: UIBarMetrics.default)
        self.vc.navigationController?.navigationBar.shadowImage = new > 0 ? nil : UIImage()

//        self.vc.navigationController?.view.backgroundColor = UIColor.Gray237Color()

    }
}
