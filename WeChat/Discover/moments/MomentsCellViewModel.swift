//
//  MomentsCellViewModel.swift
//  WeChat
//
//  Created by panzhijun on 2019/7/9.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class MomentsCellViewModel: NSObject,MeProtocol {
    

    // 点击链接地址block
    var actionClickLinkBlock : ((String) -> Void)?
    
    // 点击名字地址block
    var actionClickTextBlock : ((String) -> Void)?
    
    
    // 点击手机号block
    var actionClickPhoneBlock : ((String) -> Void)?
    
    var model : momnets?
    
    var cell : MomentsTableViewCell?
    // 图片视图高度
    var imageH : CGFloat = 0
    var imageW : CGFloat = 0
    func bindView(view: UIView) {
        
        cell = view as? MomentsTableViewCell
        setupView()
    }
    
    func setupView()  {
        let url = URL(string: (model?.userUrl)!)
        cell?.imageHead.kf.setImage(with: url)
        // 昵称
        cell?.nameLabel.text = model?.userName
        
        // 朋友圈内容
        cell?.contentLabel.text = model?.contentDesc
        cell?.contentLabel.sizeToFit()
        cell?.contentLabel.top = (cell?.nameLabel.bottom)!+10
        cell?.contentLabel.delegate = self
        
        // 判断图片个数
        let imageCount = model?.imagesList.count;

        let cellH = 80
        let cellMargin = 5
        
        
        switch imageCount {
        case 0:
            imageH = 0
            imageW = 0
        case 1:
            imageH = 240
            imageW = 150
        case 2,3:
            imageH =  CGFloat(cellH)
            imageW = CGFloat(imageCount!*cellH + cellMargin*(imageCount!-1))
        case 4:
            imageH = CGFloat(imageCount!/2*cellH + cellMargin)
            imageW = imageH
        case 5,6:
            imageH = CGFloat(2*cellH + cellMargin)
            imageW = CGFloat(3*cellH + cellMargin*2)
        case 7,8,9:
            imageH = CGFloat(3*cellH + cellMargin*2)
            imageW = imageH
            
        default:
             print("")
        }
        
        var commStr = ""
        
        // 获取评论的数组
        if model?.commentList.count ?? 0 > 0 {
            
            var rangeAry:[NSRange] = Array()
            for (index,item) in (model?.commentList)!.enumerated() {
                commStr.append("\(item.userName):\(item.commnent)")
                if index != (model?.commentList.count)! - 1 {
                    commStr.append("\n")
                }
                let str = commStr as NSString
                let range = str.range(of: "\(item.userName):")
                rangeAry.append(range)
            }

            let attrStr = NSMutableAttributedString.init(string: commStr)
            for range in rangeAry {
                
                attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value:UIColor.init(r: 87, g: 107, b: 149), range:range)
            }
   
            cell?.commLabel.attributedText = attrStr
        }

        
        // 图片视图
        cell?.imageBackView.top = (cell?.contentLabel.bottom)! + 10
        cell?.imageBackView.height = imageH
        cell?.imageBackView.width = imageW
        
        // 地址
        cell?.addressLabel.text = model?.address
        cell?.addressLabel.top = (cell?.imageBackView.bottom)! + 10
        // 时间
        cell?.timeLabel.text = model?.time
        cell?.timeLabel.top = (cell?.addressLabel.bottom)! + 5
        // 更多按钮
        cell?.moreBtn.top = (cell?.addressLabel.bottom)! + 5
        
        // 遮罩
        cell?.coverView.centerY = (cell?.moreBtn.centerY)!
        
        // 更多赞 评论
        cell?.moreImageView.centerY = (cell?.moreBtn.centerY)!
        
        // 评论
        cell?.commentView.top = (cell?.timeLabel.bottom)!+10
        cell?.commLabel .sizeToFit()
        cell?.commLabel.height = (cell?.commLabel.height)!
        cell?.commentView.height = (cell?.commLabel.height)!+10
        cell?.commLabel.width = Screen_W - (cell?.imageHead.right)! - 15*2-20
        cell?.triangleView.isHidden = false;
        // 分割线
        cell?.viewLine1.top = (cell?.commentView.bottom)!+10
        if model?.commentList.count == 0 {
            cell?.commentView.height = 0
            cell?.commLabel.height = 0
            // 分割线
            cell?.viewLine1.top = (cell?.timeLabel.bottom)!+10
            cell?.triangleView.isHidden = true;
        }
        
        
        // cell
        if imageCount == 1 {
            cell?.flowLayout!.itemSize = CGSize(width: imageW, height: imageH)
        } else {
            cell?.flowLayout!.itemSize = CGSize(width: cellH, height: cellH)
        }
        cell?.collectionView?.frame = (cell?.imageBackView.bounds)!
        cell?.collectionView?.delegate = self
        cell?.collectionView?.dataSource = self

    }
    
    func getCellHeight() -> CGFloat {
        
        return (cell?.viewLine1.bottom)! + 10
    }
}


extension MomentsCellViewModel {
    
    
}

extension MomentsCellViewModel: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (model?.imagesList.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as!
        MomentsImageCollectionViewCell
        cell.backgroundColor = UIColor.randomColor()
        
        let imageModel = model?.imagesList[indexPath.item]
        
        let url = URL(string: (imageModel?.imageUrl)!)
        cell.imageView.kf.setImage(with: url)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        // 网图加载器
        let loader = JXKingfisherLoader()
        // 数据源
        let dataSource = JXNetworkingDataSource(photoLoader: loader, numberOfItems: { () -> Int in
            return (self.model?.imagesList.count)!
        }, placeholder: { index -> UIImage? in
            let cell = collectionView.cellForItem(at: indexPath) as? MomentsImageCollectionViewCell
            return cell?.imageView.image
        }) { index -> String? in
            return self.model?.imagesList[index].imageUrl
        }
        // 视图代理，实现了光点型页码指示器
        let delegate = JXDefaultPageControlDelegate()
        // 转场动画
        let trans = JXPhotoBrowserZoomTransitioning { (browser, index, view) -> UIView? in
            let indexPath = IndexPath(item: index, section: 0)
            let cell = collectionView.cellForItem(at: indexPath) as? MomentsImageCollectionViewCell
            return cell?.imageView
        }
        // 打开浏览器
        JXPhotoBrowser(dataSource: dataSource, delegate: delegate, transDelegate: trans)
            .show(pageIndex: indexPath.item)
    }
}

extension MomentsCellViewModel : AtrributeLabelDelegate {
    
    // 点击链接
    func labelDidSelectedLink(text: String) {
        guard let linkBlock = actionClickLinkBlock else {
            return
        }
        linkBlock(text)
    }
    
    func labelDidSelectedTopic(text: String) {
        
    }
    
    // 点击名字
    func labelDidSelectedAt(text: String) {
        guard let textBlock = actionClickTextBlock else {
            return
        }
        textBlock(text)
    }
    
    // 点击手机号
    func labelDidSelectedPhone(text: String) {
        guard let phoneBlock = actionClickPhoneBlock else {
            return
        }
        phoneBlock(text)
    }
    
    
}
