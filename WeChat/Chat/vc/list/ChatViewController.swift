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
        
        let searchController = SearchViewController.init(searchResultsController: UIViewController())
        return searchController
    }()
    fileprivate var imgv : UIImageView?
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
    
    let miniProH : CGFloat = 100
    
    //
    var tableCover = UIView()
    var titleTop = UILabel()
    var titleTopView = UIView()
    var viewMini = MiniProgramView()
    
    // 震动反馈
    fileprivate var generator : UIImpactFeedbackGenerator?
    
    var ballView : ChatBallView = ChatBallView(frame: CGRect(x: 0, y: 0, width: Screen_H, height: 50))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
        view.backgroundColor = UIColor.white

 
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)

        self.navigationController?.navigationBar.shadowImage = UIImage()
        
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
        
        let viewNew = UIView(frame: self.tableView.bounds)
        viewNew.backgroundColor = UIColor.Gray237Color()
        self.tableView.backgroundView = viewNew
        
        // 添加毛玻璃效果
        let blur = UIBlurEffect(style: UIBlurEffect.Style.light)

        effectView = UIVisualEffectView(effect: blur)
        effectView?.frame = CGRect(x: 0, y: 0, width: Screen_W, height: NavaBar_H)
        effectView?.backgroundColor =  UIColor(red: 237/255.0, green: 237/255.0, blue: 237/255.0, alpha: 0)
        effectView?.alpha = 1
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
        rightButton.setImage(UIImage(named: "Fav_List_Add_Icon_Normal"), for: .normal)
        rightButton.imageView?.contentMode = .scaleAspectFill
        rightButton.frame = CGRect(x: Screen_W-30 - 15, y: StatusBar_H + (44 - 30)/2, width: 30, height: 30)
        rightButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        rightButton.backgroundColor = UIColor.clear
        rightButton.addTarget(self, action: #selector(more), for: .touchUpInside)
        titleTop.frame = CGRect(x: 0, y: StatusBar_H , width: Screen_W, height: 44)
        titleTop.text = "微信"
        titleTop.textAlignment = .center
        titleTop.font = UIFont.boldSystemFont(ofSize: 17)
        titleTopView.frame =  CGRect(x: 0, y: StatusBar_H , width: Screen_W, height: 44)
        titleTopView.backgroundColor = UIColor(r: 92, g: 86, b: 114)
        titleTopView.alpha = 0
        topView.addSubview(titleTopView)
        topView.addSubview(titleTop)
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
        
        
        viewMini.frame = CGRect(x: 0, y: -(Screen_H-searchAllH), width: Screen_W, height: Screen_H-searchAllH)
        viewMini.backgroundColor = UIColor.Gray237Color();
        viewMini.alpha = 0
        self.tableView.addSubview(viewMini)
        
        
        
        // 进入小程序后遮罩视图
        tableCover.frame = CGRect(x: 0, y: 0, width: Screen_W, height: Screen_H)
        tableCover.backgroundColor = UIColor(r: 92, g: 86, b: 114)
        tableCover.alpha = 0
        self.tableView.addSubview(tableCover)
        
        // 小球动画视图
        ballView.frame = CGRect(x: 0, y: 30, width: Screen_W, height: BallViewH)
        ballView.alpha = 0
        view.addSubview(self.ballView)
        
        generator = UIImpactFeedbackGenerator(style: .light)
        
    }

}

extension ChatViewController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewSearch {
            return 1
        }
        return msgArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatGoupListTableViewCell") as! ChatGoupListTableViewCell
            
            cell.textMes = msgArray[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SearchTableViewCell
            return cell
        }
       
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tableViewSearch {
            return Screen_H - NavaBar_H
        }
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableViewSearch {
            return 
        }
        let receiver : DBChat = msgArray[indexPath.row]
        
        let que = "objectId = \'\(receiver.recipientId)\'"
        let dbUsers =  RealmTool.getDBUserById(que)
        
        if dbUsers.first == nil {
            socketClient.sendFridenDetail(phone: receiver.recipientId)
            Toast.showCenterWithText(text: "好友信息暂未获取，稍后重试")
           return
        }
        
        let chatVc = ChatRoomViewController(dbUsers: dbUsers,type: .chatlist)
        self.navigationController?.pushViewController(chatVc, animated: true)

    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 搜索的tableView 直接返回
        if scrollView == tableViewSearch {
            return
        }
        
        // 设置顶部视图跟随滑动更新位置
        if scrollView.contentOffset.y > -NavaBar_H {
            self.topView.frame.origin.y = 0
        } else {
            topView.top = -scrollView.contentOffset.y - NavaBar_H
        }

        // 更改导航栏的颜色等
        let tableHeadH : CGFloat = tableView.tableHeaderView?.height ?? 0.0
        let scrollsetOffY = scrollView.contentOffset.y + NavaBar_H - tableHeadH
        changeNavigation(scrollsetOffY)
        

        /// 下拉小球动画
        smallBallAnimation(scrollView.contentOffset.y + NavaBar_H)
        
        
        /// 更新小程序的背景透明度
        updataMiniALpha(scrollView.contentOffset.y + NavaBar_H)

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
            
            
            // 上滑内间距
        }
        else{
            if offset > -NavaBar_H && offset <  -NavaBar_H + self.searchAllH {
                scrollView.setContentOffset(CGPoint(x: 0, y: -NavaBar_H ), animated: true)
            }
            
            // 下滑设置tableView 内边距
            if offset + NavaBar_H < -miniProH  && offset >= -self.tableView.height+self.searchAllH {
                self.tableView.contentInset = UIEdgeInsets(top: self.tableView.height-self.searchAllH, left: 0, bottom: 0, right: 0)
                
            }
        }

       
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 搜索的tableView 直接返回
        if scrollView == tableViewSearch {
            return
        }
        
        // 处理下拉进入小程序页面的逻辑
        enterToMiniProgram(scrollView.contentOffset.y + NavaBar_H)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        oldOffset = scrollView.contentOffset.y
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
    
    @objc func btnCancleClick()  {
        self.searchView.endEditing(true)
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
        
        effectView?.alpha = offset <= -searchAllH ? 0 : 1
        
        viewLine1.isHidden = offset <= -searchAllH
        if offset == -8 {
            viewLine1.isHidden = true
        }

    }
    
}



