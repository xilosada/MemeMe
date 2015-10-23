//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by X.I. Losada on 20/10/15.
//  Copyright © 2015 XiLosada. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController {
    
    // This is an array of Meme instances.
    var memes: [Meme]! {
        return AppDelegate.getInstance().memes
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewRow")! as! MemeTableViewRow
        let meme = memes[indexPath.row]
    
        cell.topTextView.text = meme.topText
        cell.bottomTextView.text = meme.bottomText
        cell.thumbnailView.image = meme.memedImage
    
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete{
            AppDelegate.getInstance().removeMeme(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        MemeDetailViewController.pushController(self as UIViewController, meme: memes[indexPath.row])
    }
    
    @IBAction func openEditor(sender: AnyObject!) {
        EditorViewController.presentController(self as UIViewController)
    }
}