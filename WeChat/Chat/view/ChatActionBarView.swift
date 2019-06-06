//
//  ChatActionBarView.swift
//  WeChat
//
//  Created by panzhijun on 2019/6/4.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit



let kChatActionBarOriginalHeight: CGFloat = 55      //ActionBar orginal height
let kChatActionBarTextViewMaxHeight: CGFloat = 120   //Expandable textview max height
let kChatActionBarBtnHeight: CGFloat = 35
let kChatActionBarMargin: CGFloat = 8
/**
 *  表情按钮和分享按钮来控制键盘位置
 */
protocol ChatActionBarViewDelegate: class {
    /**
     不显示任何自定义键盘，并且回调中处理键盘frame
     当唤醒的自定义键盘时候，这时候点击切换录音 button。需要隐藏掉
     */
    func chatActionBarRecordVoiceHideKeyboard()
    
    /**
     显示表情键盘，并且处理键盘高度
     */
    func chatActionBarShowEmotionKeyboard()
    
    /**
     显示分享键盘，并且处理键盘高度
     */
    func chatActionBarShowShareKeyboard()
}

class ChatActionBarView: UIView {

    enum ChatKeyboardType: Int {
        case `default`, text, emotion, share
    }
    
    fileprivate  var emoticonView : EmoticonView!
    var keyboardType: ChatKeyboardType? = .default
    weak var delegate: ChatActionBarViewDelegate?
    var inputTextViewCurrentHeight: CGFloat = kChatActionBarOriginalHeight
    
    fileprivate  var  effectView : UIVisualEffectView?
        fileprivate var dbUser :DBUser?
    
        var actionBarViewClickBlock : ((String,MessageType) -> Void)?
    fileprivate lazy var inputTextView: UITextView = {
        
        let inputTextView = UITextView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        inputTextView.font = UIFont.systemFont(ofSize: 17)
        inputTextView.layer.borderColor = UIColor.Gray213Color().cgColor
        inputTextView.layer.borderWidth = 1/UIScreen.main.scale
        inputTextView.layer.cornerRadius = 5.0
        inputTextView.scrollsToTop = false
        inputTextView.textContainerInset =  UIEdgeInsets(top: 7, left: 5, bottom: 5, right: 5)

        inputTextView.backgroundColor = UIColor.white
        inputTextView.returnKeyType = .send
        inputTextView.isHidden = false
        inputTextView.enablesReturnKeyAutomatically = true
        inputTextView.layoutManager.allowsNonContiguousLayout = false
        inputTextView.scrollsToTop = false
        inputTextView.delegate = self
        return inputTextView
        }()
    
