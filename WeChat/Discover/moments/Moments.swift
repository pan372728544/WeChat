//
//  Moments.swift
//  WeChat
//
//  Created by panzhijun on 2019/7/10.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

struct Moment:Codable{
    var momnetsList:[momnets]
}

struct momnets:Codable {
    var userId:String
    var userName:String
    var userUrl:String
    var contentDesc:String
    var imagesList:[images]
    var commentList:[commnet]
    var time:String
    var address:String
}

struct images:Codable {
    var imageUrl:String
}


struct commnet:Codable {
    var userId:String
    var userName:String
    var commnent:String
}
