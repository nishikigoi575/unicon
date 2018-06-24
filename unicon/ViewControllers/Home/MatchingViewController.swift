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

class MatchingViewController: UIViewController {
    
    private let cardWidth = CGFloat(250)
    private let cardHeight = CGFloat(300)
    
    let kolodaView = KolodaView()
    
    let images = [UIImage(named: "test1"), UIImage(named: "test2"), UIImage(named: "test3"), UIImage(named: "test4")]
    
    var dataSource = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        for image in images {
            let card = UIImageView(frame: CGRect(x: 0, y: 0, width: cardWidth, height: cardHeight))
            card.image = image
            dataSource.append(card)
        }
        
        kolodaView.frame = CGRect(x: 0, y: 0, width: cardWidth, height: cardHeight)
        kolodaView.center = self.view.center
        self.view.addSubview(kolodaView)
        
        kolodaView.dataSource = self // dataSource設定
        kolodaView.delegate = self // delegate設定
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func profileBarButttonTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "toProfileVC", sender: nil)
    }
    
    @IBAction func chatBarButtonTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "toChatVC", sender: nil)
    }
    
}

extension MatchingViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        print("Out of stock!!")
    }
    
    func koloda(koloda: KolodaView, didSelectCardAtIndex index: UInt) {
        print("index \(index) has tapped!!")
    }
    
    func koloda(koloda: KolodaView, didSwipeCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) {
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
        return dataSource[Int(index)]
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return nil
    }
}
