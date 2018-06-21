//
//  User.swift
//  unicon
//
//  Created by Imajin Kawabe on 2018/06/21.
//  Copyright © 2018年 Imajin Kawabe. All rights reserved.
//

import Foundation
import Firestore.FIRDocumentSnapshot
import FirebaseAuth

class User: NSObject {
    
    // MARK: - Properties
    
    let userUID: String
    let firstName: String
    var userImage:  String
    var belongsToTeam: Bool?
    var pushID: String?
    var facebookID: String?
    
    // Need App Review from facebook to get these data
    var age: Int?
    var gender: String?
    var area: String?
    
    
    // To write
    init(userUID: String, firstName: String, userImage: String, pushID: String?, belongsToTeam: Bool?) {
        self.userUID = userUID
        self.firstName = firstName
        self.userImage = userImage
        self.pushID = pushID
        self.belongsToTeam = belongsToTeam
        
        super.init()
    }
    
    init?(document: DocumentSnapshot) {
        guard let dict = document.data() as? [String : Any],
            let firstName = dict["firstName"] as? String,
            let userImage = dict["userImage"] as? String
            else { return nil }
        
        self.userUID = document.documentID
        self.firstName = firstName
        self.userImage = userImage
        
        
        if let pushID = dict["pushID"] as? String {
            self.pushID = pushID
        }
        
        if let belongs = dict["belongsToTeam"] as? Bool {
            self.belongsToTeam = belongs
        }
        
        super.init()
    }
    
//    required init?(coder aDecoder: NSCoder) {
//        guard let userUID = aDecoder.decodeObject(forKey: Constants.UserDefaults.userUID) as? String,
//            let firstName = aDecoder.decodeObject(forKey: Constants.UserDefaults.firstName) as? String,
//            let userImage = aDecoder.decodeObject(forKey: Constants.UserDefaults.userImage) as? String
//            else { return nil }
//        
//        self.userUID = userUID
//        self.firstName = firstName
//        self.userImage = userImage
//        
//        if let pushID = aDecoder.decodeObject(forKey: Constants.UserDefaults.pushID) as? String {
//            self.pushID = pushID
//        }
//        
//        super.init()
//    }
//    
//    private static var _current: User?
//    
//    static var current: User? {
//        return _current
//    }
//    
//    // MARK: - Class Methods
//    
//    class func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
//        
//        if writeToUserDefaults {
//            let data = NSKeyedArchiver.archivedData(withRootObject: user)
//            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
//        }
//        
//        _current = user
//    }
}
