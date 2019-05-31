//
//  ChatGoupListTableViewCell.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/31.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class ChatGoupListTableViewCell: UITableViewCell {

    internal var imgTou: UIImageView = UIImageView()
    
    internal var messageCenter: UIImageView = UIImageView()
    internal var nameLabel : UILabel = UILabel()
    
    internal var contentLabel : UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.backgroundColor = UIColor.clear
        
        // 创建视图
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var textMes : DBChat? {
        didSet {
            
            let url = URL(string: (textMes?.picture)!)
            imgTou.kf.setImage(with: url)

            nameLabel.text = textMes?.recipientName
            contentLabel.text = "\(textMes!.lastMessageName):\(textMes!.lastMessage)"
        }
    }
    
    
}


extension ChatGoupListTableViewCell {
    
    func setupView()  {
        
        imgTou.frame = CGRect(x: 15, y: 15, width: 50, height: 50)
        imgTou.contentMode = .scaleAspectFill
        imgTou.clipsToBounds = true
        self.contentView.addSubview(imgTou)
        
        messageCenter.frame = CGRect(x: imgTou.frame.origin.x+imgTou.frame.size.width-5, y: 12, width: 15, height: 16)
        messageCenter.contentMode = .scaleAspectFill
        messageCenter.image = UIImage(named: "MessageCenter_NewNotify~iphone")
        
        nameLabel.frame = CGRect(x: imgTou.frame.origin.x+imgTou.frame.size.width+10, y: 15, width: Screen_W - 100, height: 20)
        nameLabel.font = UIFont.systemFont(ofSize: 17)
        self.contentView.addSubview(nameLabel)
        
        contentLabel.frame = CGRect(x: imgTou.frame.origin.x+imgTou.frame.size.width+10, y: nameLabel.frame.origin.y+nameLabel.frame.size.height + 10 , width: Screen_W-100, height: 30)
        contentLabel.numberOfLines = 1
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        contentLabel.textColor = UIColor.textNameColor()
        self.contentView.addSubview(contentLabel)
        
    }
    
}

