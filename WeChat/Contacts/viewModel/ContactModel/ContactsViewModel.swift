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
    fileprivate   var  effectView : UIVisualEffectView?
    fileprivate var countAll : Int?
    fileprivate var contactArray : [Any] = [Any]()
    fileprivate var arraySectionH : [CGFloat] = [CGFloat]()
    fileprivate var arraySectionNewH : [CGFloat] = [CGFloat]()
    fileprivate var viewLine1: UIView = UIView()
    
    // 搜索
    let searchH : CGFloat = 34
    let searchAllH : CGFloat = 52
    var searchView = SearchView()
    var tableViewSearch : UITableView!
    var imagV = UIImageView()
    var btnCancle = UIButton()
    var back = UIView()
    var topView = UIView()
    var btnSearch = UIButton()
    var oldOffset : CGFloat = 0
    
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
        
        let viewFoot = UIView(frame: CGRect(x: 0, y: 44, width: Screen_W, height: Screen_H))
        viewFoot.backgroundColor = UIColor.white
        viewBottom.addSubview(viewFoot)
        
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
        self.tableView.contentInsetAdjustmentBehavior = .never
        self.tableView.contentInset = UIEdgeInsets(top: NavaBar_H, left: 0, bottom: Tabbar_H, right: 0)
        
        self.view.addSubview(self.indexView)
        self.indexView.setSelectionIndex(index: 1)
        self.indexView.vibrationOn = true


        // 解决下拉有其他view 背景颜色问题
        let viewNew = UIView(frame: self.tableView.bounds)
        viewNew.backgroundColor = UIColor.Gray237Color()
        self.tableView.backgroundView = viewNew
        

        // 添加毛玻璃效果
        let blur = UIBlurEffect(style: UIBlurEffect.Style.light)
        
        effectView = UIVisualEffectView(effect: blur)
        effectView?.frame = CGRect(x: 0, y: 0, width: Screen_W, height: NavaBar_H)
        effectView?.backgroundColor = UIColor(red: 237/255.0, green: 237/255.0, blue: 237/255.0, alpha: 0.6)
        effectView?.alpha = 0
        self.view.addSubview(effectView!)
        for item in effectView!.subviews {
            item.backgroundColor =  UIColor(red: 237/255.0, green: 237/255.0, blue: 237/255.0, alpha: 0.5)
        }
        
        
        let viewH = 1/UIScreen.main.scale
        
        viewLine1 = UIView(frame: CGRect(x: 0, y: NavaBar_H-viewH, width: Screen_W, height: viewH))
        viewLine1.backgroundColor = UIColor.Gray213Color()
        viewLine1.isHidden = true
        self.view.addSubview(viewLine1)
        
        // 导航添加
        topView = UIView(frame: effectView!.bounds)
        topView.backgroundColor = UIColor.clear
        let rightButton = UIButton(type: .custom)
        rightButton.setImage(UIImage(named: "AlbumGroupIcon"), for: .normal)
        rightButton.imageView?.contentMode = .scaleAspectFill
        rightButton.frame = CGRect(x: Screen_W-30 - 15, y: StatusBar_H + (44 - 30)/2, width: 30, height: 30)
        rightButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        rightButton.backgroundColor = UIColor.clear
        rightButton.addTarget(self, action: #selector(more), for: .touchUpInside)
        let title = UILabel(frame: CGRect(x: 0, y: StatusBar_H + (44 - 30)/2, width: Screen_W, height: 30))
        title.text = "通讯录"
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 17)
        topView.addSubview(title)
        topView.addSubview(rightButton)
        self.view.addSubview(topView)
        
        // 搜索背景视图
        let backSearch = UIView(frame: CGRect(x: 0, y: 0, width: Screen_W, height: searchAllH))
        backSearch.backgroundColor = UIColor.Gray237Color()
        
        // 搜索框
        searchView.frame  = CGRect(x: 10, y: 9, width: Screen_W-20, height: searchH)
        searchView.searchDelegate = self
        btnCancle.frame = CGRect(x: searchView.right, y: 0, width: 60, height: searchAllH)
        btnCancle.setTitle("取消", for: .normal)
        btnCancle.setTitleColor(UIColor(r: 87, g: 107, b: 148), for: .normal)
        btnCancle.addTarget(self, action: #selector(btnCancleClick), for: .touchUpInside)
        backSearch.addSubview(btnCancle)
        searchView.backgroundColor = UIColor.white
        
        /// 搜索左侧视图
        imagV = UIImageView(frame: CGRect(x: 10, y: 1, width: 16, height: 16))
        imagV.image = UIImage(named: "local_search_icon_Normal")
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        v.addSubview(imagV)
        searchView.leftView = v
        searchView.leftViewMode = .always
        searchView.placeholder = "搜索"
        
        // 动画的搜索占位
        btnSearch.frame = CGRect(x: 0, y: 0, width: 100, height: searchH)
        btnSearch.setTitle("搜索", for: .normal)
        btnSearch.setTitleColor(UIColor(r: 199, g: 199, b: 204), for: .normal)
        btnSearch.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btnSearch.setImage(UIImage(named: "local_search_icon_Normal"), for: .normal)
        btnSearch.imageEdgeInsets = UIEdgeInsets(top: 2, left: -12, bottom: 0, right: 6)
        btnSearch.titleEdgeInsets = UIEdgeInsets(top: -2, left: -12, bottom: 0, right: 0)
        btnSearch.isHidden = true
        searchView.addSubview(btnSearch)
        searchView.layer.cornerRadius = 4;
        searchView.contentVerticalAlignment = .center
        backSearch.addSubview(searchView)
        tableView.tableHeaderView = backSearch
        
        
        // 搜索页面展示
        tableViewSearch = UITableView(frame: CGRect(x: 0, y: NavaBar_H + searchAllH, width: Screen_W, height: self.view.frame.size.height-NavaBar_H), style: .plain)
        
        tableViewSearch.register(SearchTableViewCell.self, forCellReuseIdentifier: "cell")
        tableViewSearch.dataSource = self
        tableViewSearch.delegate = self
        tableViewSearch.separatorStyle = .none
        tableViewSearch.backgroundColor = UIColor.white
        tableViewSearch.contentInsetAdjustmentBehavior = .never
        tableViewSearch.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let viewNew2 = UIView(frame: self.view.bounds)
        viewNew2.backgroundColor = UIColor.Gray237Color()
        tableViewSearch.backgroundView = viewNew2
    }
    
}

