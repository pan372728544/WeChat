//
//  MoreActionView.swift
//  WeChat
//
//  Created by panzhijun on 2019/6/6.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

private let kMoreActionCellID = "kMoreActionCellID"

class MoreActionView: UIView {
    
    var moreActionClickCallback : ((MoreAction) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension MoreActionView {
    fileprivate func setupUI() {
        // 1.创建PageCollectionView
        let style = TitleStyle()
        style.type = .moreAction
        style.titleHeight = 0
        style.rows = 2
        style.cols = 4
        let layout = PageCollectionViewLayout()
//        layout.cols = 4
//        layout.rows = 2
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        let pageCollectionView = PageCollectionView(frame: bounds, titles: [""], style: style, isTitleInTop: false, layout: layout)
        
        pageCollectionView.backgroundColor = UIColor.Gray237Color()
        
        // 2.将pageCollectionView添加到view中
        addSubview(pageCollectionView)
        
        // 3.设置pageCollectionView的属性
        pageCollectionView.dataSource = self
        pageCollectionView.delegate = self
        
        pageCollectionView.register(cell: MoreActionViewCell.self, identifier: kMoreActionCellID)
        
    }
}


extension MoreActionView : PageCollectionViewDataSource {
    func numberOfSections(in pageCollectionView: PageCollectionView) -> Int {
        return MoreViewModel.share.packages.count
    }
    
    func pageCollectionView(_ collectionView: PageCollectionView, numberOfItemsInSection section: Int) -> Int {
        return MoreViewModel.share.packages[section].moreActions.count
        
    }
    
    func pageCollectionView(_ pageCollectionView: PageCollectionView, _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kMoreActionCellID, for: indexPath) as! MoreActionViewCell
        cell.emoticon = MoreViewModel.share.packages[indexPath.section].moreActions[indexPath.item]

        return cell
    }
}


extension MoreActionView : PageCollectionViewDelegate {
    func pageCollectionViewDidClickSend() {
        
    }
    
    func pageCollectionView(_ pageCollectionView: PageCollectionView, didSelectItemAt indexPath: IndexPath) {
        let moreAction = MoreViewModel.share.packages[indexPath.section].moreActions[indexPath.item]
        if let moreActionClickCallback = moreActionClickCallback {
            moreActionClickCallback(moreAction)
        }
    }
}
