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
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CSentMemes", forIndexPath:  indexPath)
        let meme = memes[indexPath.row]
        let imageView = UIImageView(image: meme.image)
        
        cell.backgroundView = imageView
        
        return cell
    }
}