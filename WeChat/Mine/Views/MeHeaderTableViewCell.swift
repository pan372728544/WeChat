//
//  MeHeaderTableViewCell.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/15.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit
import Kingfisher

class MeHeaderTableViewCell: UITableViewCell {

    var imageHead = UIImageView()
    
    var nameLabel = UILabel()
    
    var idLabel = UILabel()
    
    var imgCode = UIImageView()
    var imageArrow = UIImageView()
    
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
        
        
        imageHead.frame = CGRect(x: 30, y: 20+NavaBar_H, width: 60, height: 60)
        contentView.addSubview(imageHead)
        
        nameLabel.frame = CGRect(x: imageHead.right + 20, y: imageHead.top+10, width: 200, height: 24)
        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        contentView.addSubview(nameLabel)
        
        idLabel.frame = CGRect(x: imageHead.right + 20, y: nameLabel.bottom+10 , width: 100, height: 20)
        idLabel.textColor = UIColor.init(r: 127, g: 127, b: 127)
        contentView.addSubview(idLabel)
        
        
        imageArrow.frame = CGRect(x: Screen_W-20-16, y: idLabel.top+3, width: 16, height: 16)
        imageArrow.image = UIImage(named: "PhoneAuth_AccesoryArrow_Normal-1")
        contentView.addSubview(imageArrow)
        
        imgCode.frame = CGRect(x: imageArrow.left - 10 - 20, y: idLabel.top+3, width: 16, height: 16)
        imgCode.image = UIImage(named: "setting_myQR_Normal")
        contentView.addSubview(imgCode)
        
  
    }
}
