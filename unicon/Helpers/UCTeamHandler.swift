//
//  UCTeamHandler.swift
//  unicon
//
//  Created by yo hanashima on 2018/07/06.
//  Copyright © 2018 Imajin Kawabe. All rights reserved.
//

import Foundation

class UCTeamHandler {
    
    public static func excludeTeams(teamList: [String], completion: @escaping ([String]) -> Void) {
        let excludedSwiped = teamList.filter { excludeSwipedTeam(uid: $0) }
        let excludedSwipedNMatched = excludedSwiped.filter { excludeMatchedTeam(uid: $0) }
        return completion(excludedSwipedNMatched)
    }
    
    private static func excludeSwipedTeam(uid: String) -> Bool {
        return !MatchingViewController.swipedTeamList.contains(uid)
    }
    
    private static func excludeMatchedTeam(uid: String) -> Bool {
        return !MatchingViewController.matchedTeamList.contains(uid)
    }
    
    public static func sliceTeamList(teamList: [String], startIndex: Int, size: Int, completion: @escaping ([String]) -> Void){
        guard teamList.count > startIndex else { return completion([]) }
        if teamList.count < startIndex+size {
            let range = startIndex ..< teamList.count
            let slicedTeamList = range.map { (i) -> String in
                return teamList[i]
            }
            return completion(slicedTeamList)
        } else {
            let range = startIndex ..< startIndex+size
            let slicedTeamList = range.map { (i) -> String in
                return teamList[i]
            }
            return completion(slicedTeamList)
        }
    }
    
    public static func updateSwipedTeamList(uid: String) {
        MatchingViewController.swipedTeamList.append(uid)
        if MatchingViewController.swipedTeamList.count > MatchingViewController.numOfStoreSwipedTeams {
            MatchingViewController.swipedTeamList.removeLast()
        }
    }
}
