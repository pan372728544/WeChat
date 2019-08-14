//
//  MiniTableViewCell.swift
//  WeChat
//
//  Created by panzhijun on 2019/8/7.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class MiniTableViewCell: UITableViewCell,UICollectionViewDataSource, UICollectionViewDelegate {

     var collectionView : UICollectionView?
    
    var array = [MeModel]()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView()  {
        
        // 初始化
        let layout = UICollectionViewFlowLayout.init()
        
        layout.itemSize = CGSize(width: 80, height: 100)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView.init(frame: CGRect(x:0, y:0, width:Screen_W, height:100), collectionViewLayout: layout)
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.showsHorizontalScrollIndicator = false
        self.addSubview(collectionView!)
        
        // 注册cell
        collectionView?.register(MiniCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        let me1 = MeModel()
        me1.img = "MoreMyFavorites_Normal"
        me1.name = "小程序1"
        
        let me2 = MeModel()
        me2.img = "add_friend_icon_offical_Normal"
        me2.name = "小程序2"
        
        let me3 = MeModel()
        me3.img = "AlbumReflashIcon"
        me3.name = "小程序3"
        
        
        array.append(me1)
        array.append(me2)
        array.append(me3)
        array.append(me1)
        array.append(me2)
        array.append(me3)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
      
    }
    


    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MiniCollectionViewCell
        cell.backgroundColor = UIColor.clear
        cell.model = array[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    
}

