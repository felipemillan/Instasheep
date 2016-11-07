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
    var usersForPosts = [User]()

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let postCellNib = UINib(nibName: "PostCell", bundle: nil)
        collectionView.register(postCellNib, forCellWithReuseIdentifier: cellId)
        
        fetchPosts()
        
    }
    
    @IBAction func logOutButtonTapped(_ sender: UIBarButtonItem) {
        
        Auth.shared.logout()
        
        if let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") {
            present(loginVC, animated: true, completion: nil)
        }
        
    }
    

    func fetchPosts() {
        Database.shared.posts.observe(.childAdded, with: {
            snapshot in
            
            if let dict = snapshot.value as? [String: Any] {
                
                let newPost = Post(withUID: snapshot.key, dictionary: dict)
                if let userUID = newPost.userUID {
                    
                    Database.shared.users.child(userUID).observeSingleEvent(of: .value, with: { (snapshot) in
                        if let dict = snapshot.value as? [String: Any] {
                            let user = User(withUID: snapshot.key, dictionary: dict)
                            self.usersForPosts.insert(user, at: 0)
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
        let user = usersForPosts[indexPath.row]
        
        cell.usernameLabel.text = user.username
        
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
        
        if let userProfileImageStr = user.profileImageUrl,
            let imageUrl = URL(string: userProfileImageStr) {
            
            URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                
                if let data = data {
                    DispatchQueue.main.async {
                        cell.userProfileImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
            
        }
        
        return cell
    }
    
}

extension FeedViewController: UICollectionViewDelegate {
    
}
