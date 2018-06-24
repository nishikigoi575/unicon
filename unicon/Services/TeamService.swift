////
////  TeamService.swift
////  unicon
////
////  Created by Imajin Kawabe on 2018/06/19.
////  Copyright © 2018年 Imajin Kawabe. All rights reserved.
////
//
//import Foundation
//import UIKit
//import FirebaseStorage
//
//class TeamService {
//    
//    static func create(for image: UIImage, targetGender: String, teamName: String, teamIntro: String, ownerUID: String,  completion: @escaping (Bool) -> Void) {
//        let imageRef = StorageReference.newPostImageReference()
//        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
//            guard let downloadURL = downloadURL else {
//                return completion(false)
//            }
//            
//            let urlString = downloadURL.absoluteString
//            create(forURLString: urlString, ku1: ku1, ku2: ku2, ku3: ku3, ku123: ku123, kanaKu1: kanaKu1, kanaKu2: kanaKu2, kanaKu3: kanaKu3, kanaKu123: kanaKu123, uid: uid, userID: userID, userImage: userImage, username: username, topic: topic, likeCount: likeCount, topicId: topicId, topicTitle: topicTitle) { success in
//                if success {
//                    completion(true)
//                } else {
//                    completion(false)
//                }
//            }
//        }
//    }
//    
//    
//    private static func create(forURLString urlString: String, targetGeneder: String, teamName: String, teamIntro: String, ownerUID: String, success: @escaping (Bool) -> Void) {
//        guard let currentUser = User.current else { return success(false) }
//        let post = Post(ku1: ku1, ku2: ku2, ku3: ku3, ku123: ku123, kanaKu1: kanaKu1, kanaKu2: kanaKu2, kanaKu3: kanaKu3, kanaKu123: kanaKu123, haiku: urlString, uid: uid,  userID: userID, userImage: userImage, username: username, topic: topic, topicTitle: topicTitle, topicId: topicId, likeCount: likeCount)
//        
//        print(topicId)
//        
//        let rootRef = Firestore.firestore()
//        let newPostRef = rootRef.collection("posts").document()
//        post.postID = newPostRef.documentID
//        // Upload posts
//        rootRef.collection("posts").document(post.postID!).setData(post.dictValue) { error in
//            if let error = error {
//                print("posting error: \(error)")
//                return success(false)
//            } else {
//                let postRefData = ["date": post.date]
//                // Upload myPosts
//                let myPostRef = rootRef.collection("users").document(uid).collection("myPosts").document(post.postID!)
//                myPostRef.setData(postRefData, completion: { err in
//                    if let err = err {
//                        print("fail to upload my posts: \(err)")
//                        return success(false)
//                    } else {
//                        let dispatchGroup = DispatchGroup()
//                        // Upload followingPosts
//                        UserService.followers(for: currentUser.uid) { (followerUIDs) in
//                            for uid in followerUIDs {
//                                let followPostRef = rootRef.collection("users").document(uid).collection("followingPosts").document(post.postID!)
//                                dispatchGroup.enter()
//                                followPostRef.setData(postRefData, completion: { err in
//                                    if let err = err {
//                                        print("fail to upload following posts: \(err)")
//                                        return success(false)
//                                    } else {
//                                        dispatchGroup.leave()
//                                    }
//                                })
//                            }
//                            dispatchGroup.notify(queue: .main, execute: {
//                                if topic {
//                                    let topicPostRef = Firestore.firestore().collection("topics").document(topicId).collection("posts").document(post.postID!)
//                                    
//                                    addPostsNum(topicId: topicId)
//                                    
//                                    topicPostRef.setData(postRefData, completion: { err in
//                                        if let err = err {
//                                            print("ERROR TOPIC POST: \(err)")
//                                            return success(false)
//                                        } else {
//                                            let postRef = rootRef.collection("posts").document(post.postID!)
//                                            postRef.setData(["topicId": topicId], options: SetOptions.merge()) { error in
//                                                if let error = error {
//                                                    assertionFailure(error.localizedDescription)
//                                                    return success(false)
//                                                } else {
//                                                    success(true)
//                                                }
//                                            }
//                                        }
//                                    })
//                                    
//                                } else {
//                                    success(true)
//                                }
//                            })
//                        }
//                    }
//                })
//            }
//        }
//    }
//    
//    
//}
//

import Foundation
import UIKit
import FirebaseStorage
import Firestore
import FirebaseAuth

class TeamService {
    
    
    static func show(forTeamID teamID: String, completion: @escaping (Team?) -> Void) {
        //print(uid)
        let ref = Firestore.firestore().collection("teams").document(teamID)
        ref.getDocument() { (document, err) in
            
            guard let document = document, let team = Team(snapshot: document) else {
                return completion(nil)
            }
            
            completion(team)
        }
    }
    
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
                            UserService.joinTeam(teamID: teamID, userUID: createdBy){ (success) in
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
    
    
    static func searchByTeamID(teamID: String, completion: @escaping (Team?) -> Void) {
        Firestore.firestore().collection("teams").whereField("teamID", isEqualTo: teamID).limit(to: 1)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completion(nil)
                } else {
                    guard querySnapshot?.count == 1 else { return completion(nil) }
                    let document = querySnapshot!.documents[0]
                    TeamService.show(forTeamID: document.documentID) { (team) in
                        guard let team = team else { return completion(nil) }
                        completion(team)
                    }
                }
        }
    }
    
}
