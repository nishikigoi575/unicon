//
//  MatchingViewController.swift
//  unicon
//
//  Created by yo hanashima on 2018/06/19.
//  Copyright © 2018 Imajin Kawabe. All rights reserved.
//

import Foundation
import UIKit
import Koloda
import Alamofire
import AlamofireImage

class MatchingViewController: UIViewController {
    
    private let cardWidth = CGFloat(350)
    private let cardHeight = CGFloat(600)
    
    let kolodaView = KolodaView()
    var teams = [Team]()
    
    var dataSource = [CardView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        kolodaView.frame = CGRect(x: 0, y: 0, width: cardWidth, height: cardHeight)
        kolodaView.center = self.view.center
        self.view.addSubview(kolodaView)
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        TeamService.getFive() { teams in
            if let teams = teams {
                self.teams = teams
                CardViewHelper.makeCardViews(teams: teams) { cards in
                    self.dataSource = cards
                    self.kolodaView.reloadData()
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}

extension MatchingViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        print("Out of stock!!")
    }
    
    private func koloda(_ koloda: KolodaView, didSelectCardAtIndex index: UInt) {
        print("index \(index) has tapped!!")
    }
    
    func koloda(_ koloda: KolodaView, shouldSwipeCardAt index: Int, in direction: SwipeResultDirection) -> Bool {
        return true
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        switch direction {
        case .right:
            print("Swiped to right!")
        case .left:
            print("Swiped to left!")
        default:
            return
        }
    }
}

extension MatchingViewController: KolodaViewDataSource {
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return dataSource.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let card = dataSource[index]
        let team = teams[index]
        if let image = team.teamImage {
            card.imageView.image = image
        } else {
            Alamofire.request(team.teamImageURL).responseImage { response in
                if let image = response.result.value {
                    card.imageView.image = image
                }
            }
        }
        return card
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return nil
    }
}
