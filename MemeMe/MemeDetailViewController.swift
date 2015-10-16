//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Ed Ballington on 10/9/15.
//  Copyright © 2015 Ed Ballington. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    var selectedMeme: Meme!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.memeImageView!.image = selectedMeme.memeImage
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "editMemeSegue") {
            
            if let editVC = segue.destinationViewController as? MemeEditorViewController {
                
                editVC.ImagePickerView!.image = selectedMeme.originalImage
                editVC.topTextField!.text = selectedMeme.topText
                editVC.bottomTextField!.text = selectedMeme.bottomText
                
            
            }
            
        }
        
    }

    
}

