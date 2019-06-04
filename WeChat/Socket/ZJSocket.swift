//
//  ZJSocket.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/15.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

import RealmSwift

// 代理
protocol ZJSocketDelegate : class {
    // 进入会话
    func socket(_ socket : ZJSocket, joinRoom user : ProtoUser)
    // 离开会话
    func socket(_ socket : ZJSocket, leaveRoom user : ProtoUser)
    // 登录
    func socket(_ socket : ZJSocket, login user : ProtoUser)
    // 获取好友列表
    func socket(_ socket : ZJSocket, friend user : ProtoFriend)
    
    // 获取好友详情
    func socket(_ socket : ZJSocket, friendDetail user : ProtoUser)
    
    // 收到消息
    func socket(_ socket : ZJSocket, chatMsg : ProtoMessage)
//    func socket(_ socket : ZJSocket, groupMsg : GroupMessage)
}


class ZJSocket : NSObject{
    
    weak var delegate : ZJSocketDelegate?
    
    fileprivate var tcpClient : TCPClient

    
    // 记录之前的时间c
    fileprivate var timeOld : Int64 = 0
    init(addr: String, port : Int32) {
        // 创建TCP
        tcpClient = TCPClient(address: addr, port: port )
    }
}


// MARK:- scoket调用方法
extension ZJSocket {
    
    // 连接服务器
    func connectServer() -> Result {
        isConnected = true
        return tcpClient.connect(timeout: 5)
    }
    
    
    // 关闭服务器连接
    func closeServer() {
        isConnected = false
        return tcpClient.close()
    }
    
    // 读取消息
    func startReadMsg() {
        DispatchQueue.global().async {
            while isConnected {
                
                Thread.sleep(forTimeInterval: 0.2)
                // 1.取出长度消息
                if let lengthMsg = self.tcpClient.read(4) {
                    let lData = Data(bytes: lengthMsg, count: 4)
                    var length : Int = 0
                    (lData as NSData).getBytes(&length, length: 4)
                    
                    // 2.读取类型消息
                    guard let typeMsg = self.tcpClient.read(2) else {
                        return
                    }
                    
                    var type : Int = 0
                    let tdata = Data(bytes: typeMsg, count: 2)
                    (tdata as NSData).getBytes(&type, length: 2)
                    
                    // 3.读取消息
                    guard let msg = self.tcpClient.read(length) else {
                        return
                    }
                    let msgData = Data(bytes: msg, count: length)
                    
                    // 4.消息转发出去
                    DispatchQueue.main.async {
                        self.handleMsg(type: type, data: msgData)
                    }
                }
            }
        }
    }
    
    // 处理消息
    fileprivate func handleMsg(type : Int, data : Data) {
        switch type {
        case 0, 1:
            let user = try! ProtoUser.parseFrom(data: data)
            type == 0 ? delegate?.socket(self, joinRoom: user) : delegate?.socket(self, leaveRoom: user)
        case 2:
            // 收到消息
            let chatMsg = try! ProtoMessage.parseFrom(data: data)
            
//            Toast.showCenterWithText(text: "收到消息； \(chatMsg.text)")
            delegate?.socket(self, chatMsg: chatMsg)
        case 10:
               print("T##items: Any...##Any")
//            let group = try! GroupMessage.parseFrom(data: data)
//            delegate?.socket(self, groupMsg: group)
        case 200 :
            let protoUser = try! ProtoUser.parseFrom(data: data)
            delegate?.socket(self, login: protoUser)
        case 201 :
            let protoFriend = try! ProtoFriend.parseFrom(data: data)
            delegate?.socket(self, friend: protoFriend)
        case 202 :
            let protoUser = try! ProtoUser.parseFrom(data: data)
            delegate?.socket(self, friendDetail: protoUser)

        default:

            print("未知类型: \(type)")
            Toast.showCenterWithText(text: "未知数据类型： \(type)")
        }
    }
}


// MARK:- 发送不同类型消息
extension ZJSocket {
    
    // 登录
    func sendLogin(phone : String)  {
        
        print(phone)
        
        let msgData = phone.data(using: .utf8)
        
        sendMsg(data: msgData!, type: 200)
    }
    // 获取好友列表
    func sendLoadFriends() {
        // 用户信息
        
        let userInfo = getUserInfo()
        let msgData = (try! userInfo.build()).data()
        
        // 发送
        sendMsg(data: msgData, type: 201)
    }
    // 获取好友详细信息
    func sendFridenDetail(phone : String)  {
        
        print(phone)
        
        let msgData = phone.data(using: .utf8)
        
        sendMsg(data: msgData!, type: 202)
    }
    
