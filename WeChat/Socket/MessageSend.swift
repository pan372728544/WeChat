//
//  MessageSend.swift
//  WeChat
//
//  Created by panzhijun on 2019/6/5.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class MessageSend: NSObject {
    
    
    static let share = MessageSend()
    
    
//    func <#name#>(<#parameters#>) -> <#return type#> {
//        <#function body#>
//    }
    
}


extension MessageSend : UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
    
        return true
    }
    
}
