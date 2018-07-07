//
//  InviteMemberViewController.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/06/18.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import UIKit
import AlamofireImage
import Social

class InviteMemberViewController: UIViewController, UITextViewDelegate {

    var teamID = String()
    var imageUrlStr = String()
    
    @IBOutlet weak var teamIDTextView: UITextView!
    @IBOutlet weak var teamImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teamIDTextView.delegate = self
        teamIDTextView.textContainerInset = UIEdgeInsetsMake(20, 30, 20, 30)
        teamIDTextView.sizeToFit()
        teamImageView.layer.cornerRadius = 80
        teamImageView.layer.masksToBounds = true
        
        teamIDTextView.text = teamID
        if let url = URL(string: imageUrlStr) {
            teamImageView.af_setImage(withURL: url)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func shareTeamID(_ sender: Any) {
        let text = "https://we-we.herokuapp.com/?team_id=\(teamID)"
        let items = [text] as [Any]
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
