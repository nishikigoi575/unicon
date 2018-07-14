//
//  MyKukaiListTableViewCellController.swift
//  wada.
//
//  Created by yo hanashima on 2018/07/08.
//  Copyright © 2018 tokyo.imagine. All rights reserved.
//

import Foundation
import UIKit

class NewMatchedTeamsTableViewCellController: UITableViewCell {
    
    var delegate: UIViewController?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let nib: UINib = UINib(nibName: "NewMatchedTeamCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "NewMatchedTeam")
        //noKukaiView.isHidden = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }
    
    func loadData() {
        collectionView.reloadData()
    }
    
    func showNokukaiView() {
        print("show")
        //noKukaiView.isHidden = false
    }
    
    func hideNokukaiView() {
        print("hide")
        //noKukaiView.isHidden = true
    }
}

extension NewMatchedTeamsTableViewCellController {
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.setContentOffset(collectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        collectionView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set { collectionView.contentOffset.x = newValue }
        get { return collectionView.contentOffset.x }
    }
}
