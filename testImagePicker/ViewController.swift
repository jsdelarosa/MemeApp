//
//  ViewController.swift
//  testImagePicker
//
//  Created by Salvador De La Rosa on 7/11/16.
//  Copyright © 2016 Magnolia Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var topText: UITextField!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
  

    struct Meme {
        var top: String
        var bottom: String
        var image: UIImage
        
        // The actual meme image. It was built using the meme elemets
        var memedImage: UIImage
        
        init(top: String, bottom: String, image: UIImage, memedImage: UIImage) {
            self.top = top
            self.bottom = bottom
            self.image = image
            self.memedImage = memedImage
        }
    }

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
        textProperties()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textProperties() {
        topText.textAlignment = .Center
        bottomText.textAlignment = .Center
        
        topText.text = "Insert Text"
        bottomText.text = "Insert Text"
        
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        
        topText.delegate = self
        bottomText.delegate = self
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
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
        // self.dismissViewControllerAnimated(true, completion: nil)
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        let memedImage = generateMemedImage()
        
        
        let nextController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
                
        presentViewController(nextController, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelMeme(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
        textProperties()
        print("done")
    }
    
    //Moves the view when the kb covers the text field
    func keyboardWillShow(notification: NSNotification) {
    
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    //Returns the view when keyboard dismisses
    func keyboardWillHide(notification: NSNotification) {
        
        view.frame.origin.y = 0
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
    
    
    
    func save(memedImage: UIImage!) {

        //Create the meme

        let meme = Meme(top: topText.text!, bottom: bottomText.text!, image: imagePickerView.image!, memedImage: memedImage)
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

