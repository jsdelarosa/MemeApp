//
//  ViewController.swift
//  testImagePicker
//
//  Created by Salvador De La Rosa on 7/11/16.
//  Copyright © 2016 Magnolia Inc. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var topText: UITextField!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
  

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
        imagePickerView.image = image
        shareButton.enabled = true
        }
        
    dismissViewControllerAnimated(true, completion: nil)
    }
    
    let imagePicker = UIImagePickerController()
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view, typically from a nib.
        setupTextField(topText)
        setupTextField(bottomText)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera);
        shareButton.enabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
         // Subscribe to keyboard notifications to allow the view to raise when necessary
        subscribeToKeyboardNotifications()
        subsbscribeToKeyboardHideNotification()
    }
    
    override func viewWillDisappear(animated: Bool) {
          super.viewWillAppear(animated)
        unsubscribeFromKeyboardNotifications()
        unsubscribeToKeyboardHideNotification()
    }
    
    func setupTextField(textField: UITextField!) {
        textField.text = "Insert Text"
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .Center
        textField.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        view.endEditing(true)
        return false
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as!NSValue
        return keyboardSize.CGRectValue().height
    }

    //Select the path of the image Album or camera
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        pickAnImageFromSource(.PhotoLibrary)

    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        pickAnImageFromSource(.Camera)
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            if success {
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        presentViewController(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelMeme(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
        setupTextField(topText)
        setupTextField(bottomText)
    }
    
    func pickAnImageFromSource(source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //Moves the view when the kb covers the text field
    func keyboardWillShow(notification: NSNotification) {
        if bottomText.isFirstResponder() {
          view.frame.origin.y = getKeyboardHeight(notification) * (-1)
        }
    }
    
    //Returns the view when keyboard dismisses
    func keyboardWillHide(notification: NSNotification) {
        if bottomText.isFirstResponder() {
            view.frame.origin.y = 0
        }
    }
    
    //Subscribe & Unsubscribe from Keyboard Notifications
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    
    func subsbscribeToKeyboardHideNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardHideNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    
    func save() {

        //Create the meme
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, image: imagePickerView.image!, memedImage: generateMemedImage())

     }
    
    func generateMemedImage() -> UIImage {
        
        //Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return memedImage
    }
}

