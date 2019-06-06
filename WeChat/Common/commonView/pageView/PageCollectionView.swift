//
//  PageCollectionView.swift
//  WeChat
//
//  Created by panzhijun on 2019/6/5.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

protocol PageCollectionViewDataSource : class {
    func numberOfSections(in pageCollectionView : PageCollectionView) -> Int
    func pageCollectionView(_ collectionView: PageCollectionView, numberOfItemsInSection section: Int) -> Int
    func pageCollectionView(_ pageCollectionView : PageCollectionView ,_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell

}

protocol PageCollectionViewDelegate : class {
    func pageCollectionView(_ pageCollectionView: PageCollectionView, didSelectItemAt indexPath: IndexPath)
    
    
    func pageCollectionViewDidClickSend()
}

let kEmoticonAddWidth: CGFloat = 55
let kEmoticonCols : Int = 4
let kEmoticonRows : Int = 2

var kEmoticonDefaultCols : Int = 8
var kEmoticonDefaultRows : Int = 3

class PageCollectionView: UIView {
    
    weak var dataSource : PageCollectionViewDataSource?
    weak var delegate : PageCollectionViewDelegate?
    
    fileprivate var titles : [String]
    fileprivate var isTitleInTop : Bool
    fileprivate var style : TitleStyle
    fileprivate var layout : PageCollectionViewLayout
    fileprivate var collectionView : UICollectionView!
    fileprivate var pageControl : UIPageControl!
    fileprivate var titleView : TitleView!
    fileprivate var sourceIndexPath : IndexPath = IndexPath(item: 0, section: 0)
    
    fileprivate var safeBottomView : UIView!
    
    fileprivate var shadowView : UIView!
    
    fileprivate var buttonSetting : UIButton!
    
    fileprivate var  buttonAdd : UIButton!
    
    init(frame: CGRect, titles : [String], style : TitleStyle, isTitleInTop : Bool, layout : PageCollectionViewLayout) {
        self.titles = titles
        self.style = style
        self.isTitleInTop = isTitleInTop
        self.layout = layout
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK:- 设置UI界面
extension PageCollectionView {
    fileprivate func setupUI() {
        
        let blur = UIBlurEffect(style: UIBlurEffect.Style.light)
        let  effectView = UIVisualEffectView(effect: blur)
        effectView.frame = bounds
        effectView.backgroundColor = UIColor(red: 237/255.0, green: 237/255.0, blue: 237/255.0, alpha: 0.6)
        effectView.alpha = 1.0
        effectView.isUserInteractionEnabled = true
        addSubview(effectView)

        let viewLine1 = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 1/UIScreen.main.scale))
        viewLine1.backgroundColor = UIColor.Gray213Color()
        effectView.contentView.addSubview(viewLine1)
        
        
        // 1.创建titleView
        let titleY = isTitleInTop ? 0 : bounds.height - style.titleHeight - Bottom_H
        let titleFrame = CGRect(x: kEmoticonAddWidth, y: titleY, width: bounds.width-kEmoticonAddWidth, height: style.titleHeight)
        titleView = TitleView(frame: titleFrame, titles: titles, style: style)
        titleView.backgroundColor = UIColor.white
        effectView.contentView.addSubview(titleView)
        titleView.delegate = self
        
        // 2.创建UIPageControl
        let pageControlHeight : CGFloat = 20
        let pageControlY = isTitleInTop ? (bounds.height - pageControlHeight - Bottom_H) : (bounds.height - pageControlHeight - style.titleHeight - Bottom_H)
        let pageControlFrame = CGRect(x: 0, y: pageControlY, width: bounds.width, height: pageControlHeight)
        pageControl = UIPageControl(frame: pageControlFrame)
        pageControl.numberOfPages = 4
        pageControl.isEnabled = false
        pageControl.currentPageIndicatorTintColor = UIColor.gray
        pageControl.pageIndicatorTintColor = UIColor.Gray213Color()
        effectView.contentView.addSubview(pageControl)
        
        // 3.创建UICollectionView
        let collectionViewY = isTitleInTop ? style.titleHeight : 0
        let collectionViewFrame = CGRect(x: 0, y: collectionViewY, width: bounds.width, height: bounds.height - style.titleHeight - pageControlHeight - Bottom_H)
        collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        effectView.contentView.addSubview(collectionView)
        

        buttonAdd = UIButton(frame: CGRect(x: 0, y: titleY, width: kEmoticonAddWidth, height: style.titleHeight))
        
        
        var imgV = UIImage.init(named: "watch-settings-add")
        imgV = imgV?.withRenderingMode(.alwaysTemplate)
        buttonAdd.tintColor = UIColor.black
        buttonAdd.setImage(imgV, for: .normal)
        buttonAdd.backgroundColor = UIColor.white
        effectView.contentView.addSubview(buttonAdd)
        
        shadowView = UIView(frame: CGRect(x: Screen_W-kEmoticonAddWidth, y: titleY, width: kEmoticonAddWidth, height: style.titleHeight))
        shadowView.backgroundColor = UIColor.clear
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: -3, height: 0)
        shadowView.layer.shadowRadius = 3
        shadowView.layer.shadowOpacity = 0.21
        effectView.contentView.addSubview(shadowView)
        
