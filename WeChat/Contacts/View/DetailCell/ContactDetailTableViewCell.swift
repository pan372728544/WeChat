//
//  ContactDetailTableViewCell.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/22.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class ContactDetailTableViewCell: ContactBaseTableViewCell {


    var imagePhoto = UIImageView()
    
    var imageGender = UIImageView()
    var lbelNike = UILabel()
    var lbelId = UILabel()
    var lbelCity = UILabel()

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
        
        
        imagePhoto.frame = CGRect(x: 20, y: 15, width: 70, height: 70)
        imagePhoto.layer.masksToBounds = true
        imagePhoto.layer.cornerRadius = 10
        contentView.addSubview(imagePhoto)

        
        lbelNike.frame = CGRect(x:  imagePhoto.right + 10, y: 15, width: 200, height: 30)
        lbelNike.textColor = UIColor.black
        lbelNike.font = UIFont.boldSystemFont(ofSize: 23)
        contentView.addSubview(lbelNike)
        
        
        imageGender.frame = CGRect(x: lbelNike.right + 10, y: lbelNike.top+4, width: 20, height: 20)

        contentView.addSubview(imageGender)
        
        lbelId.frame = CGRect(x:  imagePhoto.right + 10, y: lbelNike.bottom + 8, width: 200, height: 20)
        lbelId.textColor = UIColor.textNameColor()
        lbelId.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(lbelId)
        
        lbelCity.frame = CGRect(x:  imagePhoto.right + 10, y: lbelId.bottom + 5, width: 200, height: 20)
        lbelCity.textColor = UIColor.textNameColor()
        lbelCity.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(lbelCity)
        
     
        
    }
    
    
}
