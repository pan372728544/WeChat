//
//  SearchTableViewCell.swift
//  WeChat
//
//  Created by panzhijun on 2019/8/7.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {


    internal var searchLabel : UILabel = UILabel()
    
    var array : [String] = [String]()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.backgroundColor = UIColor.clear
        
        array = ["朋友圈","文章","公众号","小程序","音乐","表情"]
        // 创建视图
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
}


extension SearchTableViewCell {
    
    func setupView()  {
        
      
        
        searchLabel.frame = CGRect(x: 0, y: 30, width: Screen_W , height: 20)
        searchLabel.font = UIFont.systemFont(ofSize: 14)
        searchLabel.textAlignment = .center
        searchLabel.text = "搜索指定内容"
        searchLabel.textColor = UIColor(r: 177, g: 177, b: 177)
        self.contentView.addSubview(searchLabel)
        

        //每行显示三个
        let imgCount: CGFloat = 3.0
        //每个图片宽度
        let imageW : CGFloat = 100
        //每个图片宽度
        let imageH : CGFloat = 30
        //间隙
        let padding: CGFloat = 5
        //循环9次
        for index in 0..<array.count{
            //求余,用于X轴索引(每一行达到3的整数时,求余就是零)
            let yu =  CGFloat(index).truncatingRemainder(dividingBy: imgCount)
            //X轴坐标
            let X = yu * (imageW + padding) + (Screen_W - imgCount*imageW - 10)/2
            //y轴坐标(索引除以每行的个数,得到每行的y轴坐标)
            let Y = CGFloat( index / Int(imgCount)) * (imageH + padding) + searchLabel.bottom + 20
            let btn = UIButton.init(frame: CGRect(x: X, y: Y, width: imageW, height: imageH))
            btn.setTitle(array[index], for: .normal)
            btn.setTitleColor(UIColor(r: 87, g: 107, b: 148), for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            contentView.addSubview(btn)
            
            if yu == 2 {
                continue
            }
            let view = UIView(frame: CGRect(x: btn.right + 2, y: Y + 6, width: 1/UIScreen.main.scale, height: 18))
            view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
            contentView.addSubview(view)
        }
        
        
     
    }
    
}

