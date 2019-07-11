//
//  AtrributeLabel.swift
//  WeChat
//
//  Created by panzhijun on 2019/7/11.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

protocol AtrributeLabelDelegate: NSObjectProtocol {
    func labelDidSelectedLink(text: String)
    func labelDidSelectedTopic(text: String)
    func labelDidSelectedAt(text: String)
    func labelDidSelectedPhone(text: String)
}

class AtrributeLabel: UILabel {
    
    // 点击代理
    weak var delegate: AtrributeLabelDelegate?
    
    // 点击选中的范围
    var selectedRange: NSRange?
    
    // 链接文本颜色
    var linkTextColor =  UIColor.init(r: 100, g: 149, b: 237)
    
    var selectedBackgroudColor = UIColor.init(r: 211, g: 211, b: 211)
    
    
    // MARK: TextKit核心对象
    /// NSAttributedString 子类 设置文本统一使用
    fileprivate lazy var textStorage = NSTextStorage()
    /// 布局管理器 负责 字形 布局
    fileprivate lazy var layoutManager = NSLayoutManager()
    /// 绘制区域
    fileprivate lazy var textContainer = NSTextContainer()
    // MARK: 重写属性
    override var text: String? {
        didSet {
            prepareText()
        }
    }
    
    override var attributedText: NSAttributedString? {
        didSet {
            prepareText()
        }
    }
    
    override var font: UIFont! {
        didSet {
            prepareText()
        }
    }
    
    override var textColor: UIColor! {
        didSet {
            prepareText()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareTextSystem()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        prepareTextSystem()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 指定文本绘制区域
        textContainer.size = bounds.size
    }
    
    // 绘制textStorage的文本内容
    override func drawText(in rect: CGRect) {
        
        // 绘制背景
        let range = NSRange(location: 0, length: textStorage.length)
        layoutManager.drawBackground(forGlyphRange: range, at: CGPoint())
        
        // 绘制字形
        layoutManager.drawGlyphs(forGlyphRange: range, at: CGPoint())
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if selectedRange != nil {

            self.modifySelectedAttribute(false)
        }
    }
    
    
    // MARK: 点击文本
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else {
            return
        }
        selectedRange = nil
        // 获取点击了第几个字符
        let index = layoutManager.glyphIndex(for: location, in: textContainer)
        
        // 判断index是否在 range里
        for range in urlRanges ?? [] {
            if NSLocationInRange(index, range) {
                
                selectedRange = range
                self.modifySelectedAttribute(true)
                let str = (textStorage.string as NSString).substring(with: range)
                delegate?.labelDidSelectedLink(text: str)
                return
            }
        }
        
        for range in topicRanges ?? [] {
            if NSLocationInRange(index, range) {
                selectedRange = range
                self.modifySelectedAttribute(true)
                let str = (textStorage.string as NSString).substring(with: range)
                delegate?.labelDidSelectedTopic(text: str)
                return
            }
        }
        
        for range in atRanges ?? [] {
            if NSLocationInRange(index, range) {
                selectedRange = range
                self.modifySelectedAttribute(true)
                let str = (textStorage.string as NSString).substring(with: range)
                delegate?.labelDidSelectedAt(text: str)
                return
            }
        }
        
        for range in phoneRanges ?? [] {
            if NSLocationInRange(index, range) {
                selectedRange = range
                self.modifySelectedAttribute(true)
                let str = (textStorage.string as NSString).substring(with: range)
                delegate?.labelDidSelectedPhone(text: str)
                return
            }
        }
        
    }
    
}

// MARK: 交互
extension AtrributeLabel {
    func modifySelectedAttribute(_ isSet: Bool) {
        if selectedRange == nil {
            return
        }
        var attributes = textStorage.attributes(at: 0, effectiveRange: nil)
        attributes[NSAttributedString.Key.foregroundColor] = linkTextColor
        attributes[NSAttributedString.Key.backgroundColor] = isSet ?  selectedBackgroudColor : UIColor.clear
        textStorage.addAttributes(attributes, range: selectedRange!)
        selectedRange = !isSet ? nil : selectedRange
        setNeedsDisplay()
    }
}

// MARK: 设置TextKit
extension AtrributeLabel {
    
    /// 准备文本系统
    fileprivate func prepareTextSystem() {
        
        // 打开交互
        isUserInteractionEnabled = true
        
        // 设置行样式
        lineBreakMode = .byCharWrapping
        // 准备文本内容
        prepareText()
        
        // 设置对象的关系
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        
    }
    
    /// 准备文本内容 - 使用TextStorage 接管 label内容
    fileprivate func prepareText() {
        if let attributedText = attributedText {
            textStorage.setAttributedString(attributedText)
        }else if let text = text {
            textStorage.setAttributedString(NSAttributedString(string: text))
        }else {
            textStorage.setAttributedString(NSAttributedString(string: ""))
            return
        }
        
        // 设置Text属性
        setupTextAttributes()
        
    }
    
}

// MARK: 设置TextStorage text的属性 (设置显示)
extension AtrributeLabel {
    fileprivate func setupTextAttributes() {
        
        textStorage.addAttributes([NSAttributedString.Key.font: font,
                                   NSAttributedString.Key.foregroundColor: textColor],
                                  range: NSRange(location: 0, length: textStorage.length))
        
        for range in urlRanges ?? [] {
            textStorage.addAttributes([NSAttributedString.Key.foregroundColor: linkTextColor], range: range)
        }
        
        for range in topicRanges ?? [] {
            textStorage.addAttributes([NSAttributedString.Key.foregroundColor: linkTextColor], range: range)
        }
        
        for range in atRanges ?? [] {
            textStorage.addAttributes([NSAttributedString.Key.foregroundColor: linkTextColor], range: range)
        }
        
        for range in phoneRanges ?? [] {
            textStorage.addAttributes([NSAttributedString.Key.foregroundColor: linkTextColor], range: range)
        }
    }
    
}

// MARK: 正则表达式
extension AtrributeLabel {
    /// 链接
    var urlRanges: [NSRange]? {
        let pattern = "\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))"
        
        return findRanges(pattern: pattern)
    }
    
    /// 话题
    var topicRanges: [NSRange]? {
        let pattern = "#[^#]+#"
        
        return findRanges(pattern: pattern)
    }
    
    /// @用户
    var atRanges: [NSRange]? {
        let pattern = "@[\\u4e00-\\u9fa5a-zA-Z0-9_-]{2,30}"
        
        return findRanges(pattern: pattern)
    }
    
    /// 手机号
    var phoneRanges: [NSRange]? {
        let pattern = "1+[35678]+\\d{9}"
        return findRanges(pattern: pattern)
    }
    
    
    /// 根据正则表达式在textStorage中寻找对应的range
    ///
    /// - Parameter pattern: 正则表达式
    /// - Returns: 对应NSRange数组
    private func findRanges(pattern: String) -> [NSRange]? {
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        
        let matches = regx.matches(in: textStorage.string, options: [], range: NSRange(location: 0, length: textStorage.length))
        
        var ranges = [NSRange]()
        for match in matches {
            ranges.append(match.range(at: 0))
        }
        
        return ranges
    }
}
