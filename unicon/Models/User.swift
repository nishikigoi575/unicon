//
//  User.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/06/19.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import Foundation
import Firestore.FIRDocumentSnapshot

class User: NSObject {
    
    // MARK: - Properties
    
    let userUID: String
    let userName: String
    var userPhoto:  String
    var userGender: String
    var userAge: String
    var homeLocation: String
    var pushID: String?
    
    // MARK: - Init
    
    init(userUID: String, userName: String, userPhoto: String, pushID: String?) {
        self.userUID = userUID
        self.userName = userName
        self.userPhoto = userPhoto
        self.pushID = pushID
        
        super.init()
    }
    
    init?(document: DocumentSnapshot) {
        guard let dict = document.data() as? [String : Any],
            let userName = dict["userName"] as? String,
            let userPhoto = dict["userPhoto"] as? String
            else { return nil }
        
        self.userUID = document.documentID
        self.userName = userName
        self.userPhoto = userPhoto
        
        if let pushID = dict["pushID"] as? String {
            self.pushID = pushID
        }
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let userUID = aDecoder.decodeObject(forKey: "userUID") as? String,
            let userName = aDecoder.decodeObject(forKey: "userName") as? String,
            let userPhoto = aDecoder.decodeObject(forKey: "userPhoto") as? String
            else { return nil }
        
        self.userUID = userUID
        self.userName = userName
        self.userPhoto = userPhoto
        
        super.init()
    }
    
    private static var _current: User?
    
    static var current: User? {
        return _current
    }
    
    // MARK: - Class Methods
    
    class func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        
        if writeToUserDefaults {
            let data = NSKeyedArchiver.archivedData(withRootObject: user)
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
        }
        
        _current = user
    }
}

extension User: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(userUID, forKey: "userUID")
        aCoder.encode(userName, forKey: "userName")
        aCoder.encode(userPhoto, forKey: "userPhoto")
    }
}
