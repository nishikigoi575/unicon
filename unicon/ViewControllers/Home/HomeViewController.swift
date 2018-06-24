//
//  HomeViewController.swift
//  unicon
//
//  Created by yo hanashima on 2018/06/24.
//  Copyright © 2018 Imajin Kawabe. All rights reserved.
//

import Foundation
import UIKit
import EZSwipeController

class HomeViewController: EZSwipeController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func setupView() {
        datasource = self
    }
    
}

extension HomeViewController: EZSwipeControllerDataSource {
    
    func viewControllerData() -> [UIViewController] {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let matchingVC = storyboard.instantiateViewController(withIdentifier: "MatchingVC")
        let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileVC")
        let chatVC = storyboard.instantiateViewController(withIdentifier: "ChatVC")
        return [profileVC, matchingVC, chatVC]
    }
    
    func indexOfStartingPage() -> Int {
        return 1
    }
    
    func changedToPageIndex(_ index: Int) {
        
    }
    
    func navigationBarDataForPageIndex(_ index: Int) -> UINavigationBar {
        
        var image = "chat"
        if index == 0 {
            image = "unicorn"
        } else if index == 1 {
            image = "chat"
        } else if index == 2 {
            image = "chat"
        }
        
        let navigationBar = UINavigationBar()
        
        navigationBar.barStyle = UIBarStyle.default
        let pink = UIColor.hex(hex: "E32BC7", alpha: 1.0)
        
        navigationBar.titleTextAttributes = [
            .foregroundColor: pink
        ]
        navigationBar.barTintColor = .white
        navigationBar.tintColor = pink
        let navigationItem = UINavigationItem()
        navigationItem.hidesBackButton = true
        navigationItem.titleView = UIImageView(image:UIImage(named:image))
        
        if index == 0 {
            let rightButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: Selector(("a")))
            rightButtonItem.tintColor = UIColor.black
            
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem = rightButtonItem
        } else if index == 1 {
            let rightButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.bookmarks, target: self, action: Selector(("a")))
            rightButtonItem.tintColor = UIColor.black
            
            let leftButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.camera, target: self, action: Selector(("a")))
            leftButtonItem.tintColor = UIColor.black
            
            navigationItem.leftBarButtonItem = leftButtonItem
            navigationItem.rightBarButtonItem = rightButtonItem
        } else if index == 2 {
            let leftButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: Selector(("a")))
            leftButtonItem.tintColor = UIColor.black
            
            navigationItem.leftBarButtonItem = leftButtonItem
            navigationItem.rightBarButtonItem = nil
        }
        navigationBar.pushItem(navigationItem, animated: false)
        
        
        
        return navigationBar
    }
}
