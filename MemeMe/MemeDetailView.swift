//
//  MemeDetailView.swift
//  MemeMe
//
//  Created by Michael Main on 4/2/16.
//  Copyright © 2016 Michael Main. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController : UIViewController {
    @IBOutlet weak var imageView:UIImageView?
    var meme:Meme?
    
    override func viewWillAppear(animated: Bool) {
        // Setup image view
        imageView!.image = meme?.image
        imageView!.contentMode = .ScaleAspectFit
        imageView!.backgroundColor = UIColor.blackColor()
    }
}