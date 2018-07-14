//
//  ChatRoom.swift
//  unicon
//
//  Created by yo hanashima on 2018/07/10.
//  Copyright © 2018 Imajin Kawabe. All rights reserved.
//

import Foundation
import UIKit
import Firestore.FIRDocumentSnapshot
import Alamofire
import AlamofireImage

class ChatRoom: NSObject{
    var uid: String
    var myTeamUID: String
    var opponentTeamUID: String
    var myMembers: [String]
    var opponentMembers: [String]
    var myTeamName: String
    var myTeamImageURL: String
    var opponentTeamName: String
    var opponentTeamImageURL: String
    var lastActiveDate: Date
    var lastDate: TimeInterval?
    var numOfMembers: Int
    var isActive: Bool = true {
        didSet {
            if !oldValue && isActive {
                ChatRoomService.updateMembersRooms(room: self, dict: ["isActive": true]) { success in
                    if success {
                        print("succees update room is active")
                    }
                }
            }
        }
    }
    var lastMessage: String?
    var myTeamImage: UIImage?
    var opponentTeamImage: UIImage?
    
    // To write
    init(uid: String, myTeamUID: String, opponentTeamUID: String, myMembers: [String], opponentMembers: [String], myTeamName: String, myTeamImageURL: String, opponentTeamName: String, opponentTeamImageURL: String, numOfMembers: Int) {
        self.uid = uid
        self.myTeamUID = myTeamUID
        self.myMembers = myMembers
        self.myTeamName = myTeamName
        self.myTeamImageURL = myTeamImageURL
        self.opponentTeamUID = opponentTeamUID
        self.opponentMembers = opponentMembers
        self.opponentTeamName = opponentTeamName
        self.opponentTeamImageURL = opponentTeamImageURL
        self.numOfMembers = numOfMembers
        self.lastActiveDate = Date()

        super.init()
    }

    init?(document: DocumentSnapshot) {
        guard let dict = document.data() as? [String : Any],
            let uid = dict["uid"] as? String,
            let teamAUID = dict["teamAUID"] as? String,
            let teamBUID = dict["teamBUID"] as? String,
            let membersA = dict["membersA"] as? [String],
            let membersB = dict["membersB"] as? [String],
            let teamAName = dict["teamAName"] as? String,
            let teamBName = dict["teamBName"] as? String,
            let teamAImageURL = dict["teamAImageURL"] as? String,
            let teamBImageURL = dict["teamBImageURL"] as? String,
            let numOfMembers = dict["numOfMembers"] as? Int,
            let lastActiveDate = dict["lastActiveDate"] as? Date,
            let isActive = dict["isActive"] as? Bool
            else { return nil }

        guard let currentUserUID = User.current?.userUID else { return nil }
        let isTeamA = membersA.contains(currentUserUID)
        if isTeamA {
            self.myTeamUID = teamAUID
            self.myMembers = membersA
            self.myTeamName = teamAName
            self.myTeamImageURL = teamAImageURL
            self.opponentTeamUID = teamBUID
            self.opponentMembers = membersB
            self.opponentTeamName = teamBName
            self.opponentTeamImageURL = teamBImageURL
        } else {
            self.myTeamUID = teamBUID
            self.myMembers = membersB
            self.myTeamName = teamBName
            self.myTeamImageURL = teamBImageURL
            self.opponentTeamUID = teamAUID
            self.opponentMembers = membersA
            self.opponentTeamName = teamAName
            self.opponentTeamImageURL = teamAImageURL
        }

        self.uid = uid
        self.lastActiveDate = lastActiveDate
        self.numOfMembers = numOfMembers
        self.lastDate = lastActiveDate.timeIntervalSince1970
        self.isActive = isActive
        
        super.init()
        
        if let lastMsg = dict["lastMessage"] as? String {
            self.lastMessage = lastMsg
        }
        
        if isTeamA {
            Alamofire.request(teamAImageURL).responseImage { [weak self] (response) in
                if let image = response.result.value {
                    self?.myTeamImage = image
                }
            }
            Alamofire.request(teamBImageURL).responseImage { [weak self] (response) in
                if let image = response.result.value {
                    self?.opponentTeamImage = image
                }
            }
        } else {
            Alamofire.request(teamBImageURL).responseImage { [weak self] (response) in
                if let image = response.result.value {
                    self?.myTeamImage = image
                }
            }
            Alamofire.request(teamAImageURL).responseImage { [weak self] (response) in
                if let image = response.result.value {
                    self?.opponentTeamImage = image
                }
            }
        }
        
    }
    
    var dictValue: [String : Any] {
        return [
            "uid": uid,
            "teamAUID": myTeamUID,
            "teamBUID": opponentTeamUID,
            "membersA": myMembers,
            "membersB": opponentMembers,
            "teamAName": myTeamName,
            "teamBName": opponentTeamName,
            "teamAImageURL": myTeamImageURL,
            "teamBImageURL": opponentTeamImageURL,
            "numOfMembers": numOfMembers,
            "lastActiveDate": lastActiveDate,
            "isActive": false
        ]
    }
}
