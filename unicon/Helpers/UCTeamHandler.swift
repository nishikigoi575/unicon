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
        let shouldExcludeTeams = getShouldExcludeTeams()
        let excludedTeams = teamList.filter { exclude(teamList: shouldExcludeTeams, uid: $0) }
        return completion(excludedTeams)
    }
    
    private static func getShouldExcludeTeams() -> [String] {
        return MatchingViewController.swipedTeamList + MatchingViewController.matchedTeamList + MatchingViewController.myTeamList
    }
    
    private static func exclude(teamList: [String], uid: String) -> Bool {
        return !teamList.contains(uid)
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
