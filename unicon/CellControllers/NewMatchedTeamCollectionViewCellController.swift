//
//  MyKukaiCollectionViewCellController.swift
//  wada.
//
//  Created by yo hanashima on 2018/07/08.
//  Copyright © 2018 tokyo.imagine. All rights reserved.
//

import Foundation
import UIKit

class NewMatchedTeamCollectionViewCellController: UICollectionViewCell {
    
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    
    var userUIDArray: [String] = [String]() {
        didSet {
            for userUID in userUIDArray {
                UserService.show(forUserUID: userUID) { user in
                    if let user = user {
                        self.userDict.updateValue(user, forKey: userUID)
                        self.isUserInteractionEnabled = true
                    }
                }
            }
        }
    }
    var userDict = [String: User]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        teamImageView.layer.cornerRadius = teamImageView.frame.height/2
        teamImageView.layer.masksToBounds = true
        //teamImageView.layer.borderColor = UIColor.white.cgColor
        //teamImageView.layer.borderWidth = 1.0
    }
    
}
