//
//  RefactorDB.swift
//  unicon
//
//  Created by yo hanashima on 2018/07/10.
//  Copyright © 2018 Imajin Kawabe. All rights reserved.
//

import Foundation
import Firestore

class RefactorDB {
    static func setUDMyTeam() {
        guard let currentUser = User.current else { return }
        TeamService.myTeams(keyUID: currentUser.userUID) { teams in
            if let teams = teams {
                let dispatchGroup = DispatchGroup()
                for team in teams {
                    dispatchGroup.enter()
                    MatchingViewController.myTeamList.append(team.teamID)
                    dispatchGroup.leave()
                }
                dispatchGroup.notify(queue: .main, execute: {
                    UCUserDefaultsHelper.setMyTeams()
                })
            }
        }
    }
    
    static func setTeamList() {
        let ref = Firestore.firestore().collection("teams")
        let listRef = Firestore.firestore().collection("teamList")
        
        ref.getDocuments() { (snapshot, err) in
            guard let snapshot = snapshot else { return }
            let dispatchGroup = DispatchGroup()
            for dc in snapshot.documents {
                dispatchGroup.enter()
                let r = listRef.document(dc.documentID)
                r.getDocument() { (document, err) in
                    if document?.exists ?? false {
                        dispatchGroup.leave()
                    } else {
                        if let date = dc["date"] {
                            r.setData(["lastLoginDate": date]) { err in
                                dispatchGroup.leave()
                            }
                        } else {
                            print(dc.documentID)
                            dispatchGroup.leave()
                        }
                    }
                }
            }
            
        }
    }
}
