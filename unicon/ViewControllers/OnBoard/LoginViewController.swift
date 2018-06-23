//
//  LoginViewController.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/06/17.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import UIKit
import FirebaseAuth
import FacebookCore
import FacebookLogin

class LoginViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        signInWithFacebook()
    }
    
    
    private func signInWithFacebook() {
        
//        AppDelegate.instance().showActivityIndicator()
        
        let loginManager = LoginManager()
        // Facebook へログイン
        loginManager.logIn(readPermissions: [.email, .publicProfile, .userFriends], viewController: self) { result in
            switch result {
            case .success(_, _, let token):
                
                // Facebook からユーザー情報を取得
                GraphRequest(graphPath: "me", parameters: ["fields":"email,first_name,last_name,gender,picture,age_range"]).start { (response, result) in
                    switch result {
                    case .success(let response):
                        
                        let credential = FacebookAuthProvider
                            .credential(withAccessToken: token.authenticationToken)
                        
                        // Firebase への認証
                        Auth.auth().signIn(with: credential) { (user, error) in
                            if let error = error {
                                // error handling
                                print(error.localizedDescription)
                                
                                let errorAlert = UIAlertController(title: "Oooops", message: "エラーが発生しました。通信状況などを確認してください。\(error.localizedDescription)", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "閉じる", style: .default, handler: nil)
                                
                                errorAlert.addAction(okAction)
                                
                                self.present(errorAlert, animated: true, completion: nil)
                                
                                return
                                
                            } else {
                                if let data = response.dictionaryValue, let user = user {
                                    
                                    let userImage = UserHelper.getPicUrlFromFacebook(facebookID: data["id"] as! String, size: 800)
                                    
                                    UserService.signIn(user, firstName: data["first_name"] as! String, userImage: userImage, facebookID: data["id"] as! String){ (user) in
                                        guard let user = user else {
                                            let alertViewController = UIAlertController(title: "いとあやし", message: "なにかがおかしいようです。", preferredStyle: .alert)
                                            let okAction = UIAlertAction(title: "閉じる", style: .default, handler: nil)
                                            
                                            alertViewController.addAction(okAction)
                                            self.present(alertViewController, animated: true, completion: nil)
                                            return
                                        }
                                        
                                        
                                        User.setCurrent(user)
                                        
                                        print("ここに注目！: \(data)")
                                        
                                        // Success to add user info into DB
                                        if let pushID = UserDefaults.standard.string(forKey: "GT_PLAYER_ID") {
                                            user.pushID = pushID
                                            UserService.addPushID(userUID: user.userUID, pushID: pushID) { success in
                                                if success {
                                                    print("add push ID success")
                                                }
                                            }
                                        }
                                        
                                        
                                        if let belongs = user.belongsToTeam {
                                            
                                            if belongs {
                                                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                                let newVC = storyboard.instantiateViewController(withIdentifier: "HomeSB")
                                                self.present(newVC, animated: true, completion: nil)
                                            } else {
                                                self.performSegue(withIdentifier: "ToNext", sender: nil)
                                            }
                                            
                                        } else {
                                            self.performSegue(withIdentifier: "ToNext", sender: nil)
                                        }
                                        
                                        
                                        
                                    }
                                }
                            }
                        }
                    case .failed:
                        // error handling
                        print("ERROR OMG\(result)")
                        break
                    }
                }
            case .cancelled: // Facebook へのログインがキャンセルされた
                break
            case .failed: // Facebook へのログインが失敗した
                break
            }
        }
    }

}
