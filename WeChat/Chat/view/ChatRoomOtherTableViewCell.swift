//
//  ChatRoomOtherTableViewCell.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/30.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class ChatRoomOtherTableViewCell: UITableViewCell {

    
    internal var timeLabel : UILabel = UILabel()
    // 头像
    internal var imgTou: UIImageView = UIImageView()
    internal var nameLabel : UILabel = UILabel()
    internal var contentLabel : UILabel = UILabel()
    
    // 气泡
    internal var imgPao: UIImageView = UIImageView()
    
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
    
    var textMes : DBMessage? {
        didSet {
            
            timeLabel.isHidden = true
            if textMes?.updatedAt != 0 {
                let currentData = Date()
                let dataFormatter = DateFormatter()
                dataFormatter.dateFormat = "YYYY-MM-dd HH:mm"
                let customDate = dataFormatter.string(from: currentData)
                
                timeLabel.text = customDate
                
                timeLabel.isHidden = false
            }
            
            let url = URL(string: (textMes?.recipientPicture)!)

            imgTou.kf.setImage(with: url)
            imgTou.frame.origin.y = textMes?.updatedAt != 0 ? 15+40 : 15
            
            nameLabel.text = textMes?.recipientName
            nameLabel.frame.origin.y = imgTou.frame.origin.y
            contentLabel.text = textMes?.text
    
            let widthCell = IMDataManager.share.getChatTextSize(text: (textMes?.text)!).width
            
            let heightCell = IMDataManager.share.getChatTextSize(text: (textMes?.text)!).height
            contentLabel.frame.size.height = heightCell
            contentLabel.frame.size.width = widthCell

            contentLabel.frame = CGRect(x: 15 + 40 + 10 + 10 - 2, y: imgTou.frame.origin.y+10+1.5, width: widthCell, height: heightCell)
            
            let oriImg = UIImage.init(named: "ChatRoom_Bubble_Text_Receiver_White")
            
            let edgeInsets = UIEdgeInsets(top: oriImg!.size.height*0.7, left: oriImg!.size.width*0.3, bottom: oriImg!.size.height*0.29, right: oriImg!.size.width*0.3)
            
            
            let resiImg = oriImg!.resizableImage(withCapInsets: edgeInsets, resizingMode: UIImage.ResizingMode.stretch)
            // 计算图片尺寸
            imgPao.frame = CGRect(x: 15 + 40 + 5  , y: imgTou.frame.origin.y , width: widthCell + 25, height: heightCell + 25)
            imgPao.image = resiImg
            
            
            contentLabel.frame.size.height = heightCell
        }
    }
    
    
}


extension ChatRoomOtherTableViewCell {
    
    func setupView()  {
        
        timeLabel.frame = CGRect(x: 0, y: 10, width: Screen_W, height: 40)
        timeLabel.textAlignment = NSTextAlignment.center
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        timeLabel.textColor = UIColor.textNameColor()
        self.contentView.addSubview(timeLabel)
        
        imgTou.frame = CGRect(x: 15, y: 15, width: 40, height: 40)
        imgTou.contentMode = .scaleAspectFill
        imgTou.clipsToBounds = true
        self.contentView.addSubview(imgTou)
        
        nameLabel.frame = CGRect(x: imgTou.frame.origin.x+imgTou.frame.size.width+10, y: 15, width: Screen_W - 100, height: 20)
        nameLabel.font = UIFont.systemFont(ofSize: 12)
        nameLabel.textColor = UIColor.textNameColor()
        nameLabel.isHidden = true
        self.contentView.addSubview(nameLabel)
        
        
        imgPao.frame =  CGRect(x: 0, y: 0, width: 0, height: 0)
        self.contentView.addSubview(imgPao)
        
        
        contentLabel.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 16)
        self.contentView.addSubview(contentLabel)
        
    }
    
    
    
}