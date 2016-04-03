//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by Michael Main on 3/30/16.
//  Copyright © 2016 Michael Main. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController : UICollectionViewController {
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(animated: Bool) {
        self.collectionView?.reloadData()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Meme", style: .Plain, target: self, action: "createNewMeme")
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CSentMemes", forIndexPath:  indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
        
        // Set image
        cell.imageView.image = meme.image
        cell.imageView.contentMode = .ScaleAspectFit
        cell.imageView.backgroundColor = UIColor.blackColor()
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //Grab the DetailVC from Storyboard
        let object: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailVC")
        let detailView = object as! MemeDetailViewController
        detailView.hidesBottomBarWhenPushed = true
        detailView.meme = memes[indexPath.row]
        
        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
    func createNewMeme() {
        let object:AnyObject = (self.storyboard?.instantiateViewControllerWithIdentifier("NewMemeVC"))!
        let viewController:ViewController = object as! ViewController
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        //self.presentViewController(viewController, animated: true, completion: nil)
    }
}