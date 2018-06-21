//
//  Team.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/06/21.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import Foundation
import UIKit
import Firestore.FIRDocumentSnapshot

class Team{
    var teamName: String
    var teamGender: String
    var targetGender: String
    var numOfMembers: Int
    var teamImage: String
    var intro: String?
    var teamID: String
    var createdBy: String
    
    
    init(teamName: String, teamGender: String, targetGender: String, numOfMembers: Int, teamImage: String, intro: String, teamID: String, createdBy: String) {
        
        self.teamName = teamName
        self.teamGender = teamGender
        self.targetGender = targetGender
        self.numOfMembers = numOfMembers
        self.teamImage = teamImage
        self.intro = intro
        self.teamID = teamID
        self.createdBy = createdBy
        
    }
    
    init?(snapshot: DocumentSnapshot) {
        guard let dictionary = snapshot.data() as? [String : Any],
            let teamName = dictionary["teamName"] as? String,
            let teamGender = dictionary["teamGender"] as? String,
            let targetGender = dictionary["targetGender"] as? String,
            let numOfMembers = dictionary["numOfMembers"] as? Int,
            let teamImage = dictionary["teamImage"] as? String,
            let teamID = dictionary["teamID"] as? String,
            let createdBy = dictionary["createdBy"] as? String
        else {return nil}
        
        self.teamName = teamName
        self.teamGender = teamGender
        self.targetGender = targetGender
        self.numOfMembers = numOfMembers
        self.teamImage = teamImage
        self.teamID = teamID
        self.createdBy = createdBy
        
        if let intro = dictionary["intro"] as? String {
            self.intro = intro
        }
        
        
    }
    
    var dictValue: [String : Any] {
        return [
            "teamName":teamName,
            "teamGender":teamGender,
            "targetGender":targetGender,
            "numOfMembers":numOfMembers,
            "teamImage":teamImage,
            "teamID":teamID,
            "intro":intro,
            "createdBy":createdBy
        ]
    }
    
}

