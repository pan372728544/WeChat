//
//  ContactDetailVideoViewModel.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/22.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class ContactDetailVideoViewModel: NSObject {
    var model : ContactModel?
    var cell : ContactDetailVideoTableViewCell?
 
    func bindView(view: UIView) {
        
        self.cell = view as? ContactDetailVideoTableViewCell
        setupView()
    }
    
}

extension ContactDetailVideoViewModel {
    
    func setupView()  {
        
        self.cell?.nameLabel.text = model?.name
        
        
        self.cell?.nameLabel.frame.origin.x = (Screen_W-200)/2
        self.cell?.nameLabel.textAlignment = .center
        self.cell?.nameLabel.textColor = UIColor.init(r: 65, g: 105, b: 225)
        self.cell?.imageArrow.isHidden = true
        self.cell?.viewLine.frame = CGRect(x: 0, y: MeCellH, width: Screen_W, height: 1/UIScreen.main.scale)
    }
}
