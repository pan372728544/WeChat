//
//  EmoticonViewModel.swift
//  WeChat
//
//  Created by panzhijun on 2019/6/5.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class EmoticonViewModel {

    static let share : EmoticonViewModel = EmoticonViewModel()
    lazy var packages : [EmoticonPackage] = [EmoticonPackage]()
    
    init() {
        packages.append(EmoticonPackage(plistName: "Expression.plist"))
        packages.append(EmoticonPackage(plistName: "ali.plist"))
    }
}
