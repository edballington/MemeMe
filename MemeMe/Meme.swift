//
//  Meme.swift
//  MemeMe
//
//  Created by Ed Ballington on 10/6/15.
//  Copyright © 2015 Ed Ballington. All rights reserved.
//

import UIKit

class Meme: NSObject {
    
    // MARK: Model
    
    struct Meme {
        var topText = ""
        var bottomText = ""
        var originalImage = UIImage()
        var memeImage = UIImage()
        
    }

    func saveMeme(topText: String, bottomText: String, originalImage: UIImage, memeImage: UIImage) -> Meme {
        
        //Save the meme object
        return Meme(topText: topText, bottomText: bottomText, originalImage: originalImage, memeImage: memeImage)
    }

    
}
