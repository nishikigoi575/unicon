//
//  SetTeamIntroViewController.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/06/18.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import UIKit
import Firestore

class SetTeamIntroViewController: UIViewController {

    
    // heres are the data to create a team
    static var targetGender = String()
    static var teamName = String()
    static var teamImage = UIImage()
    
    var teamID = String()
    
    @IBOutlet weak var hitokotoTextView: UITextView!
    
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
        
        TeamService.create(teamName: SetTeamIntroViewController.teamName, teamGender: "male", targetGender: SetTeamIntroViewController.targetGender, teamImage: SetTeamIntroViewController.teamImage, intro: hitokotoTextView.text) { (team, completion) in
            
            if let team = team, completion {
                self.teamID = team.teamID
                self.performSegue(withIdentifier: "ToNext", sender: team)
            } else {
                print("失敗でごじゃる")
            }
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToNext") {
            if let subVC: InviteMemberViewController = segue.destination as? InviteMemberViewController {
                subVC.teamID = self.teamID
            }
        }
    }

}
