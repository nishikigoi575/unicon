//
//  UCUserdefaultsHelper.swift
//  unicon
//
//  Created by yo hanashima on 2018/07/06.
//  Copyright © 2018 Imajin Kawabe. All rights reserved.
//

import Foundation

class UCUserDefaultsHelper {
    static let ud = UserDefaults.standard
    
    public static func getSwipedTeams() {
        if let teamID = Team.current?.teamID {
            let key = teamID + "swipedTeams"
            MatchingViewController.swipedTeamList = ud.array(forKey: key)  as? [String] ?? []
        }
    }
    
    public static func setSwipedTeams() {
        if let teamID = Team.current?.teamID {
            let key = teamID + "swipedTeams"
            ud.set(MatchingViewController.swipedTeamList, forKey: key)
        }
    }
    
    public static func getMatchedTeams() {
        if let teamID = Team.current?.teamID {
            let key = teamID + "matchedTeams"
            MatchingViewController.matchedTeamList = ud.array(forKey: key)  as? [String] ?? []
        }
    }
    
    public static func setMatchedTeams() {
        if let teamID = Team.current?.teamID {
            let key = teamID + "matchedTeams"
            ud.set(MatchingViewController.matchedTeamList, forKey: key)
        }
    }
}
