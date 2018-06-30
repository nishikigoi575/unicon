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

class Team: NSObject {
    var teamName: String
    var teamGender: String
    var targetGender: String
    var numOfMembers: Int
    var teamImageURL: String
    var intro: String
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
        
        super.init()
    }
    
    init?(snapshot: DocumentSnapshot) {
        guard let dictionary = snapshot.data() as? [String : Any],
            let teamName = dictionary["teamName"] as? String,
            let teamGender = dictionary["teamGender"] as? String,
            let targetGender = dictionary["targetGender"] as? String,
            let numOfMembers = dictionary["numOfMembers"] as? Int,
            let teamImageURL = dictionary["teamImage"] as? String,
            let teamID = dictionary["teamID"] as? String,
            let createdBy = dictionary["createdBy"] as? String,
            let intro = dictionary["intro"] as? String
            else {return nil}
        
        self.teamName = teamName
        self.teamGender = teamGender
        self.targetGender = targetGender
        self.numOfMembers = numOfMembers
        self.teamImageURL = teamImageURL
        self.teamID = teamID
        self.createdBy = createdBy
        self.intro = intro
        
        super.init()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let teamName = aDecoder.decodeObject(forKey: Constants.UserDefaults.teamName) as? String,
            let teamGender = aDecoder.decodeObject(forKey: Constants.UserDefaults.teamGender) as? String,
            let targetGender = aDecoder.decodeObject(forKey: Constants.UserDefaults.targetGender) as? String,
            let numOfMembers = aDecoder.decodeInteger(forKey: Constants.UserDefaults.numOfMembers) as? Int,
            let teamImageURL = aDecoder.decodeObject(forKey: Constants.UserDefaults.teamImageURL) as? String,
            let teamID = aDecoder.decodeObject(forKey: Constants.UserDefaults.teamID) as? String,
            let intro = aDecoder.decodeObject(forKey: Constants.UserDefaults.intro) as? String,
            let createdBy = aDecoder.decodeObject(forKey: Constants.UserDefaults.createdBy) as? String
            else { return nil }
        
        self.teamName = teamName
        self.teamGender = teamGender
        self.targetGender = targetGender
        self.numOfMembers = numOfMembers
        self.teamImageURL = teamImageURL
        self.teamID = teamID
        self.createdBy = createdBy
        self.intro = intro
        
        super.init()
    }
    
    private static var _current: Team?
    
    static var current: Team? {
        return _current
    }
    
    // MARK: - Class Methods
    
    class func setCurrent(_ team: Team, writeToUserDefaults: Bool = false) {
        
        if writeToUserDefaults {
            let data = NSKeyedArchiver.archivedData(withRootObject: team)
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentTeam)
        }
        
        _current = team
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

extension Team: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(teamName, forKey: Constants.UserDefaults.teamName)
        aCoder.encode(teamGender, forKey: Constants.UserDefaults.teamGender)
        aCoder.encode(targetGender, forKey: Constants.UserDefaults.targetGender)
        aCoder.encode(numOfMembers, forKey: Constants.UserDefaults.numOfMembers)
        aCoder.encode(teamImageURL, forKey: Constants.UserDefaults.teamImageURL)
        aCoder.encode(teamID, forKey: Constants.UserDefaults.teamID)
        aCoder.encode(intro, forKey: Constants.UserDefaults.intro)
        aCoder.encode(createdBy, forKey: Constants.UserDefaults.createdBy)
    }
}

    

