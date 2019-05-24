//
//  IMDataManager.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/15.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit
import RealmSwift

class IMDataManager: NSObject {
    
    
    static let share = IMDataManager()
    
//    func updateHuiHua(_ message: Any)  {
//        NotificationCenter.default.post(name: NSNotification.Name("updataHuiHua"), object: self, userInfo: ["mess": message])
//    }
//
//    // 更新列表数据库
//    open func insertRealmGroupMessage(cupid : GroupMessage.Builder) {
//        let chatMsg = try! cupid.build()
//        let userChat = chatMsg.user
//        // realm消息数据
//        let message = GroupListMessage()
//        message.text = chatMsg.text
//        message.groupId = Int(chatMsg.groupId)
//        message.id = Int(chatMsg.groupId)
//        // realm用户数据
//        let realmUser = UserInfoRealm()
//        realmUser.name = userChat!.name
//        realmUser.level = Int(userChat!.level)
//        realmUser.iconUrl = userChat!.iconUrl
//        realmUser.userId = userChat!.userId
//
//        message.userInfo = realmUser
//        RealmTool.updateGroupMessage(message: message)
//    }
//
//    // 插入聊天会话 聊天记录
//    open func insertRealmTextMessage(cupid : TextMessage.Builder) {
//        let chatMsg = try! cupid.build()
//        let userChat = chatMsg.user
//        // realm消息数据
//        let message = ChatMessage()
//        message.text = chatMsg.text
//        message.chatId = chatMsg.chatId
//        message.toUserId = chatMsg.toUserId
//        message.chatType = chatMsg.chatType
//        message.success = chatMsg.success
//        message.sendTime = chatMsg.sendTime
//
//        // realm用户数据
//        let realmUser = UserInfoRealm()
//        realmUser.name = userChat!.name
//        realmUser.level = Int(userChat!.level)
//        realmUser.iconUrl = userChat!.iconUrl
//        realmUser.userId = userChat!.userId
//
//        message.userInfo = realmUser
//        RealmTool.insertMessage(by: message)
//
//    }
    
//
//    // 查询聊天列表数据
//    func searchRealmGroupList(curr : Int) -> [GroupMessage] {
//
//        // 返回的数组
//        var msgArray : [GroupMessage] = [GroupMessage]()
//
//        let messages : Results<GroupListMessage>
//
//        messages =  RealmTool.getGroupMessages()
//
//        // 数据库总数据
//        let  messageCount = messages.count
//        if messageCount == 0 {
//            return msgArray
//        }
//
//        // 遍历数据
//        for mess in messages {
//
//            // 创建聊天类型数据
//            let textMsg = GroupMessage.Builder()
//            textMsg.text = mess.text!
//            textMsg.groupId = Int64(mess.groupId)
//
//            // realm类型用户信息
//            let userRealm : UserInfoRealm = mess.userInfo!
//
//            // 创建聊天用户类型数据
//            let  userInfo = UserInfo.Builder()
//            userInfo.name = userRealm.name!
//            userInfo.level = Int64(userRealm.level)
//            userInfo.iconUrl = userRealm.iconUrl!
//            userInfo.userId = userRealm.userId!
//
//            // 用户信息
//            textMsg.user = try! userInfo.build()
//
//            let msg = try? textMsg.build()
//            if msg != nil {
//
//                let userId : Int64 = Int64(LogInName!.suffix(1))!
//                if (msg?.groupId)! - 1000 !=  userId {
//                    msgArray.append(msg!)
//                }
//
//            }
//
//        }
//
//        return msgArray
//    }
//
//
//    // 查询聊天记录 数据
//    func searchRealmChatMessagesList(currentPage : Int,group : GroupMessage) -> ([TextMessage],Int) {
//
//        var msgArray : [TextMessage] = [TextMessage]()
//        // 每次加载多少条数据
//        let page :  Int = 10
//        // 最大页数
//        var maxCount :  Int = 0
//
//        let userId : String = String(LogInName!.suffix(1))
//        let otherId = group.user.userId!
//        let messages : Results<ChatMessage>
//        var querString = ""
//
//        // 群聊天
//        if group.groupId == 1004 {
//            querString = "chatType = '2'"
//        } else {
//            querString = "chatId = \'\(userId)_\(otherId)\' OR chatId = \'\(otherId)_\(userId)\'"
//
//        }
//        messages =  RealmTool.getMessageByPredicate(querString)
//
//        /* 大多数其他数据库技术都提供了从检索中对结果进行“分页”的能力（例如 SQLite 中的 “LIMIT” 关键字）。这通常是很有必要的，可以避免一次性从硬盘中读取太多的数据，或者将太多查询结果加载到内存当中。
//
//         由于 Realm 中的检索是惰性的，因此这行这种分页行为是没有必要的。因为 Realm 只会在检索到的结果被明确访问时，才会从其中加载对象。
//
//         如果由于 UI 相关或者其他代码实现相关的原因导致您需要从检索中获取一个特定的对象子集，这和获取 Results 对象一样简单，只需要读出您所需要的对象即可。*/
//
//        // 数据库总数据
//        let  messageCount = messages.count
//        if messageCount == 0 {
//            return ([],0)
//        }
//        maxCount = messageCount/page + 1
//
//        var start : Int = 0
//        var end : Int = 0
//
//
//        if maxCount == 1 {
//            // 总共一页
//            // 获取开始index
//            start = 0
//            end = messageCount
//        } else {
//            if currentPage < maxCount {
//                start = messageCount-page*currentPage
//                end = start + page
//            }
//            else {
//
//                start =  0
//                end = messageCount - (currentPage-1)*page
//            }
//        }
//        var index : Int = 0
//        // 遍历数据
//        for i in start..<end {
//
//            let mess = messages[i]
//            // 创建聊天类型数据
//            let textMsg = TextMessage.Builder()
//            textMsg.chatId = mess.chatId!
//            textMsg.text = mess.text!
//            textMsg.toUserId = mess.toUserId!
//            textMsg.chatType = mess.chatType!
//            textMsg.success = mess.success!
//            textMsg.sendTime = mess.sendTime ?? ""
//
//            // realm类型用户信息
//            let userRealm : UserInfoRealm = mess.userInfo!
//
//            // 创建聊天用户类型数据
//            let  userInfo = UserInfo.Builder()
//            userInfo.name = userRealm.name!
//            userInfo.level = Int64(userRealm.level)
//            userInfo.iconUrl = userRealm.iconUrl!
//            userInfo.userId = userRealm.userId!
//
//            // 用户信息
//            textMsg.user = try! userInfo.build()
//
//            let msg = try? textMsg.build()
//            if msg != nil {
//
//                if currentPage ==  1 {
//                    msgArray.append(msg!)
//
//                } else {
//                    msgArray.insert(msg!, at: index)
//
//                }
//            }
//            index += 1
//        }
//        index = 0
//
//        return (msgArray,maxCount)
//    }
//
    
    
}

