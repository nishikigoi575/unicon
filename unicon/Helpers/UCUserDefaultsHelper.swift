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
        MatchingViewController.swipedTeamList = ud.array(forKey: "swipedTeams")  as? [String] ?? []
    }
    
    public static func setSwipedTeams() {
        ud.set(MatchingViewController.swipedTeamList, forKey: "swipedTeams")
    }
    
    public static func getMatchedTeams() {
        MatchingViewController.matchedTeamList = ud.array(forKey: "matchedTeams")  as? [String] ?? []
    }
    
    public static func setMatchedTeams() {
        ud.set(MatchingViewController.matchedTeamList, forKey: "matchedTeams")
    }
}
