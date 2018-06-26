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
import UPCarouselFlowLayout

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var window: UIWindow?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var teams = [Team]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        let nib: UINib = UINib(nibName: "TeamCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "TeamCell")
        collectionView.reloadData()
        
        getMyTeam()
        
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
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        transition.duration = 0.5
        self.navigationController!.view.layer.add(transition, forKey: nil)
        navigationController?.popViewController(animated: true)
    }
    
    func getMyTeam() {
        
        print("ゆけ")
        
        TeamService.myTeams(pageSize: 10, keyUID: Auth.auth().currentUser?.uid) { (teams) in
            
            guard let teams = teams else {
                return;
            }
            
            self.teams = teams
            
            self.collectionView.reloadData()
            
        }
        
    }
    
    
    // FOR COLLECTION VIEW
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCell", for: indexPath as IndexPath) as! TeamCollectionViewCell
        let team = teams[indexPath.row]
        if let imageUrl = URL(string: team.teamImageURL) {
            cell.memberImageView.af_setImage(
                withURL: imageUrl,
                imageTransition: .crossDissolve(0.5)
            )
        }
        
        cell.memberImageView.layer.cornerRadius = 50
        cell.memberImageView.layer.masksToBounds = true
        cell.memberNameLabel.text = team.teamName
        
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teams.count
    }
    
}


