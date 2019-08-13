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

        self.view.backgroundColor = UIColor.Gray237Color()
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

        
        searchBar.tintColor = UIColor.ThemeGreenColor()
        searchBar.placeholder = "搜索"
//        searchBar.setValue("取消", forKey:"_cancelButtonText")
        searchBar.setPositionAdjustment(UIOffset(horizontal: (Screen_W-20-90)*0.5, vertical: 0), for: UISearchBar.Icon.search)
        self.searchResultsUpdater = searResult
        searchBar.delegate = self

        searchBar.autocapitalizationType = .allCharacters

        for view in  (searchBar.subviews.last!.subviews) {
            if view.isKind(of: NSClassFromString("UISearchBarBackground")!) {
                view.removeFromSuperview()
            }
        }
        
    }
    
   

}

extension SearchViewController: UISearchControllerDelegate,UISearchBarDelegate{
 
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        print("searchBarShouldBeginEditing")
         searchBar.setPositionAdjustment(UIOffset(horizontal: 0, vertical: 0), for: UISearchBar.Icon.search)
        return true
    }
    
    func presentSearchController(_ searchController: UISearchController) {
        
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {

        
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        
    }
    func willDismissSearchController(_ searchController: UISearchController) {
        
        searchBar.setPositionAdjustment(UIOffset(horizontal: (Screen_W-20-90)*0.5, vertical: 0), for: UISearchBar.Icon.search)
                searchBar.sizeToFit()
        
    }
    func didDismissSearchController(_ searchController: UISearchController) {
        
        
    }
    
}
