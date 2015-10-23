//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by X.I. Losada on 20/10/15.
//  Copyright © 2015 XiLosada. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    ///an array of Meme instances.
    var memes: [Meme]! {
        return AppDelegate.getInstance().memes
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView!.backgroundColor = UIColor.whiteColor()
        collectionView!.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
        
        cell.imageView.image = meme.memedImage
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        MemeDetailViewController.pushController(self as UIViewController, meme: memes[indexPath.row])
    }
    
    @IBAction func openEditor(sender: AnyObject!) {
        EditorViewController.presentController(self as UIViewController)
    }
}