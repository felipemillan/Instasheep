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
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.init(red: 26/255, green: 58/255, blue: 136/255, alpha: 1).cgColor, UIColor.init(red: 0/255, green: 18/255, blue: 62/255, alpha: 1).cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: view.frame.height)
        
        view.layer.insertSublayer(gradient, at: 0)
        
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 4
        
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 4
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
