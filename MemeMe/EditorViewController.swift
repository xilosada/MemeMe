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
    var isKeyboardHidden: Bool = true
    
    /// The actual scale method. True for crop, false for fit
    var isCroppModeEnabled: Bool = false
    
    /// Current selected font
    var fontName: String!
    
    var meme: Meme?
    
    static func presentController(controller:UIViewController, defaultMeme: Meme?=nil){
        let mStoryBoard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
        let editorViewControler:EditorViewController = mStoryBoard.instantiateViewControllerWithIdentifier("EditorViewController") as! EditorViewController
        editorViewControler.meme = defaultMeme
        controller.presentViewController(editorViewControler, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.delegate = self
        bottomTextField.delegate = self
        fontName = _impactFontName
        resetViews()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //SPEC The camera button is disabled on devices without a camera.
        cameraButtonItem.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
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
            NSFontAttributeName : UIFont(name: fontName, size: 40)!,
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
        presentViewController(pickController, animated: true, completion: nil)
    }
    
    /**
        SPEC:
        The image from the camera/photo album is displayed.
    */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.contentMode = .ScaleAspectFit
            self.imageView.image = pickedImage
            
            cropButtonItem.enabled = true
            isCroppModeEnabled = false
            shareButtonItem.enabled = true
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }

    /**
        SPEC:
        The view slides up to allow the bottom text field to be shown while typing.
    */
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
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if (!isKeyboardHidden) {
            isKeyboardHidden = true
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    /**
    SPEC:
        When the user presses the “Cancel” button, the Meme Editor 
        View returns to its launch state, 
        displaying no image and default text.
    */
    
    @IBAction func cancelMeme(sender: AnyObject) {
        resetViews()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func resetViews(){
        let memeExists = meme != nil
        shareButtonItem.enabled = memeExists
        cropButtonItem.enabled = memeExists

        
        isCroppModeEnabled = memeExists ? meme!.cropped : false
        cropButtonItem.title = isCroppModeEnabled ? _fitLabel : _cropLabel
        cropButtonItem.title = isCroppModeEnabled ? _fitLabel : _cropLabel

        imageView.contentMode = isCroppModeEnabled ? .ScaleAspectFill : .ScaleAspectFit
        imageView.image = meme?.image
        
        fontName = memeExists ? meme!.fontName : fontName
        topTextField.text =  meme?.topText ?? _topLabelText
        bottomTextField.text = meme?.bottomText ?? _bottomLabelText
        updateMemeTextViews()
    }
    /**
        SPEC:
        The share button launches the Activity View.
    */
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        ///ios/documentation/UIKit/Reference/UIView_Class/index.html
        UIView.animateWithDuration(
            NSTimeInterval(0.2),
            animations: hideToolBars,
            completion: toolbarsDidHide
        )
    }
        
    func hideToolBars() {
        topToolbar.hidden = true
        bottomToolbar.hidden = true
        //topToolbar.frame.origin.y  -= topToolbar.frame.size.height
        //bottomToolbar.frame.origin.y  += bottomToolbar.frame.size.height
    }
    
    func showToolBars() {
        topToolbar.hidden = false
        bottomToolbar.hidden = false
        //topToolbar.frame.origin.y  += topToolbar.frame.size.height
        //bottomToolbar.frame.origin.y  -= bottomToolbar.frame.size.height
    }
    
    func toolbarsDidHide( result: Bool){
        createImage()
    }
    
    func createImage(){
        selectedImage = Meme.makeAnImageFromView(self.view)
        let controller = UIActivityViewController(activityItems: [selectedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = doneSharingHandler
        presentViewController(controller, animated: true, completion: nil)
    }
    
    /**
        SPEC:
        When the share action is complete the meme is saved.
    */
    func doneSharingHandler(activityType: String?, completed: Bool, returnedItems: [AnyObject]?, error: NSError?) {
        UIView.animateWithDuration(
            NSTimeInterval(0.2),
            animations: showToolBars,
            completion: save
        )
        return
    }
    
    /**
        SPEC:
        Memes are stored using a Meme model
    */

    func save(result:Bool){
        let meme = Meme( topText: topTextField.text!, bottomText : bottomTextField.text!,image : imageView.image!, memedImage: selectedImage, cropped: isCroppModeEnabled, fontName:fontName)
        // Add it to the memes array in the Application Delegate
        AppDelegate.getInstance().memes.append(meme)
    }
    
    /**
        EXTRA FEATURE:
        User can crop image
    */
    @IBAction func cropImage(sender: AnyObject) {
        imageView.contentMode = isCroppModeEnabled ? .ScaleAspectFit : .ScaleAspectFill
        isCroppModeEnabled = !isCroppModeEnabled
        cropButtonItem.title = isCroppModeEnabled ? _fitLabel : _cropLabel
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
            controller.dismissViewControllerAnimated(true, completion:nil )
        })
        controller.addAction(actionFontImpact);
        let actionFontOther = UIAlertAction(title:_fontAlertOption2, style: UIAlertActionStyle.Default, handler: {
            _ in
            self.fontName = self._papyrusFontName
            self.configureEditText(self.topTextField)
            self.configureEditText(self.bottomTextField)
            controller.dismissViewControllerAnimated(true, completion:nil )
        })
        controller.addAction(actionFontOther)
        let actionCancel = UIAlertAction(title:_fontAlertOptionCancel, style: UIAlertActionStyle.Destructive, handler:{
            _ in
            controller.dismissViewControllerAnimated(true, completion:nil )
        })
        controller.addAction(actionCancel)
        presentViewController(controller, animated: true, completion: nil)
    }

}
