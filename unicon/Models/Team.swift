//
//  Team.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/06/19.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import Foundation
import UIKit
//import Firestore.FIRDocumentSnapshot

class Team {
    
    var teamUID: String?
    var teamName: String
    var teamPhoto: String
    var teamGender: String
    var teamIntro: String
    var ownerUID: String
    let created: Date
    var updated: Date
    
    // TO WRITE
    init(teamName: String, teamPhoto: String, teamGender: String, teamIntro: String, created: Date, updated: Date, ownerUID: String) {
        
        self.teamName = teamName
        self.teamPhoto = teamPhoto
        self.teamGender = teamGender
        self.teamIntro = teamIntro
        self.ownerUID = ownerUID
        self.created = created
        self.updated = updated
        
    }
    
    // TO READ
    init?(snapshot: DocumentSnapshot) {
        guard let dictionary = snapshot.data() as? [String : Any],
            
            let teamName = dictionary["teamName"] as? String,
            let teamPhoto = dictinary["teamPhoto"] as? String,
            let teamGender = dictionary["teamGender"] as? String,
            let teamIntro = dictionary["teamIntro"] as? String,
            let ownerUID = dictionary["ownerUID"] as? String,
            let created = dictionary["created"] as? Date,
            let updated = dictionary["updated"] as? Date
            else { return nil }
        
        self.teamUID = snapshot.documentID
        self.teamName = teamName
        self.teamPhoto = teamPhoto
        self.teamGender = teamGender
        self.teamIntro = teamIntro
        self.ownerUID = ownerUID
        self.created = created
        self.updated = updated

    }
    
    var dictValue: [String : Any] {
        
        return [
            "teamUID": teamUID,
            "teamName": teamName,
            "teamPhoto": teamPhoto,
            "teamGender": teamGender,
            "teamIntro": teamIntro,
            "ownerUID": ownerUID,
            "created": created,
            "updated": updated
        ]
    }
}


