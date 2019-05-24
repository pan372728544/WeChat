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
        
        self.cell?.nameLabel.sizeToFit()
        self.cell?.nameLabel.frame.origin.x = (Screen_W-(cell?.nameLabel.width)!)/2
        self.cell?.nameLabel.frame.origin.y = (MeCellH-(cell?.nameLabel.height)!)/2
        self.cell?.nameLabel.textColor = UIColor.init(r: 112, g: 129, b: 165)
        cell?.nameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        self.cell?.imagePhoto.left = (self.cell?.nameLabel.left)! - 25 - 5
        if cell?.indexPath?.row == 0 {
            self.cell?.imagePhoto.image = UIImage.init(named: "AlbumCommentSingleAHL")
        } else {
            self.cell?.imagePhoto.image = UIImage.init(named: "AlbumInformationLikeHL")
        }

        self.cell?.imageArrow.isHidden = true
        self.cell?.viewLine.frame = CGRect(x: 0, y: MeCellH, width: Screen_W, height: 1/UIScreen.main.scale)
    }
}
