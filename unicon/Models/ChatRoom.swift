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

class ChatRoom {
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
    var numOfMembers: Int?
    var lastMessage: String?
    
    // To write
    init(uid: String, myTeamUID: String, opponentTeamUID: String, myMembers: [String], opponentMembers: [String], myTeamName: String, myTeamImageURL: String, opponentTeamName: String, opponentTeamImageURL: String) {
        self.uid = uid
        self.myTeamUID = myTeamUID
        self.myMembers = myMembers
        self.myTeamName = myTeamName
        self.myTeamImageURL = myTeamImageURL
        self.opponentTeamUID = opponentTeamUID
        self.opponentMembers = opponentMembers
        self.opponentTeamName = opponentTeamName
        self.opponentTeamImageURL = opponentTeamImageURL
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
            let lastActiveDate = dict["lastActiveDate"] as? Date
            else { return nil }
        
        guard let currentUserUID = User.current?.userUID else { return nil }
        if membersA.contains(currentUserUID) {
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
        
        if let numOfMembers = dict["numOfMembers"] {
            self.numOfMembers = numOfMembers
        } else {
            let num = membersA.count + membersB.count
            self.numOfMembers = num
            ChatRoomService.addNumOfMembers(chatRoomUID: uid, num: num)
        }
        
        ChatRoomService.getLastMessage(chatRoomUID: uid) { msg in
            if let lastMsg = msg {
                self.lastMessage = lastMsg
            } else {
                self.lastMessage = nil
            }
        }
        
        super.init()
    }
}
