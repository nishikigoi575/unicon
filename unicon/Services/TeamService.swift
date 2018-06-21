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
import FirebaseAuth

class TeamService {
    
    static func create(teamName: String, teamGender: String, targetGender: String, teamImage: UIImage, intro: String, completion: @escaping (Bool) -> Void) {
        let imageRef = StorageReference.newTeamImageReference(teamName: teamName)
        StorageService.uploadImage(teamImage, at: imageRef) { (downloadURL) in
            guard let url = downloadURL else {
                return completion(false)
            }
            
            guard let userUID = Auth.auth().currentUser?.uid else {
                return completion(false)
            }
            
            let urlStr = url.absoluteString
            
            
            create(createdBy: userUID, urlStr: urlStr, teamName: teamName, teamGender: teamGender, targetGender: targetGender, intro: intro) { (successed) in
                if successed {
                    return completion(true)
                } else {
                    return completion(false)
                }
            }
            
        }
    }
    
    private static func create(createdBy: String,urlStr: String, teamName: String, teamGender: String, targetGender: String, intro: String, successed: @escaping (Bool) -> Void){
        
        
        let rootRef = Firestore.firestore()
        let newTeamRef = rootRef.collection("teams").document()
        let teamID = newTeamRef.documentID
        
        let team = Team(teamName: teamName, teamGender: teamGender, targetGender: targetGender, numOfMembers: 1, teamImage: urlStr, intro: intro, teamID: teamID, createdBy: createdBy)
        
        rootRef.collection("teams").document(teamID).setData(team.dictValue) { error in
            if let error = error {
                print("Failed to create a team\(error.localizedDescription)")
                return successed(false)
            } else {
                
                guard let user = Auth.auth().currentUser else {
                    return successed(false)
                }
                
                UserService.join(teamID: teamID, createdBy: user.uid){ (success) in
                    
                    if success {
                        return successed(true)
                    } else {
                        return successed(false)
                    }
                    
                }
            }
        }
        
    }
    
}
