//
//  TakePictureViewController.swift
//  Instasheep
//
//  Created by Guilherme Souza on 04/11/16.
//  Copyright © 2016 Guilherme Souza. All rights reserved.
//

import UIKit

class TakePictureViewController: BaseViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    
    let textViewPlaceholder = "Yeeah! Say something about the pic :D"
    
    let picker = UIImagePickerController()
    var imagePicked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captionTextView.textColor = .lightGray
        captionTextView.text = textViewPlaceholder
        
        captionTextView.delegate = self
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
        
        guard imagePicked else {
            print("Pick an image")
            return
        }
        
        startActivity()
        
        if let imageToUpload = imageView.image,
            let imageData = UIImageJPEGRepresentation(imageToUpload, 0.6) {
            
            let name = NSUUID().uuidString + ".jpg"
            
            Storage.shared.upload(imageData, withName: name, completion: { (downloadUrl, error) in
                
                guard error == nil else {
                    self.stopActivity()
                    print(error!.localizedDescription)
                    return
                }
                
                if let downloadUrl = downloadUrl {
                    
                    let value: [String: String] = [
                        "imageUrl": downloadUrl,
                        "caption": self.captionTextView.text ?? ""
                    ]
                    Database.shared.createPost(value)
                }
                
                self.stopActivity()
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
        
        imagePicked = true
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        tabBarController?.selectedIndex = 0
    }

}


extension TakePictureViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textViewPlaceholder
            textView.textColor = .lightGray
        }
    }
    
}
