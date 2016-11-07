//
//  RegisterViewController.swift
//  Instasheep
//
//  Created by Guilherme Souza on 05/11/16.
//  Copyright © 2016 Guilherme Souza. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RegisterViewController: BaseViewController {
    
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configureUI() {
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.init(red: 26/255, green: 58/255, blue: 136/255, alpha: 1).cgColor, UIColor.init(red: 0/255, green: 18/255, blue: 62/255, alpha: 1).cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: view.frame.height)
        
        view.layer.insertSublayer(gradient, at: 0)
        
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 4
        
        registerButton.layer.masksToBounds = true
        registerButton.layer.cornerRadius = 4
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        
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
        
        startActivity()
        
        guard let name = nameTextField.text,
            let email = emailTextField.text,
            let username = usernameTextField.text,
            let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text else {
                stopActivity()
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
                                self.stopActivity()
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
                            
                            self.stopActivity()
                            // Segue to next view controller
                            self.performSegue(withIdentifier: "userRegistred", sender: nil)
                            
                        })
                        
                    } else {
                        self.stopActivity()
                        print("username already taken")
                    }
                })
                
            } else {
                stopActivity()
                print("passwords doesn't match")
            }
            
        } else {
            stopActivity()
            print("There are empty fields.")
        }
        
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}
