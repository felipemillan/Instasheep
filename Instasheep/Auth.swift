//
//  Auth.swift
//  Instasheep
//
//  Created by Guilherme Souza on 31/10/16.
//  Copyright © 2016 Guilherme Souza. All rights reserved.
//

import Foundation
import FirebaseAuth
import FBSDKLoginKit

class Auth {
    static var sharedInstance: Auth {
        struct Static {
            static let instance = Auth()
        }
        return Static.instance
    }
    
    private let auth = FIRAuth.auth()
    
    var currentUserUID: String {
        get {
            return (auth?.currentUser?.uid) ?? ""
        }
    }
    
    func loginWithFacebook(_ completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        auth?.signIn(with: credential, completion: { (user, error) in
            guard error == nil else {
                completion(false, error)
                return
            }
            
            if let user = user {
//                let newUser = [
//                    "name": user.displayName,
//                    "email": user.email
//                ]
                
                // save new user to database
                
                completion(true, nil)
            } else {
                completion(false, error)
            }
        })
    }
    
    
    func logout() throws {
        try auth?.signOut()
    }
}
