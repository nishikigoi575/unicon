//
//  TeamService.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/06/19.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import Firestore

class TeamService {
    
    static func create(for image: UIImage, targetGender: String, teamName: String, teamIntro: String, ownerUID: String,  completion: @escaping (Bool) -> Void) {
        let imageRef = StorageReference.newPostImageReference()
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return completion(false)
            }
            
            let urlString = downloadURL.absoluteString
            create(forURLString: urlString, ku1: ku1, ku2: ku2, ku3: ku3, ku123: ku123, kanaKu1: kanaKu1, kanaKu2: kanaKu2, kanaKu3: kanaKu3, kanaKu123: kanaKu123, uid: uid, userID: userID, userImage: userImage, username: username, topic: topic, likeCount: likeCount, topicId: topicId, topicTitle: topicTitle) { success in
                if success {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    
    
}

