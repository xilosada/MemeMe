//
//  EditorViewController.swift
//  MemeMe
//
//  Created by X.I. Losada on 18/10/15.
//  Copyright © 2015 XiLosada. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButtonItem: UIBarButtonItem!
    @IBOutlet weak var cropButtonItem: UIBarButtonItem!
    @IBOutlet weak var shareButtonItem: UIBarButtonItem!
    
    ///EXTRA FEATURE: App uses “Impact” font
    let _impactFontName: String = "impact"
    let _papyrusFontName: String = "papyrus"
    let _cropLabel: String = "Crop"
    let _fitLabel: String = "Fit"
    let _fontAlertTitle: String = "Font Type"
    let _fontAlertDescription: String = "Select the font of the textFields"
    let _fontAlertOption1: String = "Impact"
    let _fontAlertOption2: String = "Papyrus"
    let _fontAlertOptionCancel: String = "Cancel"
    let _topLabelText: String = "TOP TEXT"
    let _bottomLabelText: String = "BOTTOM TEXT"

    var selectedImage: UIImage!
    var memedImage: UIImage!
    var isKeyboardHidden: Bool = true
<<<<<<< HEAD:MemeMe/ViewController.swift
    
    /// The actual scale method. True for crop, false for fit
    var isCroppModeEnabled: Bool = false
    
    /// Current selected font
    var fontName: String!
    
=======

