//
//  ViewController.swift
//  MemeMe
//
//  Created by Michael Main on 2/19/16.
//  Copyright © 2016 Michael Main. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    // UI Component outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    
    // View controllers
    var imagePicker:UIImagePickerController!
    var activityView:UIActivityViewController!
    
    // State variables
    var keyboardShowing = false
    
    // Currently stored meme data
    var image:UIImage!
    var currentMeme:Meme!
    
    // Map to store default text using text field as the key for easy lookup
    var defaultText = [UITextField:String]()
    
    override func viewWillAppear(animated: Bool) {
        // Enable camera button if camera is available
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // Enable share button if imageviewer has an image
        shareButton.enabled = imageView.image != nil
        
        // Create memeTextAttributes map
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -5.0
        ]
        
        // Setup top text field
        topText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = .Center
        topText.backgroundColor = UIColor.clearColor()
        topText.borderStyle = .None
        topText.text = "TOP TEXT"
        topText.adjustsFontSizeToFitWidth = true
        topText.autocapitalizationType = .AllCharacters
        topText.delegate = self
        
        // Setup bottom text field
        bottomText.defaultTextAttributes = memeTextAttributes
        bottomText.textAlignment = .Center
        bottomText.backgroundColor = UIColor.clearColor()
        bottomText.borderStyle = .None
        bottomText.text = "BOTTOM TEXT"
        bottomText.adjustsFontSizeToFitWidth = true
        bottomText.autocapitalizationType = .AllCharacters
        bottomText.delegate = self
        
        // Store default text for both
        defaultText[topText] = "TOP TEXT"
        defaultText[bottomText] = "BOTTOM TEXT"
        
        // Set background color to black
        self.view.backgroundColor = UIColor.blackColor()
        
        // Subscribe to keyboard notifications
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unsubscribe from keyboard notifications
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // If text field is equal to the default value, clear it
        // Otherwise, leave it alone
        if (textField.text == defaultText[textField]) {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // If text field is empty, then reset the default text
        // Otherwise, leave it as what it's current set to
        if (textField.text == "") {
            textField.text = defaultText[textField]
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // When the text field should return, resign the first responder
        textField.resignFirstResponder()
        return true;
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // On image picker completion, change the image view image
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.contentMode = .ScaleAspectFit
            self.imageView.image = pickedImage
            self.imageView.backgroundColor = UIColor.blackColor()
            
            shareButton.enabled = true
        }
        
        dismissViewControllerAnimated(
            true,
            completion: nil)
    }
    
    func subscribeToKeyboardNotifications() {
        // Add keyboard show and hide observers
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "keyboardWillShow:",
            name: UIKeyboardWillShowNotification,
            object: nil)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "keyboardWillHide:",
            name: UIKeyboardWillHideNotification,
            object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        // Remove keyboard show and hide observers
        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: UIKeyboardWillShowNotification,
            object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: UIKeyboardWillHideNotification,
            object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        // If bottom text is first responder and keyboard isn't showing, show it
        if (bottomText.isFirstResponder() && !keyboardShowing) {
            print("KEYBOARD SHOW")
            keyboardShowing = true
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        // If bottom text is first responder and keyboard is showing, hide it
        if (bottomText.isFirstResponder() && keyboardShowing) {
            print("KEYBOARD HIDE")
            keyboardShowing = false
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        // Get keyboard height
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func takeScreenshot() -> UIImage {
        // Hide tool bars
        self.navigationController?.navigationBarHidden = true
        toolBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let screenShot : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show tool bars
        self.navigationController?.navigationBarHidden = false
        toolBar.hidden = false
        
        return screenShot
    }
    
    func save() {
        //Create the meme
        currentMeme = Meme(
            topText: topText.text,
            bottomText: bottomText.text,
            originalImage: imageView.image!,
            image: image)
    }
    
    func alert(title:String!, message:String!, buttonLabel:String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(
            title: buttonLabel,
            style: UIAlertActionStyle.Cancel,
            handler: {(alertAction: UIAlertAction) -> Void in
                alertController.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(
            alertController,
            animated: true,
            completion: nil)
    }

    @IBAction func sharePressed(sender: AnyObject) {
        image = takeScreenshot()
        activityView = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil)
        
        // Setup activity view completion handler
        activityView.completionWithItemsHandler = {(activityType, completed:Bool, items, error) in
            // If not completed, simply return
            if (!completed) {
                return
            }
            
            // If an error occurred, alert the user
            if ((error) != nil) {
                // TODO Create function to send error report
                self.alert("", message: "Activity failed!", buttonLabel: "Oh Teh Noes!")
                return
            }
            
            // Save meme to meme list
            self.save()
            
            // If the activity type was saving to camera roll, alert them.
            if (activityType == UIActivityTypeSaveToCameraRoll) {
                self.alert("", message: "Image saved to photos!", buttonLabel: "Woot!")
            }
        }
        
        // Present the activity view
        self.presentViewController(activityView, animated: true, completion: nil)
    }
    
    @IBAction func pickPressed(sender: AnyObject) {
        imagePicker = UIImagePickerController()
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.delegate = self
        self.presentViewController(
            imagePicker,
            animated: true,
            completion: nil)
    }
    
    @IBAction func cameraPressed(sender: AnyObject) {
        imagePicker = UIImagePickerController()
        imagePicker.sourceType = .Camera
        imagePicker.delegate = self
        self.presentViewController(
            imagePicker,
            animated: true,
            completion: nil)
    }
}