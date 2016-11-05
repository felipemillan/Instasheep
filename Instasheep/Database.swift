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
    static var shared: Database {
        struct Static {
            static let instance = Database()
        }
        return Static.instance
    }
    
    // MARK: - References
    let root = FIRDatabase.database().reference()
    var users: FIRDatabaseReference {
        return root.child("users")
    }
    var currentUser: FIRDatabaseReference {
        return users.child(Auth.shared.currentUserUID)
    }
    
    var currentUserPosts: FIRDatabaseReference {
        return currentUser.child("posts")
    }
    
    var posts: FIRDatabaseReference {
        return root.child("posts")
    }
    
    // MARK: - Users
    func saveUser(withUID uid: String, value: [String: String?], completion: @escaping (Error?) -> Void) {
        
        users.child(uid).setValue(value) { (error, _) in
            completion(error)
        }
        
    }
    
    func createPost(_ post: [String: String]) {
        
        let userUID = Auth.shared.currentUserUID
        
        let key = posts.childByAutoId().key
        
        let values = [
            "/posts/\(key)": post,
            "/user-posts/\(userUID)/\(key)": post
        ]
        
        root.updateChildValues(values)
        
    }
    
}
