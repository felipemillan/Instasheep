//
//  Storage.swift
//  Instasheep
//
//  Created by Guilherme Souza on 04/11/16.
//  Copyright © 2016 Guilherme Souza. All rights reserved.
//

import Foundation
import FirebaseStorage

class Storage {
    
    static var shared: Storage {
        struct Static {
            static let instance = Storage()
        }
        return Static.instance
    }
    
    
    // MARK: - References
    private let root = FIRStorage.storage().reference()
    private var users: FIRStorageReference {
        return root.child("users")
    }
    private var currentUser: FIRStorageReference {
        return users.child(Auth.sharedInstance.currentUserUID)
    }
    
    func upload(_ data: Data, withName name: String, completion: @escaping (_ downloadUrl: String?, _ error: Error?) -> Void) {
        let uploadMetadata = FIRStorageMetadata()
        currentUser.child(name).put(data, metadata: uploadMetadata) { metadata, error in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            let downloadUrl = metadata?.downloadURL()?.absoluteString
            completion(downloadUrl, nil)
            
        }
        
    }
    
}
