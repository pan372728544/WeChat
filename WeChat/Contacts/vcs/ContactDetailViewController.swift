//
//  ContactDetailViewController.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/22.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {

    fileprivate var userId : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    
    init(userId: String) {
        
       super.init(nibName: nil, bundle: nil)
        self.userId = userId
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
