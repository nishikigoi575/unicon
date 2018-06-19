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
                GraphRequest(graphPath: "me").start { (response, result) in
                    switch result {
                    case .success(let response):
                        print("レスポンスだよ\(response)")
                        
                        let credential = FacebookAuthProvider
                            .credential(withAccessToken: token.authenticationToken)
                        
                        // Firebase への認証
                        Auth.auth().signIn(with: credential) { (user, error) in
                            if let error = error {
                                // error handling
                                print(error.localizedDescription)
//                                AppDelegate.instance().dismissActivityIndicator()
                                
                                let errorAlert = UIAlertController(title: "Oooops", message: "エラーが発生しました。通信状況などを確認してください。", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "閉じる", style: .default, handler: nil)
                                
                                errorAlert.addAction(okAction)
                                
                                self.present(errorAlert, animated: true, completion: nil)
                                
                                return
                                
                            } else {
                                self.performSegue(withIdentifier: "ToCreateOrJoinVC", sender: nil)
                            }
                        }
                    case .failed:
                        // error handling
                        print("ERROR OMG")
//                        AppDelegate.instance().dismissActivityIndicator()
                        break
                    }
                }
            case .cancelled: // Facebook へのログインがキャンセルされた
//                AppDelegate.instance().dismissActivityIndicator()
                break
            case .failed: // Facebook へのログインが失敗した
//                AppDelegate.instance().dismissActivityIndicator()
                break
            }
        }
    }

}
