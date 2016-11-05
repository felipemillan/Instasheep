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
    }
    
}
