//
//  MatchedViewController.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/07/24.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import UIKit
import TapticEngine

class MatchedViewController: UIViewController {
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var yourImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myImageView.layer.cornerRadius = myImageView.bounds.size.width / 2
        yourImageView.layer.cornerRadius = yourImageView.bounds.size.width / 2
        myImageView.layer.masksToBounds = true
        yourImageView.layer.masksToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        TapticEngine.notification.feedback(.success)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func `continue`(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
