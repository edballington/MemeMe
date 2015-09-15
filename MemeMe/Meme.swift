//
//  Meme.swift
//  MemeMe
//
//  Created by Ed Ballington on 9/8/15.
//  Copyright (c) 2015 Ed Ballington. All rights reserved.
//

import Foundation
import UIKit

class Meme  {
    var topText = ""
    var bottomText = ""
    var originalImage = UIImage()
    var memeImage = UIImage()
    
    func save(topText: String, bottomText: String, originalImage: UIImage, memeImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memeImage = memeImage
    }

    
    
    
}