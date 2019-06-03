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
    internal var timeLabel : UILabel = UILabel()
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
            contentLabel.text = "\(textMes!.lastMessage)"
            
            
            let dataFormatter = DateFormatter()
            dataFormatter.dateFormat = "HH:mm"
            
            let data = Date(timeIntervalSince1970: TimeInterval((textMes?.lastMessageDate)!))
            let customDate = dataFormatter.string(from: data)
            timeLabel.text = customDate
        }
    }
    
    
}


extension ChatGoupListTableViewCell {
    
    func setupView()  {
        
        imgTou.frame = CGRect(x: 15, y: 15, width: 45, height: 45)
        imgTou.contentMode = .scaleAspectFill
        imgTou.layer.masksToBounds = true
        imgTou.layer.cornerRadius = 5
        imgTou.clipsToBounds = true
        self.contentView.addSubview(imgTou)
        
        messageCenter.frame = CGRect(x: imgTou.frame.origin.x+imgTou.frame.size.width-5, y: 12, width: 15, height: 16)
        messageCenter.contentMode = .scaleAspectFill
        messageCenter.image = UIImage(named: "MessageCenter_NewNotify~iphone")
        
        nameLabel.frame = CGRect(x: imgTou.right + 10, y: 15, width: Screen_W - 100, height: 20)
        nameLabel.font = UIFont.systemFont(ofSize: 17)
        self.contentView.addSubview(nameLabel)
        
        contentLabel.frame = CGRect(x: imgTou.right + 10, y:nameLabel.bottom + 8 , width: Screen_W-100, height: 15)
        contentLabel.numberOfLines = 1
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.textColor = UIColor.init(r: 115, g: 115, b: 115)
        self.contentView.addSubview(contentLabel)
        
        
        let viewH = 1/UIScreen.main.scale
        let viewLine1 = UIView(frame: CGRect(x: imgTou.right + 10, y: 72-viewH, width: Screen_W-imgTou.right - 10, height: viewH))
        viewLine1.backgroundColor = UIColor.Gray213Color()
        self.contentView.addSubview(viewLine1)
        
        timeLabel.frame = CGRect(x: Screen_W-100-15, y:15 , width: 100, height: 15)
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        timeLabel.textColor = UIColor.init(r: 115, g: 115, b: 115)
        timeLabel.textAlignment = .right
        self.contentView.addSubview(timeLabel)

        
    }
    
}

