//
//  CardViewHelper.swift
//  unicon
//
//  Created by yo hanashima on 2018/06/24.
//  Copyright © 2018 Imajin Kawabe. All rights reserved.
//

import Foundation
import UIKit

class CardViewHelper {
    public static func makeCardViews(teams: [Team], completion: @escaping ([CardView]) -> Void) {
        let dispatchGroup = DispatchGroup()
        var cards = [CardView]()
        for team in teams {
            dispatchGroup.enter()
            let card = CardView(frame: CGRect(x: 0, y: 0, width: CGFloat(350), height: CGFloat(600)))
            card.teamName.text = team.teamName
            cards.append(card)
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main, execute: {
            completion(cards)
        })
    }
}
