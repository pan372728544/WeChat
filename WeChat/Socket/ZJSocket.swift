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
    func socket(_ socket : ZJSocket, joinRoom user : ProtoUser)
    func socket(_ socket : ZJSocket, leaveRoom user : ProtoUser)
    func socket(_ socket : ZJSocket, login user : ProtoUser)
    func socket(_ socket : ZJSocket, friend user : ProtoFriend)
    
//    func socket(_ socket : ZJSocket, chatMsg : TextMessage)
//    func socket(_ socket : ZJSocket, groupMsg : GroupMessage)
}


class ZJSocket : NSObject{
    
    weak var delegate : ZJSocketDelegate?
    
    fileprivate var tcpClient : TCPClient

//    fileprivate var userInfo : UserInfo.Builder = {
//
//
//        LogInName =  UserDefaults.standard.string(forKey: NICKNAME)
//        var imgs : [String] =  ["1.jpeg","2.jpeg","3.jpeg","4.jpeg"]
//        let userInfo = UserInfo.Builder()
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
//        return userInfo
//    }()
    
    // 记录之前的时间c
    fileprivate var timeOld : String = ""
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
                
                Thread.sleep(forTimeInterval: 0.3)
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
            print("T##items: Any...##Any")
//            let user = try! UserInfo.parseFrom(data: data)
//            type == 0 ? delegate?.socket(self, joinRoom: user) : delegate?.socket(self, leaveRoom: user)
        case 2:
//            let chatMsg = try! TextMessage.parseFrom(data: data)
//            delegate?.socket(self, chatMsg: chatMsg)
   print("T##items: Any...##Any")
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
    
//    func sendJoinRoom() {
//        // 用户信息
//
//        let userInfoNew = getUserInfo()
//        let msgData = (try! userInfoNew.build()).data()
//
//        // 发送
//        sendMsg(data: msgData, type: 0)
//    }
//
//    func sendLeaveRoom() {
//        // 用户信息
//        let userInfoNew = getUserInfo()
//        let msgData = (try! userInfoNew.build()).data()
//        // 发送
//        sendMsg(data: msgData, type: 1)
//    }
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
//    
//    
//    func sendHeartBeat() {
//        // 1.获取心跳包中的数据
//        let heartString = "I am a heart beat;"
//        let heartData = heartString.data(using: .utf8)!
//        
//        // 2.发送数据
//        sendMsg(data: heartData, type: 100)
//    }
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
        return protoUser
    }
}

