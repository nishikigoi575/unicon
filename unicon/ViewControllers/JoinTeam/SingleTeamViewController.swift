//
//  SingleTeamViewController.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/06/22.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import UIKit
import FirebaseAuth
import AlamofireImage

class SingleTeamViewController: UIViewController {
    
    var imagePathStr = String()
    var teamID = String()
    var teamName = String()
    var intro = String()
    
    
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var introTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: imagePathStr) {
            teamImageView.af_setImage(
                withURL: url,
                imageTransition: .crossDissolve(0.7)
            )
        }
        
        teamNameLabel.text = teamName
        introTextView.text = intro
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func joinBtnTapped(_ sender: Any) {
        
        if let userUID = Auth.auth().currentUser?.uid {
            UserService.joinTeam(teamID: teamID, userUID: userUID){ (success) in
                
                if success {
                    print("Joined the team successfuly!")
                    
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let newVC = storyboard.instantiateViewController(withIdentifier: "HomeSB")
                    self.present(newVC, animated: true, completion: nil)
                    
                } else {
                    print("Failed to join the team...")
                }
            }
        }
        
    }
    
}
