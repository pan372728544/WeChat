//
//  IndicatorView.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/17.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class IndicatorView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.indicatorImgV)
        self.addSubview(self.titleLabel)

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate lazy var indicatorImgV : UIImageView = {
        var indicatorImgV = UIImageView(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height ))
        indicatorImgV.image = UIImage(named: "ContactIndexShape_Normal")

//        indicatorImgV.transform = CGAffineTransform(rotationAngle: CGFloat(-90*Double.pi/180))

        return indicatorImgV
        
        
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let titleLabel = UILabel(frame: CGRect(x: -3, y: 0, width: self.width, height: self.height ))
        titleLabel.font = UIFont.boldSystemFont(ofSize: 35)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = NSTextAlignment.center
        return titleLabel
        
    }()
    func setOrigin(origin: CGPoint,title: String)  {
        
        self.setCt_x(x: origin.x-self.width)
        self.setCt_centerY(centerY: origin.y)
        self.titleLabel.text = title
    }
    
    
    
    func setCt_x(x: CGFloat)  {
       self.frame = CGRect(x: x, y: self.frame.origin.y, width: self.width, height: self.height)
    }
    
    func setCt_centerY(centerY: CGFloat)  {
        var center = self.center
        center.y = centerY
        self.center = center
    }
    
}
