//
//  Database.swift
//  Instasheep
//
//  Created by Guilherme Souza on 31/10/16.
//  Copyright © 2016 Guilherme Souza. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Database {
    
    // Singleton
    static var sharedInstance: Database {
        struct Static {
            static let instance = Database()
        }
        return Static.instance
    }
    
    // MARK: - References
    private let root = FIRDatabase.database().reference()
    private var users: FIRDatabaseReference {
        return root.child("users")
    }
    private var currentUser: FIRDatabaseReference {
        return users.child(Auth.sharedInstance.currentUserUID)
    }
    
    // MARK: - Users
    func createUser(_ value: [String: String?]) {
        currentUser.updateChildValues(value)
    }
}
