//
//  NextPushId.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/31.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class NextPushId: NSObject {

    class func getUUIDString() -> String {
        let uuidRef = CFUUIDCreate(kCFAllocatorDefault)
        let strRef = CFUUIDCreateString(kCFAllocatorDefault, uuidRef)
        let uuidString = strRef! as String
 
        return uuidString
    }
}
