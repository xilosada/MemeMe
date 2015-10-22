//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by X.I. Losada on 20/10/15.
//  Copyright © 2015 XiLosada. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // This is an array of Meme instances.
    var memes: [Meme]! {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //self.tableView.reloadData()
    }
    // MARK: Collection View Data Source
    
    // MARK: Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewRow")! as! MemeTableViewRow
    let meme = self.memes[indexPath.row]
    
    // Set the name and image
    cell.topTextView?.text = meme.topText
    cell.bottomTextView?.text = meme.bottomText
    cell.thumbnailView?.image = meme.memedImage
    
    return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
    detailController.meme = self.memes[indexPath.row]
    self.navigationController!.pushViewController(detailController, animated: true)
    
    }

    
    @IBAction func openEditor(sender: AnyObject!) {
        let mStoryBoard: UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
        let editorViewControler:EditorViewController = mStoryBoard.instantiateViewControllerWithIdentifier("EditorViewController") as! EditorViewController
        self.presentViewController(editorViewControler, animated: true, completion: nil)
        
    }
    

}