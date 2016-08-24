//
//  ViewControllerPhoto.swift
//  HH Schedule
//
//  Created by Jack Crawford on 8/22/16.
//  Copyright © 2016 Jack Crawford. All rights reserved.
//

import UIKit

class ViewControllerPhoto: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    
    @IBAction func loadImageButtonTapped(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        let choosePhotoHandler = {(action: UIAlertAction!) -> Void in
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        let takePhotoHandler = {(action: UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                var imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                imagePicker.allowsEditing = false
                self.presentViewController(imagePicker, animated: true, completion: nil)
            } else {
                
            }
        }
        let alertController = UIAlertController(title: "New Photo", message: "Add a new photo of your schedule", preferredStyle: .Alert)
        
        let takePhotoAction = UIAlertAction(title: "Take a Photo", style: .Default, handler: takePhotoHandler)
        alertController.addAction(takePhotoAction)

        let choosePhotoAction = UIAlertAction(title: "Choose a Photo", style: .Default, handler: choosePhotoHandler)
        alertController.addAction(choosePhotoAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .ScaleAspectFit
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}