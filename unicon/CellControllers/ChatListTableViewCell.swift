//
//  ChatListTableViewCell.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/07/09.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import UIKit

class ChatListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var wrapperView: UIView!
    
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
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
