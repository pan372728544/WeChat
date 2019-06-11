//
//  ChatButton.swift
//  WeChat
//
//  Created by panzhijun on 2019/6/4.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class ChatButton: UIButton {

    var showTypingKeyboard: Bool
    
    
    override init(frame: CGRect) {
        self.showTypingKeyboard = false
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


}
