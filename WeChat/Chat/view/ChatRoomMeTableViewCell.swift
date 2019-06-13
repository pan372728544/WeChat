//
//  ChatRoomMeTableViewCell.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/30.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class ChatRoomMeTableViewCell: UITableViewCell {

    
    internal var timeLabel : UILabel = UILabel()
    
    internal var imgTou: UIImageView = UIImageView()
    
    internal var nameLabel : UILabel = UILabel()
    
    internal var contentLabel : UILabel = UILabel()
    
    // 气泡
    internal var imgPao: UIImageView = UIImageView()
    
    // 发送失败图片
    internal var imgFaild: UIImageView = UIImageView()
    
    
    // 图片
    internal var imageContent: UIImageView = UIImageView()
    
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

                let dataFormatter = DateFormatter()
                dataFormatter.dateFormat = "YYYY-MM-dd HH:mm"

                let data = Date(timeIntervalSince1970: TimeInterval((textMes?.updatedAt)!))
                let customDate = dataFormatter.string(from: data)
                timeLabel.text = customDate
                
                timeLabel.isHidden = false
            }

            let url  = URL(string: (textMes?.senderPicture)!)!
            imgTou.kf.setImage(with: url)
            imgTou.frame.origin.y = textMes?.updatedAt != 0 ? 15+40 : 15
            
            nameLabel.text = textMes?.senderName
            nameLabel.frame.origin.y = imgTou.frame.origin.y
            
            contentLabel.attributedText = AttrStringGenerator.generateEmoticon((textMes?.text)!)
            
            let widthCell = IMDataManager.share.getChatTextSize(text: AttrStringGenerator.generateEmoticon((textMes?.text)!)).width
            
            let heightCell = IMDataManager.share.getChatTextSize(text: AttrStringGenerator.generateEmoticon((textMes?.text)!)).height

            contentLabel.frame = CGRect(x: Screen_W-15-40-10-widthCell-10+4, y: imgTou.frame.origin.y+10+1.5 , width: widthCell, height: heightCell)

            contentLabel.textAlignment = .left

            
            let oriImg = UIImage.init(named: "ChatRoom_Bubble_Text_Sender_Green")
            
            let edgeInsets = UIEdgeInsets(top: oriImg!.size.height*0.7, left: oriImg!.size.width*0.3, bottom: oriImg!.size.height*0.29, right: oriImg!.size.width*0.3)
            
            
            let resiImg = oriImg!.resizableImage(withCapInsets: edgeInsets, resizingMode: UIImage.ResizingMode.stretch)
            // 计算图片尺寸
            imgPao.frame = CGRect(x: Screen_W-15-40-10-widthCell - 18  , y: imgTou.frame.origin.y , width: widthCell + 25, height: heightCell + 22)
            imgPao.image = resiImg
            
            if  heightCell > 20 {
                contentLabel.textAlignment = NSTextAlignment.left
            } else {
                contentLabel.textAlignment = NSTextAlignment.right
            }
            
            imgFaild.frame = CGRect(x: imgPao.frame.origin.x-25, y: imgPao.centerY-12, width: 20, height: 20)
            imgFaild.isHidden = textMes?.status == "true"
            
            
            if textMes?.type == "picture" {
                imgPao.isHidden = true
                contentLabel.isHidden = true
                imageContent.isHidden = false
                
                
                let image = UIImage(data: (textMes?.picture)!)
                
                var w : CGFloat = (image?.size.width)!
                var h : CGFloat  =  (image?.size.height)!
                
                if w >= 180 {
                    
                    h = 180*h/w
                    w = 180
                }
                
                imageContent.frame = CGRect(x: Screen_W-15-40-10-w-10+4, y: imgTou.frame.origin.y , width: w, height: h)
                
                
                // 检查图片类型
                let type  =   textMes?.picture!.kf.imageFormat
                
                if type == .GIF {
                    // 加载Gif图片, 并且转成Data类型,"my.gif就是gif图片"
                    //                guard let path = Bundle.main.path(forResource: "ali_5.gif", ofType: nil) else { return }
                    //                guard let data = NSData(contentsOfFile: path) else { return }
                    
                    // 从data中读取数据: 将data转成CGImageSource对象
                    guard let imageSource = CGImageSourceCreateWithData(textMes?.picture! as! CFData, nil) else { return }
                    let imageCount = CGImageSourceGetCount(imageSource)
                    
                    // 便利所有的图片
                    var images = [UIImage]()
                    var totalDuration : TimeInterval = 0
                    for i in 0..<imageCount {
                        // .取出图片
                        guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else { continue }
                        let image = UIImage(cgImage: cgImage)
                        if i == 0 {
                            imageContent.image = image
                        }
                        images.append(image)
                        
                        // 取出持续的时间
                        guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) else { continue }
                        guard let gifDict = (properties as NSDictionary)[kCGImagePropertyGIFDictionary] as? NSDictionary else { continue }
                        guard let frameDuration = gifDict[kCGImagePropertyGIFDelayTime] as? NSNumber else { continue }
                        totalDuration += frameDuration.doubleValue
                    }
                    
                    // 设置imageView的属性
                    imageContent.animationImages = images
                    imageContent.animationDuration = totalDuration
                    imageContent.animationRepeatCount = 0
                    
                    imageContent.startAnimating()
                    
                } else {
                    imageContent.image = image
                }
                
                
                

                
            } else {
                imgPao.isHidden = false
                contentLabel.isHidden = false
                imageContent.isHidden = true
            }
            
            
            
        }
        
    }
    
    var isSuccess: Bool?  {
        didSet {
            imgFaild.frame = CGRect(x: imgPao.frame.origin.x-15, y: imgPao.frame.origin.y + 4, width: 20, height: 20)
            
            imgFaild.isHidden = isSuccess!
        }
    }
    
    
}


extension ChatRoomMeTableViewCell {
    
    func setupView()  {
        timeLabel.frame = CGRect(x: 0, y: 10, width: Screen_W, height: 40)
        timeLabel.textAlignment = NSTextAlignment.center
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        timeLabel.textColor = UIColor.textNameColor()
        self.contentView.addSubview(timeLabel)
        imgTou.frame = CGRect(x: Screen_W - 15 - 40, y: 15 , width: 40, height: 40)
        imgTou.contentMode = .scaleAspectFill
        imgTou.clipsToBounds = true
        self.contentView.addSubview(imgTou)
        
        
        
        nameLabel.frame = CGRect(x: imgTou.frame.origin.x - 10 - Screen_W + 100, y: 15, width: Screen_W - 100, height: 20)
        nameLabel.font = UIFont.systemFont(ofSize: 12)
        nameLabel.textColor = UIColor.textNameColor()
        nameLabel.textAlignment = NSTextAlignment.right
        nameLabel.isHidden = true
        self.contentView.addSubview(nameLabel)
        
        
        imgPao.frame =  CGRect(x: 0, y: 0, width: 0, height: 0)
        self.contentView.addSubview(imgPao)
        
        imgFaild.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        imgFaild.image = UIImage.init(named: "MessageSendFail")
        imgFaild.isHidden = true
        self.contentView.addSubview(imgFaild)
        
        contentLabel.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 16)
        self.contentView.addSubview(contentLabel)
        
        
        imageContent.frame =  CGRect(x: 0, y: 0, width: 0, height: 0)
        imageContent.contentMode = .scaleToFill
        self.contentView.addSubview(imageContent)
        
        
    }
    
    
    
}


