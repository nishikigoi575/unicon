//
//  ChatViewController.swift
//  unicon
//
//  Created by yo hanashima on 2018/06/24.
//  Copyright © 2018 Imajin Kawabe. All rights reserved.
//

import Foundation
import UIKit

class ChatViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        
        self.navigationItem.hidesBackButton = true
        
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        let transition = CATransition()
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        transition.duration = 0.5
        self.navigationController!.view.layer.add(transition, forKey: nil)
        navigationController?.popViewController(animated: true)
    }
}

