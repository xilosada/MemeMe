//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by X.I. Losada on 20/10/15.
//  Copyright © 2015 XiLosada. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme : Meme!
    var isToolbarVisible = true

    @IBOutlet weak var memedImageView: UIImageView!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    static func pushController(controller:UIViewController, meme:Meme){
        let mStoryBoard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
        let detailController = mStoryBoard.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = meme
        controller.navigationController!.pushViewController(detailController, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.hidden = true
        congigureScreenOrienttation()
        addTapRecognizerToImageView()
        memedImageView.image = meme.memedImage
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.hidden = false
    }
    /**
        An “Edit” button launches the Meme Editor.
    */
    @IBAction func openEditor(sender: AnyObject) {
        EditorViewController.presentController(self as UIViewController, defaultMeme:meme)
    }
    /**
        change device orientation, if needed, to fit the image
        http://stackoverflow.com/questions/27037839
    */
    func congigureScreenOrienttation(){
        let interfaceOrientationvalue : UIInterfaceOrientation
        if meme.memedImage.size.height >= meme.memedImage.size.width{
            //already in portrait
            if UIDevice.currentDevice().orientation == .Portrait { return }
            interfaceOrientationvalue = UIInterfaceOrientation.Portrait
        }else{
            //already in landscape
            if UIDevice.currentDevice().orientation != .Portrait { return }
            interfaceOrientationvalue = UIInterfaceOrientation.LandscapeLeft
        }
        UIDevice.currentDevice().setValue(interfaceOrientationvalue.rawValue, forKey: "orientation")
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    func addTapRecognizerToImageView(){
        //http://stackoverflow.com/questions/855095
        let tapRecognizer = UITapGestureRecognizer(target:self,action:"toggleToolbars")
        memedImageView.userInteractionEnabled = true
        memedImageView.addGestureRecognizer(tapRecognizer)
    }
    
    func toggleToolbars(){
        if isToolbarVisible{
            navigationController?.navigationBarHidden = true
            bottomToolbar.hidden = true
        }else{
            navigationController?.navigationBarHidden = false
            bottomToolbar.hidden = false
        }
        isToolbarVisible = !isToolbarVisible
    }
}