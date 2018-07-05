//
//  InviteMemberViewController.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/06/18.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import UIKit

class InviteMemberViewController: UIViewController {

    var teamID = String()
    
    @IBOutlet weak var teamIDTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        teamIDTextView.text = teamID
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func shareTeamID(_ sender: Any) {
        let text = "\(teamID)"
        let items = [text]
        let activityVc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        // UIAcitivityViewControllerを表示
        self.present(activityVc, animated: true, completion: nil)
    }
    
    
    @IBAction func finish(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "NaviVC")
        self.present(newVC, animated: true, completion: nil)
    }
    
}