//extension MessageDataManager {
//
//    func handleMsgList(chatMsg: TextMessage) {
//
//        // 聊天内容
//        let  text = chatMsg.text!
//        // 发送给谁的id
//        let id = Int(chatMsg.toUserId)! + 1000
//        // 发送者id
//        let toid  = chatMsg.user.userId
//        let messages  =  RealmTool.getGroupMessages()
//        let num : Int64 = Int64(id)
//        let tonum : Int = Int(toid!)! - 1
//        let  messageCount = messages.count
//        let other : Int = Int(toid!)! + 1000
//        var names = ["TheMokeyKing:","BAYMAX:","IronMan:","群聊天555555:"]
//        for i in 0..<messageCount {
//
//            let mess = messages[i]
//
//            // 更新列表最后一套数据
//            if chatMsg.chatType == "1" {
//                if mess.groupId == num {
//
//                    let newMess =  GroupListMessage()
//                    newMess.groupId = Int(num)
//                    newMess.userInfo = mess.userInfo
//
//                    newMess.text = "\(names[tonum]) \(text)"
//                    newMess.id = Int(num)
//                    RealmTool.updateGroupMessage(message: newMess)
//                } else if mess.groupId == other {
//                    let newMess =  GroupListMessage()
//                    newMess.groupId = Int(other)
//                    newMess.userInfo = mess.userInfo
//                    newMess.text = "\(names[tonum]) \(text)"
//                    newMess.id = Int(other)
//                    RealmTool.updateGroupMessage(message: newMess)
//                }
//            } else if String(mess.groupId) == "1004" {
//
//                let newMess =  GroupListMessage()
//                newMess.groupId = mess.groupId
//                newMess.userInfo = mess.userInfo
//                newMess.text = "\(names[tonum]) \(text)"
//                newMess.id = Int(mess.groupId)
//                RealmTool.updateGroupMessage(message: newMess)
//            }
//
//
//        }
//
//        // 更新聊天记录
//        let builder = try! chatMsg.toBuilder()
//        insertRealmTextMessage(cupid: builder)
//    }
//}
//
//
extension IMDataManager : ZJSocketDelegate {
    
