//
//  ChatViewController.swift
//  unicon
//
//  Created by yo hanashima on 2018/06/24.
//  Copyright © 2018 Imajin Kawabe. All rights reserved.
//

import Foundation
import UIKit

class ChatViewController: UIViewController, UITableViewDelegate {
    
    var selectedRoom: ChatRoom?
    var selectedRoomMembers = [String: User]()
    var delegateForCollectionView: NewMatchedTeamsTableViewCellController?
    var storedOffsets = [Int: CGFloat]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noChatRoomsView: UIView!
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        
        self.navigationItem.hidesBackButton = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "ChatListTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ChatListCell")
        tableView.register(UINib(nibName: "NewMatchedTeamsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewMatchedList")
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView(frame: .zero)
        
        refreshControl.tintColor = UIColor(red: 0.85, green: 0.20, blue: 0.25, alpha: 1.0)
        refreshControl.addTarget(self, action:#selector(reloadAll), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        if ChatDataController.chatRooms.count > 0 {
            tableView.reloadData()
            noChatRoomsView.isHidden = true
        } else {
            noChatRoomsView.isHidden = false
        }
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        let transition = CATransition()
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        transition.duration = 0.5
        self.navigationController!.view.layer.add(transition, forKey: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func reloadAll() {
        reloadChatRoom()
        reloadNewMatches()
    }
    
    @objc func reloadChatRoom() {
        ChatDataController.chatRoomPaginationHelper.reloadData(completion: { [weak self] (rooms) in
            if let refreshControl = self?.refreshControl {
                if refreshControl.isRefreshing {
                    refreshControl.endRefreshing()
                }
            }
            ChatDataController.chatRooms = rooms
            if rooms.count > 0 {
                self?.tableView.reloadData()
                self?.noChatRoomsView.isHidden = true
            } else {
                self?.noChatRoomsView.isHidden = false
            }
        })
    }
    
    @objc func reloadNewMatches() {
        ChatDataController.newMatchesPaginationHelper.reloadData(completion: { [weak self] (rooms) in
            if let refreshControl = self?.refreshControl {
                if refreshControl.isRefreshing {
                    refreshControl.endRefreshing()
                }
            }
            if rooms.count > 0 {
                ChatDataController.newMatchedTeams = rooms
                self?.delegateForCollectionView?.loadData()
                self?.delegateForCollectionView?.hideNoMatchesView()
            } else {
                self?.delegateForCollectionView?.showNoMatchesView()
            }
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
        let distanceToBottom = maximumOffset - currentOffsetY
        //print("currentOffsetY: \(currentOffsetY)")
        //print("scrollView.contentSize.height: \(scrollView.contentSize.height)")
        //print("scrollView.frame.height: \(scrollView.frame.height)")
        //print("distanceToBottom: \(distanceToBottom)")
        
        if distanceToBottom < 1500 && distanceToBottom > 0 {
            
            ChatDataController.chatRoomPaginationHelper.paginate(completion: { [weak self] (rooms) in
                ChatDataController.chatRooms.append(contentsOf: rooms)
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            })
        }
    }
    
}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 44
        } else if indexPath.row == 1 {
            return 115
        } else if indexPath.row == 2 {
            return 44
        } else {
            return 100
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChatDataController.chatRooms.count + 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell") as! ChatRoomLabelTableviewCellController
            cell.isUserInteractionEnabled = false
            cell.titleLabel.text = "New Matches"
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.frame.width, bottom: 0, right: 0)
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewMatchedList") as! NewMatchedTeamsTableViewCellController
            cell.delegate = self
            self.delegateForCollectionView = cell
            if ChatDataController.newMatchedTeams.count > 0 {
                delegateForCollectionView?.loadData()
            } else {
                delegateForCollectionView?.showNoMatchesView()
            }
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.frame.width, bottom: 0, right: 0)
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell") as! ChatRoomLabelTableviewCellController
            cell.isUserInteractionEnabled = false
            cell.titleLabel.text = "Messages"
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.frame.width, bottom: 0, right: 0)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListCell") as! ChatListTableViewCell
            let room = ChatDataController.chatRooms[indexPath.row-3]
            cell.isUserInteractionEnabled = false
            ChatRoomCellView.configureCell(cell, with: room)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? NewMatchedTeamsTableViewCellController else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? ChatListTableViewCell else { return }
        let room = ChatDataController.chatRooms[indexPath.row-3]
        selectedRoom = room
        selectedRoomMembers = cell.userDict
        
        performSegue(withIdentifier: "ToSingleChat", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToSingleChat"){
            let singleChatVC = segue.destination as! SingleChatViewController
            singleChatVC.room = selectedRoom
            singleChatVC.memberDict = selectedRoomMembers
        }
    }
    
}

extension ChatViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ChatDataController.newMatchedTeams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewMatchedTeam", for: indexPath) as! NewMatchedTeamCollectionViewCellController
        if ChatDataController.newMatchedTeams.count > 0 {
            let chatRoom = ChatDataController.newMatchedTeams[indexPath.row]
            NewMatchesCellView.configureCell(cell, with: chatRoom)
            
            if ChatDataController.newMatchedTeams.count - indexPath.row > 0 && ChatDataController.newMatchedTeams.count - indexPath.row < 2 {
                ChatDataController.newMatchesPaginationHelper.paginate(completion: { [weak self] (rooms) in
                    ChatDataController.newMatchedTeams.append(contentsOf: rooms)
                    DispatchQueue.main.async {
                        self?.delegateForCollectionView?.loadData()
                    }
                })
            }

        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? NewMatchedTeamCollectionViewCellController else { return }
        let chatRoom = ChatDataController.newMatchedTeams[indexPath.row]
        selectedRoom = chatRoom
        selectedRoomMembers = cell.userDict
        
        performSegue(withIdentifier: "ToSingleChat", sender: nil)
    }
}


