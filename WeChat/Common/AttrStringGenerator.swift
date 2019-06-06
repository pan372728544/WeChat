//
//  AttrStringGenerator.swift
//  WeChat
//
//  Created by panzhijun on 2019/6/6.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class AttrStringGenerator: NSObject {

    
    // 匹配表情
    class func generateEmoticon( _ message : String) -> NSAttributedString {

        let chatMessage = message
        let chatMsgMAttr = NSMutableAttributedString(string: chatMessage)
        
        
        // 将所有表情匹配出来, 并且换成对应的图片进行展示
        // 创建正则表达式匹配表情[哈哈], [嘻嘻][嘻嘻] [123444534545235]
        let pattern = "\\[.*?\\]"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return chatMsgMAttr }
        // 获取匹配后的数组
        let results = regex.matches(in: chatMessage, options: [], range: NSRange(location: 0, length: chatMessage.count))
        
        // 获取表情的结果
        for i in (0..<results.count).reversed() {
            // 获取结果
            let result = results[i]
            let emoticonName = (chatMessage as NSString).substring(with: result.range)
            
            // 根据结果创建对应的图片
            let emoticons =  EmoticonViewModel.share.packages.first?.emoticons
            var imgName = ""
            // 获取图片名称
            for item in emoticons! {
                if   item.text == emoticonName {
                    imgName = item.image
                    break
                }
            }
            
            guard let image = UIImage(named: imgName) else {
                continue
            }
            
            // 根据图片创建NSTextAttachment
            let attachment = NSTextAttachment()
            attachment.image = image
            let font = UIFont.systemFont(ofSize: 16)
            attachment.bounds = CGRect(x: 0, y: -3, width: font.lineHeight, height: font.lineHeight)
            let imageAttrStr = NSAttributedString(attachment: attachment)
            
            // 将imageAttrStr替换到之前文本的位置
            chatMsgMAttr.replaceCharacters(in: result.range, with: imageAttrStr)
        }
        
        return chatMsgMAttr
    }
    
}
