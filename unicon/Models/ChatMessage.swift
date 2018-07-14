//
//  ChatMessage.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/07/09.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import Foundation
import CoreLocation
import MessageKit
import Firestore.FIRDocumentSnapshot

private struct MockLocationItem: LocationItem {
    
    var location: CLLocation
    var size: CGSize
    
    init(location: CLLocation) {
        self.location = location
        self.size = CGSize(width: 240, height: 240)
    }
    
}

private struct MockMediaItem: MediaItem {
    
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }
    
}

internal struct ChatMessage: MessageType {
    
    var messageId: String
    var sender: Sender
    var sentDate: Date
    var kind: MessageKind
    var creationDate: TimeInterval?
    
    private init(kind: MessageKind, sender: Sender, messageId: String, date: Date) {
        self.kind = kind
        self.sender = sender
        self.messageId = messageId
        self.sentDate = date
    }
    
    init(text: String, sender: Sender, messageId: String, date: Date) {
        self.init(kind: .text(text), sender: sender, messageId: messageId, date: date)
    }
    
    init(attributedText: NSAttributedString, sender: Sender, messageId: String, date: Date) {
        self.init(kind: .attributedText(attributedText), sender: sender, messageId: messageId, date: date)
    }
    
    init(image: UIImage, sender: Sender, messageId: String, date: Date) {
        let mediaItem = MockMediaItem(image: image)
        self.init(kind: .photo(mediaItem), sender: sender, messageId: messageId, date: date)
    }
    
    init(thumbnail: UIImage, sender: Sender, messageId: String, date: Date) {
        let mediaItem = MockMediaItem(image: thumbnail)
        self.init(kind: .video(mediaItem), sender: sender, messageId: messageId, date: date)
    }
    
    init(location: CLLocation, sender: Sender, messageId: String, date: Date) {
        let locationItem = MockLocationItem(location: location)
        self.init(kind: .location(locationItem), sender: sender, messageId: messageId, date: date)
    }
    
    init(emoji: String, sender: Sender, messageId: String, date: Date) {
        self.init(kind: .emoji(emoji), sender: sender, messageId: messageId, date: date)
    }
    
    init?(document: DocumentSnapshot) {
        guard let dict = document.data() as? [String : Any],
            let messageId = dict["messageId"] as? String,
            let senderArray = dict["sender"] as? [String],
            let date = dict["sentDate"] as? Date,
            let message = dict["message"] as? String
            else { return nil }
        
        guard senderArray.count == 2 else { return nil }
        
        let sender = Sender(id: senderArray[0], displayName: senderArray[1])
        self.init(kind: .text(message), sender: sender, messageId: messageId, date: date)
        self.creationDate = date.timeIntervalSince1970
    }
    
    var dictValue: [String : Any] {
        if case let MessageKind.text(code) = kind {
            return [
                "messageId": messageId,
                "sender": [sender.id, sender.displayName],
                "sentDate": sentDate,
                "message": code
            ]
        } else {
            return [
                "err": "it's not text"
            ]
        }
    }
    
    var content: String {
        if case let MessageKind.text(code) = kind {
            return code
        } else {
            return "it's not text"
        }
    }
    
}
