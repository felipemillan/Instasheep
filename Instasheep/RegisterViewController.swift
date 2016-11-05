//
//  RegisterViewController.swift
//  Instasheep
//
//  Created by Guilherme Souza on 05/11/16.
//  Copyright © 2016 Guilherme Souza. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    var picker: UIImagePickerController!
    
    // Flag for knowing if the user picked or not a profile image
    // It is required that user does it.
    var imagePicked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker = UIImagePickerController()
        picker.delegate = self
        
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentPickerController)))
        
        configureUI()
    }
    
    func configureUI() {
        
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 4
        
        registerButton.layer.masksToBounds = true
        registerButton.layer.cornerRadius = 4
        
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        
    }
    
    func presentPickerController() {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        
        guard let name = nameTextField.text,
            let email = emailTextField.text,
            let username = usernameTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text else {
                
                print("Unexpected Error")
                return
        }
        
        // Check if fields are not empty
        if name.characters.count > 0 &&
            email.characters.count > 0 &&
            username.characters.count > 0 &&
            password.characters.count > 0 &&
            confirmPassword.characters.count > 0 {
            
            
            
            if password == confirmPassword {
                
                Database.shared.usernameExists(username, completion: { (exists) in
                    if !exists {
                        
                        Auth.shared.registerNewUser(withEmail: email, password: password, name: name, username: username, completion: { (error) in
                            
                            guard error == nil else {
                                print(error!.localizedDescription)
                                return
                            }
                            
                            // successfully registred
                            
                            // Upload profile image on background
                            if self.imagePicked {
                                if let image = self.profileImageView.image,
                                    let imageData = UIImageJPEGRepresentation(image, 0.6) {
                                    
                                    let imageName = NSUUID().uuidString + ".jpg"
                                    Storage.shared.upload(imageData, withName: imageName, completion: { (downloadUrl, _) in
                                        if let downloadUrl = downloadUrl {
                                            Database.shared.updateUser(["profileImageUrl": downloadUrl])
                                        }
                                    })
                                }
                            }
                            
                            // Segue to next view controller
                            self.performSegue(withIdentifier: "userRegistred", sender: nil)
                            
                        })
                        
                    } else {
                        print("username already taken")
                    }
                })
                
            } else {
                print("passwords doesn't match")
            }
            
        } else {
            print("There are empty fields.")
        }
        
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}
