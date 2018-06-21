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
    
    static func create(teamName: String, teamGender: String, targetGender: String, teamImage: UIImage, intro: String, completion: @escaping (Team?, Bool) -> Void) {
        let imageRef = StorageReference.newTeamImageReference(teamName: teamName)
        StorageService.uploadImage(teamImage, at: imageRef) { (downloadURL) in
            guard let url = downloadURL else {
                return completion(nil,false)
            }
            
            guard let userUID = Auth.auth().currentUser?.uid else {
                return completion(nil,false)
            }
            
            let urlStr = url.absoluteString
            
            
            create(createdBy: userUID, urlStr: urlStr, teamName: teamName, teamGender: teamGender, targetGender: targetGender, intro: intro) { (team, successed) in
                if successed {
                    return completion(team, true)
                } else {
                    return completion(nil, false)
                }
            }
            
        }
    }
    
    private static func create(createdBy: String,urlStr: String, teamName: String, teamGender: String, targetGender: String, intro: String, successed: @escaping (Team?, Bool) -> Void){
        
        
        let rootRef = Firestore.firestore()
        let newTeamRef = rootRef.collection("teams").document()
        let teamID = newTeamRef.documentID
        
        let team = Team(teamName: teamName, teamGender: teamGender, targetGender: targetGender, numOfMembers: 1, teamImage: urlStr, intro: intro, teamID: teamID, createdBy: createdBy)
        
        rootRef.collection("teams").document(teamID).setData(team.dictValue) { error in
            if let error = error {
                print("Failed to create a team\(error.localizedDescription)")
                return successed(nil, false)
            } else {
                
                rootRef.collection("teams").document(teamID).getDocument() { (document, err) in
                    if let document = document {
                        print("Document data: ここなのか \(document.data())")
                        if let team = Team(snapshot: document) {
                            UserService.join(teamID: teamID, createdBy: createdBy){ (success) in
                                if success {
                                    print("yay")
                                    return successed(team, true)
                                } else {
                                    print("fuck")
                                    return successed(nil, false)
                                }
                            }
                        } else {
                            print("are")
                        }
                        
                    } else {
                        print("Document does not exist")
                        successed(nil, false)
                    }
                }
                
            }
        }
        
    }
    
}
