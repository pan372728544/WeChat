//
//  ChatMessage.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/15.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit
import RealmSwift


class DBUser: Object {
    
    // 用户信息搜索的id
    @objc dynamic var objectId = ""

    @objc dynamic var phone = ""
    
    @objc dynamic var name = ""
    @objc dynamic var nickName = ""

    @objc dynamic var country = ""

    @objc dynamic var status = ""
    
    @objc dynamic var picture = ""
    @objc dynamic var thumbnail = ""

    
    @objc dynamic var lastActive: Int64 = 0
    @objc dynamic var lastTerminate: Int64 = 0
    
    @objc dynamic var createdAt: Int64 = 0
    @objc dynamic var updatedAt: Int64 = 0
    @objc dynamic var gender = ""
    override static func primaryKey() -> String? {
        
        return "objectId"
    }
    
}


class DBFriend: Object {
    
    @objc dynamic var objectId = ""
    
    @objc dynamic var friendId = ""
    
    @objc dynamic var section = ""
    
    @objc dynamic var name = ""
    
    @objc dynamic var picture = ""
    
    @objc dynamic var isDeleted = false
    
    @objc dynamic var createdAt: Int64 = 0
    @objc dynamic var updatedAt: Int64 = 0
    
    override static func primaryKey() -> String? {
        
        return "objectId"
    }
    
}


//
//class UserInfoRealm: Object {
//    // 用户信息模型
//    @objc dynamic var name : String? = ""
//    @objc dynamic var level = 0
//    @objc dynamic var iconUrl : String? = ""
//    @objc dynamic var userId : String? = ""
//    
//    
//}
//
//class ChatMessage: Object {
//    
//    // 消息模型
//    @objc dynamic var text : String? = ""
//    @objc dynamic var chatId : String? = ""
//    @objc dynamic var toUserId : String? = ""
//    @objc dynamic var chatType : String? = ""
//    @objc dynamic var success : String? = ""
//    @objc dynamic var sendTime : String? = ""
//    @objc dynamic var userInfo: UserInfoRealm? = nil
//    
//}
//
//
//class GroupListMessage: Object {
//    
//    // 群组列表
//    @objc dynamic var text : String? = ""
//    @objc dynamic var groupId = 0
//    @objc dynamic var id = 0
//    @objc dynamic var userInfo: UserInfoRealm? = nil
//    override static func primaryKey() -> String? {
//        return "id"
//    }
//    
//}
