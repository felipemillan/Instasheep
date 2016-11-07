//
//  User.swift
//  Instasheep
//
//  Created by Guilherme Souza on 07/11/16.
//  Copyright © 2016 Guilherme Souza. All rights reserved.
//

import Foundation

struct User {
    
    var uid: String?
    var name: String?
    var username: String?
    var profileImageUrl: String?
    var email: String?
    
    init(withUID uid: String, dictionary: [String: Any?]) {
        self.uid = uid
        self.name = dictionary["name"] as? String
        self.username = dictionary["username"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
        self.email = dictionary["email"] as? String
    }
    
}
