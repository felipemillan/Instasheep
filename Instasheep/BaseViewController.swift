//
//  BaseViewController.swift
//  Instasheep
//
//  Created by Guilherme Souza on 07/11/16.
//  Copyright © 2016 Guilherme Souza. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    lazy var activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50.0, height: 50.0))
        ai.center = self.view.center
        ai.activityIndicatorViewStyle = .whiteLarge
        return ai
    }()
    
    lazy var blurView: UIView = {
        let bv = UIView(frame: self.view.frame)
        bv.backgroundColor = UIColor.init(red: 0/255, green: 18/255, blue: 62/255, alpha: 1)
        bv.alpha = 0.7
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bv.addSubview(blurEffectView)
        return bv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    func startActivity() {
        view.addSubview(blurView)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func stopActivity() {
        blurView.removeFromSuperview()
        activityIndicator.stopAnimating()
    }

}
