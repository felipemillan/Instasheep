//
//  LoginViewController.swift
//  Instasheep
//
//  Created by Guilherme Souza on 31/10/16.
//  Copyright © 2016 Guilherme Souza. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    func configureUI() {
        
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 4
        
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 4
        
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {
                print("Unexpected error")
                return
        }
        
        if email.characters.count > 0 && password.characters.count > 0 {
            
            Auth.shared.loginUser(withEmail: email, password: password, completion: { (error) in
                
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                
                self.performSegue(withIdentifier: "userLoggedIn", sender: nil)
                
            })
            
        }
        
    }
    
}
