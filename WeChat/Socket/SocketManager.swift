//
//  SocketManager.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/15.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit
import RealmSwift


class SocketManager : NSObject {
    
    static let share = SocketManager()
    
    // 定时器
    fileprivate var heartBeatTimer : Timer?

    // 连接
    func connect(completionHandler : @escaping (_ succ : Bool) -> ())  {

        let dbUser  = RealmTool.getDBUser()
        
        if dbUser.first == nil {
            Toast.showCenterWithText(text: "还没有登录")
        }
        

        DispatchQueue.global().async {


            // 开始连接
            if socketClient.connectServer().isSuccess {
                print("连接服务器成功")

                socketClient.delegate = IMDataManager.share as ZJSocketDelegate

                // 读取消息
                socketClient.startReadMsg()

                if RealmTool.getDBUser().first != nil {
                    socketClient.sendJoinRoom()
                }
    
                // 发送心跳包
                self.addHeartBeatTimer()
                completionHandler(true)
            }
            completionHandler(false)


        }
    
    }

    
    // 关闭
    @objc open func close()   {
        DispatchQueue.global().async {
            self.heartBeatTimer?.invalidate()
            self.heartBeatTimer = nil
            socketClient.sendLeaveRoom()
            socketClient.closeServer()


        }
    }

    func addHeartBeatTimer() {
        heartBeatTimer = Timer(fireAt: Date(), interval: 9, target: self, selector: #selector(sendHeartBeat), userInfo: nil, repeats: true)
        RunLoop.main.add(heartBeatTimer!, forMode: RunLoop.Mode.common)
    }

    @objc fileprivate func sendHeartBeat() {
        socketClient.sendHeartBeat()
        //        print("发送心跳包")
    }

}


