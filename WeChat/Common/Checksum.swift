//
//  Checksum.swift
//  WeChat
//
//  Created by panzhijun on 2019/5/30.
//  Copyright © 2019 panzhijun. All rights reserved.
//

import UIKit
import CommonCrypto

class Checksum: NSObject {

    class func md5HashOf(data: Data) -> String {
        
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            data.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG((data.count)), digestBytes)
            }
        }
        
        var md5 = ""
        for byte in digestData {
            md5 += String(format:"%02x", byte)
        }
        
        return md5
    }

    class func md5HashOf(path: String) -> String {
        
        if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            return md5HashOf(data: data)
        }
        return ""
    }
    

    class func md5HashOf(string: String) -> String {
        
        if let data = string.data(using: .utf8) {
            return md5HashOf(data: data)
        }
        return ""
    }
}
