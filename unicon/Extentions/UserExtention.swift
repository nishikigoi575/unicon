//
//  UserExtention.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/06/17.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import Foundation
import FirebaseAuth

extension User {
    
    enum LoginType {
        case anonymous
        case email
        case facebook
        case google
        case unknown
    }
    
    var loginType: LoginType {
        if isAnonymous { return .anonymous }
        for userInfo in providerData {
            switch userInfo.providerID {
            case FacebookAuthProviderID: return .facebook
            case GoogleAuthProviderID  : return .google
            case EmailAuthProviderID   : return .email
            default                    : break
            }
        }
        return .unknown
    }
    
    enum ImageResolution {
        case thumbnail
        case highres
        case custom(size: UInt)
    }
    
    var facebookUserId : String? {
        for userInfo in providerData {
            switch userInfo.providerID {
            case FacebookAuthProviderID: return userInfo.uid
            default                    : break
            }
        }
        return nil
    }
    
    
    func urlForProfileImageFor(imageResolution: ImageResolution) -> URL? {
        switch imageResolution {
        //for thumnail we just return the std photoUrl
        case .thumbnail         : return photoURL
        //for high res we use a hardcoded value of 1024 pixels
        case .highres           : return urlForProfileImageFor(imageResolution:.custom(size: 1024))
        //custom size is where the user specified its own value
        case .custom(let size)  :
            switch loginType {
            //for facebook we assemble the photoUrl based on the facebookUserId via the graph API
            case .facebook :
                guard let facebookUserId = facebookUserId else { return photoURL }
                return URL(string: "https://graph.facebook.com/\(facebookUserId)/picture?height=\(size)")
            //for google the trick is to replace the s96-c with our own requested size...
            case .google   :
                guard var url = photoURL?.absoluteString else { return photoURL }
                url = url.replacingOccurrences(of: "/s96-c/", with: "/s\(size)-c/")
                return URL(string:url)
            //all other providers we do not support anything special (yet) so return the standard photoURL
            default        : return photoURL
            }
        }
    }
    
}
