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


class DBMessage: Object {
    
    @objc dynamic var objectId = ""
    
    @objc dynamic var chatId = ""
    @objc dynamic var members = ""
    
    @objc dynamic var senderId = ""
    @objc dynamic var senderName = ""
    @objc dynamic var senderPicture = ""
    
    @objc dynamic var recipientId = ""
    @objc dynamic var recipientName = ""
    @objc dynamic var recipientPicture = ""
    
    @objc dynamic var groupId = ""
    @objc dynamic var groupName = ""
    @objc dynamic var groupPicture = ""
    
    @objc dynamic var type = ""
    @objc dynamic var text = ""
    
    @objc dynamic var picture : Data?

    
    @objc dynamic var video : Data?
    @objc dynamic var video_duration: Int64 = 0

    
    @objc dynamic var audio : Data?
    @objc dynamic var audio_duration: Int64 = 0
    
    
    @objc dynamic var file : Data?
    
    @objc dynamic var status = ""
    @objc dynamic var isDeleted = false
    
    @objc dynamic var createdAt: Int64 = 0
    @objc dynamic var updatedAt: Int64 = 0
    
    override static func primaryKey() -> String? {
        
            return "objectId"
    }
    
}
