//
//  ProfileViewController.swift
//  Instasheep
//
//  Created by Guilherme Souza on 07/11/16.
//  Copyright © 2016 Guilherme Souza. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var numberOfPostsLabel: UILabel!
    @IBOutlet weak var numberOfFollowersLabel: UILabel!
    @IBOutlet weak var numberOfFollowingLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        fetchUserData()
        
    }
    
    func configureUI() {
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }


    func fetchUserData() {
        
        Database.shared.currentUser.observeSingleEvent(of: .value, with: {
            snapshot in
            
            if let dict = snapshot.value as? [String: Any] {
                let user = User(withUID: snapshot.key, dictionary: dict)
                
                if let userProfileImageStr = user.profileImageUrl,
                    let imageUrl = URL(string: userProfileImageStr) {
                    
                    URLSession.shared.dataTask(with: imageUrl, completionHandler: { (data, response, error) in
                        guard error == nil else {
                            print(error!.localizedDescription)
                            return
                        }
                        
                        if let data = data {
                            DispatchQueue.main.async {
                                self.profileImageView.image = UIImage(data: data)
                            }
                        }
                    }).resume()
                }
                
                DispatchQueue.main.async {
                    self.navigationItem.title = user.username
                    self.nameLabel.text = user.name
                }
            }
        })
        
    }
    
    @IBAction func editYourProfileButtonTapped(_ sender: UIButton) {
    }
    
    
    
}


extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        return cell
    }
    
    
}
