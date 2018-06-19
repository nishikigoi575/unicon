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
/*
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
            let card = CardView(frame: CGRect(x: 0, y: 0, width: cardWidth, height: cardHeight))
            card.setImage(image!)
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

}

extension MatchingViewController: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        print("Out of stock!!")
    }
    
    func koloda(koloda: KolodaView, didSelectCardAtIndex index: UInt) {
        print("index \(index) has tapped!!")
    }
}

extension MatchingViewController: KolodaViewDataSource {
    func kolodaNumberOfCards(koloda:KolodaView) -> UInt {
        return UInt(dataSource.count)
    }
    
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
        return dataSource[Int(index)]
    }
    
    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
        return nil
    }
}
*/
