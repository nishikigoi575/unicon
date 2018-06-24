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
    public static func makeCardViews(teams: [Team], size: CGSize?, completion: @escaping ([CardView]) -> Void) {
        guard let size = size else { return }
        let dispatchGroup = DispatchGroup()
        var cards = [CardView]()
        for team in teams {
            dispatchGroup.enter()
            let card = CardView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            card.teamName.text = team.teamName
            cards.append(card)
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main, execute: {
            completion(cards)
        })
    }
}
