//
//  ChatRoomViewModel.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/30.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit
import RealmSwift


class ChatRoomViewModel: NSObject {

    
    fileprivate var dbUser :DBUser?
    fileprivate var vc : UIViewController?
    fileprivate var tableView : UITableView?
    fileprivate  var  effectView : UIVisualEffectView?
    private let viewBottom_Height : CGFloat =   60
    private let viewBottom_H : CGFloat =  Bottom_H + 60
    
    private var keyboardH : CGFloat =  0
    private var keyboardW : CGFloat =  0
    // 输入框
    fileprivate lazy var textField : UITextField = {
        
        let textField =  UITextField()
        textField.frame = CGRect(x: 50, y: 10, width: Screen_W - 90 - 50 , height: 40)
        textField.backgroundColor = UIColor.white
//        textField.delegate = self
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 10.0
        textField.returnKeyType = .send
        return textField
    }()
    func bingData(data: DBUser)  {
        self.dbUser = data
    }
    
    
    func loadDataRequest()  {
        
    }
    
    func bindVC(vc: BaseViewController)  {
        self.vc = vc
    }
    func bindTablView(tableView: UITableView)  {
        self.tableView = tableView
        setupMainView()
        setupChatInputView()
    }
    
}


extension ChatRoomViewModel : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    
        
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomMeTableViewCell") as! ChatRoomMeTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.randomColor()
        
        return cell

        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
       return 100
        
    }


    
}



extension ChatRoomViewModel {
    
    
    func setupMainView()   {
        
        self.tableView!.register(ChatRoomMeTableViewCell.self, forCellReuseIdentifier: "ChatRoomMeTableViewCell")
        self.tableView!.register(ChatRoomOtherTableViewCell.self, forCellReuseIdentifier: "ChatRoomOtherTableViewCell")
        
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView!.backgroundColor = UIColor.tableViewBackGroundColor()
        self.tableView!.sectionHeaderHeight = 0.1
        self.tableView!.sectionFooterHeight = 0.1
        self.tableView!.separatorStyle = .none
        self.tableView!.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        
        
    }
    
    func setupChatInputView() {
        
        // 添加毛玻璃效果
        let blur = UIBlurEffect(style: UIBlurEffect.Style.light)
        
        effectView = UIVisualEffectView(effect: blur)
        effectView?.frame = CGRect(x: 0, y: Screen_H-viewBottom_H, width: Screen_W, height: viewBottom_H)
        effectView?.backgroundColor = UIColor.Gray237Color()
        effectView?.alpha = 0.9
        self.vc!.view.addSubview(effectView!)
        
        effectView?.contentView.addSubview(self.textField)
        
        let voiceBtn = UIButton(frame: CGRect(x: 10, y: 10, width: 35, height: 35))
        var imgV = UIImage.init(named: "ToolViewInputVoice")
        imgV = imgV?.withRenderingMode(.alwaysTemplate)
        voiceBtn.tintColor = UIColor.black
        voiceBtn.setBackgroundImage(imgV, for: .normal)
        effectView?.contentView.addSubview(voiceBtn)
        
        let addBtn = UIButton(frame: CGRect(x: Screen_W-5-voiceBtn.width, y: 10, width: voiceBtn.width, height: voiceBtn.width))
        var imgA = UIImage.init(named: "ToolViewKeyboard")
        imgA = imgA?.withRenderingMode(.alwaysTemplate)
        addBtn.tintColor = UIColor.black
        addBtn.setBackgroundImage(imgA, for: .normal)
        effectView?.contentView.addSubview(addBtn)
        
        let emotionBtn = UIButton(frame: CGRect(x: addBtn.left-5-voiceBtn.width, y: 10, width: voiceBtn.width, height: voiceBtn.width))
        var imgE = UIImage.init(named: "ToolViewEmotion")
        imgE = imgE?.withRenderingMode(.alwaysTemplate)
        emotionBtn.tintColor = UIColor.black
        emotionBtn.setBackgroundImage(imgE, for: .normal)
        effectView?.contentView.addSubview(emotionBtn)
        

    }

    
}


extension ChatRoomViewModel {
    
    // 移除通知
    func removeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // 通知
    func registerNotification(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardWillShow(_ :)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardWillHide(_ :)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        
        
    }
    
    //MARK:键盘通知相关操作
    @objc func keyBoardWillShow(_ notification:Notification){
        
        print("keyBoardWillShow")
        // 1.获取动画执行的时间
        let duration =  notification.userInfo!["UIKeyboardAnimationDurationUserInfoKey"] as! Double
        // 2. 获取键盘最终的Y值
        let endFrame = (notification.userInfo!["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        
        keyboardH = endFrame.height
        keyboardW = endFrame.width
        
        // 3.执行动画
        UIView.animate(withDuration: duration) {
            self.effectView!.frame.origin.y = y - self.viewBottom_Height
        }
        self.tableView!.frame.size.height = Screen_H - endFrame.size.height-viewBottom_Height
        
        
        // 滚动到tableview底部
//        scrollToEnd()
    }
    
    @objc func keyBoardWillHide(_ notification:Notification){
        print("keyBoardWillHide")
        //1.获取动画执行的时间
        let duration =  notification.userInfo!["UIKeyboardAnimationDurationUserInfoKey"] as! Double
        
        //2.执行动画
        UIView.animate(withDuration: duration) {
            self.effectView!.frame.origin.y = Screen_H - self.viewBottom_H
        }
        
        UIView.performWithoutAnimation {
            self.tableView!.frame.size.height = Screen_H
        }
        
    }
}
