//
//  ViewController.swift
//  MemeMe
//
//  Created by Ed Ballington on 9/1/15.
//  Copyright (c) 2015 Ed Ballington. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var ImagePickerView: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
// MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topText.delegate = self
        bottomText.delegate = self
        
        topText.text = "Top"        //Default placeholder text
        bottomText.text = "Bottom"  //Default placeholder text
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor .blackColor(),
            NSForegroundColorAttributeName: UIColor .whiteColor(),
            NSBackgroundColorAttributeName: UIColor .clearColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0
        
        ]
        
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        
        topText.textAlignment = NSTextAlignment.Center
        bottomText.textAlignment = NSTextAlignment.Center
        
        shareButton.enabled = false //Disable Sharing button until user has finished a meme
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    
    }
    
// MARK: Image picker
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            self.ImagePickerView.image = image
        } else {
            println("No image")
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        shareButton.enabled = true   //Turn Sharing button back on
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func pickImagefromAlbum(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
// MARK: Meme image generation
    
    private func generateMemedImage() -> UIImage {
        
        hideToolbars()
        
        //Render view to a Meme'd image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        showToolbars()
        
        return memedImage
        
    }
    
    private func hideToolbars() {
        navBar.hidden = true
        toolBar.hidden = true
    }
    
    private func showToolbars() {
        navBar.hidden = false
        toolBar.hidden = false
    }
    
// MARK: Sharing
    @IBAction func shareMeme(sender: AnyObject) {
        
    //TODO: generate the Meme'd image
        let memeImage = self.generateMemedImage()
        
    //TODO: Define instance of ActivityViewController
        let activityViewController = UIActivityViewController(activityItems: [memeImage], applicationActivities: [UIActivityTypeMail, UIActivityTypePostToFacebook, UIActivityTypePostToTwitter])
        
    //TDOO: present ActivityViewController
        self.presentViewController(activityViewController, animated: true, completion: nil)

    }
    
    
// MARK: Delegate methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //Clear the text if it is still set to default placeholder text
        
        if (textField.text == "Top") || (textField.text == "Bottom") {
            textField.text = ""
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    
    //Move the view when the keyboard covers the bottom text field
    func keyboardWillShow(notification: NSNotification) {
        
        //Only move if bottom text field is the one selected
        if (bottomText .isFirstResponder()) {
                    self.view.frame.origin.y -= getKeyboardHeight(notification)
        }

    }
    
    //Move the view back down when the keyboard disappears
    func keyboardWillHide(notification: NSNotification) {
        
        //Only move if bottom text field is the one selected
        
        if (bottomText .isFirstResponder()) {
        self.view.frame.origin.y += getKeyboardHeight(notification)
        }
        
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userinfo = notification.userInfo
        let keyboardSize = userinfo![UIKeyboardFrameEndUserInfoKey] as! NSValue //of CGRrect
        let size = keyboardSize.CGRectValue().height
        return keyboardSize.CGRectValue().height
        
    }
    
    func subscribeToKeyboardNotifications() {
        
        NSNotificationCenter .defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter .defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NSNotificationCenter .defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter .defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
}

