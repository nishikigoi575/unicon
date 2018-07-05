//
//  SelectTeamViewController.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/07/01.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import UIKit
import AlamofireImage

class SelectTeamViewController: UIViewController, UITableViewDelegate {

    var teams = [Team]()
    var selectedTeamIndex = Int()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var switchBtnView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchBtnView.orangeCoral()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let nib: UINib = UINib(nibName: "TeamListTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TeamListCell")
        
        getMyTeams()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func getMyTeams() {
        if let userUID = User.current?.userUID {
            TeamService.myTeams(keyUID: userUID) { (teams) in
                if let teams = teams {
                    self.teams = teams
                    let group = DispatchGroup()
                    for (i, team) in teams.enumerated() {
                        group.enter()
                        if Team.current?.teamID == team.teamID {
                            self.selectedTeamIndex = i
                            self.doneBtn.setTitle(team.teamName + "に切り替え", for: UIControlState())
                        }
                        group.leave()
                    }
                    group.notify(queue: .main, execute: {
                        self.tableView.reloadData()
                    })
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTeamIndex = indexPath.row
        let selectedTeam = teams[selectedTeamIndex]
        doneBtn.setTitle(selectedTeam.teamName + "に切り替え", for: UIControlState())
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func switchCurrentTeam(_ sender: Any) {
        let selectedTeam = teams[selectedTeamIndex]
        Team.setCurrent(selectedTeam, writeToUserDefaults: true)
        if let parentVC = presentingViewController as? ProfileViewController {
            parentVC.getCurrentTeam()
        }
        dismiss(animated: true, completion: nil)
    }
    
}

extension SelectTeamViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamListCell", for: indexPath) as! TeamListTableViewCell
        
        let team = teams[indexPath.row]
        if let url = URL(string: team.teamImageURL) {
            cell.teamImageView.af_setImage(
                withURL: url,
                imageTransition: .crossDissolve(0.5)
            )
        }
        
        if indexPath.row == selectedTeamIndex {
            self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        
        cell.teamNameLabel.text = team.teamName
        cell.teamIntroTextView.text = team.intro
        
        return cell
    }
}
