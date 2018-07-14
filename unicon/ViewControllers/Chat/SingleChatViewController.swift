//
//  SingleChatViewController.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/07/09.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import UIKit
import MessageKit
import Firestore

class SingleChatViewController: MessagesViewController {

    var messageList: [ChatMessage] = []
    var room: ChatRoom?
    var lisner: FIRListenerRegistration?
    var firstLoadDone: Bool = false
    var memberDict: [String: User]?
    
    var paginationHelper: UCPaginationHelper<ChatMessage>!
    
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.hex(hex: "FF5E62", alpha: 1.0)
        
        guard let roomId = room?.uid else { return }
        lisner = Firestore.firestore().collection("chat").document(roomId).collection("messages").addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }

            if self.firstLoadDone {
                snapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                        guard let message = ChatMessage(document: diff.document), let currentUser = User.current else { return }
                        guard message.sender.id != currentUser.userUID else { return }
                        self.messageList.append(message)
                        self.messagesCollectionView.insertSections([self.messageList.count - 1])
                        self.messagesCollectionView.scrollToBottom()
                    }
                    if (diff.type == .modified) {
                        print("Modified city: \(diff.document.data())")
                    }
                    if (diff.type == .removed) {
                        print("Removed city: \(diff.document.data())")
                    }
                }
            }
        }
        
        paginationHelper = UCPaginationHelper<ChatMessage>(keyUID: roomId, serviceMethod: ChatService.getChats)
        paginationHelper.pageSize = 10
        reload()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        
        messageInputBar.delegate = self
        messageInputBar.sendButton.tintColor = UIColor.lightGray
        
        scrollsToBottomOnKeybordBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
        
        messagesCollectionView.backgroundColor = UIColor.hex(hex: "FFFCF2", alpha: 1.0)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        lisner?.remove()
        firstLoadDone = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func reload() {
        paginationHelper.reloadData(completion: { [weak self] (messages) in
            self?.messageList = messages
            DispatchQueue.main.async {
                // messagesCollectionViewをリロードして
                self?.messagesCollectionView.reloadData()
                // 一番下までスクロールする
                self?.messagesCollectionView.scrollToBottom()
                self?.firstLoadDone = true
            }
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
//        print("currentOffsetY: \(currentOffsetY)")
        
        if currentOffsetY < 0 {
            paginationHelper.paginate(completion: { [weak self] (messages) in
                self?.messageList.insert(contentsOf: messages, at: 0)
                DispatchQueue.main.async {
                    self?.messagesCollectionView.reloadData()
                }
            })
        }
    }
    
    func getMessages() -> [ChatMessage] {
        return [
            createMessage(user: User.current!, text: "あ"),
            createMessage(user: User.current!, text: "すせそたちつてとなにぬね\nのはひふへほまみむめもやゆよらりるれろわをん"),
        ]
    }
    
    func createMessage(user: User, text: String) -> ChatMessage {
        let attributedText = NSAttributedString(string: text, attributes: [.font: UIFont(name: "Hiragino Sans", size: 18)!, .foregroundColor: UIColor.black])
        return ChatMessage(attributedText: attributedText, sender: otherSender(user: user), messageId: UUID().uuidString, date: Date())
    }
}

extension SingleChatViewController: MessagesDataSource {
    func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }
    
    
    func currentSender() -> Sender {
        return Sender(id: User.current!.userUID, displayName: User.current!.firstName)
    }
    
    func otherSender(user: User) -> Sender {
        return Sender(id: user.userUID, displayName: user.firstName)
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
    }
    
    // メッセージの上に文字を表示
//    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//        if indexPath.section % 3 == 0 {
//            return NSAttributedString(
//                string: MessageKitDateFormatter.shared.string(from: message.sentDate),
//                attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 10),
//                             NSAttributedStringKey.foregroundColor: UIColor.darkGray]
//            )
//        }
//        return nil
//    }
    
    // メッセージの上に文字を表示（名前）
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    // メッセージの下に文字を表示（日付）
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
}

// メッセージのdelegate
extension SingleChatViewController: MessagesDisplayDelegate {
    
    // メッセージの色を変更（デフォルトは自分：白、相手：黒）
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .darkText
    }
    
    // メッセージの背景色を変更している（デフォルトは自分：赤、相手：グレー）
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ?
            UIColor.hex(hex: "FF5E62", alpha: 1.0) :
            UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    
    // メッセージの枠にしっぽを付ける
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
    
    // アイコンをセット
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        // message.sender.displayNameとかで送信者の名前を取得できるので
        // そこからイニシャルを生成するとよい
        guard let dict = memberDict, let user = dict[message.sender.id] else { return }
        let avatar = Avatar(image: user.userImage, initials: "")
        avatarView.set(avatar: avatar)
    }
}


// 各ラベルの高さを設定（デフォルト0なので必須）
extension SingleChatViewController: MessagesLayoutDelegate {
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
    
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if indexPath.section % 3 == 0 { return 10 }
        return 0
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
}

extension SingleChatViewController: MessageCellDelegate {
    // メッセージをタップした時の挙動
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
    }
}

extension SingleChatViewController: MessageInputBarDelegate {
    // メッセージ送信ボタンをタップした時の挙動
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        for component in inputBar.inputTextView.components {
            if let image = component as? UIImage {
                
                let imageMessage = ChatMessage(image: image, sender: currentSender(), messageId: UUID().uuidString, date: Date())
                messageList.append(imageMessage)
                messagesCollectionView.insertSections([messageList.count - 1])
                
            } else if let text = component as? String {
                if let room = self.room {
                    let msg = ChatMessage(text: text, sender: currentSender(), messageId: UUID().uuidString, date: Date())
                    self.messageList.append(msg)
                    self.messagesCollectionView.insertSections([self.messageList.count - 1])
                    ChatService.create(chatRoom: room, msg: msg) { success in
                        if !success {
                            print("failed send")
                        }
                    }
                    if !room.isActive {
                        room.isActive = true
                    }
                }
                //let attributedText = NSAttributedString(string: text, attributes: [.font: UIFont(name: "Hiragino Sans", size: 18)!, .foregroundColor: UIColor.white])
                //let message = ChatMessage(attributedText: attributedText, sender: currentSender(), messageId: UUID().uuidString, date: Date())
            }
        }
        inputBar.inputTextView.text = String()
        inputBar.inputTextView.resignFirstResponder()
        messagesCollectionView.scrollToBottom()
    }
}
