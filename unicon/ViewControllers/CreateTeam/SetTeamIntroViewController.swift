//
//  SetTeamIntroViewController.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/06/18.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import UIKit
import FirebaseFirestore

class SetTeamIntroViewController: UIViewController {

    
    // heres are the data to create a team
    static var targetGender = String()
    static var teamName = String()
    static var teamPhoto = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(SetTeamIntroViewController.targetGender)
        print(SetTeamIntroViewController.teamName)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func nextBtnTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "ToNext", sender: nil)
        
    }
    

}
