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
    public static var chatRooms = [ChatRoom]()
    public static var newMatchedTeams = [Team]()
    
    public static func reloadChatRooms() {
        ChatDataController.chatRoomPaginationHelper.reloadData(completion: { (rooms) in
            ChatDataController.chatRooms = rooms
        })
    }
}
