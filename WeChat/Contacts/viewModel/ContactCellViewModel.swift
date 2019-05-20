//
//  ContactCellViewModel.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/16.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit
import Kingfisher

class ContactCellViewModel: NSObject,MeProtocol {
    var cell : ContactsTableViewCell?

    var dbFriend : DBFriend? {
        didSet {

        }
        
    }
    
    func bindView(view: UIView) {
        
        cell = view as? ContactsTableViewCell
        setupView()
    }
    func bingData(data: Any) {
        
        let data : [ContactCellViewModel] = data as! [ContactCellViewModel]
        
        if data.count == (self.cell?.indexPath.row)!+1 {
            self.cell?.viewLine.isHidden = true
        } else {
            
            if self.cell?.indexPath.section == 0 && self.cell?.indexPath.row == 0 {
                self.cell?.viewLine.isHidden = true
            } else {
                self.cell?.viewLine.isHidden = false
            }
        }
        
    }
}

extension ContactCellViewModel {
    
    func setupView()  {
        self.cell?.searchBar.isHidden = true
        self.cell?.backgroundColor = UIColor.white
        self.cell?.nameLabel.text = dbFriend?.name
        let url = URL(string: (dbFriend?.picture)!)
        if self.cell?.indexPath.section == 0 {
            self.cell?.imageIcon.image = UIImage(named: (dbFriend?.picture)!)
            if self.cell?.indexPath.row == 0 {
                self.cell?.searchBar.isHidden = false
                self.cell?.backgroundColor = UIColor.Gray237Color()
                
            } else {
                self.cell?.searchBar.isHidden = true
            }
        } else {
            
            self.cell?.imageIcon.kf.setImage(with: url)
        }
        
    }
}
