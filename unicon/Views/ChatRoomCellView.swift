//
//  ChatRoomCellView.swift
//  unicon
//
//  Created by yo hanashima on 2018/07/10.
//  Copyright © 2018 Imajin Kawabe. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class ChatRoomCellView {
    private static let defaultImage = UIImage(named: "default")
    
    static func configureCell(_ cell: ChatListTableViewCell, with room: ChatRoom){
        
        cell.teamNameLabel.text = room.opponentTeamName
        
        cell.teamImageView.layer.cornerRadius = 45
        cell.teamImageView.layer.masksToBounds = true
        
        if let image = room.opponentTeamImage {
            cell.teamImageView.image = image
        } else {
            cell.teamImageView.af_setImage(
                withURL: URL(string: room.opponentTeamImageURL)!,
                placeholderImage: defaultImage,
                imageTransition: .crossDissolve(0.5)
            )
        }
        
        cell.userUIDArray = room.myMembers + room.opponentMembers
    }
}
