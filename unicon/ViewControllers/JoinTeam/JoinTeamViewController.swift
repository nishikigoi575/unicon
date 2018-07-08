//
//  JoinTeamViewController.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/06/22.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import UIKit
import FirebaseAuth

class JoinTeamViewController: UIViewController {

    var teamID = String()
    var teamName = String()
    var imagePathStr = String()
    var intro = String()
    
    @IBOutlet weak var teamIDTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func joinBtnTapped(_ sender: Any) {
        
        if let text = teamIDTextField.text {
            
            TeamService.searchByTeamID(teamID: text){ (team) in
                
                guard let team = team else {
                    print("失敗")
                    return
                }
                
                self.teamID = team.teamID
                self.teamName = team.teamName
                self.imagePathStr = team.teamImageURL
                self.intro = team.intro
                self.performSegue(withIdentifier: "ToNext", sender: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToNext") {
            if let subVC: SingleTeamViewController = segue.destination as? SingleTeamViewController {
                subVC.teamID = self.teamID
                subVC.teamName = self.teamName
                subVC.imagePathStr = self.imagePathStr
                subVC.intro = self.intro
            }
        }
    }
    
}
