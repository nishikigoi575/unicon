//
//  HomeViewController.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/06/17.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import UIKit
import FirebaseAuth
import FacebookLogin
import AlamofireImage

class ProfileViewController: UIViewController {
    var window: UIWindow?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        if let name = Auth.auth().currentUser?.displayName {
            nameLabel.text = name
        }
        
        if let facebookID = Auth.auth().currentUser?.providerData
            .filter({ (userInfo: UserInfo) in return userInfo.providerID == FacebookAuthProviderID})
            .map({ (userInfo: UserInfo) in return userInfo.uid})
            .first {
            
            let imageUrl = UserHelper.getPicUrlFromFacebook(facebookID: facebookID, size: 800)
            
            imageView.af_setImage(
                withURL: imageUrl,
                imageTransition: .crossDissolve(0.5)
            )
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func goMatch(_ sender: Any) {
        
        goBack()
        
    }
    
    
    @IBAction func logOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Onboard", bundle: nil)
            let newVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
            self.present(newVC, animated: true, completion: nil)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }

    func goBack() {
        let transition = CATransition()
        //CATransitionというメソッドを使う
        
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        //なんか色々書いてあるけどよくわからない
        
        transition.type = kCATransitionPush
        
        //push遷移するよという定義
        
        transition.subtype = kCATransitionFromRight
        
        //kCATransitionFromLeftのLeftをRightにすれば右遷移に変わる
        
        self.navigationController!.view.layer.add(transition, forKey: nil)
        
        //遷移先のViewControllerインスタンス化
        
        navigationController?.popViewController(animated: true)
    }
}
