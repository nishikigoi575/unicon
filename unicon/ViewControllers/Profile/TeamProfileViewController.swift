//
//  TeamProfileViewController.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/07/11.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import UIKit
import FSPagerView

class TeamProfileViewController: UIViewController {
    
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    
    @IBOutlet weak var pageControl: FSPageControl! {
        didSet {
            self.pageControl.numberOfPages = members.count
            self.pageControl.contentHorizontalAlignment = .center
            self.pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            let red = UIColor.hex(hex: "FF5E62", alpha: 1.0)
            self.pageControl.setFillColor(red, for: .selected)
        }
    }
    
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamIntroTextView: UITextView!
    
    var teamUID = String()
    var members = [User]()
    var teamImage = String()
    var teamName = String()
    var teamIntro = String()
    
    let attr: [NSAttributedStringKey : Any] = [
        .foregroundColor : UIColor.white,
        .font : UIFont(name: "Hiragino Sans", size: 25)!
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pagerView.transformer = FSPagerViewTransformer(type: .linear)
        
        teamNameLabel.text = teamName
        teamIntroTextView.text = teamIntro
        
        
        
        getMembers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func getMembers() {
        TeamService.getTeamMembers(teamUID: teamUID, completion: { members in
            if let members = members {
                self.members = members
                self.pageControl.numberOfPages = members.count + 1
                self.pageControl.currentPage = 0
                self.pagerView.reloadData()
            }
        })
    }
}

extension TeamProfileViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        print(members.count)
        return members.count + 1
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        if index == 0 {
            if let url = URL(string: teamImage) {
                cell.imageView?.af_setImage(withURL: url)
            }
            cell.imageView?.contentMode = .scaleAspectFill
            cell.imageView?.clipsToBounds = true
        }
        else {
            let member = members[index - 1]
            if let image = URL(string: member.userImageURL) {
                cell.imageView?.af_setImage(withURL: image)
            }
            
            if let age = member.age?.description {
                let str = NSAttributedString(string: member.firstName + ", " + age, attributes: attr)
                cell.textLabel?.attributedText = str
            } else {
                let str = NSAttributedString(string: member.firstName, attributes: attr)
                cell.textLabel?.attributedText = str
            }
            cell.imageView?.contentMode = .scaleAspectFill
            cell.imageView?.clipsToBounds = true
        }
        
        return cell
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard self.pageControl.currentPage != pagerView.currentIndex else {
            return
        }
        self.pageControl.currentPage = pagerView.currentIndex
    }
}
