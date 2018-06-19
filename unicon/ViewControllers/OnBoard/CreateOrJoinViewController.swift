//
//  CreateOrJoinViewController.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/06/17.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import UIKit
import FirebaseAuth
import AlamofireImage

class CreateOrJoinViewController: UIViewController {

    @IBOutlet weak var myProfileImageView: UIImageView!
    @IBOutlet weak var welcomeYouLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myProfileImageView.layer.cornerRadius = 20
        myProfileImageView.layer.masksToBounds = true
        
        let me = Auth.auth().currentUser
        if let name = me?.displayName {
            welcomeYouLable.text = "\(name)."
        }
        if let imageUrl = me?.photoURL {
            myProfileImageView.af_setImage(
                withURL: imageUrl,
                imageTransition: .crossDissolve(0.5)
            )
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func createTeam(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "CreateTeam", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "NewTeamVC")
        self.present(newVC, animated: true, completion: nil)
    }
    

}
