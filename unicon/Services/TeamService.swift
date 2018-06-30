//
//  TeamService.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/06/19.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import Firestore
import FirebaseAuth

class TeamService {
    
    static func show(forTeamID teamID: String, completion: @escaping (Team?) -> Void) {
        //print(uid)
        let ref = Firestore.firestore().collection("teams").document(teamID)
        ref.getDocument() { (document, err) in
            
            guard let document = document, let team = Team(snapshot: document) else {
                return completion(nil)
            }
            completion(team)
        }
    }
    
    static func create(teamName: String, teamGender: String, targetGender: String, teamImage: UIImage, intro: String, completion: @escaping (Team?) -> Void) {
        let imageRef = StorageReference.newTeamImageReference(teamName: teamName)
        StorageService.uploadImage(teamImage, at: imageRef) { (downloadURL) in
            guard let url = downloadURL else { return completion(nil) }
            guard let userUID = Auth.auth().currentUser?.uid else { return completion(nil) }
            
            let urlStr = url.absoluteString
            
            create(createdBy: userUID, urlStr: urlStr, teamName: teamName, teamGender: teamGender, targetGender: targetGender, intro: intro) { (team) in
                if let team = team {
                    Team.setCurrent(team, writeToUserDefaults: true)
                    return completion(team)
                } else {
                    return completion(nil)
                }
            }
        }
    }
    
    private static func create(createdBy: String,urlStr: String, teamName: String, teamGender: String, targetGender: String, intro: String, completion: @escaping (Team?) -> Void){
        
        let rootRef = Firestore.firestore()
        let newTeamRef = rootRef.collection("teams").document()
        let teamID = newTeamRef.documentID
        
        let team = Team(teamName: teamName, teamGender: teamGender, targetGender: targetGender, numOfMembers: 1, teamImageURL: urlStr, intro: intro, teamID: teamID, createdBy: createdBy)
        
        rootRef.collection("teams").document(teamID).setData(team.dictValue) { error in
            if let error = error {
                print("Failed to create a team\(error.localizedDescription)")
                return completion(nil)
            } else {
                UserService.joinTeam(teamID: team.teamID, userUID: team.createdBy){ (success) in
                    if success {
                        return completion(team)
                    } else {
                        return completion(nil)
                    }
                }
            }
        }
    }
    
    
    static func searchByTeamID(teamID: String, completion: @escaping (Team?) -> Void) {
        Firestore.firestore().collection("teams").whereField("teamID", isEqualTo: teamID).limit(to: 1)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completion(nil)
                } else {
                    guard querySnapshot?.count == 1 else { return completion(nil) }
                    let document = querySnapshot!.documents[0]
                    TeamService.show(forTeamID: document.documentID) { (team) in
                        guard let team = team else { return completion(nil) }
                        completion(team)
                    }
                }
        }
    }
    
    static func myTeams(pageSize: UInt, numOfObjects: Int = 0, keyUID: String?, completion: @escaping ([Team]?) -> Void) {
        
        guard let userUID = keyUID  else {
            print("あれれ")
            return completion([])
        }
        
        let teamRef = Firestore.firestore().collection("users").document(userUID).collection("teams")
        
        teamRef.getDocuments{ (snapshot, error) in
            guard let snapshot = snapshot else {
                print("ERROR RECEIVING MY TEAMS")
                return completion([])
            }
            
            let dispatchGroup = DispatchGroup()
            
            var teams = [Team]()
            for teamSnap in snapshot.documents {
                
                guard let teamDict = teamSnap.data() as? [String: Any]
                    else { continue }
                dispatchGroup.enter()
                
                TeamService.show(forTeamID: teamSnap.documentID) { (team) in
                    if let team = team {
                        teams.append(team)
                        dispatchGroup.leave()
                    }
                }
            }
            dispatchGroup.notify(queue: .main, execute: {
                completion(teams)
            })
            
        }
        
    }
    
    static func allTeams(pageSize: UInt, numOfObjects: Int = 0, keyUID: String?, completion: @escaping ([Team]) -> Void) {
        let teamRef = Firestore.firestore().collection("teams")
        UCPaginationTeamHelper.paginationTeam(pageSize: pageSize, numOfObjects: numOfObjects, ref: teamRef) { (teams) in
            completion(teams)
        }
    }
    
    static func getFive(completion: @escaping ([Team]?) -> Void) {
        let ref = Firestore.firestore().collection("teams").limit(to: 5)
        ref.getDocuments{ (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error retreving posts: \(error.debugDescription)")
                return completion([])
            }
            let dispatchGroup = DispatchGroup()
            
            var teams = [Team]()
            for teamSnap in snapshot.documents {
                guard let teamDict = teamSnap.data() as? [String: Any]
                    else { continue }
                
                dispatchGroup.enter()
                TeamService.show(forTeamID: teamSnap.documentID) { (team) in
                    if let team = team {
                        teams.append(team)
                        dispatchGroup.leave()
                    }
                }
            }
            dispatchGroup.notify(queue: .main, execute: {
                completion(teams)
            })
        }
        
    }
    
}
