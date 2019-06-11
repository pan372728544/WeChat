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
    
    // 查询聊天列表数据
    func searchRealmGroupList() -> [DBChat] {

        // 返回的数组
        var msgArray : [DBChat] = [DBChat]()
        
        let messages : Results<DBChat>
        
        messages =  RealmTool.getGroupMessages()
        
        // 数据库总数据
        let  messageCount = messages.count
        if messageCount == 0 {
            return msgArray
        }
        
        // 遍历数据
        for mess in messages {
            
            msgArray.append(mess)
        }
        msgArray = msgArray.sorted(by: { (s0, s1) -> Bool in
            s0.updatedAt > s1.updatedAt
        })
        return msgArray
    }


        // 查询聊天记录 数据
    func searchRealmChatMessagesList(currentPage : Int,chatId: String) -> ([DBMessage],Int) {
        
        var msgArray : [DBMessage] = [DBMessage]()
        // 每次加载多少条数据
        let page :  Int = 10
        // 最大页数
        var maxCount :  Int = 0
        
        let messages : Results<DBMessage>
        var querString = ""
        
        // 群聊天
        
        querString = "chatId = \'\(chatId)\'"
        
        messages =  RealmTool.getMessageByPredicate(querString)
        
        /* 大多数其他数据库技术都提供了从检索中对结果进行“分页”的能力（例如 SQLite 中的 “LIMIT” 关键字）。这通常是很有必要的，可以避免一次性从硬盘中读取太多的数据，或者将太多查询结果加载到内存当中。
         
         由于 Realm 中的检索是惰性的，因此这行这种分页行为是没有必要的。因为 Realm 只会在检索到的结果被明确访问时，才会从其中加载对象。
         
         如果由于 UI 相关或者其他代码实现相关的原因导致您需要从检索中获取一个特定的对象子集，这和获取 Results 对象一样简单，只需要读出您所需要的对象即可。*/
        
        // 数据库总数据
        let  messageCount = messages.count
        if messageCount == 0 {
            return ([],0)
        }
        maxCount = messageCount/page + 1
        
        var start : Int = 0
        var end : Int = 0
        
        
        if maxCount == 1 {
            // 总共一页
            // 获取开始index
            start = 0
            end = messageCount
        } else {
            if currentPage < maxCount {
                start = messageCount-page*currentPage
                end = start + page
            }
            else {
                
                start =  0
                end = messageCount - (currentPage-1)*page
            }
        }
        var index : Int = 0
        // 遍历数据
        for i in start..<end {
            
            let mess = messages[i]
            if currentPage ==  1 {
                msgArray.append(mess)
                
            } else {
                msgArray.insert(mess, at: index)
                
            }
            index += 1
        }
        index = 0
        
        return (msgArray,maxCount)
    }
    
    
    
}

extension IMDataManager : ZJSocketDelegate {
    
    func socket(_ socket: ZJSocket, joinRoom user: ProtoUser) {

    }

    func socket(_ socket: ZJSocket, leaveRoom user: ProtoUser) {

    }
    
    // 登录
    func socket(_ socket : ZJSocket, login user : ProtoUser) {
 
        let build = try! user.toBuilder()
        // 保存到数据库
        IMDataManager.share.insertProtoUser(cupid: build)
        notificationToLogin()
    }
    
    // 好友列表
    func socket(_ socket: ZJSocket, friends user: [ProtoFriend]) {
        
        for item in user {
            let build = try! item.toBuilder()
            // 更新插入数据
            IMDataManager.share.insertProtoFriend(cupid: build)
        }
        

    }
    
    
    // 好友详情
    func socket(_ socket : ZJSocket, friendDetail user : ProtoUser) {
        
        let build = try! user.toBuilder()
        
        IMDataManager.share.insertProtoUser(cupid: build)
        notificationToFriendDetail()
    }
    
    // 收到消息
    func socket(_ socket: ZJSocket, chatMsg: ProtoMessage) {
        
        
        print("收到服务器消息：\(chatMsg.text)")
        
        let build = try! chatMsg.toBuilder()
        self.insertProtoMessage(cupid: build)
     
        insertDataToChatList(chatMag: chatMsg)
        
        notificationToReceiveMessage()
        notificationToGroupList()
    }
    


}


extension IMDataManager {

    func notificationToLogin()  {

        NotificationCenter.default.post(name: NSNotification.Name("loginSuccess"), object: self, userInfo:nil)
    }
    
