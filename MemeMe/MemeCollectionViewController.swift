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
        //let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        //let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        //self.collectionView!.contentInset = insets;
        //self.collectionView!.scrollIndicatorInsets = insets
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
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
}