extension ChatViewController : SearchViewDelegate  {
    
    
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
            self.navigationController?.navigationBar.isHidden = true
            self.tableView.isScrollEnabled = false
            
            self.tableViewSearch.frame.origin.y = NavaBar_H + 5
            self.searchView.width = Screen_W-20-50
            
            self.btnCancle.frame = CGRect(x: self.searchView.frame.origin.x+self.searchView.frame.size.width, y: 0, width: 60, height: self.searchAllH)
            
            
        }
    }
    
    func searchViewShouldEndEditing(_ searchView: UITextField) {
        self.navigationController?.navigationBar.isHidden = false
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
            self.tableView.contentInset = UIEdgeInsets(top: NavaBar_H, left: 0, bottom: 0, right: 0)
            self.searchView.leftView?.isHidden = false
            self.searchView.placeholder = "搜索"
        }
    }
    
    
    @objc func more() {
        
    }
    
    
    
}

// MARK: -- 进入小程序逻辑
extension ChatViewController {
    
    
    /// 进入小程序
    /// - Parameter offset: 偏移量
    func enterToMiniProgram(_ offset : CGFloat)  {
        
        if offset-NavaBar_H > oldOffset && self.tableView.contentInset.top != NavaBar_H {
            // 向上滑动
            print("向上滑动")
            
            UIView.animate(withDuration: 0.3) {
                self.tableView.contentInset = UIEdgeInsets(top: NavaBar_H, left: 0, bottom: 0, right: 0)
            }
            
            self.tabBarController?.tabBar.isHidden = false
            DispatchQueue.main.async {
                self.tableView.setContentOffset(CGPoint(x: 0, y: -NavaBar_H), animated: true)
            }
        } else {
            print("向下滑动")
            if offset <= -miniProH  && offset >= -self.tableView.height+self.searchAllH{
                
                self.tabBarController?.tabBar.isHidden = true
                
                DispatchQueue.main.async {
                    self.tableView.setContentOffset(CGPoint(x: 0, y: -self.tableView.height+self.searchAllH), animated: true)
                }
            }
        }
        
    }
    
    
    
    /// 小球动画
    /// - Parameter offset: 偏移量
    func smallBallAnimation(_ offset : CGFloat) {
        
        ballView.updataAnimation(offset)
    }
    
    
    /// 更新小程序背景颜色
    /// - Parameter offset: 偏移量
    func updataMiniALpha(_ offset : CGFloat) {
        
        let scrollH = (Screen_H-searchAllH-NavaBar_H-offsetPoint)
        
        if offset-NavaBar_H > oldOffset {

            /// 向上滑动偏移量
            let scale = (scrollH + offset)/scrollH >= 1 ? 1 : (scrollH + offset)/scrollH
            viewMini.alpha = 1-scale
            tableCover.alpha = 1-scale
            titleTopView.alpha = 1-scale
            if scale == 1 {
                ballView.alpha = 0
                ballView.endBallAnimation()
            }
            if generator == nil {
                  generator = UIImpactFeedbackGenerator(style: .light)
              }
            
        } else {
            ballView.alpha = 1
            let scaleC = (-offset-offsetPoint)/scrollH >= 1 ? 1 : (-offset-offsetPoint)/scrollH
            // 更改小程序背景透明度 大于100才开始
            let newAlpha = -offset>=offsetPoint ? scaleC : 0
            viewMini.alpha = newAlpha
            tableCover.alpha = newAlpha
            if newAlpha >= 0.5 {
                self.titleTopView.alpha = newAlpha
            }
            
            /// 更新小球位置
            let scaleB = (-offset)/(offsetPoint*2) >= 1 ? 1 : (-offset)/(offsetPoint*2)
            if scaleB <= 0.7 {
                ballView.top = 30 + 100 * scaleB
            }
            
            /// 更新小球透明度
            if scaleB >= 0.9 {
                let aaa = (1-scaleB)*10
                ballView.alpha = aaa
            }
            
            if offset <= -offsetPoint {
                generator?.impactOccurred()
                generator = nil
            }
        }
      
    }
}
