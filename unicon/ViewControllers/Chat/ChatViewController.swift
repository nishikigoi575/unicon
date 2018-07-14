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
    
    //var chatRooms = [ChatRoom]()
    //let paginationHelper = UCPaginationHelper<ChatRoom>(keyUID: nil, serviceMethod: ChatRoomService.getChatRooms)
    var selectedRoom: ChatRoom?
    var selectedRoomMembers = [String: User]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        
        self.navigationItem.hidesBackButton = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "ChatListTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ChatListCell")
        tableView.estimatedRowHeight = 100
        
        if ChatDataController.chatRooms.count > 0 {
            tableView.reloadData()
        } else {
            reload()
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
    
    @objc func reload() {
        ChatDataController.chatRoomPaginationHelper.reloadData(completion: { [weak self] (rooms) in
            ChatDataController.chatRooms = rooms
            self?.tableView.reloadData()
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
        } else {
            return 100
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChatDataController.chatRooms.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell") as! UITableViewCell
            cell.isUserInteractionEnabled = false
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.frame.width, bottom: 0, right: 0)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListCell") as! ChatListTableViewCell
            let room = ChatDataController.chatRooms[indexPath.row-1]
            cell.isUserInteractionEnabled = false
            ChatRoomCellView.configureCell(cell, with: room)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ChatListTableViewCell else { return }
        let room = ChatDataController.chatRooms[indexPath.row-1]
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

