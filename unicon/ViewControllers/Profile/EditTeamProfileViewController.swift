//
//  EditTeamProfileViewController.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/07/06.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import UIKit
import AlamofireImage

class EditTeamProfileViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var teamNameTextField: MyTextField!
    @IBOutlet weak var teamIntroTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teamIntroTextView.delegate = self
        teamIntroTextView.textContainerInset = UIEdgeInsetsMake(20, 30, 20, 30)
        teamIntroTextView.sizeToFit()
        
        getTeamData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func getTeamData() {
        if let teamID = Team.current?.teamID {
            TeamService.show(forTeamID: teamID) { (team) in
                if let team = team {
                    if let url = URL(string: team.teamImageURL
                        ) {
                        self.teamImageView.af_setImage(
                            withURL: url,
                            imageTransition: .crossDissolve(0.5)
                        )
                    }
                    self.teamNameTextField.text = team.teamName
                    self.teamIntroTextView.text = team.intro
                }
            }
        }
    }
    
}
