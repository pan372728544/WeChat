//
//  ChatBallView.swift
//  WeChat
//
//  Created by panzhijun on 2019/8/13.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class ChatBallView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        /// 初始化视图
        setupMainView()
    }
    
    let ballWH : CGFloat = 6
    let ballMargin : CGFloat = 5
    
    
    private lazy var leftBall : UIView = {
        let view = UIView()
        view.frame = CGRect(x: (Screen_W)/2, y: (BallViewH - ballWH)/2, width: 0, height: 0)
        return view
        
    }()
    
    
    private lazy var centerBall : UIView = {
        let view = UIView()
        view.frame = CGRect(x: (Screen_W-ballWH)/2, y: (BallViewH - ballWH)/2, width: 0, height: 0)
        return view
        
    }()
    
    private lazy var rightBall : UIView = {
        let view = UIView()
        view.frame = CGRect(x: (Screen_W)/2, y: (BallViewH - ballWH)/2, width: 0, height: 0)
        return view
        
    }()
    
    
    var leftLayer : CAShapeLayer = CAShapeLayer()
    var rightLayer : CAShapeLayer = CAShapeLayer()
    var centerLayer : CAShapeLayer = CAShapeLayer()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}

extension ChatBallView {
    
    func setupMainView()  {
        
        self.backgroundColor = UIColor.clear
        self.addSubview(leftBall)
        self.addSubview(rightBall)
        self.addSubview(centerBall)
        addShapLayer(view: leftBall)
        addShapLayer(view: rightBall)
        addShapLayer(view: centerBall)
    }
    
    
    func addShapLayer(view : UIView)  {
        
        view.layer.superlayer?.removeFromSuperlayer()
        
        let bizerPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 0, height: 0))
        let shapLayer = CAShapeLayer()
        shapLayer.borderWidth = 5
        shapLayer.strokeColor = UIColor.brown.cgColor
        shapLayer.fillColor = UIColor(r: 181, g: 181, b: 181).cgColor
        shapLayer.strokeStart = 0
        shapLayer.strokeEnd = 0
        shapLayer.path = bizerPath.cgPath
        view.layer.addSublayer(shapLayer)
        
        if view == leftBall {
            self.leftLayer = shapLayer
        } else if view == rightBall {
            self.rightLayer = shapLayer
        } else {
            self.centerLayer = shapLayer
        }
    }
    
    func endBallAnimation() {
        let bizerPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 0, height: 0))
        centerBall.frame = CGRect(x: (Screen_W-ballWH)/2, y: (BallViewH - ballWH)/2, width: 0, height: 0)
        rightBall.frame = CGRect(x: (Screen_W-ballWH)/2, y: (BallViewH - ballWH)/2, width: 0, height: 0)
        leftBall.frame = CGRect(x: (Screen_W-ballWH)/2, y: (BallViewH - ballWH)/2, width: 0, height: 0)
        centerLayer.path = bizerPath.cgPath
        leftLayer.path = bizerPath.cgPath
        rightLayer.path = bizerPath.cgPath
    }
    
    
    /// 更新小球动画
    /// - Parameter offset: 滑动偏移量
    func updataAnimation(_ offset : CGFloat) {
        
        if offset <= 0 {
            // 下拉放大
            leftBall.alpha = 0
            rightBall.alpha = 0
            
            // 放大中心球
            let scaleC = (-offset/offsetPoint) >= 1 ?  1 : (-offset/offsetPoint)
            let newWH = ballWH*scaleC*1.5
            let bizerPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: newWH, height: newWH))
            centerBall.frame = CGRect(x: (Screen_W-newWH)/2, y: (BallViewH - newWH)/2, width: newWH, height: newWH)
            centerLayer.path = bizerPath.cgPath
            
            // 更新左右球
            if offset <= -offsetPoint {
                
                leftBall.alpha = 1
                rightBall.alpha = 1
                // 滑动距离大于等于临界值的
                let offsetLR = -(offset+offsetPoint)*0.5 >= ballWH*3 ? ballWH*3 : -(offset+offsetPoint)*0.5
                let scaleB : CGFloat = offsetLR/(ballWH*3) >= 1 ?  1 : offsetLR/(ballWH*3)
                
                // 缩小中心球
                let newWH2 = (ballWH*3)/(2+scaleB)
                let bizerPath2 = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: newWH2, height: newWH2))
                centerBall.frame = CGRect(x: (Screen_W-newWH2)/2, y: (BallViewH - newWH2)/2, width: newWH2, height: newWH2)
                centerLayer.path = bizerPath2.cgPath
                
                /// 滑动到临界值的时候 更新左右小球位置
                let bizerPath3 = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: ballWH, height: ballWH))
                leftBall.frame =  CGRect(x: (Screen_W-ballWH)/2 + offsetLR, y: (BallViewH - ballWH)/2, width: ballWH, height: ballWH)
                rightBall.frame = CGRect(x: (Screen_W-ballWH)/2 - offsetLR, y: (BallViewH - ballWH)/2, width: ballWH, height: ballWH)
                leftLayer.path = bizerPath3.cgPath
                rightLayer.path = bizerPath3.cgPath
            }
            
            
        }
        
    }
}
