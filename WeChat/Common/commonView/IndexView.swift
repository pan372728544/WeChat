//
//  IndexView.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/17.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

protocol IndexViewDelegate : class {
    
    func selectedSectionIndexTitle(title: String,index: Int)
    func addIndicatorView(view : UIView)
}

protocol IndexViewDataSource : class {
       func sectionIndexTitles() -> [String]
}



class IndexView: UIControl,CAAnimationDelegate {

    
    weak var delegate : IndexViewDelegate?
    weak var dataSource : IndexViewDataSource?
    
    
    var titleFontSize : CGFloat = 0.0
    var titleColor : UIColor?
    var marginRight : CGFloat = 0.0
    var titleSpace : CGFloat = 0.0
    var indicatorMarginRight : CGFloat = 0.0
    var vibrationOn : Bool = false
    var searchOn : Bool = false
    
    fileprivate var indicatorView : IndicatorView  = {
        
        let indicatorView = IndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 50))
        
        return indicatorView
    }()
    
    fileprivate var indexItems : [String] = [String]()
    fileprivate var itemsViewArray : [UILabel] = [UILabel]()
    var oldIndex : Int = 0
    var newIndex : Int = 0
     var selectedIndex : Int? {
       
        
        willSet{
            oldIndex = selectedIndex ?? 0
        }
        didSet{
            
            newIndex = selectedIndex ?? 0
            //处理新旧item
            if (oldIndex >= 0 && oldIndex < self.itemsViewArray.count) {
               let oldItemLabel = self.itemsViewArray[oldIndex];
                oldItemLabel.textColor = self.titleColor;
                self.selectedImageView.frame = CGRect(x: 0, y: 0, width: 0, height: 0);
            }
            if (newIndex >= 0 && newIndex < self.itemsViewArray.count) {
                
                let newItemLabel = self.itemsViewArray[newIndex];
                newItemLabel.textColor = UIColor.white

                var isLetter = true;

                let firstLetter : String?  = newItemLabel.text
                
                // 判断是否是字母
                for char in (firstLetter?.utf8)! {
                    if (char > 64 && char < 91) || (char > 96 && char < 123) {
                        isLetter = true
                    } else {
                        isLetter = false
                    }
                }
                //处理选中圆形
                if (isLetter || firstLetter == "#") {
                    let diameter = ((self.itemMaxSize.width > self.itemMaxSize.height) ? self.itemMaxSize.width:self.itemMaxSize.height) + self.titleSpace;
                    self.selectedImageView.frame = CGRect(x: 0, y: 0, width: diameter, height: diameter);
                    self.selectedImageView.center = newItemLabel.center;
      
                    self.selectedImageView.layer.mask = self.imageMaskLayer(bounds: self.selectedImageView.bounds, radiu: diameter/2)

                    self.insertSubview(self.selectedImageView, belowSubview: newItemLabel)
                } else {
                    isLetter = false;
                    print(self.indicatorView)
                }
                

                
                
                if self.isCallback && self.delegate != nil {
                    
                    self.delegate?.selectedSectionIndexTitle(title: self.indexItems[newIndex], index: newIndex)
                    
                    if isLetter || firstLetter == "#" {
                        
                        self.indicatorView.alpha = 1.0
                        self.indicatorView.setOrigin(origin: CGPoint(x: Screen_W-self.marginRight-self.titleFontSize-20-self.indicatorMarginRight, y: newItemLabel.center.y+self.frame.origin.y), title: newItemLabel.text!)
                        
                        if self.delegate != nil {
                            self.delegate?.addIndicatorView(view: self.indicatorView)
                        }
                    } else {
                        self.indicatorView.alpha = 0
                    }
                }
                
            }
        }

    }
    fileprivate var minY : CGFloat = 0.0
    fileprivate var maxY : CGFloat = 0.0
    fileprivate var itemMaxSize : CGSize  = CGSize(width: 0, height: 0)
    fileprivate var selectedImageView : UIImageView = {
        
        let selectedImageView = UIImageView()
        selectedImageView.backgroundColor = UIColor.ThemeGreenColor()
        return selectedImageView
    }()
    fileprivate var isCallback : Bool = false
    fileprivate var isShowIndicator : Bool = false
    fileprivate var isUpScroll : Bool = false
    fileprivate var isFirstLoad : Bool = false
    
    fileprivate var oldY : CGFloat = 0.0
    fileprivate var isAllowedChange : Bool = false
    fileprivate var generator : UIImpactFeedbackGenerator?
    
    
    func setSelectionIndex(index : Int)  {
        if (index >= 0 && index <= self.indexItems.count) {
            //改变组下标
            self.isCallback = false;
            self.selectedIndex = index;
        }
    }
    
    
    func tableViewWillDisplayHeaderView(tableView : UITableView,view: UIView,section: Int)  {
        if(self.isAllowedChange && !self.isUpScroll && !self.isFirstLoad) {
            //最上面组头（不一定是第一个组头，指最近刚被顶出去的组头）又被拉回来
            self.setSelectionIndex(index: section);  //section
        }
    }
    
    
    func tableViewDidEndDisplayingHeaderView(tableView : UITableView,view: UIView,section: Int)  {
//        if (self.isAllowedChange && !self.isFirstLoad && self.isUpScroll) {
//            //最上面的组头被顶出去
//              self.setSelectionIndex(index: section);  //section+1
//        }
        
        if (self.isAllowedChange && !self.isFirstLoad) {
            //最上面的组头被顶出去
            self.setSelectionIndex(index: section);  //section+1
        }
    }
    
    func scrollViewDidScroll(scrollow : UIScrollView)  {
        let scry = scrollow.contentOffset.y
        
        
        if (scry > self.oldY) {
            self.isUpScroll = true    // 上滑
        }
        else {
            self.isUpScroll = false      // 下滑
        }
        self.isFirstLoad = false
        
        self.oldY = scry
    }
    
    
    func reload() {
        self.isShowIndicator = false;
        //获取标题组
        if self.dataSource != nil {
            self.indexItems = (self.dataSource?.sectionIndexTitles())!
            if (self.indexItems.count == 0) {
                return
            }
        }else {
            return
        }
        //初始化属性设置
        attributeSettings()
        //初始化title
        initialiseAllTitles()
    }
    
    func attributeSettings()  {
        //文字大小
        if (self.titleFontSize == 0) {
            self.titleFontSize = 10;
        }
        //字体颜色
        if (self.titleColor == nil) {
            self.titleColor = UIColor.gray
        }
        //右边距
        if (self.marginRight == 0) {
            self.marginRight = 7;
        }
        //文字间距
        if (self.titleSpace == 0) {
            self.titleSpace = 4;
        }
        
        //默认就允许滚动改变组
        self.isAllowedChange = true;
        
        self.isFirstLoad = true;
    }
    
    // MARK: -- 初始化title
    func initialiseAllTitles()  {
        //清除缓存
        self.itemsViewArray.removeAll()
        self.selectedImageView.layer.mask = nil;
        self.selectedImageView.frame = CGRect(x: 0, y: 0, width: 0, height: 0);
        
        //高度是否符合
        let totalHeight : CGFloat = (CGFloat(self.indexItems.count) * self.titleFontSize) + (CGFloat(self.indexItems.count + 1) * self.titleSpace)
        if (self.height < totalHeight) {
            print("View height is not enough")
            return;
        }
        //宽度是否符合
        let totalWidth : CGFloat = self.titleFontSize + self.marginRight;
        if (self.width < totalWidth) {
            print("View width is not enough")
            return;
        }
        //设置Y坐标最小值
        self.minY = (self.height - totalHeight)/2.0;
        var startY = self.minY  + self.titleSpace;
        //以 'W' 字母为标准作为其他字母的标准宽高
        let stringW : String = "W"
        let attributes = [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: self.titleFontSize)]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = stringW.boundingRect(with: CGSize(width: Screen_W , height: Screen_H), options: option, attributes: attributes, context: nil)
        self.itemMaxSize = rect.size
        
        //标题视图布局
        for i in 0..<self.indexItems.count {
            let title = self.indexItems[i]
            // 创建uilabel
            let itemLable = UILabel(frame: CGRect(x: self.width-self.marginRight-self.titleFontSize, y: startY, width: self.itemMaxSize.width, height: self.itemMaxSize.height))
//            itemLable.backgroundColor = UIColor.randomColor()
            //是否有搜索
            if (title == UITableView.indexSearch) {
                itemLable.text = "搜索"
                // 创建搜索图片
                let attch = NSTextAttachment()
                //定义图片内容及位置和大小
                attch.image = UIImage(named: "SearchContactsBarIcon_Normal")
                attch.bounds = CGRect(x: 0, y: 0, width: self.itemMaxSize.height - 2, height: self.itemMaxSize.height - 2);
                let attri = NSAttributedString(attachment: attch)
                itemLable.attributedText = attri;
                
            } else {
                itemLable.font = UIFont.boldSystemFont(ofSize: self.titleFontSize)
                itemLable.textColor = self.titleColor;
                itemLable.text = title;
                itemLable.textAlignment = NSTextAlignment.center;
            }
            
            // 添加到数组中
            self.itemsViewArray.append(itemLable)

            self.addSubview(itemLable)
            //重新计算start Y
            startY = startY + self.itemMaxSize.height + self.titleSpace;
        }
        
        //设置Y坐标最大值
        self.maxY = startY;
    }
    
            
    // MARK: -- 开始处理
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let location = touch.location(in: self)
        self.isAllowedChange = false
        selectedIndexByPoint(location: location)
        
        if (self.vibrationOn){
            self.generator = UIImpactFeedbackGenerator(style: .light);
        }
        return true
    }
    
    // MARK: -- 滑动
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        selectedIndexByPoint(location: location)
        return true
    }
    // MARK: -- 结束滑动
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        let location = touch!.location(in: self)
        
        if (location.y < self.minY || location.y > self.maxY) {
            return
        }
        
        //重新计算坐标
        selectedIndexByPoint(location: location)
        
        //判断当前是否是搜索，如果不是搜索才进行动画
        var isSearch = false;
        if (self.indexItems.count > 0) {
            let firstTitle = self.indexItems[self.selectedIndex!];
            if (firstTitle == UITableView.indexSearch) {
                isSearch = true
            }
        }
        if (!isSearch) {

            self.animationView(view: self.indicatorView)
        }
        
        //滑动结束后，允许scrollview改变组
        self.isAllowedChange = true
        
        self.generator = nil
    }
    
    // MARK: -- 取消
    override func cancelTracking(with event: UIEvent?) {
        //只有当指示视图在视图上时，才能进行动画
        if ((self.indicatorView.superview) != nil) {
            self.animationView(view: self.indicatorView)
        }
        //滑动结束后，允许scrollview改变组
        self.isAllowedChange = true;
        
        self.generator = nil;
    }
    
    // MARK: - 根据Y坐标计算选中位置，当坐标有效时，返回YES
    func selectedIndexByPoint(location: CGPoint)  {
        if (location.y >= self.minY && location.y <= self.maxY) {
            //计算下标
            let offsetY : Int = Int(location.y - self.minY - (self.titleSpace / 2.0));
            //单位高
            let item = self.itemMaxSize.height + self.titleSpace;
            //计算当前下标
            let index : Int = (Int(offsetY / Int(item))) ;//+ ((offsetY % item == 0)?0:1) - 1;
            
            if (index != self.selectedIndex && index < self.indexItems.count && index >= 0) {
                self.isCallback = true;
                self.selectedIndex = index;
                
                if (self.vibrationOn) {
                    self.generator?.prepare()
                    self.generator?.impactOccurred()
                }
                
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.cancelTracking(with: event)
    }
    
    
    func animationView(view: UIView)  {
        //即将开始进行动画前，判断指示器视图是否已经添加到父视图上
        if (self.indicatorView.superview != nil) {
 
            if delegate != nil {
                delegate?.addIndicatorView(view: self.indicatorView)
                //将view放在这里，而不是if外，是确保点击搜索视图时，不会出现indicatorView
                view.alpha = 1.0
            }
        }

        UIView.animate(withDuration: 0.3, animations: {
            view.alpha = 0
        }) { (isfinsh) in
              //视图不移除，保证视图在连续点击时，不会出现瞬间消失的情况
        }
    }
    
    
    // 设置圆
    func imageMaskLayer(bounds: CGRect,radiu: CGFloat) -> CAShapeLayer {
        
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: radiu, height: radiu))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        return maskLayer
        
    }
    
    override func didMoveToSuperview() {
        self.reload()
    }
}
