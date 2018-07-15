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
    var numOfMembers: Int
    var myMembers: [String]
    var opponentMembers: [String]
    var myTeam: Team?
    var opponentTeam: Team?
    var lastActiveDate: Date
    var lastDate: TimeInterval?
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
    
    // To write
    init(uid: String, myTeamUID: String, opponentTeamUID: String, myMembers: [String], opponentMembers: [String], numOfMembers: Int) {
        self.uid = uid
        self.myTeamUID = myTeamUID
        self.myMembers = myMembers
        self.opponentTeamUID = opponentTeamUID
        self.opponentMembers = opponentMembers
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
            let numOfMembers = dict["numOfMembers"] as? Int,
            let lastActiveDate = dict["lastActiveDate"] as? Date,
            let isActive = dict["isActive"] as? Bool
            else { return nil }

        guard let currentUserUID = User.current?.userUID else { return nil }
        let isTeamA = membersA.contains(currentUserUID)
        if isTeamA {
            self.myTeamUID = teamAUID
            self.myMembers = membersA
            self.opponentTeamUID = teamBUID
            self.opponentMembers = membersB
        } else {
            self.myTeamUID = teamBUID
            self.myMembers = membersB
            self.opponentTeamUID = teamAUID
            self.opponentMembers = membersA
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
            TeamService.show(forTeamID: teamAUID) { team in
                self.myTeam = team
            }
            TeamService.show(forTeamID: teamBUID) { team in
                self.opponentTeam = team
            }
        } else {
            TeamService.show(forTeamID: teamBUID) { team in
                self.myTeam = team
            }
            TeamService.show(forTeamID: teamAUID) { team in
                self.opponentTeam = team
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
            "numOfMembers": numOfMembers,
            "lastActiveDate": lastActiveDate,
            "isActive": false
        ]
    }
}
