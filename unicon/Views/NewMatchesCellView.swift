//
//  NewMatchesCellView.swift
//  unicon
//
//  Created by yo hanashima on 2018/07/15.
//  Copyright © 2018 Imajin Kawabe. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class NewMatchesCellView {
    private static let defaultImage = UIImage(named: "default")
    
    static func configureCell(_ cell: NewMatchedTeamCollectionViewCellController, with room: ChatRoom) {
        
        cell.isUserInteractionEnabled = false
        cell.userUIDArray = room.myMembers + room.opponentMembers
        
        if let opponentTeam = room.opponentTeam {
            cell.teamNameLabel.text = opponentTeam.teamName
            if let image = opponentTeam.teamImage {
                cell.teamImageView.image = image
            } else {
                if let url = URL(string: opponentTeam.teamImageURL){
                    cell.teamImageView.af_setImage(
                        withURL: url,
                        placeholderImage: defaultImage,
                        imageTransition: .crossDissolve(0.5)
                    )
                }
            }
        } else {
            TeamService.show(forTeamID: room.opponentTeamUID) { team in
                guard let opponentTeam = team else { return }
                cell.teamNameLabel.text = opponentTeam.teamName
                if let image = opponentTeam.teamImage {
                    cell.teamImageView.image = image
                } else {
                    if let url = URL(string: opponentTeam.teamImageURL){
                        cell.teamImageView.af_setImage(
                            withURL: url,
                            placeholderImage: defaultImage,
                            imageTransition: .crossDissolve(0.5)
                        )
                    }
                }
            }
        }
    }
}
