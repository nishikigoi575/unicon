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
    
    static func create(chatRoom: ChatRoom, msg: ChatMessage, success: @escaping (Bool) -> Void) {
        let chatRef = Firestore.firestore().collection("chat").document(chatRoom.uid).collection("messages").document(msg.messageId)
        chatRef.setData(msg.dictValue)  { error in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            } else {
                let dict = ["lastMessage": msg.content, "lastActiveDate": Date()] as [String : Any]
                ChatRoomService.update(room: chatRoom, dict: dict) { suc in
                    if suc {
                        return success(true)
                    } else {
                        return success(false)
                    }
                }
            }
        }
    }
    
    static func getChats(pageSize: UInt, numOfObjects: Int = 0, keyUID: String?, completion: @escaping ([ChatMessage]) -> Void) {
        guard let chatRoomUID = keyUID else { return completion([]) }
        let ref = Firestore.firestore().collection("chat").document(chatRoomUID).collection("messages").order(by: "sentDate", descending: true)
        if numOfObjects > 0 {
            print("message pagination next: \(numOfObjects)")
            let first = ref.limit(to: numOfObjects)
            first.getDocuments {(snapshot, error) in
                guard let snapshot = snapshot else {
                    print("Error retreving price: \(error.debugDescription)")
                    return completion([])
                }
                
                guard let lastSnapshot = snapshot.documents.last else {
                    return completion([])
                }
                
                let next = ref.start(afterDocument: lastSnapshot).limit(to: Int(pageSize))
                next.getDocuments { (nextSnapshot, error) in
                    guard let nextSnapshot = nextSnapshot else {
                        print("Error : \(error.debugDescription)")
                        return completion([])
                    }
                    let dispatchGroup = DispatchGroup()
                    var messages = [ChatMessage]()
                    for msgSnap in nextSnapshot.documents {
                        guard let message = ChatMessage(document: msgSnap) else { continue }
                        dispatchGroup.enter()
                        messages.append(message)
                        dispatchGroup.leave()
                    }
                    dispatchGroup.notify(queue: .main, execute: {
                        messages.sort(by: {$0.creationDate! < $1.creationDate!})
                        completion(messages)
                    })
                }
            }
        } else {
            print("pagination initial")
            let query = ref.limit(to: Int(pageSize))
            query.getDocuments{ (snapshot, error) in
                guard let snapshot = snapshot else {
                    print("Error retreving posts: \(error.debugDescription)")
                    return completion([])
                }
                let dispatchGroup = DispatchGroup()
                
                var messages = [ChatMessage]()
                for msgSnap in snapshot.documents {
                    guard let message = ChatMessage(document: msgSnap) else { continue }
                    dispatchGroup.enter()
                    messages.append(message)
                    dispatchGroup.leave()
                }
                dispatchGroup.notify(queue: .main, execute: {
                    messages.sort(by: {$0.creationDate! < $1.creationDate!})
                    completion(messages)
                })
            }
        }
    }
}
