//
//  EmoticonView.swift
//  WeChat
//
//  Created by panzhijun on 2019/6/5.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

private let kEmoticonCellID = "kEmoticonCellID"

class EmoticonView: UIView {
    
    var emoticonClickCallback : ((Emoticon) -> Void)?
    
    var emoticonClickSend : (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension EmoticonView {
    fileprivate func setupUI() {
        // 1.创建PageCollectionView
        let style = TitleStyle()
        style.isScrollEnable = true
        style.selectedColor =  UIColor(red: 237/255.0, green: 237/255.0, blue: 237/255.0, alpha: 0.6)
//        style.selectedColor = UIColor.clear
        style.normalColor = UIColor.init(r: 255, g: 255, b: 255)
        let layout = PageCollectionViewLayout()
        layout.cols = 8
        layout.rows = 3
        layout.minimumLineSpacing = 13
        layout.minimumInteritemSpacing = 13
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let pageCollectionView = PageCollectionView(frame: bounds, titles: ["Add_emoticon_icon_nor","alibg"], style: style, isTitleInTop: false, layout: layout)
        
        pageCollectionView.backgroundColor = UIColor.Gray237Color()
        
        // 2.将pageCollectionView添加到view中
        addSubview(pageCollectionView)
        
        // 3.设置pageCollectionView的属性
        pageCollectionView.dataSource = self
        pageCollectionView.delegate = self

        pageCollectionView.register(cell: EmoticonViewCell.self, identifier: kEmoticonCellID)
        
    }
}


extension EmoticonView : PageCollectionViewDataSource {
    func numberOfSections(in pageCollectionView: PageCollectionView) -> Int {
        return EmoticonViewModel.share.packages.count
    }
    
    func pageCollectionView(_ collectionView: PageCollectionView, numberOfItemsInSection section: Int) -> Int {
        return EmoticonViewModel.share.packages[section].emoticons.count

    }
    
    func pageCollectionView(_ pageCollectionView: PageCollectionView, _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kEmoticonCellID, for: indexPath) as! EmoticonViewCell
        cell.emoticon = EmoticonViewModel.share.packages[indexPath.section].emoticons[indexPath.item]

        return cell
    }
}


extension EmoticonView : PageCollectionViewDelegate {
    func pageCollectionView(_ pageCollectionView: PageCollectionView, didSelectItemAt indexPath: IndexPath) {
        let emoticon = EmoticonViewModel.share.packages[indexPath.section].emoticons[indexPath.item]
        if let emoticonClickCallback = emoticonClickCallback {
            emoticonClickCallback(emoticon)
        }
    }
    
    func pageCollectionViewDidClickSend() {
        // 点击了发送按钮
        emoticonClickSend!()
    }
}
