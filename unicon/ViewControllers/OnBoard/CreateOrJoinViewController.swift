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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func createTeam(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "CreateTeam", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "NewTeamVC")
        self.present(newVC, animated: true, completion: nil)
    }
    
    @IBAction func joinTeam(_ sender: Any) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "JoinTeam", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "JoinTeamVC")
        self.present(newVC, animated: true, completion: nil)
        
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
