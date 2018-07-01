//
//  TeamListTableViewCell.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/07/01.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import UIKit

class TeamListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var wrapper: UIView!
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamIntroTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        wrapper.layer.cornerRadius = 5
        wrapper.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
