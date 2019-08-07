//
//  MiniCollectionViewCell.swift
//  WeChat
//
//  Created by panzhijun on 2019/8/7.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class MiniCollectionViewCell: UICollectionViewCell {
    
    var imageHead = UIImageView()
    
    var nameLabel = UILabel()
    
    var model : MeModel? {
        
        didSet {
            imageHead.image = UIImage(named: model!.img)
            nameLabel.text = model?.name
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView()  {
        
        
        imageHead.layer.cornerRadius = 5
        imageHead.layer.masksToBounds = true
        imageHead.image = UIImage(named: "tabbar_discoverHL_Normal")
        contentView.addSubview(imageHead)
        
        
        nameLabel.textColor = UIColor.white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        nameLabel.text = "小程序名字"
        nameLabel.textAlignment = .center
        contentView.addSubview(nameLabel)
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageHead.frame = CGRect(x: (self.width-45)/2, y: (self.height - 45)/2, width: 45, height: 45)
        nameLabel.frame = CGRect(x: 0, y: imageHead.bottom+10, width: 80, height: 20)
    }
}
