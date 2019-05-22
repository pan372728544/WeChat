//
//  ContactsTableViewCell.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/16.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {
    var imageIcon = UIImageView()
    
    var nameLabel = UILabel()
    var indexPath = IndexPath()
    
    var viewLine = UIView()
    
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
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView()  {
        
        
        imageIcon.frame = CGRect(x: 15, y: (ContactCellH-45)/2, width: 45, height: 45)
        imageIcon.layer.cornerRadius = 5
        imageIcon.layer.masksToBounds = true
        contentView.addSubview(imageIcon)
        
        nameLabel.frame = CGRect(x: imageIcon.right + 20, y: 0, width: 200, height: ContactCellH)
        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont.systemFont(ofSize: 17)
        contentView.addSubview(nameLabel)
        
        
        
        viewLine.frame = CGRect(x: imageIcon.right+20, y: ContactCellH-1, width: Screen_W-imageIcon.right-20, height: 1/UIScreen.main.scale)
        viewLine.backgroundColor = UIColor.Gray213Color()
        contentView.addSubview(viewLine)
        
    }

}