    func notificationToFriendDetail()  {
        
        NotificationCenter.default.post(name: NSNotification.Name("FriendDetailSuccess"), object: self, userInfo:nil)
    }
    
    func notificationToReceiveMessage()  {
        
        NotificationCenter.default.post(name: NSNotification.Name("ReceiveMessageSuccess"), object: self, userInfo:nil)
    }
    
    func notificationToGroupList()  {
        
        NotificationCenter.default.post(name: NSNotification.Name("GroupListSuccess"), object: self, userInfo:nil)
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
    
    func insertProtoMessage(cupid : ProtoMessage.Builder) {
        let protoMessage = try! cupid.build()
        // realm消息数据
        let dbMessage = DBMessage()
        
        dbMessage.objectId = protoMessage.objectId
        dbMessage.chatId =  protoMessage.chatId
        dbMessage.members = protoMessage.members
        dbMessage.senderId = protoMessage.senderId
        
        dbMessage.senderName =  protoMessage.senderName
        dbMessage.senderPicture = protoMessage.senderPicture
        dbMessage.recipientId = protoMessage.recipientId
        dbMessage.recipientName = protoMessage.recipientName
        
        dbMessage.recipientPicture = protoMessage.recipientPicture
        dbMessage.groupId =  protoMessage.groupId
        dbMessage.groupName = protoMessage.groupName
        dbMessage.groupPicture = protoMessage.groupPicture
        
        dbMessage.type =  protoMessage.type
        dbMessage.text = protoMessage.text
        dbMessage.picture = protoMessage.picture
        dbMessage.video = protoMessage.video
        
        dbMessage.video_duration = protoMessage.videoDuration
        dbMessage.audio =  protoMessage.audio
        dbMessage.audio_duration = protoMessage.audioDuration
        dbMessage.file = protoMessage.file
        
        dbMessage.createdAt =  protoMessage.createdAt
        dbMessage.updatedAt = protoMessage.updatedAt
        dbMessage.status = protoMessage.status
        dbMessage.isDeleted = protoMessage.isDeleted
        
        RealmTool.insertMessages(by: dbMessage)
        
    }
    
    
    func insertDataToChatList(chatMag: ProtoMessage) {
        
        // 创建会话列表
        let dbChat = DBChat()
        let timeInterval = Date().timeIntervalSince1970
        
        let  currentId = self.getCurrentId()
        
        var receiveId = ""
        var receiveName = ""
        var receivePic = ""
        
        if  currentId == chatMag.senderId {
            receiveId = chatMag.recipientId
            receiveName = chatMag.recipientName
            receivePic = chatMag.recipientPicture
        } else {
            receiveId = chatMag.senderId
            receiveName = chatMag.senderName
            receivePic = chatMag.senderPicture
        }
        
        
        dbChat.chatId = IMDataManager.share.getChatId(receiveId: receiveId)
        dbChat.recipientId = receiveId
        dbChat.recipientName = receiveName
        dbChat.picture = receivePic
        dbChat.groupId = ""
        dbChat.lastMessage =   chatMag.text
        if chatMag.updatedAt == 0 {
            dbChat.lastMessageDate = Int64(timeInterval)
        } else {
            dbChat.lastMessageDate = chatMag.updatedAt
        }

        
        dbChat.lastMessageName = chatMag.senderName
        
        dbChat.lastIncoming = 0
        dbChat.isArchived = true
        dbChat.isDeleted = false
        dbChat.createdAt = Int64(timeInterval)
        dbChat.updatedAt = Int64(timeInterval)
        
        RealmTool.insertSessionList(by: dbChat)
    }
    
    func getChatId(receiveId : String) -> String {
        let members = [self.getCurrentId(), receiveId]
        let sorted = members.sorted{$0.localizedCaseInsensitiveCompare($1) == .orderedAscending}
        let chatIdStr =  Checksum.md5HashOf(string: sorted.joined(separator: ""))
        return chatIdStr
    }
    
    
    func getCurrentId() -> String {
        
        let user = RealmTool.getDBUser().first
        
        return (user?.objectId)!
    }
    
    
    func getChatTextSize(text : NSAttributedString) -> CGSize {

        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = text.boundingRect(with: CGSize(width: Screen_W - 140, height: CGFloat(MAXFLOAT)), options: option, context: nil)
        
        return rect.size
    }
    

}


