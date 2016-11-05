//
//  UIImagePickerController+RegisterViewController.swift
//  Instasheep
//
//  Created by Guilherme Souza on 05/11/16.
//  Copyright © 2016 Guilherme Souza. All rights reserved.
//

import UIKit

extension RegisterViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var pickedImage: UIImage?
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            pickedImage = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pickedImage = originalImage
        }
        
        if pickedImage != nil {
            imagePicked = true
            profileImageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }


}
