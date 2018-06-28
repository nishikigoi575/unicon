//
//  MyProfileViewController.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/06/28.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import UIKit
import AlamofireImage
import BubbleTransition

class MyProfileViewController: UIViewController {

    @IBOutlet weak var profImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var belongingLabel: UILabel!
    @IBOutlet weak var introTextView: UITextView!
    @IBOutlet weak var closeBtn: UIButton!
    
    let transition = BubbleTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageUrl = URL(string: (User.current?.userImage)!) {
            profImageView.af_setImage(
                withURL: imageUrl,
                imageTransition: .crossDissolve(0.5)
            )
        }
        
        if let firstName = User.current?.firstName {
            
            if let age = User.current?.age {
                let ageStr = age.description
                nameLabel.text = firstName + "’ " + ageStr
            } else {
                nameLabel.text = firstName
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

    

}
