//
//  FeedViewController.swift
//  Instasheep
//
//  Created by Guilherme Souza on 31/10/16.
//  Copyright © 2016 Guilherme Souza. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    let cellId = "PostCell"
    
    var posts = [Post]()
    var usernamesForUserPosts = [String]()

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let postCellNib = UINib(nibName: "PostCell", bundle: nil)
        collectionView.register(postCellNib, forCellWithReuseIdentifier: cellId)
        
        fetchPosts()
        
    }

    func fetchPosts() {
        Database.shared.posts.observe(.childAdded, with: {
            snapshot in
            
            if let dict = snapshot.value as? [String: Any] {
                
                let newPost = Post(with: dict)
                if let userUID = newPost.userUID {
                    Database.shared.users.child(userUID).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
                        if let name = snapshot.value as? String {
                            self.usernamesForUserPosts.insert(name, at: 0)
                            self.posts.insert(newPost, at: 0)
                            self.collectionView.reloadData()
                        }
                    })
                }
            }
            
        })
    }


}
// ==================================
//       MARK: - CollecionView
// ==================================

extension FeedViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PostCell
        
        let post = posts[indexPath.row]
        let username = usernamesForUserPosts[indexPath.row]
        
        cell.usernameLabel.text = username
        
        if let imageUrlStr = post.imageUrl,
            let imageUrl = URL(string: imageUrlStr) {
            URLSession.shared.dataTask(with: imageUrl) { (data, reponse, error) in
                
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                
                if let data = data {
                    DispatchQueue.main.async {
                        cell.postImageView.image = UIImage(data: data)
                    }
                }
                
            }.resume()
        }
        
        return cell
    }
    
}

extension FeedViewController: UICollectionViewDelegate {
    
}
