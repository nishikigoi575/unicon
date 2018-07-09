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
    
}
