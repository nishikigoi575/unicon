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
    
    var chatRooms = [ChatRoom]()
    let paginationHelper = UCPaginationHelper<ChatRoom>(keyUID: nil, serviceMethod: ChatRoomService.getChatRooms)
    var selectedRoomUID: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        
        self.navigationItem.hidesBackButton = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "ChatListTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ChatListCell")
        
        reload()
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
        self.paginationHelper.reloadData(completion: { [weak self] (rooms) in
            self?.chatRooms = rooms
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
            
            paginationHelper.paginate(completion: { [weak self] (rooms) in
                self?.chatRooms.append(contentsOf: rooms)
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            })
        }
    }
    
}

extension ChatViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListCell") as! ChatListTableViewCell
        let room = chatRooms[indexPath.row]
        
        ChatRoomCellView.configureCell(cell, with: room)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = chatRooms[indexPath.row]
        selectedRoomUID = room.uid
            
        performSegue(withIdentifier: "ToSingleChat", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToSingleChat"){
            let singleChatVC = segue.destination as! SingleChatViewController
            singleChatVC.roomUID = selectedRoomUID
        }
    }
    
}

