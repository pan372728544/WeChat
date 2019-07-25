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
        fileprivate var generator : UIImpactFeedbackGenerator?
    fileprivate var view : UIView = UIView()
    fileprivate var vc : UIViewController = UIViewController()
    fileprivate var sectionAry : [Any] = [Any]()
    
    fileprivate var dataAry : [MeModel] = [MeModel]()
    
    fileprivate var cellVM = MeHeaderCellViewModel()
    
    fileprivate var cellOhterVM =  MeOtherViewModel()
    
    fileprivate var dbUsers : Results<DBUser>?
    fileprivate var isCan : Bool!
    fileprivate var model = MeModel()
    fileprivate var imgv : UIImageView?
    
    fileprivate var photoButton : UIButton?
    fileprivate var headArray : [MeHeaderCellViewModel] = [MeHeaderCellViewModel]()
        fileprivate var viewHead : UIView?
    fileprivate var otherArray : [Any] = [Any]()
    
    func bindView(view: UIView) {
        isCan = false
        self.view = view
        self.setupMainView()
        
    }
    func bindViewController(vc: UIViewController) {
        
        self.vc = vc
        
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
        
        
        let viewH = UIView(frame: CGRect(x: 0, y: 0, width: Screen_W, height: Screen_H))
        viewH.backgroundColor = UIColor.tableViewBackGroundColor()
        let img = UIImage(named: "story_teach_bg")
        imgv =  UIImageView(frame: CGRect(x: 0, y:-200, width: Screen_W, height: 344))
        imgv!.contentMode = .left
        imgv!.image = img
        viewH.addSubview(imgv!)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(pan:)))

        viewH.addGestureRecognizer(panGesture)
        self.view.addSubview(viewH)
        
        
        viewHead = UIView(frame: CGRect(x: 0, y: 0, width: Screen_W, height: NavaBar_H+60))
        viewHead?.backgroundColor = UIColor.white
        self.view.addSubview(viewHead!)
        
        self.tableView.register(MeHeaderTableViewCell.self, forCellReuseIdentifier: "MeHeaderTableViewCell")
        self.tableView.register(MeOtherTableViewCell.self, forCellReuseIdentifier: "MeOtherTableViewCell")
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.sectionHeaderHeight = 0.1
        self.tableView.sectionFooterHeight = 0.1
        self.tableView.separatorStyle = .none
        view.addSubview(self.tableView)
        
        self.tableView.contentInset = UIEdgeInsets(top: -NavaBar_H, left: 0, bottom: 0, right: 0)
        generator = UIImpactFeedbackGenerator(style: .light)
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
            cell.backgroundColor = UIColor.clear
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Screen_W, height: 8))
        view.backgroundColor = UIColor.tableViewBackGroundColor()
        return view
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("\(scrollView.contentOffset.y)=====")
        
        let offsetY = scrollView.contentOffset.y
        // 设置head尺寸
        if offsetY < 0 {
            viewHead?.frame.size.height = NavaBar_H+60-offsetY
        }
        
        if offsetY < -80 {
            
            imgv?.frame.origin.y = -200 - offsetY*1.3
            viewHead?.alpha = 1 - CGFloat(-(offsetY+80)/200)
        } else {
            viewHead?.alpha = 1
        }
        
        if offsetY <= -120 {
            generator?.impactOccurred()
            generator = nil
        }

    }

    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")

        let offseY = scrollView.contentOffset.y
        
        if offseY < -120 {
            
            self.tableView.delegate = nil
            self.viewHead?.isHidden = true
            self.tableView.transform = CGAffineTransform(translationX: 0, y: -offseY+NavaBar_H)

            UIView.animate(withDuration: 0.3, animations: {
                self.vc.tabBarController?.tabBar.isHidden = true
                self.vc.navigationController?.navigationBar.isHidden = true
                self.tableView.transform = CGAffineTransform(translationX: 0, y: Screen_H)
                self.imgv?.frame = CGRect(x: 0, y: Screen_H-Tabbar_H-344, width: Screen_W, height: 344)
                self.imgv?.isUserInteractionEnabled = true
                
                
            
        
            }) { (isFinish) in
                self.viewHead?.frame.size.height = Screen_H
                self.tableView.delegate = self
                self.photoButton?.removeFromSuperview()
                self.photoButton = UIButton(frame: CGRect(x: (Screen_W-190)/2, y: 200, width: 190, height: 45))
                self.photoButton?.setTitle("拍一个视频动态", for: UIControl.State.normal)
                self.photoButton?.setTitleColor(UIColor.init(r: 14, g: 156, b: 230), for: .normal)
                var img = UIImage.init(named: "ChatRomm_ToolPanel_Icon_Video_Normal")
                img = img?.withRenderingMode(.alwaysTemplate)
                self.photoButton?.tintColor = UIColor.init(r: 14, g: 156, b: 230)
                self.photoButton?.setImage(img, for: .normal)
                self.photoButton?.setImage(img, for: .highlighted)
                self.photoButton?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
                self.photoButton?.layer.masksToBounds = true
                self.photoButton?.layer.cornerRadius = 5
                self.photoButton?.imageEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: 30)
                self.photoButton?.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
                self.photoButton?.addTarget(self, action: #selector(self.btnClick22(btn:)), for: UIControl.Event.touchUpInside)
                self.photoButton?.addTarget(self, action: #selector(self.btnClick11(btn:)), for: UIControl.Event.touchDown)
                self.imgv?.addSubview(self.photoButton!)
                if self.generator == nil {
                    self.generator = UIImpactFeedbackGenerator(style: .light)
                }
            }
            
        }
    }
}


