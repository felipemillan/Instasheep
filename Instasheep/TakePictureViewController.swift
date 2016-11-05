//
//  TakePictureViewController.swift
//  Instasheep
//
//  Created by Guilherme Souza on 04/11/16.
//  Copyright © 2016 Guilherme Souza. All rights reserved.
//

import UIKit

class TakePictureViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePresentingImagePickerController)))
        
    }
    
    func handlePresentingImagePickerController() {
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        // Magic happens!
        
        if let imageToUpload = imageView.image,
            let imageData = UIImageJPEGRepresentation(imageToUpload, 0.6) {
            
            
            let name = NSUUID().uuidString + ".jpg"
            
            
            Storage.shared.upload(imageData, withName: name, completion: { (downloadUrl, error) in
                
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                
                if let downloadUrl = downloadUrl {
                    
                    let value: [String: String] = [
                        "userUID": Auth.sharedInstance.currentUserUID,
                        "imageUrl": downloadUrl,
                        "caption": self.captionTextField.text ?? ""
                    ]
                    Database.sharedInstance.createPost(value)
                }
                
                self.tabBarController?.selectedIndex = 0
                
            })
            
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageView.image = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = originalImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        tabBarController?.selectedIndex = 0
    }

}
