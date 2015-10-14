//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Ed Ballington on 9/1/15.
//  Copyright (c) 2015 Ed Ballington. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var ImagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    
// MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        setupMeme()
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    
    }
    
// MARK: Setup
    
    // Setup initial Meme configuration
    func setupMeme() {
        
        topTextField.text = "Top"        //Default placeholder text
        bottomTextField.text = "Bottom"  //Default placeholder text
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor .blackColor(),
            NSForegroundColorAttributeName: UIColor .whiteColor(),
            NSBackgroundColorAttributeName: UIColor .clearColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0
            
        ]
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.textAlignment = NSTextAlignment.Center
        
        ImagePickerView.image = nil
        
        shareButton.enabled = false //Disable Sharing button until user has finished a meme
        
    }
    
// MARK: Image picker
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            ImagePickerView.image = image
        } else {
            print("No image")
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
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func pickImagefromAlbum(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
// MARK: Meme image generation
    
    private func generateMemedImage() -> UIImage {
        
        hideToolbars()
        
        //Render view to a Meme'd image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
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
    
    
// MARK: Saving, Sharing and Cancel

    func save() {
        
        let originalImage = ImagePickerView.image
        let memeImage = generateMemedImage()
        
        // Create the Meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: originalImage!, memeImage: memeImage)
        
        //Add it to the memes array in the App Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    
    }
    
    @IBAction func shareMeme(sender: AnyObject) {
        
        let memeImage = generateMemedImage()
        
        let activityViewController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        
        //Define the completion handler to execute upon successful completion of the activityItem 
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
        
            if success == true {
                
                //Save the meme and dismiss the meme editor view controller
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
        }
        
        
        presentViewController(activityViewController, animated: true, completion: nil)

    }
    
    @IBAction func cancelMeme(sender: AnyObject) {
        
        // Return meme to initial configuration
        dismissViewControllerAnimated(true, completion: nil)
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
        if (bottomTextField .isFirstResponder()) {
                    view.frame.origin.y -= getKeyboardHeight(notification)
        }

    }
    
    //Move the view back down when the keyboard disappears
    func keyboardWillHide(notification: NSNotification) {
        
        //Only move if bottom text field is the one selected
        
        if (bottomTextField .isFirstResponder()) {
        view.frame.origin.y += getKeyboardHeight(notification)
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

