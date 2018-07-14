//
//  MatchService.swift
//  unicon
//
//  Created by yo hanashima on 2018/07/10.
//  Copyright © 2018 Imajin Kawabe. All rights reserved.
//

import Foundation
import Firestore

struct MatchService {
    static func create(for team: Team, success: @escaping (Bool) -> Void) {
        guard let currentTeam = Team.current else { return success(false) }
        let currentTeamUID = currentTeam.teamID
        
        // make a batch
        let batch = Firestore.firestore().batch()
        let teamsRef = Firestore.firestore().collection("teams")
        let curRef = teamsRef.document(currentTeamUID).collection("matchedTeams").document(team.teamID)
        batch.setData(["date": Date()], forDocument: curRef)
        
        let opnRef = teamsRef.document(team.teamID).collection("matchedTeams").document(currentTeamUID)
        batch.setData(["date": Date()], forDocument: opnRef)
        
        // Commit the batch
        batch.commit() { err in
            if let err = err {
                print("Error writing match batch \(err)")
                success(false)
            } else {
                print("Match batch write succeeded.")
                MatchingViewController.matchedTeamList.append(team.teamID)
                UCUserDefaultsHelper.setMatchedTeams()
                UCUserDefaultsHelper.getMatchedTeams()
                success(true)
            }
        }
    }
    
    static func getNewMatches(pageSize: UInt, numOfObjects: Int = 0, keyUID: String?, completion: @escaping ([ChatRoom]) -> Void) {
        guard let currenUserUID = User.current?.userUID else { return completion([]) }
        let ref = Firestore.firestore().collection("users").document(currenUserUID).collection("chatRooms").whereField("isActive", isEqualTo: false).order(by: "lastActiveDate", descending: true)
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
                        rooms.sort(by: {$0.lastDate! < $1.lastDate!})
                        completion(rooms)
                    })
                }
            }
        } else {
            print("room pagination initial")
            let query = ref.limit(to: Int(pageSize))
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
                    rooms.sort(by: {$0.lastDate! < $1.lastDate!})
                    completion(rooms)
                })
            }
        }
    }
}
