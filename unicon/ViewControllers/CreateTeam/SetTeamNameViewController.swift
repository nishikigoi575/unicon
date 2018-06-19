//
//  SetTeamNameViewController.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/06/17.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import UIKit

class SetTeamNameViewController: UIViewController {

    
    @IBOutlet weak var teamNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        
        if let teamName = teamNameTextField.text, teamNameTextField.text != "" {
            
            SetTeamIntroViewController.teamName = teamName
            performSegue(withIdentifier: "ToNext", sender: nil)
            
        }
        
        
        
    }
    
}
