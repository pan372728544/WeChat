//
//  ContactDetailHeaderViewModel.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/22.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class ContactDetailHeaderViewModel: NSObject {
    var dbUser : DBUser?
    var model : ContactModel?
        var cell : ContactDetailTableViewCell?

    func bindView(view: UIView) {
        
        self.cell = view as? ContactDetailTableViewCell
        setupView()
    }

}

extension ContactDetailHeaderViewModel {
    
    func setupView()  {
        
        self.cell?.nameLabel.text = model?.name
        self.cell?.viewLine.frame.origin.y = 130+NavaBar_H - MeCellH
        self.cell?.imageArrow.frame.origin.y = 130+NavaBar_H - MeCellH + (MeCellH-16)/2
        self.cell?.nameLabel.frame.origin.y = 130+NavaBar_H - MeCellH
        
        
        cell?.lbelNike.text = dbUser?.name
        cell?.lbelNike.sizeToFit()

        cell?.lbelId.text = "微信号:  \(String(describing: dbUser!.objectId))"
        cell?.lbelId.sizeToFit()
        
        cell?.lbelCity.text = "地区:  \(String(describing: dbUser!.country))"
        cell?.lbelCity.sizeToFit()
        
        let url = URL(string: (dbUser?.picture)!)
        
        cell?.imagePhoto.kf.setImage(with: url)
    }
}
