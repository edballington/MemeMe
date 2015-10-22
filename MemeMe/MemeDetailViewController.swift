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
        
        memeImageView!.image = selectedMeme.memeImage
        
    }
    
    @IBAction func editMeme(sender: AnyObject) {
        
        let memeEditorVC = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        
        memeEditorVC.imageToMeme = selectedMeme.originalImage
        memeEditorVC.topMemeText = selectedMeme.topText
        memeEditorVC.bottomMemeText = selectedMeme.bottomText
        
        //Present the Meme Editor View Controller and go back to the table or collection view when done.
        
        navigationController!.presentViewController(memeEditorVC, animated: true, completion: {
            
            navigationController?.popViewControllerAnimated(true)
            
        })
        
    }

    
}

