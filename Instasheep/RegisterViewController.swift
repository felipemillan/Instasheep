//
//  RegisterViewController.swift
//  Instasheep
//
//  Created by Guilherme Souza on 05/11/16.
//  Copyright © 2016 Guilherme Souza. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                
                Auth.shared.registerNewUser(withEmail: email, password: password, name: name, username: username, completion: { (error) in
                    
                    guard error == nil else {
                        print(error!.localizedDescription)
                        return
                    }
                    
                    // successfully registred
                    
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
