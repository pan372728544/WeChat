//
//  EmoticonPackage.swift
//  WeChat
//
//  Created by panzhijun on 2019/6/5.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class EmoticonPackage {

    lazy var emoticons : [Emoticon] = [Emoticon]()
    
    init(plistName : String) {
        guard let path = Bundle.main.path(forResource: plistName, ofType: nil) else {
            return
        }
        
        guard let emotionArray = NSArray(contentsOfFile: path) as? [Dictionary<String, String>] else {
            return
        }
        
        for item  in emotionArray {
            var dic : Dictionary = item
            emoticons.append(Emoticon(emoticonName: dic["text"]!, imageName: dic["image"]!))
        }
        
        print("")
    }
}