    func socket(_ socket: ZJSocket, joinRoom user: ProtoUser) {

    }

    func socket(_ socket: ZJSocket, leaveRoom user: ProtoUser) {

    }
    
    func socket(_ socket : ZJSocket, login user : ProtoUser) {
        
        print(user)
        let build = try! user.toBuilder()
        
        IMDataManager.share.insertProtoUser(cupid: build)
        notificationToLogin()
    }
    func socket(_ socket: ZJSocket, friend user: ProtoFriend) {
        let build = try! user.toBuilder()
        // 更新插入数据
        IMDataManager.share.insertProtoFriend(cupid: build)
//        print(user)
    }
    
    func socket(_ socket : ZJSocket, friendDetail user : ProtoUser) {
        
//        print(user)
        let build = try! user.toBuilder()
        
        IMDataManager.share.insertProtoUser(cupid: build)
        notificationToFriendDetail()
    }
//    func socket(_ socket: ZJSocket, chatMsg: TextMessage) {
//        print("接收到会话消息： \(chatMsg.text ?? "")")
//
//        // 发送通知给会话页面 数组添加这条数据
//        MessageDataManager.shareInstance.updateHuiHua(chatMsg)
//
//        // 更新聊天列表数据库 和 插入数据到聊天记录数据库
//        MessageDataManager.shareInstance.handleMsgList(chatMsg: chatMsg)
//
//        // 上面已经存储数据到数据库
//        notificationToGroupList()
//    }
//
//    func socket(_ socket: ZJSocket, groupMsg: GroupMessage) {
//
//        print("接收到列表消息数据： \(groupMsg.text ?? "")")
//        // 列表消息插入更新到数据库
//        let build = try! groupMsg.toBuilder()
//
//        MessageDataManager.shareInstance.insertRealmGroupMessage(cupid: build)
//        // 上面已经存储数据到数据库
//        notificationToGroupList()
//    }


}


extension IMDataManager {

    func notificationToLogin()  {

        NotificationCenter.default.post(name: NSNotification.Name("loginSuccess"), object: self, userInfo:nil)
    }
    
    func notificationToFriendDetail()  {
        
        NotificationCenter.default.post(name: NSNotification.Name("FriendDetailSuccess"), object: self, userInfo:nil)
    }
}



extension IMDataManager {
    
        func insertProtoUser(cupid : ProtoUser.Builder) {
            let protoUser = try! cupid.build()

            // realm消息数据
            let dbUser = DBUser()
            
            dbUser.objectId = protoUser.objectId
            dbUser.phone =  protoUser.phone
            dbUser.name = protoUser.name
            dbUser.nickName = protoUser.nickName
            dbUser.country =  protoUser.country
            dbUser.status =  protoUser.status
            dbUser.picture = protoUser.picture
            dbUser.thumbnail = protoUser.thumbnail
            dbUser.lastActive = protoUser.lastActive
            dbUser.lastTerminate = protoUser.lastTerminate
            dbUser.createdAt =  protoUser.createdAt
            dbUser.updatedAt = protoUser.updatedAt
            dbUser.gender = protoUser.gender
            RealmTool.insertDBUser(by: dbUser)
    
        }
    
    
    
    func insertProtoFriend(cupid : ProtoFriend.Builder) {
        let protoFriend = try! cupid.build()
        
        // realm消息数据
        let dbFriend = DBFriend()
        
        dbFriend.objectId = protoFriend.objectId
        dbFriend.friendId =  protoFriend.friendId
        dbFriend.section = protoFriend.section
        dbFriend.isDeleted = protoFriend.isDeleted
       
        dbFriend.createdAt =  protoFriend.createdAt
        dbFriend.updatedAt = protoFriend.updatedAt
        dbFriend.name = protoFriend.name
        dbFriend.picture = protoFriend.picture
        
        RealmTool.insertDBFriend(by: dbFriend)
        
    }
    
}
