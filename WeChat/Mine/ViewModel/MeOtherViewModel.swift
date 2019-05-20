//
//  MeOtherViewModel.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/15.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class MeOtherViewModel: NSObject,MeProtocol {
    
    var model : MeModel? {
        
        didSet {
            
        }
    }
    
    var cell : MeOtherTableViewCell?
    
    func bindView(view: UIView) {
        
        cell = view as? MeOtherTableViewCell
        setupView()
    }
    
    func setupView()  {
        
        self.cell?.nameLabel.text = model?.name
        
        cell?.imageIcon.image = UIImage(named: (model?.img)!)

        if model?.name == "支付" || model?.name == "表情" || model?.name == "设置" {
            cell?.viewLine.isHidden = true
        } else {
            cell?.viewLine.isHidden = false
        }
    }

}
