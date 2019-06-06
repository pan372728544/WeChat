//
//  MoreActionPackage.swift
//  WeChat
//
//  Created by panzhijun on 2019/6/6.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class MoreActionPackage {

    lazy var moreActions : [MoreAction] = [MoreAction]()
    
    init(plistName : String) {
        guard let path = Bundle.main.path(forResource: plistName, ofType: nil) else {
            return
        }
        
        guard let emotionArray = NSArray(contentsOfFile: path) as? [Dictionary<String, String>] else {
            return
        }
        
        for item  in emotionArray {
            var dic : Dictionary = item
            moreActions.append(MoreAction(moreName: dic["text"]!, imageName: dic["image"]!))
        }

    }
    
}
