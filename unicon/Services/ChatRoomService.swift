//
//  ChatRoomService.swift
//  unicon
//
//  Created by yo hanashima on 2018/07/10.
//  Copyright © 2018 Imajin Kawabe. All rights reserved.
//

import Foundation
import Firestore

struct ChatRoomService {
    static func create(for team: Team) {
        guard let currentUser = User.current else { return }
        guard let currentTeam = Team.current else { return }
        let currentTeamUID = currentTeam.teamID
        let rootRef = Firestore.firestore().collection("users")
        
        // Current user
        let chatRoomRef = rootRef.document(currentUser.userUID).collection("chatRooms").document()
        let chatRoomUID = chatRoomRef.documentID
        let chatRef = Firestore.firestore().collection("chat").document(chatRoomUID)
        
        // Current team (MembersA)
        TeamService.getTeamMembers(teamUID: currentTeamUID) { members in
            if let members = members {
                var userUIDs = [String]()
                let dispatchGroup = DispatchGroup()
                for user in members {
                    dispatchGroup.enter()
                    let ref = rootRef.document(user.userUID).collection("chatRooms").document(chatRoomUID)
                    ref.setData(["lastActiveDate": Date()]) { error in
                        if let error = error {
                            assertionFailure(error.localizedDescription)
                            return
                        }
                        userUIDs.append(user.userUID)
                        dispatchGroup.leave()
                    }
                }
                dispatchGroup.notify(queue: .main, execute: {
                    chatRef.setData(["TeamA": currentTeamUID, "MembersA": userUIDs], options: SetOptions.merge()) { err in
                        if let err = err {
                            print(err.localizedDescription)
                            return
                        }
                    }
                })
            }
        }
        
        // Opponent team (MembersB)
        TeamService.getTeamMembers(teamUID: team.teamID) { members in
            if let members = members {
                var userUIDs = [String]()
                let dispatchGroup = DispatchGroup()
                for user in members {
                    dispatchGroup.enter()
                    let ref = rootRef.document(user.userUID).collection("chatRooms").document(chatRoomUID)
                    ref.setData(["lastActiveDate": Date()]) { error in
                        if let error = error {
                            assertionFailure(error.localizedDescription)
                            return
                        }
                        userUIDs.append(user.userUID)
                        dispatchGroup.leave()
                    }
                }
                dispatchGroup.notify(queue: .main, execute: {
                    chatRef.setData(["TeamB": team.teamID, "MembersB": userUIDs], options: SetOptions.merge()) { err in
                        if let err = err {
                            print(err.localizedDescription)
                            return
                        }
                    }
                })
            }
        }
    }
    
    static func addNumOfMembers(chatRoomUID: String, num: Int) {
        let ref = Firestore.firestore().collection("chat").document(chatRoomUID)
        ref.setData(["numOfMembers": num], options: SetOptions.merge()) { err in
            if let err = err {
                print(err.localizedDescription)
                return
            }
        }
    }
    
    static func getLastMessage(chatRoomUID: String, completion: @escaping (String?) -> Void) {
        let ref = Firestore.firestore().collection("chat").document(chatRoomUID).collection("messages")
        ref.order(by: "date", descending: true).limit(to: 1).getDocuments() { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error retreving posts: \(error.debugDescription)")
                return completion(nil)
            }
            let dict = snapshot.documents[0].data()
            if let msg = dict["message"] as? String {
                return completion(msg)
            } else {
                return completion(nil)
            }
        }
    }
}
