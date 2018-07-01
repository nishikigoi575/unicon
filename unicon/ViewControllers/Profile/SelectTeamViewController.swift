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
    var selectedTeam = [Team]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
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
        cell.teamNameLabel.text = team.teamName
        cell.teamIntroTextView.text = team.intro
        
        return cell
    }
}
