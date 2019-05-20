//
//  Const.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/13.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit


let Screen_W : CGFloat = UIScreen.main.bounds.width

let Screen_H : CGFloat = UIScreen.main.bounds.height

let Tabbar_H : CGFloat = CGFloat(49+(UIApplication.shared.keyWindow?.rootViewController?.view.safeAreaInsets.bottom)! )

let Bottom_H : CGFloat = (UIApplication.shared.keyWindow?.rootViewController?.view.safeAreaInsets.bottom)!


let StatusBar_H : CGFloat = UIApplication.shared.statusBarFrame.size.height



let NavaBar_H : CGFloat = StatusBar_H + 44



var isConnected = false
let socketClient : ZJSocket = ZJSocket(addr: "10.2.116.42", port: 9999)


let MeCellH : CGFloat = 56

let ContactCellH : CGFloat = 56
