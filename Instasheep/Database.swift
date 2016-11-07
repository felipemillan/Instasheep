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
    
    var usernames: FIRDatabaseReference {
        return root.child("usernames")
    }
    
    var posts: FIRDatabaseReference {
        return root.child("posts")
    }
    
    // MARK: - Users
    
    func usernameExists(_ username: String, completion: @escaping (Bool) -> Void) {
        usernames.child(username).observeSingleEvent(of: .value, with: { snapshot in
            completion(snapshot.exists())
        })
    }
    
    
    func saveUser(withUID uid: String, username: String, value: [String: String?], completion: @escaping (Error?) -> Void) {
        let values = ["/users/\(uid)": value, "/usernames/\(username)": uid] as [String: Any]
        root.updateChildValues(values) { (error, _) in
            completion(error)
        }
    }
    
    func updateUser(_ newValue: [String: String]) {
        currentUser.updateChildValues(newValue)
    }
    
    func createPost(_ _post: [String: String]) {
        
        let userUID = Auth.shared.currentUserUID
        let key = posts.childByAutoId().key
        
        var post = _post
        post["userUID"] = userUID
        
        currentUser.child("username").observeSingleEvent(of: .value, with: { snapshot in
            if let username = snapshot.value as? String {
                post["username"] = username
                let values = [
                    "/posts/\(key)": post,
                    "/user-posts/\(userUID)/\(key)": post
                ]
                self.root.updateChildValues(values)
            }
        })
        
    }
    
}
