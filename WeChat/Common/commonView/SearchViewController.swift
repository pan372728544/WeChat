//
//  SearchViewController.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/21.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class SearchViewController: UISearchController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.view.backgroundColor = UIColor.clear
    }
    
    fileprivate var searResult : ContactSearchViewController?
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        self.searResult = searchResultsController as? ContactSearchViewController
        setup()
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {

  //        let image = UIImage(named: "fav_searchbar_textfield2")?.resizableImage(withCapInsets: UIEdgeInsets(top: 12, left: 6, bottom: 12, right: 6), resizingMode: UIImage.ResizingMode.stretch)
        // 样式
//        searchBar.barTintColor = UIColor.Gray237Color()
        
        searchBar.tintColor = UIColor.ThemeGreenColor()
        searchBar.placeholder = "搜索"
        searchBar.setValue("取消", forKey:"_cancelButtonText")
        searchBar.setPositionAdjustment(UIOffset(horizontal: (Screen_W-20-90)*0.5, vertical: 0), for: UISearchBar.Icon.search)
        self.searchResultsUpdater = searResult

        let viewSearch = UIView(frame: CGRect(x: 0, y: NavaBar_H, width: Screen_W, height: Screen_H-NavaBar_H))
        viewSearch.backgroundColor = UIColor.Gray237Color()
        self.view.addSubview(viewSearch)
        
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
    }
    
   

}

extension SearchViewController: UISearchControllerDelegate {
 
    func willPresentSearchController(_ searchController: UISearchController) {
        searchBar.setPositionAdjustment(UIOffset(horizontal: 0, vertical: 0), for: UISearchBar.Icon.search)
        
        let image = imageFromColor(color: UIColor.Gray237Color(), viewSize: CGSize(width: Screen_W, height: NavaBar_H))
        
        searchBar.setBackgroundImage(image, for: .any, barMetrics: .defaultPrompt)
        
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        
    }
    func willDismissSearchController(_ searchController: UISearchController) {
        
        searchBar.setPositionAdjustment(UIOffset(horizontal: (Screen_W-20-90)*0.5, vertical: 0), for: UISearchBar.Icon.search)
        
    }
    func didDismissSearchController(_ searchController: UISearchController) {
        
        
    }
    
}

extension SearchViewController {
    
    func imageFromColor(color: UIColor, viewSize: CGSize) -> UIImage{
        
        let rect: CGRect = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsGetCurrentContext()
        return image!
        
    }
}
