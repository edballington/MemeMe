//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Ed Ballington on 10/7/15.
//  Copyright © 2015 Ed Ballington. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme] {
        
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup the collectionView flow layout properties\
        
        let space: CGFloat = 3.0
        let widthDimension = (view.frame.size.width - (2 * space)) / 3.0
        let heightDimension = (view.frame.size.height - (2 * space)) / 3.0
        
        collectionViewFlowLayout.minimumInteritemSpacing = 3.0
        collectionViewFlowLayout.minimumLineSpacing = space
        collectionViewFlowLayout.itemSize = CGSizeMake(widthDimension, heightDimension)
    }
    
    override func viewWillAppear(animated: Bool) {
        collectionView!.reloadData()
    }

    @IBAction func addMeme(sender: AnyObject) {
        
        let memeEditorVC = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        navigationController!.presentViewController(memeEditorVC, animated: true, completion: nil)
        
    }

    
    // MARK: - Delegate Methods
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CustomMemeCell", forIndexPath: indexPath) as! CustomMemeCell
        let meme = memes[indexPath.item]
        cell.memeImage.image = meme.memeImage
        
        return cell
        
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // Get the detailViewController from storyboard
        let object: AnyObject = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController")
        let memeDetailVC = object as! MemeDetailViewController
        
        //Setup the View Controller with selected meme
        memeDetailVC.selectedMeme = memes[indexPath.item]
        memeDetailVC.hidesBottomBarWhenPushed = true    //Turn off tab bar
        
        //Present the view controller
        navigationController!.pushViewController(memeDetailVC, animated: true)
        
    }


}
