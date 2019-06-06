//
//  PageView.swift
//  WeChat
//
//  Created by panzhijun on 2019/6/5.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class PageView: UIView {

    
    // MARK: 定义属性
    fileprivate var titles : [String]!
    fileprivate var style : TitleStyle!
    fileprivate var childVcs : [UIViewController]!
    fileprivate weak var parentVc : UIViewController!
    
    fileprivate var titleView : TitleView!
    fileprivate var contentView : ContentView!
    
    // MARK: 自定义构造函数
    init(frame: CGRect, titles : [String], style : TitleStyle, childVcs : [UIViewController], parentVc : UIViewController) {
        super.init(frame: frame)
        
        assert(titles.count == childVcs.count, "标题&控制器个数不同,请检测!!!")
        self.style = style
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        parentVc.automaticallyAdjustsScrollViewInsets = false
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK:- 设置界面内容
extension PageView {
    fileprivate func setupUI() {
        let titleH : CGFloat = 44
        let titleFrame = CGRect(x: 0, y: 0, width: frame.width, height: titleH)
        titleView = TitleView(frame: titleFrame, titles: titles, style : style)
        titleView.delegate = self
        addSubview(titleView)
        
        let contentFrame = CGRect(x: 0, y: titleH, width: frame.width, height: frame.height - titleH)
        contentView = ContentView(frame: contentFrame, childVcs: childVcs, parentViewController: parentVc)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.delegate = self
        addSubview(contentView)
    }
}


// MARK:- 设置ContentView的代理
extension PageView : ContentViewDelegate {
    func contentView(_ contentView: ContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        titleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    func contentViewEndScroll(_ contentView: ContentView) {
        titleView.contentViewDidEndScroll()
    }
}


// MARK:- 设置TitleView的代理
extension PageView : TitleViewDelegate {
    func titleView(_ titleView: TitleView, selectedIndex index: Int) {
        contentView.setCurrentIndex(index)
    }
}
