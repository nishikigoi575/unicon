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
        cell.teamImageView.layer.cornerRadius = cell.teamImageView.frame.width/2
        cell.teamImageView.layer.masksToBounds = true
        cell.myTeamImageView.layer.cornerRadius = cell.myTeamImageView.frame.width/2
        cell.myTeamImageView.layer.masksToBounds = true
        cell.userUIDArray = room.myMembers + room.opponentMembers
        cell.lastMessageLabel.text = room.lastMessage
        
        if let opponentTeam = room.opponentTeam {
            cell.teamNameLabel.text = opponentTeam.teamName
            
            if let image = opponentTeam.teamImage {
                cell.teamImageView.image = image
            } else {
                cell.teamImageView.af_setImage(
                    withURL: URL(string: opponentTeam.teamImageURL)!,
                    placeholderImage: defaultImage,
                    imageTransition: .crossDissolve(0.5)
                )
            }
        } else {
            TeamService.show(forTeamID: room.opponentTeamUID) { team in
                guard let opponentTeam = team else { return }
                cell.teamNameLabel.text = opponentTeam.teamName
                
                if let image = opponentTeam.teamImage {
                    cell.teamImageView.image = image
                } else {
                    cell.teamImageView.af_setImage(
                        withURL: URL(string: opponentTeam.teamImageURL)!,
                        placeholderImage: defaultImage,
                        imageTransition: .crossDissolve(0.5)
                    )
                }
            }
        }
        
        if let myTeam = room.myTeam {
            cell.myTeamNameLabel.text = myTeam.teamName
            
            if let image = myTeam.teamImage {
                cell.myTeamImageView.image = image
            } else {
                cell.myTeamImageView.af_setImage(
                    withURL: URL(string: myTeam.teamImageURL)!,
                    placeholderImage: defaultImage,
                    imageTransition: .crossDissolve(0.5)
                )
            }
        } else {
            TeamService.show(forTeamID: room.myTeamUID) { team in
                guard let myTeam = team else { return }
                cell.myTeamNameLabel.text = myTeam.teamName
                
                if let image = myTeam.teamImage {
                    cell.myTeamImageView.image = image
                } else {
                    cell.myTeamImageView.af_setImage(
                        withURL: URL(string: myTeam.teamImageURL)!,
                        placeholderImage: defaultImage,
                        imageTransition: .crossDissolve(0.5)
                    )
                }
            }
        }
    }
}
