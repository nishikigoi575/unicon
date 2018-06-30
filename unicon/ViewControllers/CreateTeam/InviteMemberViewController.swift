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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func finish(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "NaviVC")
        self.present(newVC, animated: true, completion: nil)
    }
    
}
