//
//  ChatRoomViewModel.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/30.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit
import RealmSwift
enum MessageType {
    case text,picture,video,audio,file
}


class ChatRoomViewModel: NSObject {

    
    fileprivate var dbUser :DBUser?
    fileprivate var vc : UIViewController?
    fileprivate var tableView : UITableView!
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
        textField.delegate = self
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 10.0
        textField.returnKeyType = .send
        return textField
    }()
    
    // 模型数组
    fileprivate var msgArray : [DBMessage] = [DBMessage]()
    // 每次加载多少条数据
    private let page :  Int = 10
    
    // 当前页数
    private var currentPage :  Int = 1
    // 最大页数
    private var maxCount :  Int = 0
    
    private var lastText : String = ""
    
    // 加载视图高度
     let loadingH : CGFloat =  44
    
      fileprivate var addBtn : UIButton!
    
    // 下拉刷新
    fileprivate var indicatorView : UIActivityIndicatorView = {
        
        var  indicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: -44, width: Screen_W, height: 44))
        indicatorView.backgroundColor = UIColor.red
        return indicatorView
    }()
    
    func bingData(data: DBUser)  {
        self.dbUser = data
        currentPage = 1
    }
    
    
    func bindVC(vc: BaseViewController)  {
        self.vc = vc
    }
    func bindTablView(tableView: UITableView)  {
        self.tableView = tableView
        setupMainView()
        setupChatInputView()
    }
    func loadDataRequest()  {
        
        let chatId = IMDataManager.share.getChatId(receiveId: (self.dbUser?.objectId)!)
        
        let (msgArray,max) = IMDataManager.share.searchRealmChatMessagesList(currentPage: currentPage, chatId: chatId)
        maxCount = max
        
        var index : Int = 0
        for (msg) in msgArray {
            
            if currentPage ==  1 {
                self.msgArray.append(msg)
                
            } else {
                self.msgArray.insert(msg, at: index)
            }
            index += 1
        }
        reloadTableView()
    }
    
}


extension ChatRoomViewModel : UITableViewDelegate,UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let msg : DBMessage = msgArray[indexPath.row]
        

        let currentId = IMDataManager.share.getCurrentId()
        
        if currentId == msg.senderId {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomMeTableViewCell") as! ChatRoomMeTableViewCell
            cell.textMes = msg

            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomOtherTableViewCell") as! ChatRoomOtherTableViewCell
            cell.textMes = msg
            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let msg : DBMessage = msgArray[indexPath.row]
        if msg.updatedAt != 0 {
            return IMDataManager.share.getChatTextSize(text: msg.text).height + 45 + 40
        }
        return IMDataManager.share.getChatTextSize(text: msg.text).height + 45
    }

    // scrollview
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if currentPage != maxCount {
            self.tableView.contentInset.top =  loadingH+NavaBar_H
        }
        if maxCount == 1 {
            indicatorView.stopAnimating()
        } else {

        }
    }


    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        // 滑动距离大于loading添加新的数据
        if scrollView.contentOffset.y == -loadingH-NavaBar_H {

            currentPage += 1
            if currentPage > maxCount {
                currentPage = maxCount
                indicatorView.stopAnimating()
                self.tableView.contentInset.top =  NavaBar_H
                return
            } else if currentPage == maxCount {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                    self.loadDataRequest()
                }

                indicatorView.stopAnimating()
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {

                self.loadDataRequest()
            }

        }
    }



    
}