>>>>>>> finished collection, table and detail views:MemeMe/EditorViewController.swift
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.delegate = self
        bottomTextField.delegate = self
        resetViews()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //SPEC The camera button is disabled on devices without a camera.
        cameraButtonItem.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    /**
        SPEC:
        Text fields are provided for top and bottom text in a font and style that are easy to read:
        bold, all caps, white with a black outlineand shrink to fit.
    */
    func updateMemeTextViews(){
        configureEditText(topTextField)
        configureEditText(bottomTextField)
    }
    
    func configureEditText(textField: UITextField){
        let memeDefaultText = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: self.fontName, size: 40)!,
            NSStrokeWidthAttributeName : -3
            
        ]
        textField.defaultTextAttributes = memeDefaultText
        textField.sizeToFit()
        textField.textAlignment = .Center
        textField.backgroundColor = .clearColor()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /**
        SPEC:
        The app displays the camera when the camera button is pressed on a phone.
    */
    @IBAction func takeAPhoto(sender: AnyObject) {
        //TODO: Test in a real device
        pickAnImageFromSource(.Camera, cameraMode:true)
    }
    
    /**
        SPEC:
        The app displays the image picker when the Album button is pressed.
    */
    @IBAction func pickAnImageFromGallery(sender: AnyObject) {
        pickAnImageFromSource(.PhotoLibrary, cameraMode:false)
    }
    
    func pickAnImageFromSource(sourceType:UIImagePickerControllerSourceType, cameraMode: Bool){
        let pickController = UIImagePickerController()
        pickController.delegate = self
        pickController.sourceType = sourceType
        if cameraMode{
            //from http://makeapppie.com/2014/12/04/swift-swift-using-the-uiimagepickercontroller-for-a-camera-and-photo-library/
            pickController.cameraCaptureMode = .Photo
            pickController.modalPresentationStyle = .FullScreen
        }
        self.presentViewController(pickController, animated: true, completion: nil)
    }
    
    /**
        SPEC:
        The image from the camera/photo album is displayed.
    */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.contentMode = .ScaleAspectFit
            self.imageView.image = pickedImage
            
            self.cropButtonItem.enabled = true
            self.isCroppModeEnabled = false
            shareButtonItem.enabled = true
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
        SPEC:
        The view slides up to allow the bottom text field to be shown while typing.
    */
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "phoneDidRotate:"    , name: UIDeviceOrientationDidChangeNotification, object: nil)
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
<<<<<<< HEAD:MemeMe/ViewController.swift

    /**
    SPEC:
        When the user presses the “Cancel” button, the Meme Editor 
        View returns to its launch state, 
        displaying no image and default text.
    */
    @IBAction func cancelMeme(sender: AnyObject) {
        resetViews()
=======
    
    func phoneDidRotate(notification: NSNotification){
        imageView.image = selectedImage
        imageView.sizeThatFits(frameView.frame.size)
    }
    
    @IBAction func takeAPhoto(sender: AnyObject) {
        let pickController = UIImagePickerController()
        pickController.delegate = self
        pickController.sourceType = .PhotoLibrary
        self.presentViewController(pickController, animated: true, completion: nil)
>>>>>>> finished collection, table and detail views:MemeMe/EditorViewController.swift
    }
    
    func resetViews(){
        shareButtonItem.enabled = false
        imageView.image = nil
        cropButtonItem.enabled = false
        cropButtonItem.title = _cropLabel
        self.fontName = _impactFontName
        topTextField.text = _topLabelText
        bottomTextField.text = _bottomLabelText
        updateMemeTextViews()
    }
    
<<<<<<< HEAD:MemeMe/ViewController.swift
    /**
        SPEC:
        The share button launches the Activity View.
    */
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        ///ios/documentation/UIKit/Reference/UIView_Class/index.html
        UIView.animateWithDuration(
            NSTimeInterval(0.5),
            animations: hideToolBars,
            completion: toolbarsDidHide
        )
    }
    
    func hideToolBars() {
        topToolbar.frame.origin.y  -= topToolbar.frame.size.height
        bottomToolbar.frame.origin.y  += bottomToolbar.frame.size.height

    }
    
    func showToolBars() {
        topToolbar.frame.origin.y  += topToolbar.frame.size.height
        bottomToolbar.frame.origin.y  -= bottomToolbar.frame.size.height
    }
    
    func toolbarsDidHide( result: Bool){
        createImage()
    }
    
    func createImage(){
        selectedImage = Meme.makeAnImageFromView(self.view)
        let controller = UIActivityViewController(activityItems: [selectedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = doneSharingHandler
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    /**
        SPEC:
        When the share action is complete the meme is saved.
    */
    func doneSharingHandler(activityType: String?, completed: Bool, returnedItems: [AnyObject]?, error: NSError?) {
        UIView.animateWithDuration(
            NSTimeInterval(0.5),
            animations: showToolBars,
            completion: save
        )
        return
    }
    
    /**
        SPEC:
        Memes are stored using a Meme model
    */
    func save(finished: Bool){
        let meme = Meme( topText: topTextField.text!, bottomText : bottomTextField.text!,image : imageView.image!, memedImage: selectedImage!)
        print("TOP TEXT \(meme.topText)")
        print("BOT TEXT \(meme.bottomText)")
        print("BOT TEXT \(meme.image.description)")
        print("BOT TEXT \(meme.memedImage.description)")
=======
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.contentMode = .ScaleAspectFit
            self.imageView.image = pickedImage
            self.imageView.sizeThatFits(frameView.frame.size)
            shareButtonItem.enabled = true
            selectedImage = pickedImage
        }
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func cancelMeme(sender: AnyObject) {
        resetViews()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        // Present the Activity View Controller
        memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.presentViewController(controller, animated: true, completion: save)
    }
    
    func save(){
        let meme = Meme( topText: topTextField.text!, bottomText : bottomTextField.text!,image : imageView.image!, memedImage: memedImage)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
>>>>>>> finished collection, table and detail views:MemeMe/EditorViewController.swift
    }
    
    /**
        EXTRA FEATURE:
        User can crop image
    */
    @IBAction func cropImage(sender: AnyObject) {
        self.imageView.contentMode = isCroppModeEnabled ? .ScaleAspectFit : .ScaleAspectFill
        isCroppModeEnabled = !isCroppModeEnabled
        self.cropButtonItem.title = isCroppModeEnabled ? _fitLabel : _cropLabel
    }
    
    /**
        EXTRA FEATURE:
        User can choose between different fonts
    */
    @IBAction func changeFont(sender: UIBarButtonItem) {
        let controller = UIAlertController()
        controller.title = _fontAlertTitle
        controller.message = _fontAlertDescription
        let actionFontImpact = UIAlertAction(title:_fontAlertOption1, style: UIAlertActionStyle.Default,handler:{
            _ in
            self.fontName = self._impactFontName
            self.configureEditText(self.topTextField)
            self.configureEditText(self.bottomTextField)
            self.dismissViewControllerAnimated(true, completion:nil )
        })
        controller.addAction(actionFontImpact);
        let actionFontOther = UIAlertAction(title:_fontAlertOption2, style: UIAlertActionStyle.Default, handler: {
            _ in
            self.fontName = self._papyrusFontName
            self.configureEditText(self.topTextField)
            self.configureEditText(self.bottomTextField)
            self.dismissViewControllerAnimated(true, completion:nil )
        })
        controller.addAction(actionFontOther)
        let actionCancel = UIAlertAction(title:_fontAlertOptionCancel, style: UIAlertActionStyle.Destructive, handler:{
            _ in
            self.dismissViewControllerAnimated(true, completion:nil )
            
        })
        controller.addAction(actionCancel)
        self.presentViewController(controller, animated: true, completion: nil)
    }

}

