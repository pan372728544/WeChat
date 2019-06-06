//
//  EmoticonViewCell.swift
//  WeChat
//
//  Created by panzhijun on 2019/6/5.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class EmoticonViewCell: UICollectionViewCell {
    
    
    internal var iconImageView: UIImageView = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var emoticon : Emoticon? {

        didSet {
            
            let width = min(self.width, self.height)
            
            
            iconImageView.frame =  CGRect(x: (self.width-width)/2, y: (self.height-width)/2, width: width, height: width)
            var file = Bundle.main.path(forResource: "\(emoticon!.image)@2x", ofType: "png")
        
            if file == nil {
                // 其他表情
                file = Bundle.main.path(forResource: "\(emoticon!.image)", ofType: "gif")
            }

            iconImageView.image = UIImage(contentsOfFile: file!)
        }
    }
    
}

extension EmoticonViewCell {
    func setupView()  {
        
    
//        iconImageView.backgroundColor = UIColor.white
        iconImageView.contentMode = .scaleToFill
        self.contentView.addSubview(iconImageView)
    }
    
    
    func asyncImageName(name: String,finshBlock : @escaping (UIImage) -> ()) {
        
        DispatchQueue.global().async {
          
            let image = UIImage(named: name)
            
            DispatchQueue.main.async {
              
                finshBlock(image!)
            }
            
        }
    }
}
