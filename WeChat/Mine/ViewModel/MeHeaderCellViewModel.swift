//
//  MeHeaderCellViewModel.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/15.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit
import RealmSwift

class MeHeaderCellViewModel: NSObject,MeProtocol{
    

    var cell : MeHeaderTableViewCell?
    
    var dbUser : DBUser? {
        
        didSet {
            

        }
        
    }
    override init() {
        
        super.init()
    }
    
    func bindView(view: UIView) {
        
        self.cell = view as? MeHeaderTableViewCell
        setupView()
    }


}

extension MeHeaderCellViewModel {
    
    func setupView()  {
        
        self.cell?.nameLabel.text = dbUser?.name
        cell?.idLabel.text = "微信号:  \(String(describing: dbUser!.objectId))"
        cell?.idLabel.sizeToFit()
        let url = URL(string: (dbUser?.picture)!)
        
        cell?.imageHead.kf.setImage(with: url)

    }
}


