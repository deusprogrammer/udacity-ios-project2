//
//  TableViewController.swift
//  MemeMe
//
//  Created by Michael Main on 3/30/16.
//  Copyright © 2016 Michael Main. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController : UITableViewController {
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(animated: Bool) {
        // Reload the collection view data
        self.tableView.reloadData()
        
        // Add the new meme button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Meme", style: .Plain, target: self, action: "createNewMeme")
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Get the cell
        let cell = tableView.dequeueReusableCellWithIdentifier("SentMemes")!
        
        // Get the meme from the shared array
        let meme = memes[indexPath.row]
        
        // Set image and text
        cell.textLabel?.text = meme.topText + " " + meme.bottomText
        cell.imageView?.image = meme.image
        cell.imageView?.contentMode = .ScaleAspectFit
        cell.imageView?.backgroundColor = UIColor.blackColor()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Get view controller from story board
        let object: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailVC")
        let detailView = object as! MemeDetailViewController
        
        // Setup view controller before opening
        detailView.hidesBottomBarWhenPushed = true
        detailView.meme = memes[indexPath.row]
        
        // Push the view controller onto the navigation stack
        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
    func createNewMeme() {
        // Get view controller from story board
        let object:AnyObject = (self.storyboard?.instantiateViewControllerWithIdentifier("NewMemeVC"))!
        let viewController:ViewController = object as! ViewController
        
        // Setup view controller before opening
        viewController.hidesBottomBarWhenPushed = true
        
        // Push the view controller onto the navigation stack
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}