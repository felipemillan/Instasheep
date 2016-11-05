//
//  Post.swift
//  Instasheep
//
//  Created by Guilherme Souza on 04/11/16.
//  Copyright © 2016 Guilherme Souza. All rights reserved.
//

import Foundation

struct Post {
    
    var uid: String?
    var userUID: String?
    var imageUrl: String?
    var caption: String?
    var likes: Int?
    
    init(imageUrl: String?, caption: String?) {
        self.imageUrl = imageUrl
        self.caption = caption
    }
    
    init(with dictionary: [String: Any?]) {
        self.imageUrl = dictionary["imageUrl"] as? String
        self.caption = dictionary["caption"] as? String
        self.userUID = dictionary["userUID"] as? String
    }
    
}
