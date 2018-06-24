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
    
    let paginationHelper = UCPaginationHelper<Team>(keyUID: nil, serviceMethod: TeamService.allTeams)
    
    @IBOutlet weak var kolodaView: KolodaView!
    
    var teams = [Team]()
    
    var dataSource = [CardView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        reloadTeams()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func goProfile(_ sender: Any) {
        let transition = CATransition()
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.navigationController!.view.layer.add(transition, forKey: nil)
        let HowToLeftPush = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
        
        self.navigationController?.pushViewController(HowToLeftPush, animated: true )
    }
    
    
    func reloadTeams() {
        self.paginationHelper.reloadData(completion: { [weak self] (teams) in
            self?.teams = teams
            CardViewHelper.makeCardViews(teams: teams, size: self?.kolodaView.frame.size) { cards in
                self?.dataSource = cards
                self?.kolodaView.reloadData()
            }
        })
    }
    
    func paginate() {
        paginationHelper.paginate(completion: { [weak self] (teams) in
            self?.teams.append(contentsOf: teams)
            CardViewHelper.makeCardViews(teams: teams, size: self?.kolodaView.frame.size) { cards in
                self?.dataSource.append(contentsOf: cards)
                self?.kolodaView.reloadData()
            }
        })
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
        if dataSource.count - index < 6 {
            paginate()
        }
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
