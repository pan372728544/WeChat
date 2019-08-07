//
//  SearchView.swift
//  WeChat
//
//  Created by panzhijun on 2019/8/7.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

protocol SearchViewDelegate {
    
    func searchViewShouldBeginEditing(_ textField: UITextField)
    
    func searchViewShouldEndEditing(_ textField: UITextField)
}


class SearchView: UITextField {
    
    var searchDelegate : SearchViewDelegate?
    
    
    var rect = CGRect(x: Screen_W/2-50, y: 9, width: 30, height: 18)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.tintColor = UIColor.ThemeGreenColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        
        return rect
    }
}

extension SearchView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        rect.origin.x = 0
        searchDelegate?.searchViewShouldBeginEditing(textField)
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        rect.origin.x = Screen_W/2-50
        searchDelegate?.searchViewShouldEndEditing(textField)
        return true
    }
}
