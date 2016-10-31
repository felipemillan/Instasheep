//
//  LoginViewController.swift
//  Instasheep
//
//  Created by Guilherme Souza on 31/10/16.
//  Copyright © 2016 Guilherme Souza. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        facebookLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
        facebookLoginButton.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension LoginViewController: FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if let error = error {
            print(error.localizedDescription)
        } else {
            Auth.sharedInstance.loginWithFacebook() { (success, error) in
                
                if success {
                    // perform segue to home controller
                    print("Yahooo!!!")
                } else {
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
                
            }
        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("didLogOut")
    }
}
