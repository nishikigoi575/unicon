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
    
    static func create(for team: Team, success: @escaping (Bool) -> Void) {
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
                    ref.setData(["lastActiveDate": Date(), "isActive": false]) { error in
                        if let error = error {
                            assertionFailure(error.localizedDescription)
                            return success(false)
                        } else {
                            print("membersA done")
                        }
                        
                    }
                }
                // Opponent team (MembersB)
                TeamService.getTeamMembers(teamUID: team.teamID) { member in
                    if let membersB = member {
                        for user in membersB {
                            let ref = rootRef.document(user.userUID).collection("chatRooms").document(chatRoomUID)
                            ref.setData(["lastActiveDate": Date(), "isActive": false]) { error in
                                if let error = error {
                                    assertionFailure(error.localizedDescription)
                                    return success(false)
                                } else {
                                    print("membersB done")
                                }
                            }
                        }
                        
                        let userAUIDs = membersA.map { $0.userUID }
                        let userBUIDs = membersB.map { $0.userUID }
                        
                        let chatRoom = ChatRoom(uid: chatRoomUID, myTeamUID: currentTeamUID, opponentTeamUID: team.teamID, myMembers: userAUIDs, opponentMembers: userBUIDs, myTeamName: currentTeam.teamName, myTeamImageURL: currentTeam.teamImageURL, opponentTeamName: team.teamName, opponentTeamImageURL: team.teamImageURL, numOfMembers: userAUIDs.count+userBUIDs.count)
                        chatRef.setData(chatRoom.dictValue, options: SetOptions.merge()) { err in
                            if let err = err {
                                print(err.localizedDescription)
                                return success(false)
                            } else {
                                print("success chat room")
                                return success(true)
                            }
                        }
                    } else {
                        print("no memberB")
                        return success(false)
                    }
                }
            } else {
                print("no memberA")
                return success(false)
            }
        }
    }
    
    static func update(room: ChatRoom, dict: [String: Any], success: @escaping (Bool) -> Void) {
        let ref = Firestore.firestore().collection("chat").document(room.uid)
        ref.updateData(dict) { error in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            } else {
                let dic = ["lastActiveDate": Date()]
                ChatRoomService.updateMembersRooms(room: room, dict: dic) { suc in
                    return success(suc)
                }
            }
        }
    }
    
    static func updateMembersRooms(room: ChatRoom, dict: [String: Any], success: @escaping (Bool) -> Void) {
        let rootRef = Firestore.firestore().collection("users")
        let memberUIDs = room.myMembers + room.opponentMembers
        let dispatchGroup = DispatchGroup()
        for memberUID in memberUIDs {
            dispatchGroup.enter()
            let ref = rootRef.document(memberUID).collection("chatRooms").document(room.uid)
            ref.updateData(dict) { error in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    return success(false)
                } else {
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .main, execute: {
            return success(true)
        })
    }
    
    static func getChatRooms(pageSize: UInt, numOfObjects: Int = 0, keyUID: String?, completion: @escaping ([ChatRoom]) -> Void) {
        guard let currenUserUID = User.current?.userUID else { return completion([]) }
        let ref = Firestore.firestore().collection("users").document(currenUserUID).collection("chatRooms").whereField("isActive", isEqualTo: true).order(by: "lastActiveDate", descending: true)
        if numOfObjects > 0 {
            print("room pagination next")
            let first = ref.limit(to: numOfObjects)
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
            let query = ref.limit(to: Int(pageSize))
            query.getDocuments{ (snapshot, error) in
                guard let snapshot = snapshot else {
                    print("Error retreving posts: \(error.debugDescription)")
                    return completion([])
                }
                let dispatchGroup = DispatchGroup()
                print("HOGEJPEGOJPEHGPJE`J`JE")
                var rooms = [ChatRoom]()
                for roomSnap in snapshot.documents {
                    guard let roomDict = roomSnap.data() as? [String: Any]
                        else { continue }
                    
                    dispatchGroup.enter()
                    ChatRoomService.show(roomUID: roomSnap.documentID) { (room) in
                        if let room = room {
                            print(room.uid)
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
}