extension MeViewModel {
    
    @objc func btnClick22(btn: UIButton) {
        btn.backgroundColor = UIColor.clear
    }
    
    @objc func btnClick11(btn: UIButton) {
        btn.backgroundColor = UIColor.Gray213Color()
    }
    
    @objc func handlePanGesture(pan: UIPanGestureRecognizer)  {
        //得到拖的过程中的xy坐标
        let translation : CGPoint = pan.translation(in: self.view)
        print(translation.y)
        
        switch pan.state {
            
        case .changed:
            self.tableView.frame.origin.y = Screen_H + translation.y*0.1
            
            self.imgv?.frame = CGRect(x: 0, y: Screen_H-Tabbar_H-344 + translation.y*0.3, width: Screen_W, height: 344)
            
            self.photoButton?.backgroundColor = UIColor.clear
            if translation.y < -200 {
            
                generator?.impactOccurred()
                generator = nil;
            }
        case .ended:
            if translation.y < -200 {
              
                self.viewHead?.alpha = 0
                UIView.animate(withDuration: 0.3, animations: {
                    self.viewHead?.alpha = 1
                    self.photoButton?.removeFromSuperview()
                    self.tableView.transform = CGAffineTransform.identity
                    self.tableView.frame.origin.y = 0
                    self.viewHead?.isHidden = false
                    self.viewHead?.frame.size.height = NavaBar_H+60
                    self.imgv?.frame = CGRect(x: 0, y:  -200, width: 144, height: 344)
                    self.vc.tabBarController?.tabBar.isHidden = false
                    self.vc.navigationController?.navigationBar.isHidden = false
                    if self.generator == nil {
                        self.generator = UIImpactFeedbackGenerator(style: .light)
                    }
                }) { (finish) in
        
                }
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    
                    self.tableView.frame.origin.y = Screen_H
                    
                    self.imgv?.frame = CGRect(x: 0, y: Screen_H-Tabbar_H-344, width: Screen_W, height: 344)
                    
                }) { (finish) in
                    self.viewHead?.isHidden = true
                }
            }
        default:
            print("")
        }
        
        
      
        
        }
    
    
}
