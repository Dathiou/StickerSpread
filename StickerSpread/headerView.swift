//
//  headerView.swift
//  StickerSpread
//
//  Created by Student iMac on 5/27/16.
//  Copyright © 2016 Student iMac. All rights reserved.
//

import UIKit
import Parse

class headerView: UICollectionReusableView {
    
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var fullnameLbl: UILabel!
    @IBOutlet weak var webTxt: UITextView!
    @IBOutlet weak var bioLbl: UILabel!
    
    @IBOutlet weak var posts: UILabel!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var followings: UILabel!
    
    @IBOutlet weak var postsTitle: UILabel!
    @IBOutlet weak var followersTitle: UILabel!
    @IBOutlet weak var followingsTitle: UILabel!
    
    @IBOutlet weak var button: UIButton!
   
    
    
    // default func
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // alignment
        let width = UIScreen.mainScreen().bounds.width
        
        avaImg.frame = CGRectMake(width / 16, width / 16, width / 4, width / 4)
        
        posts.frame = CGRectMake(width / 2.5, avaImg.frame.origin.y, 50, 30)
        followers.frame = CGRectMake(width / 1.7, avaImg.frame.origin.y, 50, 30)
        followings.frame = CGRectMake(width / 1.25, avaImg.frame.origin.y, 50, 30)
        
        postsTitle.center = CGPointMake(posts.center.x, posts.center.y + 20)
        followersTitle.center = CGPointMake(followers.center.x, followers.center.y + 20)
        followingsTitle.center = CGPointMake(followings.center.x, followings.center.y + 20)
        
        button.frame = CGRectMake(postsTitle.frame.origin.x, postsTitle.center.y + 20, width - postsTitle.frame.origin.x - 10, 30)
        button.layer.cornerRadius = button.frame.size.width / 50
        
        fullnameLbl.frame = CGRectMake(avaImg.frame.origin.x, avaImg.frame.origin.y + avaImg.frame.size.height, width - 30, 30)
        webTxt.frame = CGRectMake(avaImg.frame.origin.x - 5, fullnameLbl.frame.origin.y + 30, width - 30, 30)
        bioLbl.frame = CGRectMake(avaImg.frame.origin.x, webTxt.frame.origin.y + 30, width - 30, 30)
        
        // round ava
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
    }

    
    
    
    @IBAction func followBtn_click(sender: AnyObject) {
        //let title = followBtn.titleForState(.Normal)
        let title = button.titleForState(.Normal)
        
        // to follow
        if title == "FOLLOW" {
            let object = PFObject(className: "follow")
            object["follower"] = PFUser.currentUser()?.username
            object["following"] = guestname.last! //usernameLbl.text
            object.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                if success {
                    self.button.setTitle("FOLLOWING", forState: UIControlState.Normal)
                    self.button.backgroundColor = .greenColor()
                } else {
                    print(error?.localizedDescription)
                }
            })
            
            // unfollow
        } else {
            let query = PFQuery(className: "follow")
            query.whereKey("follower", equalTo: PFUser.currentUser()!.username!)
            query.whereKey("following", equalTo: guestname.last!)
            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                if error == nil {
                    
                    for object in objects! {
                        object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                            if success {
                                self.button.setTitle("FOLLOW", forState: UIControlState.Normal)
                                self.button.backgroundColor = .lightGrayColor()
                            } else {
                                print(error?.localizedDescription)
                            }
                        })
                    }
                    
                } else {
                    print(error?.localizedDescription)
                }
            })
            
        }

    }
    
    

    
}
