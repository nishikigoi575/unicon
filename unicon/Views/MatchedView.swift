//
//  MatchedView.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/07/12.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import Foundation
import UIKit

class MatchedView: UIView {
    
    @IBOutlet weak var myTeamImage: UIImageView!
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var moveBtn: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
    
    @IBAction func moveToGroupChat(_ sender: Any) {
    }
    
    @IBAction func `continue`(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    override func awakeFromNib() {
        teamImageView.layer.cornerRadius = teamImageView.frame.size.width / 2
        myTeamImage.layer.cornerRadius = myTeamImage.frame.size.width / 2
        teamImageView.layer.masksToBounds = true
        myTeamImage.layer.masksToBounds = true
    }
    
    
    
}
