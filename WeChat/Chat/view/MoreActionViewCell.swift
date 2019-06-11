//
//  MoreActionViewCell.swift
//  WeChat
//
//  Created by panzhijun on 2019/6/6.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class MoreActionViewCell: UICollectionViewCell {
    
    internal var iconImageView: UIImageView = UIImageView()
    
    internal var label: UILabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var emoticon : MoreAction? {
        
        didSet {
            
            let width : CGFloat = 60
            iconImageView.frame =  CGRect(x: (self.width-width)/2, y: 0, width: width, height: width)
            iconImageView.backgroundColor = UIColor.white
            iconImageView.image = UIImage(named: emoticon!.image)
            
            label.text = emoticon?.text
            label.frame = CGRect(x: 0, y: iconImageView.bottom+5, width: self.width, height: 20)
        }
    }
    
}

extension MoreActionViewCell {
    func setupView()  {
        
        iconImageView.contentMode = .scaleToFill
        iconImageView.layer.cornerRadius = 5
        iconImageView.layer.masksToBounds = true
        self.contentView.addSubview(iconImageView)
        
        label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        self.contentView.addSubview(label)
    }
    

}
