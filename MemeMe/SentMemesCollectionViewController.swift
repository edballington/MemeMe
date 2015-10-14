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
        let widthDimension = (self.view.frame.size.width - (2 * space)) / 3.0
        let heightDimension = (self.view.frame.size.height - (2 * space)) / 3.0
        
        collectionViewFlowLayout.minimumInteritemSpacing = 3.0
        collectionViewFlowLayout.minimumLineSpacing = space
        collectionViewFlowLayout.itemSize = CGSizeMake(widthDimension, heightDimension)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.collectionView!.reloadData()
    }

    @IBAction func addMeme(sender: AnyObject) {
        
        let memeEditorVC = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
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
        let object: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController")
        let memeDetailVC = object as! MemeDetailViewController
        
        //Setup the View Controller with image from selected meme
        memeDetailVC.memeImageView.image = memes[indexPath.item].memeImage
        
        //Present the view controller
        self.navigationController!.pushViewController(memeDetailVC, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
