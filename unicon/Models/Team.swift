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
import Alamofire
import AlamofireImage

class Team {
    var teamName: String
    var teamGender: String
    var targetGender: String
    var numOfMembers: Int
    var teamImageURL: String
    var intro: String?
    var teamID: String
    var createdBy: String
    var teamImage: UIImage?
    
    init(teamName: String, teamGender: String, targetGender: String, numOfMembers: Int, teamImageURL: String, intro: String, teamID: String, createdBy: String) {
        
        self.teamName = teamName
        self.teamGender = teamGender
        self.targetGender = targetGender
        self.numOfMembers = numOfMembers
        self.teamImageURL = teamImageURL
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
            let teamImageURL = dictionary["teamImage"] as? String,
            let teamID = dictionary["teamID"] as? String,
            let createdBy = dictionary["createdBy"] as? String
        else {return nil}
        
        self.teamName = teamName
        self.teamGender = teamGender
        self.targetGender = targetGender
        self.numOfMembers = numOfMembers
        self.teamImageURL = teamImageURL
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
            "teamImage":teamImageURL,
            "teamID":teamID,
            "intro":intro,
            "createdBy":createdBy
        ]
    }
    
}
