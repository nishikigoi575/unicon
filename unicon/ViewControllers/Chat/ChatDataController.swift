//
//  ChatDataController.swift
//  unicon
//
//  Created by yo hanashima on 2018/07/14.
//  Copyright © 2018 Imajin Kawabe. All rights reserved.
//

import Foundation

struct ChatDataController {
    public static let chatRoomPaginationHelper = UCPaginationHelper<ChatRoom>(keyUID: nil, serviceMethod: ChatRoomService.getChatRooms)
    public static let newMatchesPaginationHelper = UCPaginationHelper<ChatRoom>(keyUID: nil, serviceMethod: MatchService.getNewMatches)
    public static var chatRooms = [ChatRoom]()
    public static var newMatchedTeams = [ChatRoom]()
    
    public static func reloadChatRooms() {
        ChatDataController.chatRoomPaginationHelper.reloadData(completion: { (rooms) in
            for room in rooms {
                print("chatRoom: \(room.uid)")
            }
            ChatDataController.chatRooms = rooms
        })
    }
    
    public static func reloadNewMatches() {
        ChatDataController.newMatchesPaginationHelper.reloadData(completion: { (newMatches) in
            for room in newMatches {
                print("newMatches: \(room.uid)")
            }
            ChatDataController.newMatchedTeams = newMatches
        })
    }
}
