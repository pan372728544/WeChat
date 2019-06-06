//
//  Emoticon.swift
//  WeChat
//
//  Created by panzhijun on 2019/6/5.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class Emoticon {

    var text : String = ""
    var image : String = ""
    init(emoticonName : String,imageName : String) {
        self.text = emoticonName
        self.image = imageName
    }
}
