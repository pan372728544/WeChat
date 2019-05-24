//
//  ContactDetailVideoTableViewCell.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/22.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class ContactDetailVideoTableViewCell: ContactBaseTableViewCell {
    
    var imagePhoto = UIImageView()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupMainView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupMainView()  {
        
        imagePhoto.frame = CGRect(x: 15, y: (MeCellH-25)/2, width: 25, height: 25)
        contentView.addSubview(imagePhoto)
        
    }
}
