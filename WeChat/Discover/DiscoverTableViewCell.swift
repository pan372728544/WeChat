//
//  DiscoverTableViewCell.swift
//  WeChat
//
//  Created by panzhijun on 2019/6/18.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class DiscoverTableViewCell: UITableViewCell {
    public var imageIcon = UIImageView()
    
   public var nameLabel = UILabel()
    
    var imageArrow = UIImageView()
    
    public var indexPath : IndexPath = IndexPath(item: 0, section: 0) {
        
        didSet {
            if (indexPath.section == 1 ||  indexPath.section == 4) && indexPath.row == 0 {
                viewLine.isHidden = false
            }
        }
    }
    
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
        
        
        imageIcon.frame = CGRect(x: 15, y: (MeCellH-25)/2, width: 25, height: 25)
        contentView.addSubview(imageIcon)
        
        nameLabel.frame = CGRect(x: imageIcon.right + 20, y: 0, width: 200, height: 55)
        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont.systemFont(ofSize: 17)
        contentView.addSubview(nameLabel)
        
        
        
        imageArrow.frame = CGRect(x: Screen_W-20-16, y: (MeCellH-16)/2, width: 16, height: 16)
        imageArrow.image = UIImage(named: "PhoneAuth_AccesoryArrow_Normal-1")
        contentView.addSubview(imageArrow)
        
        
        viewLine.frame = CGRect(x: imageIcon.right+20, y: MeCellH, width: Screen_W-imageIcon.right-20, height: 1/UIScreen.main.scale)
        viewLine.backgroundColor = UIColor.Gray213Color()
        viewLine.isHidden = true
        contentView.addSubview(viewLine)
        
    }
}
