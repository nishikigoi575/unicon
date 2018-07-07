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
    
    static var swipedTeamList = [String]()
    static var matchedTeamList = [String]()
    static var numOfStoreSwipedTeams: Int = 10
    
    var teamList = [String]()
    var indexOfTeamList: Int = 0
    var sizeOfTeamList: Int = 20
    var teams = [Team]()
    var indexOfTeams: Int = 0
    var sizeOfTeams: Int = 5
    
    var dataSource = [CardView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Team.current == nil {
            let storyboard: UIStoryboard = UIStoryboard(name: "Onboard", bundle: nil)
            let newVC = storyboard.instantiateViewController(withIdentifier: "CreateOrJoinVC")
            self.present(newVC, animated: true, completion: nil)
        }
        
        kolodaView.layer.cornerRadius = 20.0
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        UCUserDefaultsHelper.getSwipedTeams()
        UCUserDefaultsHelper.getMatchedTeams()
        
        print("hoge: \(MatchingViewController.swipedTeamList)")
        
        initialLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func goProfile(_ sender: Any) {
        let transition = CATransition()
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        transition.duration = 0.5
        
        self.navigationController!.view.layer.add(transition, forKey: nil)
        let storyboard: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let leftPush = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
        leftPush.modalPresentationStyle = .overCurrentContext
        self.navigationController?.pushViewController(leftPush, animated: false )
    }
    
    
    @IBAction func goChat(_ sender: Any) {
        let transition = CATransition()
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.duration = 0.5
        transition.subtype = kCATransitionFromRight
        self.navigationController!.view.layer.add(transition, forKey: nil)
        let rightPush = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatViewController
        rightPush.providesPresentationContextTransitionStyle = true
        self.navigationController?.pushViewController(rightPush, animated: false)
    }
    
    func initialLoad() {
        loadTeamList() { [weak self] (success) in
            if success {
                print(self?.teamList)
                self?.loadTeams()
            } else {
                self?.loadTeamList() { [weak self] (_) in
                    self?.loadTeams()
                }
            }
        }
    }
    
    func loadTeamList(success: @escaping (Bool) -> Void) {
        TeamService.getTeamList(index: indexOfTeamList, size: sizeOfTeamList) { [weak self] (teamList) in
            print(teamList)
            if let size = self?.sizeOfTeamList {
                if teamList.count < size {
                    self?.indexOfTeamList = 0
                } else {
                    self?.indexOfTeamList += teamList.count
                }
            }
            
            if teamList.count > 0 {
                UCTeamHandler.excludeTeams(teamList: teamList) { [weak self] (excludedTL) in
                    print(excludedTL)
                    self?.teamList.append(contentsOf: excludedTL)
                    return success(true)
                }
            } else {
                return success(false)
            }
        }
    }
    
    func loadTeams() {
        UCTeamHandler.sliceTeamList(teamList: self.teamList, startIndex: indexOfTeams, size: sizeOfTeams) { [weak self] (forLoadTeamList) in
            print(forLoadTeamList)
            if forLoadTeamList.count > 0 {
                TeamService.getTeams(teamList: forLoadTeamList) { [weak self] (teams) in
                    self?.indexOfTeams += teams.count
                    self?.teams.append(contentsOf: teams)
                    CardViewHelper.makeCardViews(teams: teams, size: self?.kolodaView.frame.size) { cards in
                        self?.dataSource.append(contentsOf: cards)
                        self?.kolodaView.reloadData()
                    }
                }
            } else {
                self?.initialLoad()
            }
        }
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
    
    @IBAction func likeButttonTapped(_ sender: UIButton) {
        kolodaView.swipe(.right, force: true)
    }
    
    @IBAction func unlikeButtonTapped(_ sender: UIButton) {
        kolodaView.swipe(.left, force: true)
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
        if teamList.count - teams.count < 10 {
            loadTeamList() { _ in }
        }
        
        if dataSource.count - index < 6 {
            loadTeams()
        }
        return true
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        let team = teams[index]
        UCTeamHandler.updateSwipedTeamList(uid: team.teamID)
        
        print(MatchingViewController.swipedTeamList)
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