extension ContactsViewModel : UITableViewDelegate,UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tableViewSearch {
            return 1
        }
        return keysAry.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewSearch {
            return 1
        }
        let key = keysAry[section]
        
        let array = dicAll[key]
        
        
        return array!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsTableViewCell") as! ContactsTableViewCell
            cell.selectionStyle = .none
            cell.indexPath = indexPath
            let array = contactArray[indexPath.section] as! [ContactCellViewModel]
            let vm = array[indexPath.row]
            vm.bindView(view: cell)
            vm.bingData(data: array)
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SearchTableViewCell
            return cell
        }

        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tableViewSearch {
            return Screen_H - NavaBar_H
        }
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
        if tableView == tableViewSearch {
            return
        }
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

        

    }
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        
    }
 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableViewSearch {
            return
        }

        let tableHeadH : CGFloat = tableView.tableHeaderView?.height ?? 0.0
        
        let scrollsetOffY = scrollView.contentOffset.y + NavaBar_H - tableHeadH
        changeNavigation(scrollsetOffY)

        for index in 1..<keysAry.count {
            
            // 设置seciton
            if scrollsetOffY  >= arraySectionH[index-1] && scrollsetOffY  <= arraySectionH[index]  {
                
                self.indexView.tableViewDidEndDisplayingHeaderView(tableView: self.tableView, view: UIView(), section: index)
                
            }
            
            // 设置headview颜色
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

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // 搜索的tableView 直接返回
        if scrollView == tableViewSearch {
            return
        }
        
        let offset = scrollView.contentOffset.y
        
        if offset > oldOffset {
            
            if offset > -NavaBar_H && offset <  -NavaBar_H + self.searchAllH &&  offset > -NavaBar_H + 15{
                
                scrollView.setContentOffset(CGPoint(x: 0, y: -NavaBar_H + self.searchAllH ), animated: true)
            } else if offset >= -36 {
                
            }else {
                scrollView.setContentOffset(CGPoint(x: 0, y: -NavaBar_H ), animated: true)
            }
        }
        else{
            if offset > -NavaBar_H && offset <  -NavaBar_H + self.searchAllH {
                scrollView.setContentOffset(CGPoint(x: 0, y: -NavaBar_H ), animated: true)
            }
        }
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        oldOffset = scrollView.contentOffset.y
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

        effectView?.alpha = offset <= -searchAllH ? 0 : 1
        
        viewLine1.isHidden = offset <= -searchAllH
        if offset == -8 {
            viewLine1.isHidden = true
        }

    }
}

extension ContactsViewModel : SearchViewDelegate  {
    
    
    func searchViewShouldBeginEditing(_ searchView: UITextField) {
        self.view.addSubview(self.tableViewSearch)
        self.searchView.leftView?.isHidden = false
        self.searchView.placeholder = "搜索"
        btnSearch.frame = CGRect(x: 0, y: 0, width: 100, height: searchH)
        self.btnSearch.isHidden = true
        UIView.animate(withDuration: 0.3) {
            self.tableView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
            self.topView.frame.origin.y = -NavaBar_H
            self.effectView!.frame.origin.y = -NavaBar_H
            self.vc.navigationController?.navigationBar.isHidden = true
            self.tableView.isScrollEnabled = false
            
            self.tableViewSearch.frame.origin.y = NavaBar_H + 5
            self.searchView.width = Screen_W-20-50
            
            self.btnCancle.frame = CGRect(x: self.searchView.frame.origin.x+self.searchView.frame.size.width, y: 0, width: 60, height: self.searchAllH)
            
            
        }
    }
    
    func searchViewShouldEndEditing(_ searchView: UITextField) {
        self.vc.navigationController?.navigationBar.isHidden = false
        self.tableView.isScrollEnabled = true
        self.tableViewSearch.frame.origin.y = NavaBar_H+searchAllH
        self.tableViewSearch.removeFromSuperview()
        self.searchView.leftView?.isHidden = true
        self.searchView.placeholder = ""
        self.btnSearch.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.topView.frame.origin.y = 0
            self.effectView!.frame.origin.y = 0
            self.tableView.setContentOffset(CGPoint(x: 0, y: -NavaBar_H), animated: false)
            
            self.searchView.width = Screen_W-20
            
            self.btnCancle.frame = CGRect(x: self.searchView.frame.origin.x+self.searchView.frame.size.width, y: 0, width: 60, height: self.searchAllH)
            self.btnSearch.frame.origin.x = Screen_W/2 - 50-5
            
            
        }) { (finish) in
            self.btnSearch.isHidden = true
            self.tableView.contentInset = UIEdgeInsets(top: NavaBar_H, left: 0, bottom: Tabbar_H, right: 0)
            self.searchView.leftView?.isHidden = false
            self.searchView.placeholder = "搜索"
        }
    }
    @objc func btnCancleClick()  {
        self.searchView.endEditing(true)
    }
    @objc func more() {
        
    }
    
}
