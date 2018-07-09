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
        
        // Current team
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
                    chatRef.setData(["myMember": userUIDs], options: SetOptions.merge()) { err in
                        if let err = err {
                            print(err.localizedDescription)
                            return
                        }
                    }
                })
            }
        }
        
        // Opponent team
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
                    chatRef.setData(["opponentMember": userUIDs], options: SetOptions.merge()) { err in
                        if let err = err {
                            print(err.localizedDescription)
                            return
                        }
                    }
                })
            }
        }
        
    }
}
