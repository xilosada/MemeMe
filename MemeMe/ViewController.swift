//
//  ViewController.swift
//  MemeMe
//
//  Created by X.I. Losada on 18/10/15.
//  Copyright © 2015 XiLosada. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var cropButtonItem: UIBarButtonItem!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var frameView: UIView!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButtonItem: UIBarButtonItem!
    @IBOutlet weak var shareButtonItem: UIBarButtonItem!
    
    var selectedImage: UIImage!
    var isKeyboardHidden: Bool = true
    var isCroppModeEnabled: Bool = false
    var fontName: String = "impact"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureEditText(topTextField)
        configureEditText(bottomTextField)
        topTextField.delegate = self
        bottomTextField.delegate = self
        resetViews()
    }

    @IBAction func cropImage(sender: AnyObject) {
        self.imageView.contentMode = isCroppModeEnabled ? .ScaleAspectFit : .ScaleAspectFill
        isCroppModeEnabled = !isCroppModeEnabled
        self.cropButtonItem.title = isCroppModeEnabled ? "Fit " : "Crop"
    }
    
    @IBAction func changeFont(sender: UIBarButtonItem) {
        let controller = UIAlertController()
        controller.title = "select the font"
        controller.message = "anyFont"
        let actionFontImpact = UIAlertAction(title:"Impact", style: UIAlertActionStyle.Default,handler:{
            action in
            self.fontName = "impact"
            self.configureEditText(self.topTextField)
            self.configureEditText(self.bottomTextField)
            self.dismissViewControllerAnimated(true, completion:nil )
        })
        controller.addAction(actionFontImpact);
        let actionFontOther = UIAlertAction(title:"Papyrus", style: UIAlertActionStyle.Default, handler: {
            action in
            self.fontName = "papyrus"
            self.configureEditText(self.topTextField)
            self.configureEditText(self.bottomTextField)
            self.dismissViewControllerAnimated(true, completion:nil )
        })
        controller.addAction(actionFontOther)
        let actionCancel = UIAlertAction(title:"Cancel", style: UIAlertActionStyle.Destructive, handler:{ action in
            self.dismissViewControllerAnimated(true, completion:nil )
            
        })
        controller.addAction(actionCancel)
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    
    func resetViews(){
        shareButtonItem.enabled = false
        topTextField.text = "TOP TEXT"
        bottomTextField.text = "BOTTOM TEXT"
        imageView.image = nil
        cropButtonItem.title = "Fit"
        cropButtonItem.enabled = false
    }
    
    func configureEditText(textField: UITextField){
        let memeDefaultText = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: fontName, size: 40)!,
            NSStrokeWidthAttributeName : -3
            
        ]
        textField.defaultTextAttributes = memeDefaultText
        textField.textAlignment = .Center
        textField.backgroundColor = .clearColor()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        cameraButtonItem.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        self.subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    func keyboardWillShow(notification: NSNotification) {
        if (isKeyboardHidden && bottomTextField.isFirstResponder()) {
            isKeyboardHidden = false
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if (!isKeyboardHidden) {
            isKeyboardHidden = true
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    @IBAction func takeAPhoto(sender: AnyObject) {
        let pickController = UIImagePickerController()
        pickController.delegate = self
        pickController.sourceType = .PhotoLibrary
        self.presentViewController(pickController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromGallery(sender: AnyObject) {
        let pickController = UIImagePickerController()
        pickController.delegate = self
        pickController.sourceType = .PhotoLibrary
        self.presentViewController(pickController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.contentMode = .ScaleAspectFit
            self.imageView.image = pickedImage
            self.imageView.sizeThatFits(frameView.frame.size)
            
            
            self.cropButtonItem.enabled = true
            self.isCroppModeEnabled = false
            shareButtonItem.enabled = true
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func cancelMeme(sender: AnyObject) {
        resetViews()
    }
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        // Present the Activity View Controller
        UIView.animateWithDuration(
            NSTimeInterval(2.0),
            animations: showToolBar,
            completion: toolbarDidHide
        )
    }
    
    func showToolBar() {
        topToolbar.frame.origin.y  -= topToolbar.frame.size.height;
    }
    
    func hideToolBar() {
        topToolbar.frame.origin.y  += topToolbar.frame.size.height;
    }
    
    func toolbarDidHide( result: Bool){
        createImage()
    }
    
    func createImage(){
        selectedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [selectedImage], applicationActivities: nil)
        self.presentViewController(controller, animated: true, completion: save)
    }
    
    func save(){
        let meme = Meme( topText: topTextField.text!, bottomText : bottomTextField.text!,image : imageView.image!, memedImage: selectedImage!)
        print("TOP TEXT \(meme.topText)")
        print("BOT TEXT \(meme.bottomText)")
        print("BOT TEXT \(meme.image.description)")
        print("BOT TEXT \(meme.memedImage.description)")
        UIView.animateWithDuration(
            NSTimeInterval(2.0),
            animations: hideToolBar,
            completion: nil
        )
    }
    
    func generateMemedImage() -> UIImage
    {
        // Render view to an image
        
    UIGraphicsBeginImageContext(frameView.frame.size)
        let origin = CGPoint(x:0,y:0)
        frameView.drawViewHierarchyInRect(CGRect(origin: origin, size: frameView.frame.size),afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return memedImage
    }
        
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

