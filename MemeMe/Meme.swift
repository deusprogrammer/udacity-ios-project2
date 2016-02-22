//
//  MemeImage.swift
//  MemeMe
//
//  Created by Michael Main on 2/19/16.
//  Copyright © 2016 Michael Main. All rights reserved.
//

import Foundation
import UIKit

class Meme {
    var topText:String!
    var bottomText:String!
    var originalImage:UIImage!
    var image:UIImage!
    
    init(topText:String!, bottomText:String!, originalImage:UIImage, image: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.image = image
    }
}