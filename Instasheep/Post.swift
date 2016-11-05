//
//  Post.swift
//  Instasheep
//
//  Created by Guilherme Souza on 04/11/16.
//  Copyright © 2016 Guilherme Souza. All rights reserved.
//

import Foundation

struct Post {
    
    var imageUrl: String
    var caption: String
    
    init(imageUrl: String, caption: String) {
        self.imageUrl = imageUrl
        self.caption = caption
    }
    
    init(with dictionary: [String: Any]) {
        self.imageUrl = "\(dictionary["image_url"])"
        self.caption = "\(dictionary["caption"])"
    }
    
}
