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
}
