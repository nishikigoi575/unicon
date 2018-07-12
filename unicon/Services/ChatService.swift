//
//  ChatService.swift
//  unicon
//
//  Created by yo hanashima on 2018/07/11.
//  Copyright © 2018 Imajin Kawabe. All rights reserved.
//

import Foundation
import Firestore
import MessageKit

struct ChatService {
    static func show(chatRoomUID: String, chatUID: String, completion: @escaping (ChatMessage?) -> Void) {
        let ref = Firestore.firestore().collection("chat").document(chatRoomUID).collection("messages").document(chatUID)
        ref.getDocument() { (document, err) in
            if let err = err {
                print(err)
                return completion(nil)
            } else {
                guard let document = document, let message = ChatMessage(document: document) else { return completion(nil) }
                return completion(message)
            }
        }
     }
    
    static func create(chatRoomUID: String, sender: Sender, message: String, completion: @escaping (ChatMessage?) -> Void) {
        let chatRef = Firestore.firestore().collection("chat").document(chatRoomUID).collection("messages").document()
        let msg = ChatMessage(text: message, sender: sender, messageId: chatRef.documentID, date: Date())
        chatRef.setData(msg.dictValue)  { error in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            } else {
                ChatRoomService.update(roomUID: chatRoomUID, key: "lastActiveDate", value: Date()) { success in
                    return completion(msg)
                }
            }
        }
    }
    
    static func getAllChats(chatRoomUID: String, completion: @escaping ([ChatMessage]) -> Void) {
        let ref = Firestore.firestore().collection("chat").document(chatRoomUID).collection("messages")
        ref.getDocuments() { (documents, err) in
            if let err = err {
                print(err.localizedDescription)
                return completion([])
            } else {
                guard let documents = documents else { return completion([]) }
                let dispatchGroup = DispatchGroup()
                var messages = [ChatMessage]()
                for document in documents.documents {
                    dispatchGroup.enter()
                    ChatService.show(chatRoomUID: chatRoomUID, chatUID: document.documentID) { msg in
                        if let msg = msg {
                            messages.append(msg)
                        }
                        dispatchGroup.leave()
                    }
                }
                dispatchGroup.notify(queue: .main, execute: {
                    messages.sort(by: {$0.creationDate! > $1.creationDate!})
                    return completion(messages)
                })
            }
        }
    }
}