    fileprivate lazy var voiceButton: ChatButton = {

        let voiceBtn = ChatButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        var imgV = UIImage.init(named: "ToolViewInputVoice")
        imgV = imgV?.withRenderingMode(.alwaysTemplate)
        voiceBtn.tintColor = UIColor.black
        voiceBtn.setBackgroundImage(imgV, for: .normal)
        var imgV2 = UIImage.init(named: "ToolViewKeyboard")
        imgV2 = imgV2?.withRenderingMode(.alwaysTemplate)
        voiceBtn.setBackgroundImage(imgV2, for: .selected)
        voiceBtn.showTypingKeyboard = false
        return voiceBtn
    }()
      fileprivate lazy var emotionButton: ChatButton = {
        
        
        let emotionBtn = ChatButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        var imgE = UIImage.init(named: "ToolViewEmotion")
        imgE = imgE?.withRenderingMode(.alwaysTemplate)
        emotionBtn.tintColor = UIColor.black
        emotionBtn.setBackgroundImage(imgE, for: .normal)
        
        var imgB = UIImage.init(named: "ToolViewKeyboard")
        imgB = imgB?.withRenderingMode(.alwaysTemplate)
        emotionBtn.setBackgroundImage(imgB, for: .selected)
        emotionBtn.showTypingKeyboard = false
        emotionBtn.addTarget(self, action: #selector(emotionBtnClick(_:)), for: UIControl.Event.touchUpInside)
        return emotionBtn
        }()
    
       fileprivate lazy var shareButton: ChatButton = {

        let shareButton = ChatButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        var imgA = UIImage.init(named: "TypeSelectorBtn_Black")
        imgA = imgA?.withRenderingMode(.alwaysTemplate)
        shareButton.tintColor = UIColor.black
        shareButton.setBackgroundImage(imgA, for: .normal)
        var imgB = UIImage.init(named: "ToolViewKeyboard")
        imgB = imgB?.withRenderingMode(.alwaysTemplate)
        shareButton.setBackgroundImage(imgB, for: .selected)
        shareButton.showTypingKeyboard = false
//        shareButton.addTarget(self, action: #selector(addBtnClick(_:)), for: UIControl.Event.touchUpInside)
        
        return shareButton
        
        }()
    
      fileprivate lazy var recordButton: UIButton = {
        
        let recordButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        recordButton.setBackgroundImage(UIImage.from(color:UIColor.init("#F3F4F8")), for: .normal)
        recordButton.setBackgroundImage(UIImage.from(color:UIColor.init("#C6C7CB")), for: .highlighted)
        recordButton.layer.borderColor = UIColor.gray.cgColor
        recordButton.layer.borderWidth = 0.5
        recordButton.layer.cornerRadius = 5.0
        recordButton.layer.masksToBounds = true
        recordButton.isHidden = true
        return recordButton
        }()
    
    override init (frame: CGRect) {
        super.init(frame : frame)
        setupMainView()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func setupMainView() {
        
        // 添加毛玻璃效果
        let blur = UIBlurEffect(style: UIBlurEffect.Style.light)
        effectView = UIVisualEffectView(effect: blur)
        effectView?.frame = CGRect(x: 0, y: 0, width: Screen_W, height: kChatActionBarOriginalHeight+Bottom_H)
        effectView?.backgroundColor = UIColor(red: 237/255.0, green: 237/255.0, blue: 237/255.0, alpha: 0.6)
        effectView?.alpha = 1.0
        effectView?.isUserInteractionEnabled = true
        addSubview(effectView!)
        
        let viewH = 1/UIScreen.main.scale
        let viewLine1 = UIView(frame: CGRect(x: 0, y: 0, width: Screen_W, height: viewH))
        viewLine1.backgroundColor = UIColor.Gray213Color()
        effectView?.contentView.addSubview(viewLine1)
        
        self.voiceButton.frame = CGRect(x: kChatActionBarMargin, y: kChatActionBarMargin, width: kChatActionBarBtnHeight, height: kChatActionBarBtnHeight)
        effectView?.contentView.addSubview(self.voiceButton)
        
        self.inputTextView.frame = CGRect(x: self.voiceButton.right+kChatActionBarMargin, y: kChatActionBarMargin-2, width: Screen_W-5*kChatActionBarMargin-3*kChatActionBarBtnHeight, height: 40)
        effectView?.contentView.addSubview(self.inputTextView)
        
        self.recordButton.frame = self.inputTextView.frame
        effectView?.contentView.addSubview(self.recordButton)
        
        
        self.emotionButton.frame = CGRect(x: self.inputTextView.right+kChatActionBarMargin, y: kChatActionBarMargin, width: kChatActionBarBtnHeight, height: kChatActionBarBtnHeight)
        
        effectView?.contentView.addSubview(self.emotionButton)
        
        
        self.shareButton.frame = CGRect(x: self.emotionButton.right+kChatActionBarMargin, y: kChatActionBarMargin, width: kChatActionBarBtnHeight, height: kChatActionBarBtnHeight)
        effectView?.contentView.addSubview(self.shareButton)
    
        
        emoticonView  = EmoticonView(frame: CGRect(x: 0, y: 0, width: Screen_W, height: 250+Bottom_H))
        
        emoticonView.emoticonClickCallback = {[weak self] emoticon in
            // 1.判断是否是删除按钮
            if emoticon.text == "compose_emotion_delete" {
                self?.inputTextView.deleteBackward()
                return
            }
            
            // 2.获取光标位置
            guard let range = self?.inputTextView.selectedTextRange else { return }
            self?.inputTextView.replace(range, withText: emoticon.text)
        }
        
        emoticonView.emoticonClickSend = {
            
            print(self.inputTextView.text)
            
            self.actionBarViewClickBlock!(self.inputTextView.text,.text)
            
            self.inputTextView.text = ""
        }
    }


}


extension ChatActionBarView {
    
    @objc func emotionBtnClick(_ btn: UIButton) {
    
        btn.isSelected = !btn.isSelected
        
        // 切换键盘
        let range = inputTextView.selectedTextRange
        inputTextView.resignFirstResponder()
        inputTextView.inputView = inputTextView.inputView == nil ? emoticonView : nil
        inputTextView.becomeFirstResponder()
        inputTextView.selectedTextRange = range
    }
    
}


extension ChatActionBarView: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // 点击发送按钮
        if text == "\n" {
            self.actionBarViewClickBlock!(self.inputTextView.text,.text)
            self.inputTextView.text = ""
            return false
        }
        return true
    }
    
}
