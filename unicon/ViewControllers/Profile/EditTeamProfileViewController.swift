//
//  EditTeamProfileViewController.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/07/06.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import UIKit
import AlamofireImage

class EditTeamProfileViewController: UIViewController, UITextViewDelegate, UITableViewDelegate {
    
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var teamNameTextField: MyTextField!
    @IBOutlet weak var teamIntroTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveBtnView: UIView!
    @IBOutlet weak var genderBtn: UIButton!
    
    var members = [User]()
    var changedTeamImage: UIImage? = nil
    var changedTeamName: String? = nil
    var changedTeamIntro: String? = nil
    var changedMatchingGender: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teamIntroTextView.delegate = self
        teamIntroTextView.textContainerInset = UIEdgeInsetsMake(20, 30, 20, 30)
        teamIntroTextView.sizeToFit()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        saveBtnView.learningAndLeading()
        
        let nib: UINib = UINib(nibName: "MemberTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MemberTableCell")
        
        getTeamData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func saveChanges(_ sender: Any) {
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addMember(_ sender: Any) {
        
        // guard when members are more than 5
        
        if let teamID = Team.current?.teamID {
            let storyboard: UIStoryboard = UIStoryboard(name: "CreateTeam", bundle: nil)
            let newVC = storyboard.instantiateViewController(withIdentifier: "InviteVC") as! InviteMemberViewController
            newVC.teamID = teamID
            
            if let url = Team.current?.teamImageURL {
                newVC.imageUrlStr = url
            }
            
            self.present(newVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func selectGender(_ sender: Any) {
        if let gen = genderBtn.titleLabel?.text {
            let sb = UIStoryboard(name: "Profile", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "SelectGenderModal") as! SelectGenderModalViewController
            vc.selectedGender = gen
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
    }

    @IBAction func pickImage(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "ImagePicker", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "ImagePickerVC") as! CamerarollViewController
        newVC.from = self
        self.present(newVC, animated: true, completion: nil)
    }
    
    @IBAction func nameChanged(_ sender: Any) {
        changedTeamName = teamNameTextField.text
    }
    
    
    func getTeamData() {
        if let teamID = Team.current?.teamID {
            TeamService.show(forTeamID: teamID) { (team) in
                if let team = team {
                    if let url = URL(string: team.teamImageURL
                        ) {
                        self.teamImageView.af_setImage(
                            withURL: url,
                            imageTransition: .crossDissolve(1)
                        )
                    }
                    
                    switch team.teamGender {
                        case "male":
                            self.genderBtn.setTitle("男性", for: UIControlState())
                        case "female":
                            self.genderBtn.setTitle("女性", for: UIControlState())
                        case "other":
                            self.genderBtn.setTitle("その他", for: UIControlState())
                        default:
                            self.genderBtn.setTitle("未設定", for: UIControlState())
                    }
                    
                    self.teamNameTextField.text = team.teamName
                    self.teamIntroTextView.text = team.intro
                    self.getTeamMembers(teamUID: team.teamID)
                }
            }
        }
    }
    
    func getTeamMembers(teamUID: String) {
        TeamService.getTeamMembers(teamUID: teamUID, completion: { members in
            if let members = members {
                self.members = members
                self.tableView.reloadData()
            }
        })
    }
    
    func textViewDidChange(_ textView: UITextView) {
        changedTeamIntro = teamIntroTextView.text
    }
    
    func updateGenderBtn(gender: String) {
        
        switch gender {
        case "男性":
            changedMatchingGender = "male"
        case "女性":
            changedMatchingGender = "female"
        case "その他":
            changedMatchingGender = "other"
        default:
            changedMatchingGender = nil
        }
        
        genderBtn.setTitle(gender, for: UIControlState())
    }
    
    func updateImage(image: UIImage) {
        changedTeamImage = image
        teamImageView.image = image
    }
}

extension EditTeamProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberTableCell", for: indexPath) as! MemberTableViewCell
        
        let member = members[indexPath.row]
        if let url = URL(string: member.userImage) {
            cell.userImageView.af_setImage(
                withURL: url,
                imageTransition: .crossDissolve(0.5)
            )
        }
        
        cell.userNameLabel.text = member.firstName
        
        return cell
    }
}