        // 发送按钮
        let buttonSend = UIButton(frame: CGRect(x: 0, y: 0, width: kEmoticonAddWidth, height: style.titleHeight))
        buttonSend.setTitle("发送", for: .normal)
        buttonSend.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        buttonSend.setTitleColor(UIColor.black, for: .normal)
        buttonSend.backgroundColor =  UIColor(red: 237/255.0, green: 237/255.0, blue: 237/255.0, alpha: 1)
        buttonSend.addTarget(self, action: #selector(btnClick(btn:)), for: UIControl.Event.touchUpInside)
        shadowView.addSubview(buttonSend)
        
        
        // 设置按钮
        buttonSetting = UIButton(frame: CGRect(x: 0, y: 0, width: kEmoticonAddWidth, height: style.titleHeight))
        var imgS = UIImage.init(named: "MoreSetting_Normal")
        imgS = imgS?.withRenderingMode(.alwaysTemplate)
        buttonSetting.tintColor = UIColor.black
        buttonSetting.setImage(imgS, for: .normal)
        buttonSetting.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        buttonSetting.setTitleColor(UIColor.black, for: .normal)
        buttonSetting.backgroundColor =  UIColor(red: 237/255.0, green: 237/255.0, blue: 237/255.0, alpha: 1)
        buttonSetting.addTarget(self, action: #selector(btnSetClick(btn:)), for: UIControl.Event.touchUpInside)
        buttonSetting.alpha = 0
        shadowView.addSubview(buttonSetting)

        safeBottomView = UIView(frame: CGRect(x: 0, y: bounds.height-Bottom_H, width: Screen_H, height: Bottom_H))
        safeBottomView.backgroundColor = UIColor.white
        effectView.contentView.addSubview(safeBottomView)
        
        
        
        
        if style.type == .moreAction {
            kEmoticonDefaultCols = 4
            kEmoticonDefaultRows = 2
            buttonAdd.isHidden = true
            shadowView.isHidden = true
            safeBottomView.backgroundColor = UIColor.clear
            
        } else {
            kEmoticonDefaultCols = 8
            kEmoticonDefaultRows = 3
            buttonAdd.isHidden = false
            shadowView.isHidden = false
            safeBottomView.backgroundColor = UIColor.white
        }
        
    }
}


// MARK:- 对外暴露的方法
extension PageCollectionView {
    func register(cell : AnyClass?, identifier : String) {
        collectionView.register(cell, forCellWithReuseIdentifier: identifier)
    }
    
    func register(nib : UINib, identifier : String) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    @objc  func btnClick(btn: UIButton)  {
        delegate?.pageCollectionViewDidClickSend()
    }
    
    @objc  func btnSetClick(btn: UIButton)  {
        Toast.showCenterWithText(text: "不用点了没有实现")
    }
}


// MARK:- UICollectionViewDataSource
extension PageCollectionView : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSections(in: self) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemCount = dataSource?.pageCollectionView(self, numberOfItemsInSection: section) ?? 0
        
        if section == 0 {
            pageControl.numberOfPages = (itemCount - 1) / (kEmoticonDefaultCols * kEmoticonDefaultRows) + 1
        }

        
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource!.pageCollectionView(self, collectionView, cellForItemAt: indexPath)
    }
}


// MARK:- UICollectionViewDelegate
extension PageCollectionView : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pageCollectionView(self, didSelectItemAt: indexPath)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewEndScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewEndScroll()
        }
    }
    
    fileprivate func scrollViewEndScroll() {
        // 1.取出在屏幕中显示的Cell
        let point = CGPoint(x: layout.sectionInset.left + 1 + collectionView.contentOffset.x, y: layout.sectionInset.top + 1)
        guard let indexPath = collectionView.indexPathForItem(at: point) else { return }
        
        
        print("==== \(indexPath.section)")
        
        // 2.判断分组是否有发生改变
        if sourceIndexPath.section != indexPath.section {
            
            animationSendBtn(section : indexPath.section)
            
            // 3.1.修改pageControl的个数
            let itemCount = dataSource?.pageCollectionView(self, numberOfItemsInSection: indexPath.section) ?? 0
            
            if indexPath.section == 0 {
                pageControl.numberOfPages = (itemCount - 1) / (kEmoticonDefaultCols * kEmoticonDefaultRows) + 1
            } else {
                pageControl.numberOfPages = (itemCount - 1) / (kEmoticonCols * kEmoticonRows) + 1
            }
            
            
            // 3.2.设置titleView位置
            titleView.setTitleWithProgress(1.0, sourceIndex: sourceIndexPath.section, targetIndex: indexPath.section)
            
            // 3.3.记录最新indexPath
            sourceIndexPath = indexPath
        }
        
        // 3.根据indexPath设置pageControl
        if indexPath.section == 0 {
            pageControl.currentPage = indexPath.item / (kEmoticonDefaultCols * kEmoticonDefaultRows)
        } else {
            pageControl.currentPage = indexPath.item / (kEmoticonCols * kEmoticonRows)
        }
   
    }
}


// MARK:- TitleViewDelegate
extension PageCollectionView : TitleViewDelegate {
    func titleView(_ titleView: TitleView, selectedIndex index: Int) {
        let indexPath = IndexPath(item: 0, section: index)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        collectionView.contentOffset.x -= layout.sectionInset.left
        
        scrollViewEndScroll()
    }
}


extension PageCollectionView {
    
    func animationSendBtn(section : Int) {
        
            UIView.animate(withDuration: 0.1, animations: {
                
                self.shadowView.frame.origin.x = Screen_W
            }) { (isfinish) in
                
                if section == 0 {
                    self.buttonSetting.alpha = 0
                } else {
                    self.buttonSetting.alpha = 1
                }
                
                UIView.animate(withDuration: 0.1) {
                    self.shadowView.frame.origin.x = Screen_W-kEmoticonAddWidth
                }

            }

        
    }
    
}