    // 发送消息
    func sendMessage(recipient: DBUser, text: String?, picture: UIImage?, video: URL?, audio: String?,file: String?)  -> (re: Result,da: Data,ch: ProtoMessage.Builder){
        // 获取当前用户
        let userInfo = getUserInfo()
        
        let message = ProtoMessage.Builder()
        
        
        let members = [ userInfo.objectId, recipient.objectId]
        let sorted = members.sorted{$0.localizedCaseInsensitiveCompare($1) == .orderedAscending}
        let chatIdStr =  Checksum.md5HashOf(string: sorted.joined(separator: ""))
        
        message.objectId = NextPushId.getUUIDString()
        message.chatId = chatIdStr

        message.members = "\( userInfo.objectId),\(recipient.objectId)"
        
        message.senderId =  userInfo.objectId
        message.senderName = userInfo.name
        message.senderPicture = userInfo.picture
        
        message.recipientId = recipient.objectId
        message.recipientName = recipient.name
        message.recipientPicture = recipient.picture
        
        message.groupId = ""
        message.groupName = ""
        message.groupPicture = ""
        
        var typeNew = ""
        var textNew = ""
        
        if (text != nil){
            typeNew = "text"
            textNew = text!
        } else if (picture != nil) {
            typeNew = "picture"
            textNew = "[图片]"
            message.picture = (picture?.pngData())!
        } else if (video != nil) {
            typeNew = "video"
            textNew = "[视频]"
            message.video = Data()
        } else if (audio != nil)  {
            typeNew = "aduio"
            textNew = "[语音]"
            
            message.audio = Data()
        }else if (file != nil)  {
            typeNew = "file"
            textNew = "[文件]"
            
            message.file = Data()
        } else {
            typeNew = "unknown"
            textNew = "[未知]"
        }
        
        message.type = typeNew
        message.text = textNew
        
        message.videoDuration = 0
        

        message.audioDuration = 0
        

        
        message.status = "true"
        message.isDeleted = false
        
        
        // 发送时间
        let timeInterval : TimeInterval = Date().timeIntervalSince1970
        
        if timeOld + 60 <= Int64(timeInterval) {
            message.updatedAt = Int64(timeInterval)
            timeOld = message.updatedAt
        } else {
            message.updatedAt = 0
            if timeOld == 0 {
                message.updatedAt = Int64(timeInterval)
            }
            timeOld = Int64(timeInterval)
        }
        message.createdAt = 0
        
        
        
        // 获取对应的data
        let chatData = (try! message.build()).data()
        
        // 发送消息到服务器
        let result = sendMsg(data: chatData, type: 2)
        
        return (result,chatData,message)
    }
    
    func sendJoinRoom() {
        // 用户信息

        let userInfoNew = getUserInfo()
        let msgData = (try! userInfoNew.build()).data()

        // 发送
        sendMsg(data: msgData, type: 0)
    }

