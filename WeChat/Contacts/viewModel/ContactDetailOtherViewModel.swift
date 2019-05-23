//
//  ContactDetailOtherViewModel.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/22.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class ContactDetailOtherViewModel: NSObject {
    var model : ContactModel?
    var cell : ContactDetailOtherTableViewCell?
    
    func bindView(view: UIView) {
        
        self.cell = view as? ContactDetailOtherTableViewCell
        setupView()
        
        if self.cell?.indexPath?.row == 0 {

            self.cell?.imageArrow.frame.origin.y = (99-16)/2
            self.cell?.nameLabel.frame.origin.y = (99 - 55)/2
            self.cell?.viewLine.frame.origin.y = 99
            
        }
    }
    
}

extension ContactDetailOtherViewModel {
    
    func setupView()  {
        
        self.cell?.nameLabel.text = model?.name
        
    }
}
