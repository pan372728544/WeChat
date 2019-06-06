//
//  MoreViewModel.swift
//  WeChat
//
//  Created by panzhijun on 2019/6/6.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class MoreViewModel {
    
    static let share : MoreViewModel = MoreViewModel()
    lazy var packages : [MoreActionPackage] = [MoreActionPackage]()
    
    init() {
        packages.append(MoreActionPackage(plistName: "MoreAction.plist"))
    }

}