extension ChatRoomViewModel {
    
    
    func setupMainView()   {
        
        self.tableView.register(ChatRoomMeTableViewCell.self, forCellReuseIdentifier: "ChatRoomMeTableViewCell")
        self.tableView.register(ChatRoomOtherTableViewCell.self, forCellReuseIdentifier: "ChatRoomOtherTableViewCell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.tableViewBackGroundColor()
        self.tableView.sectionHeaderHeight = 0.1
        self.tableView.sectionFooterHeight = 0.1
        self.tableView.separatorStyle = .none
        self.tableView.estimatedSectionFooterHeight = 0
        self.tableView.estimatedSectionHeaderHeight = 0
        self.tableView.estimatedRowHeight = 0
        self.tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        self.tableView.contentInsetAdjustmentBehavior = .never
        self.tableView.contentInset = UIEdgeInsets(top: NavaBar_H, left: 0, bottom: viewBottom_H, right: 0)
        
        
        //加载
        indicatorView.backgroundColor = UIColor.tableViewBackGroundColor()
        indicatorView.startAnimating()
        indicatorView.style = UIActivityIndicatorView.Style.gray
        self.tableView.addSubview(indicatorView)
        
        
    }
    
    func setupChatInputView() {
        
        // 添加毛玻璃效果
        let blur = UIBlurEffect(style: UIBlurEffect.Style.light)
        
        effectView = UIVisualEffectView(effect: blur)
        effectView?.frame = CGRect(x: 0, y: Screen_H-viewBottom_H, width: Screen_W, height: viewBottom_H)
        effectView?.backgroundColor = UIColor.Gray237Color()
        effectView?.alpha = 0.9
        effectView?.isUserInteractionEnabled = true
        self.vc!.view.addSubview(effectView!)
        
        effectView?.contentView.addSubview(self.textField)
        
        let voiceBtn = UIButton(frame: CGRect(x: 10, y: 10, width: 35, height: 35))
        var imgV = UIImage.init(named: "ToolViewInputVoice")
        imgV = imgV?.withRenderingMode(.alwaysTemplate)
        voiceBtn.tintColor = UIColor.black
        voiceBtn.setBackgroundImage(imgV, for: .normal)
        var imgV2 = UIImage.init(named: "ToolViewKeyboard")
        imgV2 = imgV2?.withRenderingMode(.alwaysTemplate)
        voiceBtn.setBackgroundImage(imgV2, for: .selected)
        effectView?.contentView.addSubview(voiceBtn)
        
        addBtn = UIButton(frame: CGRect(x: Screen_W-5-voiceBtn.width, y: 10, width: voiceBtn.width, height: voiceBtn.width))
        var imgA = UIImage.init(named: "TypeSelectorBtn_Black")
        imgA = imgA?.withRenderingMode(.alwaysTemplate)
        addBtn.tintColor = UIColor.black
        addBtn.setBackgroundImage(imgA, for: .normal)
        var imgB = UIImage.init(named: "ToolViewKeyboard")
        imgB = imgB?.withRenderingMode(.alwaysTemplate)
        addBtn.setBackgroundImage(imgB, for: .selected)
        effectView?.contentView.addSubview(addBtn)
        addBtn.addTarget(self, action: #selector(addBtnClick(_:)), for: UIControl.Event.touchUpInside)
        
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
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(messageSuccess(nofification:)),
                                               name: NSNotification.Name(rawValue: "ReceiveMessageSuccess"),
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
        self.tableView!.frame.size.height = Screen_H - endFrame.size.height
        
        
        // 滚动到tableview底部
        scrollToEnd()
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
    
    // 收到消息
    @objc func messageSuccess(nofification:Notification)  {
       
        let message : DBMessage =  RealmTool.getMessages().last!
        
        updateAndappendMessage(chatMsg: message)
        
    }
}

extension ChatRoomViewModel: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage(type: .text)
        return true
    }
}

extension ChatRoomViewModel {
    // 发送消息
     func sendMessage(type: MessageType)  {
        
        var cupid : (Result,Data, ProtoMessage.Builder)?
        
        switch type {
        case .text:
            cupid =   socketClient.sendMessage(recipient: self.dbUser!, text: self.textField.text ?? "", picture: nil, video: nil, audio: nil, file: nil)
        case .picture:
            cupid =   socketClient.sendMessage(recipient: self.dbUser!, text: nil, picture: UIImage(), video: nil, audio: nil, file: nil)
        case .video:
            cupid =   socketClient.sendMessage(recipient: self.dbUser!, text: nil, picture: nil, video: nil, audio: nil, file: nil)
        case .file:
            cupid =   socketClient.sendMessage(recipient: self.dbUser!, text: nil, picture: nil, video: nil, audio: nil, file: nil)
        default:
            print("")
        }

        self.lastText = self.textField.text ?? ""
        
        if (cupid?.0.isSuccess)! {
            print("聊天消息发送成功 \(self.textField.text ?? " ")")
        } else {
            let chatMsgBuild = cupid?.2
            chatMsgBuild?.status = "false"
            
            IMDataManager.share.insertProtoMessage(cupid: chatMsgBuild!)
            IMDataManager.share.insertDataToChatList(chatMag: (try! chatMsgBuild?.build())!)
            NotificationCenter.default.post(name: NSNotification.Name("ReceiveMessageSuccess"), object: self, userInfo:nil)
            NotificationCenter.default.post(name: NSNotification.Name("GroupListSuccess"), object: self, userInfo:nil)
        }
        // 清空数据框
        self.textField.text = ""
        
    }
}

extension ChatRoomViewModel {
    
   @objc func addBtnClick(_ btn: UIButton)  {
    btn.isSelected = !btn.isSelected

    }
}


extension ChatRoomViewModel {
    
    func reloadTableView() {
        
        updateOffset {
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
            
        }
        
    }
    
    func updateOffset(finishedCallback : @escaping () -> ())  {
        
        let oldOffset = self.tableView.contentSize.height - self.tableView.contentOffset.y
        
        finishedCallback()
        self.tableView.contentInset.top = NavaBar_H
        
        if currentPage == 1 {
            scrollToEnd()
            return
        }
        if oldOffset == 0 {
            return
        }
        let  offset = self.tableView.contentSize.height - oldOffset
        self.tableView.contentOffset.y =  offset
    }
    
    
    // 滚动到底部
    func scrollToEnd() {
        
        guard msgArray.count == 0 else {
            
            self.tableView.scrollToRow(at: IndexPath(item: msgArray.count-1 < 0 ? 0: msgArray.count-1, section: 0 ), at: UITableView.ScrollPosition.bottom, animated: false)
            return
        }
        
    }
    
    // 通知收到消息
    func updateAndappendMessage(chatMsg: DBMessage) {
        
        msgArray.append(chatMsg)
        self.tableView.reloadData()
        scrollToEnd()
    }
    
    
    
}