    func sendLeaveRoom() {
        // 用户信息
        let userInfoNew = getUserInfo()
        let msgData = (try! userInfoNew.build()).data()
        // 发送
        sendMsg(data: msgData, type: 1)
    }
//    @discardableResult
//    func sendTextMsg(message : String, group : GroupMessage) -> (re: Result,da: Data,ch: TextMessage.Builder) {
//
//        // 发送消息
//        let chatMsg = TextMessage.Builder()
//
//        let userInfoNew = getUserInfo()
//
//        // 用户
//        chatMsg.user = try! userInfoNew.build()
//        // 发送信息
//        chatMsg.text = message
//
//        // 发送给
//        chatMsg.toUserId = group.user.userId
//
//        // 聊天ID
//        chatMsg.chatId = "\(chatMsg.user.userId!)_\( chatMsg.toUserId)"
//
//        // 发送成功标示
//        chatMsg.success = "true"
//
//        // 发送时间
//        let currentData = Date()
//        let dataFormatter = DateFormatter()
//        dataFormatter.dateFormat = "YYYY-MM-dd HH:mm"
//        let customDate = dataFormatter.string(from: currentData)
//        if timeOld != customDate {
//            chatMsg.sendTime = "\(customDate)"
//            timeOld = chatMsg.sendTime
//        } else {
//            chatMsg.sendTime = ""
//        }
//        // 聊天类型
//        if group.groupId != 1004 {
//            chatMsg.chatType = "1"
//        } else {
//            chatMsg.chatType = "2"
//        }
//
//        // 获取对应的data
//        let chatData = (try! chatMsg.build()).data()
//
//        // 发送消息到服务器
//        let result = sendMsg(data: chatData, type: 2)
//        return (result,chatData,chatMsg)
//    }
//
//    // 获取聊天列表
//    func sendGroupMsg() {
//
//        // 获取本地数据传给服务器
//        var names = ["TheMokeyKing-001","BAYMAX-002","IronMan-003","群聊天555555-004"]
//        var texts = ["如来在哪里？","你看起来很健康。","我没有电了！！！","大家都来这里，这里有好东西！"]
//        var imgsGroup : [String] = ["1.jpeg","2.jpeg","3.jpeg","4.jpeg"]
//
//        let userId : String = String(LogInName!.suffix(1))
//
//        names.remove(at: Int(userId)!-1)
//        texts.remove(at: Int(userId)!-1)
//        imgsGroup.remove(at:  Int(userId)!-1)
//
//        for  i in 0...2 {
//
//            // 群组信息
//            let chatMsg = GroupMessage.Builder()
//            // 添加用户信息
//            let userInfo = UserInfo.Builder()
//            let count = names[i].count - 4
//            userInfo.name = String(names[i].prefix(count))
//            userInfo.level = Int64(i)
//            let userId = names[i].suffix(1)
//            userInfo.userId = String(userId)
//            userInfo.iconUrl = imgsGroup[i]
//            // 设置用户信息
//            chatMsg.user = try! userInfo.build()
//            chatMsg.text = texts[i]
//            chatMsg.groupId = Int64(names[i].suffix(3))! + 1000
//
//            // 获取对应的data
//            let chatData = (try! chatMsg.build()).data()
//            // 发送
//            sendMsg(data: chatData, type: 10)
//        }
    
//    }
    
    
    func sendHeartBeat() {
        // 1.获取心跳包中的数据
        let heartString = "I am a heart beat;"
        let heartData = heartString.data(using: .utf8)!
        
        // 2.发送数据
        sendMsg(data: heartData, type: 100)
    }
    @discardableResult
    func sendMsg(data : Data, type : Int) -> Result{
        // 1.将消息长度, 写入到data
        var length = data.count
        let headerData = Data(bytes: &length, count: 4)
        
        // 2.消息类型
        var tempType = type
        let typeData = Data(bytes: &tempType, count: 2)
        
        // 3.发送消息
        let totalData = headerData + typeData + data
        let res : Result = tcpClient.send(data: totalData)
        return res
    }
}

// MARK:- 弹框
extension ZJSocket {
    
//    //弹出消息框
//    func alert(msg:String,after:()->(Void)){
//        let alertController = UIAlertController(title: "",
//                                                message: msg,
//                                                preferredStyle: .alert)
//        
//        UIApplication.shared.keyWindow?.rootViewController!.present(alertController, animated: true, completion: nil)
//        
//        //1.5秒后自动消失
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
//            alertController.dismiss(animated: false, completion: nil)
//        }
//    }
//    
//    
//    func getUserInfo() ->  UserInfo.Builder {
//        
//        
//        LogInName =  UserDefaults.standard.string(forKey: NICKNAME)
//        var imgs : [String] =  ["1.jpeg","2.jpeg","3.jpeg","4.jpeg"]
//        let userInfo = UserInfo.Builder()
//        print(LogInName)
//        // 用户ID
//        let userId : String = String(LogInName!.suffix(1))
//        userInfo.userId = userId
//        
//        // 用户名
//        let count = LogInName!.count
//        userInfo.name = String(LogInName!.prefix(count-4) )
//        
//        // 用户等级
//        userInfo.level = Int64(userId)!
//        
//        // 用户头像
//        let n : Int = Int(userId)!
//        let str = imgs[n-1]
//        userInfo.iconUrl = str
//        
//        return userInfo
//        
//    }
    
    
    func getUserInfo() -> ProtoUser.Builder {
        
        let dbUsers =  RealmTool.getDBUser()
        
        let dbUser = (dbUsers.first)!
        
        let protoUser = ProtoUser.Builder()
        protoUser.objectId = dbUser.objectId
        protoUser.phone = dbUser.phone
        protoUser.name = dbUser.name
        protoUser.nickName = dbUser.nickName
        protoUser.country = dbUser.country
        protoUser.status = dbUser.status
        protoUser.picture = dbUser.picture
        protoUser.thumbnail = dbUser.thumbnail
        protoUser.lastActive = dbUser.lastActive
        protoUser.lastTerminate = dbUser.lastTerminate
        protoUser.createdAt = dbUser.createdAt
        protoUser.updatedAt = dbUser.updatedAt
        protoUser.gender = dbUser.gender
        return protoUser
    }
}

