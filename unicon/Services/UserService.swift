//
//  UserService.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/06/21.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import Firestore
import Firestore.FIRDocumentSnapshot

typealias FIRUser = FirebaseAuth.User

struct UserService {
    
    static func show(forUserUID userUID: String, completion: @escaping (User?) -> Void) {
        //print(uid)
        let ref = Firestore.firestore().collection("users").document(userUID)
        ref.getDocument() { (document, err) in
            
            guard let document = document, let user = User(document: document) else {
                return completion(nil)
            }
            completion(user)
        }
    }
    
    static func signIn(_ firUser: FIRUser, firstName: String, userImage: URL, facebookID: String,  completion: @escaping (User?) -> Void) {
        
        let userImage = userImage.absoluteString
        
        // gender, age, area に関してはFacebookのアプリレビューが必要ならしいからとりあえずやめておいた。
        let userAttrs = ["firstName": firstName, "userImage": userImage, "userUID": firUser.uid, "facebookID": facebookID, "age": 20, "area": "Tokyo", "gender": "male"] as [String : Any]
        
        let ref = Firestore.firestore().collection("users").document(firUser.uid)
        
        
        ref.setData(userAttrs, options: SetOptions.merge()) { error in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.getDocument() { (document, err) in
                if let document = document {
                    print("Document data: \(document.data())")
                    if let user = User(document: document) {
                        print("User created")
                        completion(user)
                    } else {
                        print("User created foojfhaodhfoair")
                    }
                } else {
                    print("Document does not exist")
                    completion(nil)
                }
            }
        }
    }
    
    static func addPushID(userUID: String, pushID: String, success: @escaping (Bool) -> Void) {
        Firestore.firestore().collection("users").document(userUID).setData(["pushID": pushID], options: SetOptions.merge()) {
            err in
            if let err = err {
                print(err.localizedDescription)
                return success(false)
            } else {
                success(true)
            }
        }
    }
    
    static func joinTeam(teamID: String, userUID: String , success: @escaping (Bool) -> Void) {
        let rootRef = Firestore.firestore()
        let teamRef = rootRef.collection("teams").document(teamID).collection("members").document(userUID)
        let userRef = rootRef.collection("users").document(userUID)
        let batch = Firestore.firestore().batch()
        
        // First, get the user data
        userRef.getDocument() { (doc, err) in
            if let doc = doc {
                if let user = User(document: doc), let facebookID = user.facebookID {
                    let userDict = [
                        "firstName": user.firstName, "userImage": user.userImage, "userUID": userUID, "facebookID": facebookID, "age": 20, "area": "Tokyo", "gender": "male"] as [String : Any
                    ]
                    
                    batch.setData(userDict, forDocument: teamRef, options: SetOptions.merge())
                    
                    let teamData = ["teamID": teamID, "joined": Date()] as [String : Any]
                    let myTeamsRef = userRef.collection("teams").document(teamID)
                    batch.setData(teamData, forDocument: myTeamsRef, options: SetOptions.merge())
                    
                    batch.setData(["belongsToTeam": true], forDocument: userRef, options: SetOptions.merge())
                    
                    batch.commit() { err in
                        if let err = err {
                            print("Error writing batch \(err)")
                            success(false)
                        } else {
                            print("Batch write succeeded.")
                            success(true)
                        }
                    }
                    
                } else {
                    success(false)
                }
            } else {
                success(false)
            }
        }
        
    }
    
    
    
    
    
}
