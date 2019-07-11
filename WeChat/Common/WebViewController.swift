//
//  WebViewController.swift
//  WeChat
//
//  Created by panzhijun on 2019/7/11.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: BaseViewController {
    
    var webView = WKWebView()
    var url : String?
    
    // 进度条
    lazy var progressView : UIProgressView = {
        let progress = UIProgressView()
        progress.progressTintColor = UIColor.ThemeGreenColor()
        progress.trackTintColor = .clear
        return progress
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.progressView.frame = CGRect(x: 0, y: NavaBar_H, width: Screen_W, height: 2)
        self.progressView.isHidden = false
        UIView.animate(withDuration: 1.0) {
            self.progressView.progress = 0.0
        }
    }
    
    init(url : String) {
        super.init(nibName: nil, bundle: nil)
        self.url = url
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        effectView!.alpha = 1
        
        viewLine1.isHidden = false
        
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width:Screen_W, height: Screen_H))
        view.insertSubview(webView, belowSubview: effectView!)
        webView.navigationDelegate = self
        let mapwayURL = URL(string: self.url!)
        let mapwayRequest = URLRequest(url: mapwayURL!)
        webView.load(mapwayRequest)
        view.insertSubview(self.progressView, belowSubview: effectView!)
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
}

extension WebViewController : WKNavigationDelegate {
    
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        self.navigationItem.title = "加载中..."
        /// 获取网页的progress
        UIView.animate(withDuration: 0.5) {
            self.progressView.progress = Float(self.webView.estimatedProgress)
        }
    }
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){

    }
    
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        /// 获取网页title
        self.title = self.webView.title
              print("didFinish")
        UIView.animate(withDuration: 0.5) {
            self.progressView.progress = 1.0
            self.progressView.isHidden = true
        }
    }
    

    
    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        
        UIView.animate(withDuration: 0.5) {
            self.progressView.progress = 0.0
            self.progressView.isHidden = true
        }
        /// 弹出提示框点击确定返回
        let alertView = UIAlertController.init(title: "提示", message: "加载失败", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title:"确定", style: .default) { okAction in
            _=self.navigationController?.popViewController(animated: true)
        }
        alertView.addAction(okAction)
        self.present(alertView, animated: true, completion: nil)
        
    }
    
}


extension WebViewController {
    
    // 添加观察者方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        //设置进度条
        if keyPath == "estimatedProgress"{
            progressView.alpha = 1.0
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            if webView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                    self.progressView.alpha = 0
                }, completion: { (finish) in
                    self.progressView.setProgress(0.0, animated: false)
                })
            }
        }
            
            //重设标题
        else if keyPath == "title" {
            self.title = self.webView.title
        }
    }
}
