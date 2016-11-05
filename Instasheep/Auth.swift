//
//  Auth.swift
//  Instasheep
//
//  Created by Guilherme Souza on 31/10/16.
//  Copyright © 2016 Guilherme Souza. All rights reserved.
//

import Foundation
import FirebaseAuth

class Auth {
    static var shared: Auth {
        struct Static {
            static let instance = Auth()
        }
        return Static.instance
    }
    
    private let auth = FIRAuth.auth()
    private let isLoggedInKey = "isLoggedIn"
    
    var currentUserUID: String {
        get {
            return (auth?.currentUser?.uid) ?? ""
        }
    }
    
    var isLoggedIn: Bool {
        return UserDefaults.standard.bool(forKey: isLoggedInKey)
    }
    
    func registerNewUser(withEmail email: String, password: String, name: String, username: String, completion: @escaping (Error?) -> Void) {
        
        auth?.createUser(withEmail: email, password: password) { (user, error) in
            guard error == nil else {
                completion(error)
                return
            }
            
            let value = [
                "name": name,
                "email": email,
                "username": username
            ]
            
            if let user = user {
                Database.shared.saveUser(withUID: user.uid, value: value) { error in
                    guard error == nil else {
                        completion(error)
                        return
                    }
                    
                    UserDefaults.standard.set(true, forKey: self.isLoggedInKey)
                    completion(nil)
                }
            }
        }
        
    }
    
    
    func logout() {
        if ((try? auth?.signOut()) != nil) {
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
        }
    }
}
