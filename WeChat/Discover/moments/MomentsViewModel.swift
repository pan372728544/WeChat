//
//  MomentsViewModel.swift
//  WeChat
//
//  Created by panzhijun on 2019/7/9.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher


// 刷新的状态
enum RefreshStatus {
    case normal,will,refresh,done
}

class MomentsViewModel: NSObject,MeProtocol {

    fileprivate var generator : UIImpactFeedbackGenerator?
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
    
    var frameChange = CGRect()
    
    var circleStatus : RefreshStatus = .normal {
        
        didSet {
            
            switch circleStatus {
            case .normal: // 开始状态透明度为0
                    self.circleView.alpha = 0
            case .will: // 下拉的时候改变Y值，修改透明度
                UIView.animate(withDuration: 0.2) {
                    self.circleView.centerY =  self.circleY
                    self.circleView.alpha = 1.0
                    self.generator = UIImpactFeedbackGenerator(style: .light);
                    self.generator?.impactOccurred()
                }
                self.generator = nil
            case .refresh:  // 松开手的时候执行旋转动画1.5秒后刷新完成
                // 1. 创建动画
                let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
                
                // 2. 设置动画属性
                rotationAnim.fromValue = 0
                rotationAnim.toValue = Double.pi * 2
                rotationAnim.repeatCount = MAXFLOAT
                rotationAnim.duration = 1
                //默认是true，切换到其他控制器再回来，动画效果会消失，需要设置成false，动画就不会停了
                rotationAnim.isRemovedOnCompletion = false
                self.circleView.layer.add(rotationAnim, forKey: nil)
                
                DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
                    self.circleView.layer.removeAllAnimations()
                    self.circleStatus = .done
                }
            default: // 刷新完成后改变Y值
                UIView.animate(withDuration: 0.2) {
                    self.circleView.centerY =  StatusBar_H
                    self.circleView.alpha = 0
                }
            }
        }
    }
    
    var circleView : UIImageView = {
        let circleView = UIImageView(image: UIImage(named: "AlbumReflashIcon"))
        circleView.frame = CGRect.init(x: 20, y: StatusBar_H, width: 30, height: 30)
        return circleView
    }()
    
    var circleY : CGFloat =  NavaBar_H + 30
    open  var  effectView : UIVisualEffectView?
    open  var viewLine1: UIView = UIView()
    fileprivate lazy var headView : UIView = {
        let head = UIView(frame: CGRect(x: 0, y: 0, width: Screen_W, height: 400))
        head.backgroundColor = UIColor.white
        let headImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: Screen_W, height: 345))
        headImageView.image = UIImage(named: "momnets_bj.jpeg")
        headImageView.contentMode = .scaleAspectFill
        head.addSubview(headImageView)
        
        
        // 获取当前用户数据
        let user = RealmTool.getDBUser().first
        let userView = UIImageView(frame: CGRect(x: Screen_W-15-60, y: headImageView.bottom-60 + 10, width: 60, height: 60))
        userView.layer.cornerRadius = 5
        userView.layer.masksToBounds = true
        let url = URL(string: (user?.picture)!)
        userView.kf.setImage(with: url)
        head.addSubview(userView)
        
        let userNick = UILabel(frame: CGRect(x: userView.left-20-100, y: headImageView.bottom-60 + 10, width: 100, height: 60))
        userNick.font = UIFont.boldSystemFont(ofSize: 18)
        userNick.textColor = UIColor.white
        userNick.text = user?.name
        userNick.textAlignment = .right
        
        head.addSubview(userNick)
        
        return head
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
        tableView.register(MomentsTableViewCell.self, forCellReuseIdentifier: "MomentsTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.sectionHeaderHeight = 0.1
        tableView.sectionFooterHeight = 0.1
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.addSubview(self.tableView)
        let back = UIImageView(frame: self.view.bounds)
        back.image = UIImage(named: "around-friends_bg")
        
        tableView.backgroundView = back
        
        tableView.tableHeaderView = headView
        
        // 添加毛玻璃效果
        let blur = UIBlurEffect(style: UIBlurEffect.Style.light)
        
        effectView = UIVisualEffectView(effect: blur)
        effectView?.frame = CGRect(x: 0, y: 0, width: Screen_W, height: NavaBar_H)
        effectView?.backgroundColor = UIColor(red: 237/255.0, green: 237/255.0, blue: 237/255.0, alpha: 0.6)
        effectView?.alpha = 0
        self.view.addSubview(effectView!)
        
        let viewH = 1/UIScreen.main.scale
        
        viewLine1 = UIView(frame: CGRect(x: 0, y: NavaBar_H-viewH, width: Screen_W, height: viewH))
        viewLine1.backgroundColor = UIColor.Gray213Color()
        viewLine1.isHidden = true
        self.view.addSubview(viewLine1)
        
        self.view.addSubview(circleView)
        
        circleStatus = .normal
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MomentsTableViewCell
        UIView.animate(withDuration: 0.3) {
            cell.moreImageView.left = Screen_W - 15 - 32
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellVM = aryCellVM[indexPath.section]
        return cellVM.getCellHeight()
    }
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 移除赞评论视图
        removewMoreView()
        
        // 更新导航栏
        updateNavigation(y: scrollView.contentOffset.y)
        
        // 朋友圈下拉刷新动画
        updateCirCleView(offsetY: scrollView.contentOffset.y)
        
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
    
    func removewMoreView()  {
        // 修改cell的评论 赞 视图的显示位置
        let cells : [MomentsTableViewCell] = self.tableView.visibleCells as! [MomentsTableViewCell]
        for cell in cells{
            UIView.animate(withDuration: 0.3) {
                cell.moreImageView.left = Screen_W - 15 - 32
            }
        }
    }
    
    func updateNavigation(y : CGFloat)  {
        let offsetY = 345 - NavaBar_H
        // 修改导航栏的颜色
        if y >= offsetY {
            effectView?.alpha = 1 * (y - offsetY)/30
            viewLine1.isHidden = false
        } else {
            effectView?.alpha = 0
            viewLine1.isHidden = true
        }
    }
    
    func updateCirCleView(offsetY : CGFloat)  {
        
        var y = offsetY
        if y <= -StatusBar_H {
            y = -StatusBar_H
            if self.tableView.isDragging && circleStatus != .will {
                circleStatus = .will
            } else if self.tableView.isDecelerating && circleStatus != .refresh {
                circleStatus = .refresh
            }

        } else {
            if self.tableView.isDragging && circleStatus != .done {
                circleStatus = .done
            }
        }

        // 设置滑动时为5°
        let rotationAngle = CGFloat((offsetY+60)*CGFloat.pi/180*5)
        // 进行旋转
        circleView.transform = CGAffineTransform.init(rotationAngle: rotationAngle)

    }
    
}
