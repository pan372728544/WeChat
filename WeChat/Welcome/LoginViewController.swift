//
//  LoginViewController.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/15.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    fileprivate var textField = PhoneTextField()
    fileprivate var loginBtn : UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Gray237Color()
        
        let cancleBtn = UIButton(frame: CGRect(x: 0, y: StatusBar_H + 10, width: 45, height: 45))
        cancleBtn.setBackgroundImage(UIImage(named: "close_trusted_friend_tips_hl_Normal"), for: UIControl.State.normal)

        cancleBtn.setTitleColor(UIColor.ThemeGreenColor(), for: UIControl.State.normal)
        cancleBtn.addTarget(self, action: #selector(btnClick), for: UIControl.Event.touchUpInside)
        view.addSubview(cancleBtn)
        
        
        
        let phoneLabel = UILabel(frame: CGRect(x: 15, y: cancleBtn.bottom + 40 , width: 180, height: 70))
        phoneLabel.textAlignment = NSTextAlignment.left
        phoneLabel.text = "手机号登录"
        phoneLabel.textColor = UIColor.black
        phoneLabel.font = UIFont.systemFont(ofSize: 30)
        view.addSubview(phoneLabel)
        
        
        
        let country = UILabel(frame: CGRect(x: 15, y: phoneLabel.bottom + 40 , width: 180, height: 20))
        country.textAlignment = NSTextAlignment.left
        country.text = "国家/地区   中国"
        country.textColor = UIColor.black
        country.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(country)
        
        let imgV = UIImageView(frame: CGRect(x: Screen_W-15-40, y: country.top, width: 20, height: 20))
        imgV.image = UIImage(named: "PhoneAuth_AccesoryArrow_Normal")
        view.addSubview(imgV)
        
        
        let viewH = 1/UIScreen.main.scale
        
        let viewLine1 = UIView(frame: CGRect(x: 15, y: country.bottom+10, width: Screen_W-30, height: viewH))
        viewLine1.backgroundColor = UIColor.Gray213Color()
        view.addSubview(viewLine1)
        
        
        let phone86 = UILabel(frame: CGRect(x: 15, y: viewLine1.bottom  , width: 50, height: 44))
        phone86.textAlignment = NSTextAlignment.left
        phone86.text = "+86"
        phone86.textColor = UIColor.black
        phone86.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(phone86)
        
        
        let viewLine3 = UIView(frame: CGRect(x: phone86.right + 40, y: viewLine1.bottom, width: viewH, height: 44))
        viewLine3.backgroundColor = UIColor.Gray213Color()
        view.addSubview(viewLine3)
        
        
        
        let viewLine2 = UIView(frame: CGRect(x: 15, y: viewLine1.bottom+44, width: Screen_W-30, height: viewH))
        viewLine2.backgroundColor = UIColor.Gray213Color()
        view.addSubview(viewLine2)
        
        
        textField.frame = CGRect(x: viewLine3.right + 10 , y: viewLine1.bottom, width: 200, height: 44)
        textField.placeholder = "请填写手机号码"
        textField.delegate = self
        textField.tintColor = UIColor.ThemeGreenColor()
        textField.keyboardType = UIKeyboardType.numberPad
        view.addSubview(textField)
        
        

        
        let otherLogin = UILabel(frame: CGRect(x: 15, y: viewLine2.bottom + 20  , width: 270, height: 44))
        otherLogin.textAlignment = NSTextAlignment.left
        otherLogin.text = "使用微信号/QQ号/邮箱登录"
        otherLogin.textColor = UIColor.init(r: 87, g: 107, b: 148)
        otherLogin.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(otherLogin)
        
        
        loginBtn = UIButton(frame: CGRect(x: 15, y: otherLogin.bottom + 40, width: Screen_W-30, height: 50))
        loginBtn.setTitle("下一步", for: UIControl.State.normal)
        loginBtn.backgroundColor = UIColor.ThemeGreenColor()
        loginBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        loginBtn.alpha = 0.4
        loginBtn.layer.cornerRadius = 4
        loginBtn.isEnabled = false
        loginBtn.addTarget(self, action: #selector(btnNextClick), for: UIControl.Event.touchUpInside)
        view.addSubview(loginBtn)
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loginsuccess(nofi:)),
                                               name: NSNotification.Name(rawValue: "loginSuccess"),
                                               object: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

}



extension LoginViewController {
    
    @objc func loginsuccess(nofi : Notification){
        
        dismiss(animated: true) {

        }
        let window = UIApplication.shared.keyWindow
        window?.rootViewController = BaseTabBarController()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            Toast.showCenterWithText(text: "登录成功")
        }
        
        socketClient.sendLoadFriends()
    }
    
    @objc func btnClick() {
        
        dismiss(animated: true) {
            
        }
        
    }
    
    @objc func btnNextClick() {
        
        self.view.endEditing(true)

        // 发送登录消息
        socketClient.sendLogin(phone: self.textField.text!.removeAllSapce)
        
    }
    
}


extension LoginViewController : UITextFieldDelegate {
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        var phone = textField.text
        
      phone = textField.text?.replacingCharacters(in: (phone?.toRange(range))!, with: string)

        if (phone?.count)! > 12 {
            loginBtn.isEnabled = true
            loginBtn.alpha = 1.0
        } else {
            loginBtn.isEnabled = false
            loginBtn.alpha = 0.4
        }

        
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
             print(textField.text)

    }
}
