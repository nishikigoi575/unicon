//
//  UserHelper.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/06/21.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import Foundation

class UserHelper {
    
    // get highres pic from facebook
    
    static func getPicUrlFromFacebook(facebookID: String, size: Int) -> URL {
        
        if let url = URL(string: "https://graph.facebook.com/\(facebookID)/picture?height=\(size)") {
            return url
        } else {
            return URL(string: "https://picsum.photos/\(size)/\(size)")!
        }
    }
    
}
