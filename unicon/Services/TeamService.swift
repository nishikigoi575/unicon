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
