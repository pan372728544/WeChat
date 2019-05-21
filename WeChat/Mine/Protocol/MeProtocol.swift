//
//  MeProtocol.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/15.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

protocol MeProtocol {
    

    func bindView(view : UIView) 
    

}

extension MeProtocol {
    func bingData(data: Any){}
    
    func bingViewController(vc: UIViewController){}
}
