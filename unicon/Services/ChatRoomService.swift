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
    static func show(roomUID: String, completion: @escaping (ChatRoom?) -> Void) {
        let ref = Firestore.firestore().collection("chat").document(roomUID)
        ref.getDocument() { (document, err) in
            guard let document = document, let room = ChatRoom(document: document) else {
                return completion(nil)
            }
            completion(room)
        }
    }
    
    static func create(for team: Team) {
        guard let currentUser = User.current else { return }
        guard let currentTeam = Team.current else { return }
        let currentTeamUID = currentTeam.teamID
        let rootRef = Firestore.firestore().collection("users")
        
        // Get chat room uid
        let chatRoomRef = rootRef.document(currentUser.userUID).collection("chatRooms").document()
        let chatRoomUID = chatRoomRef.documentID
        let chatRef = Firestore.firestore().collection("chat").document(chatRoomUID)
        
        // Current team (MembersA)
        TeamService.getTeamMembers(teamUID: currentTeamUID) { member in
            if let membersA = member {
                for user in membersA {
                    let ref = rootRef.document(user.userUID).collection("chatRooms").document(chatRoomUID)
                    ref.setData(["lastActiveDate": Date()]) { error in
                        if let error = error {
                            assertionFailure(error.localizedDescription)
                            return
                        }
                        
                    }
                }
                // Opponent team (MembersB)
                TeamService.getTeamMembers(teamUID: team.teamID) { member in
                    if let membersB = member {
                        for user in membersB {
                            let ref = rootRef.document(user.userUID).collection("chatRooms").document(chatRoomUID)
                            ref.setData(["lastActiveDate": Date()]) { error in
                                if let error = error {
                                    assertionFailure(error.localizedDescription)
                                    return
                                }
                            }
                        }
                        
                        let userAUIDs = membersA.map { $0.userUID }
                        let userBUIDs = membersB.map { $0.userUID }
                        
                        let chatRoom = ChatRoom(uid: chatRoomUID, myTeamUID: currentTeamUID, opponentTeamUID: team.teamID, myMembers: userAUIDs, opponentMembers: userBUIDs, myTeamName: currentTeam.teamName, myTeamImageURL: currentTeam.teamImageURL, opponentTeamName: team.teamName, opponentTeamImageURL: team.teamImageURL, numOfMembers: userAUIDs.count+userBUIDs.count)
                        chatRef.setData(chatRoom.dictValue, options: SetOptions.merge()) { err in
                            if let err = err {
                                print(err.localizedDescription)
                                return
                            }
                        }
                    }
                }
            }
        }
    }
    
    static func update(roomUID: String, key: String, value: Any, success: @escaping (Bool) -> Void) {
        let ref = Firestore.firestore().collection("chat").document(roomUID)
        ref.updateData([key: value]) { error in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            } else {
                return success(true)
            }
        }
    }
    
    static func getChatRooms(pageSize: UInt, numOfObjects: Int = 0, keyUID: String?, completion: @escaping ([ChatRoom]) -> Void) {
        guard let currenUserUID = User.current?.userUID else { return completion([]) }
        let ref = Firestore.firestore().collection("users").document(currenUserUID).collection("chatRooms")
        if numOfObjects > 0 {
            print("room pagination next")
            let first = ref.order(by: "lastActiveDate", descending: true).limit(to: numOfObjects)
            first.getDocuments {(snapshot, error) in
                guard let snapshot = snapshot else {
                    print("Error retreving price: \(error.debugDescription)")
                    return completion([])
                }
                
                guard let lastSnapshot = snapshot.documents.last else {
                    return completion([])
                }
                
                let next = ref.start(afterDocument: lastSnapshot).limit(to: Int(pageSize))
                next.getDocuments { (nextSnapshot, error) in
                    guard let nextSnapshot = nextSnapshot else {
                        print("Error : \(error.debugDescription)")
                        return completion([])
                    }
                    let dispatchGroup = DispatchGroup()
                    
                    var rooms = [ChatRoom]()
                    for roomSnap in nextSnapshot.documents {
                        guard let roomDict = roomSnap.data() as? [String: Any]
                            else { continue }
                        
                        dispatchGroup.enter()
                        
                        ChatRoomService.show(roomUID: roomSnap.documentID) { (room) in
                            if let room = room {
                                rooms.append(room)
                                dispatchGroup.leave()
                            }
                        }
                    }
                    dispatchGroup.notify(queue: .main, execute: {
                        rooms.sort(by: {$0.lastDate! > $1.lastDate!})
                        completion(rooms)
                    })
                }
            }
        } else {
            print("pagination initial")
            let query = ref.order(by: "lastActiveDate", descending: true).limit(to: Int(pageSize))
            query.getDocuments{ (snapshot, error) in
                guard let snapshot = snapshot else {
                    print("Error retreving posts: \(error.debugDescription)")
                    return completion([])
                }
                let dispatchGroup = DispatchGroup()
                
                var rooms = [ChatRoom]()
                for roomSnap in snapshot.documents {
                    guard let roomDict = roomSnap.data() as? [String: Any]
                        else { continue }
                    
                    dispatchGroup.enter()
                    ChatRoomService.show(roomUID: roomSnap.documentID) { (room) in
                        if let room = room {
                            rooms.append(room)
                            dispatchGroup.leave()
                        }
                    }
                }
                dispatchGroup.notify(queue: .main, execute: {
                    rooms.sort(by: {$0.lastDate! > $1.lastDate!})
                    completion(rooms)
                })
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
            if snapshot.count > 0 {
                let dict = snapshot.documents[0].data()
                if let msg = dict["message"] as? String {
                    return completion(msg)
                } else {
                    return completion(nil)
                }
            } else {
                return completion(nil)
            }
        }
    }
}
