//
//  LikeService.swift
//  unicon
//
//  Created by yo hanashima on 2018/07/09.
//  Copyright © 2018 Imajin Kawabe. All rights reserved.
//

import Foundation
import Firestore

struct LikeService {
    static func create(for team: Team, success: @escaping (Bool) -> Void) {
        
        guard let currentTeam = Team.current else { return success(false) }
        
        let currentTeamUID = currentTeam.teamID
        let db = Firestore.firestore()
        let ref = db.collection("likes").document(currentTeamUID).collection("likingTeams").document(team.teamID)
        
        ref.setData(["date": Date()]) { error in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            } else {
                return success(true)
            }
        }
    }
    
    static func delete(for team: Team, success: @escaping (Bool) -> Void) {
        
        guard let currentTeam = Team.current else { return success(false) }
        
        let currentTeamUID = currentTeam.teamID
        let db = Firestore.firestore()
        let ref = db.collection("likes").document(team.teamID).collection("likingTeams").document(currentTeamUID)
        
        ref.delete() { error in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            } else {
                return success(true)
            }
        }
    }
    
    static func isTeamLiking(_ team: Team, byCurrentUserWithCompletion completion: @escaping (Bool) -> Void) {
        
        guard let currentTeamUID = Team.current?.teamID else { return }
        
        let ref = Firestore.firestore().collection("likes").document(team.teamID).collection("likingTeams").document(currentTeamUID)
        ref.getDocument() { (document, err) in
            if document?.exists ?? false {
                // liked
                if let _ = document?.data() {
                    completion(true)
                // not liked
                } else {
                    completion(false)
                }
            // not liked
            } else {
                completion(false)
            }
        }
    }
}
