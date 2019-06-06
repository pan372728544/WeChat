//
//  ChatShareMoreView.swift
//  WeChat
//
//  Created by panzhijun on 2019/6/4.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

private let kLeftRightPadding: CGFloat = 35.0
private let kTopBottomPadding: CGFloat = 30.0
private let kItemCountOfRow: CGFloat = 4
private let kItemCountOfColoum: CGFloat = 2
class ChatShareMoreView: UIView {


    fileprivate var collectionView : UICollectionView!
    
    
    fileprivate let itemDataSouce: [(name: String, iconImage: UIImage)] = [
        ("照片", UIImage(named: "ChatRomm_ToolPanel_Icon_Photo")!),
        ("拍摄", UIImage(named: "ChatRomm_ToolPanel_Icon_Video")!),
        ("视频通话", UIImage(named: "ChatRomm_ToolPanel_Icon_Videovoip")!),
        ("位置", UIImage(named: "ChatRomm_ToolPanel_Icon_Location")!),
        ("红包", UIImage(named: "ChatRomm_ToolPanel_Icon_Luckymoney")!),
        ("转账", UIImage(named: "ChatRomm_ToolPanel_Icon_Pay")!),
        ("语音输入", UIImage(named: "ChatRomm_ToolPanel_Icon_Voiceinput")!),
        ("收藏", UIImage(named: "ChatRomm_ToolPanel_Icon_MyFav")!),
        ("个人名片", UIImage(named: "ChatRomm_ToolPanel_Icon_FriendCard")!),
        ("文件", UIImage(named: "ChatRomm_ToolPanel_Icon_Files")!),
        ("卡券", UIImage(named: "ChatRomm_ToolPanel_Icon_Wallet")!),
        ]
    fileprivate var groupDataSouce = [[(name: String, iconImage: UIImage)]]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var array : [(name: String, iconImage: UIImage)] = [(name: String, iconImage: UIImage)]()
        
        for i in 0..<8 {
            array.append(itemDataSouce[i])
        }
        self.groupDataSouce.append(array)
        
        var array2 : [(name: String, iconImage: UIImage)] = [(name: String, iconImage: UIImage)]()
        for i in 8..<itemDataSouce.count {
            array2.append(itemDataSouce[i])
        }
        self.groupDataSouce.append(array2)
        setupMainView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension ChatShareMoreView {
    
    func setupMainView()  {
        
        
//        let layout = FullyHorizontalFlowLayout()
//        layout.minimumLineSpacing = 8
//        layout.minimumInteritemSpacing = 0
//        layout.sectionInset = UIEdgeInsets(
//           top: kTopBottomPadding,
//           left: kLeftRightPadding,
//           bottom: kTopBottomPadding,
//           right: kLeftRightPadding
//        )
//        //Calculate the UICollectionViewCell size
//        let itemSizeWidth = (Screen_W - kLeftRightPadding*2 - layout.minimumLineSpacing*(kItemCountOfRow - 1)) / kItemCountOfRow
//        let itemSizeHeight = (100 - kTopBottomPadding*2)/2
//        layout.itemSize = CGSize(width: itemSizeWidth, height: itemSizeHeight)
//
//
//        collectionView = UICollectionView.init(frame: CGRect(x:0, y:0, width:Screen_W, height:197), collectionViewLayout: layout)
//        collectionView?.backgroundColor = UIColor.white
//        collectionView?.delegate = self as! UICollectionViewDelegate
//        collectionView?.dataSource = self as! UICollectionViewDataSource
//        self.addSubview(collectionView!)
//        collectionView.isPagingEnabled = true
//
//        collectionView.register(ChatShareMoreCollectionViewCell.self, forCellWithReuseIdentifier: "ChatShareMoreCollectionViewCell")
        
        
        // 初始化
//        let layout = UICollectionViewFlowLayout.init()
let layout = FullyHorizontalFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        
        let itemSizeWidth = (Screen_W - kLeftRightPadding*2 - layout.minimumLineSpacing*(kItemCountOfRow - 1)) / kItemCountOfRow
        let itemSizeHeight = (300 - kTopBottomPadding*2-layout.minimumInteritemSpacing)/2
        
        layout.itemSize = CGSize(width: 100, height: itemSizeHeight)
        
        
        
        collectionView = UICollectionView.init(frame: CGRect(x:0, y:0, width:Screen_W, height:300), collectionViewLayout: layout)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView.isPagingEnabled = true
        self.addSubview(collectionView!)
        collectionView.register(ChatShareMoreCollectionViewCell.self, forCellWithReuseIdentifier: "ChatShareMoreCollectionViewCell")
    }
    
    
}

extension ChatShareMoreView: UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.groupDataSouce.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let subArray = self.groupDataSouce[section]
        return subArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatShareMoreCollectionViewCell", for: indexPath)
        
        cell.backgroundColor = UIColor.randomColor()
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
