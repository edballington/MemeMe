//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Ed Ballington on 10/7/15.
//  Copyright © 2015 Ed Ballington. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    var memes: [Meme] {
        
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }

    //MARK: - View lifecycle
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
    }

    @IBAction func addMeme(sender: AnyObject) {
        
        let memeEditorVC = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        navigationController!.presentViewController(memeEditorVC, animated: true, completion: nil)
        
    }
    
 
    
    // MARK: - Delegate Methods
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tableViewCell", forIndexPath: indexPath)
        let meme = memes[indexPath.item]
        cell.imageView!.image = meme.memeImage
        cell.textLabel?.text = meme.topText + "..." + meme.bottomText
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            
        let memeDetailVC = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        memeDetailVC.selectedMeme = memes[indexPath.item]

        memeDetailVC.hidesBottomBarWhenPushed = true        //Turn off tab bar

        navigationController!.pushViewController(memeDetailVC, animated: true)
        
    }

    
}
