//
//  ViewControllerPhoto.swift
//  HH Schedule
//
//  Created by Jack Crawford on 8/22/16.
//  Copyright © 2016 Jack Crawford. All rights reserved.
//

import UIKit
import CoreData
extension ViewControllerPhoto: UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
class ViewControllerPhoto: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBAction func loadImageButtonTapped(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        let choosePhotoHandler = {(action: UIAlertAction!) -> Void in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .PhotoLibrary
            
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
                let nocameraalertcontroller = UIAlertController(title: "uh oh", message: "your phone done goofed, you got no camera", preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "Oops", style: .Cancel, handler: nil)
                nocameraalertcontroller.addAction(cancelAction)
                self.presentViewController(nocameraalertcontroller, animated: true, completion: nil)

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
    
    @IBOutlet weak var photoscroll: UIScrollView!
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateMinZoomScaleForSize(view.bounds.size)
    }
    private func updateMinZoomScaleForSize(size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        photoscroll.minimumZoomScale = minScale
        
        photoscroll.zoomScale = minScale
    }
    override func viewDidAppear(animated: Bool) {
        imagePicker.delegate = self

        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let imagepathstring = documentsPath as String! + "/ImagePicker/schedule.png"
        //let imagepathstring = imgpath.path
        print(imagepathstring)
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(imagepathstring) {
            let pickedImage = UIImage(contentsOfFile: imagepathstring)
            imageView.image = pickedImage
            imageView.contentMode = .ScaleAspectFit

            
            print("File exists")
            
        } else {
            print("File don't exists")
            
            let choosePhotoHandler = {(action: UIAlertAction!) -> Void in
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .PhotoLibrary
                
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
                    let nocameraalertcontroller = UIAlertController(title: "uh oh", message: "your phone done goofed, you got no camera", preferredStyle: .Alert)
                    let cancelAction = UIAlertAction(title: "Oops", style: .Cancel, handler: nil)
                    nocameraalertcontroller.addAction(cancelAction)
                    self.presentViewController(nocameraalertcontroller, animated: true, completion: nil)
                    
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

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .ScaleAspectFit
            imageView.image = pickedImage
            let image = pickedImage

            
            
            var imagesDirectoryPath:String!
            
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            // Get the Document directory path
            let documentDirectorPath:String = paths[0]
            // Create a new path for the new images folder
            imagesDirectoryPath = documentDirectorPath.stringByAppendingString("/ImagePicker")
            var objcBool:ObjCBool = true
            let isExist = NSFileManager.defaultManager().fileExistsAtPath(imagesDirectoryPath, isDirectory: &objcBool)
            // If the folder with the given path doesn't exist already, create it
            if isExist == false{
                do{
                    try NSFileManager.defaultManager().createDirectoryAtPath(imagesDirectoryPath, withIntermediateDirectories: true, attributes: nil)
                }catch{
                    print("Something went wrong while creating a new folder")
                }
            }
                
            // Save image to Document directory
            var imagePath = "schedule"
            imagePath = imagePath.stringByReplacingOccurrencesOfString(" ", withString: "")
            imagePath = imagesDirectoryPath.stringByAppendingString("/\(imagePath).png")
            print(imagePath)
            let data = UIImagePNGRepresentation(image)
            let success = NSFileManager.defaultManager().createFileAtPath(imagePath, contents: data, attributes: nil)
            
            
            
            
            
        dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}