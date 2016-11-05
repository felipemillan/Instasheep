//
//  Helpers.swift
//  Instasheep
//
//  Created by Guilherme Souza on 05/11/16.
//  Copyright © 2016 Guilherme Souza. All rights reserved.
//

import Foundation

func isUsernameValid(_ username: String) -> Bool {
    return !username.contains(" ")
}

//func normalizeUsername(_ oldUsername: String) -> String {
//    
//    let accepterdChars = Set<Character>()
//    
//    let newUsername = oldUsername.lowercased().characters.filter {
//        accepterdChars.hasMember(inPlane: String($0).utf8.first!)
//    }
//    
//    return String(newUsername)
//}
