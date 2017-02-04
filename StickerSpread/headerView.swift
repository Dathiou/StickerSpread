//
//  headerView.swift
//  StickerSpread
//
//  Created by Student iMac on 5/27/16.
//  Copyright © 2016 Student iMac. All rights reserved.
//

import UIKit
//import Parse
import Firebase


class headerView: UICollectionReusableView{
    
    
    
    @IBOutlet weak var firstConstr: NSLayoutConstraint!
    @IBOutlet weak var secondConstr: NSLayoutConstraint!
    @IBOutlet weak var thirdConstr: NSLayoutConstraint!
    @IBOutlet weak var fourthConstr: NSLayoutConstraint!
    
    @IBOutlet weak var pic1: UIImageView!
    @IBOutlet weak var pic2: UIImageView!
    @IBOutlet weak var pic3: UIImageView!
    @IBOutlet weak var pic4: UIImageView!
    
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var first_Lbl: UILabel!
    @IBOutlet weak var second_Lbl: UILabel!
    @IBOutlet weak var third_Lbl: UILabel!
    @IBOutlet weak var fourth_Lbl: UILabel!
    
    @IBOutlet weak var posts: UILabel!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var followings: UILabel!
    
    @IBOutlet weak var postsTitle: UILabel!
    @IBOutlet weak var followersTitle: UILabel!
    @IBOutlet weak var followingsTitle: UILabel!
    
    var username = String()
    
    @IBOutlet weak var followButton: UIButton!

   
    @IBOutlet weak var Settingsbutton: UIButton!
    
    // default func
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // alignment
//        let width = UIScreen.mainScreen().bounds.width
//        
//        avaImg.frame = CGRectMake(width / 16, width / 16, width / 4, width / 4)
//        
//        posts.frame = CGRectMake(width / 2.5, avaImg.frame.origin.y, 50, 30)
//        followers.frame = CGRectMake(width / 1.7, avaImg.frame.origin.y, 50, 30)
//        followings.frame = CGRectMake(width / 1.25, avaImg.frame.origin.y, 50, 30)
//        
//        postsTitle.center = CGPointMake(posts.center.x, posts.center.y + 20)
//        followersTitle.center = CGPointMake(followers.center.x, followers.center.y + 20)
//        followingsTitle.center = CGPointMake(followings.center.x, followings.center.y + 20)
//        
//        button.frame = CGRectMake(postsTitle.frame.origin.x, postsTitle.center.y + 20, width - postsTitle.frame.origin.x - 10, 30)
//        button.layer.cornerRadius = button.frame.size.width / 50
//        
//        fullnameLbl.frame = CGRectMake(avaImg.frame.origin.x, avaImg.frame.origin.y + avaImg.frame.size.height, width - 30, 30)
//        webTxt.frame = CGRectMake(avaImg.frame.origin.x - 5, fullnameLbl.frame.origin.y + 30, width - 30, 30)
//        bioLbl.frame = CGRectMake(avaImg.frame.origin.x, webTxt.frame.origin.y + 30, width - 30, 30)
        
        // round ava
        avaImg.layer.cornerRadius = 4.0
        avaImg.clipsToBounds = true
        avaImg.layer.borderColor = UIColor.white.cgColor
        avaImg.layer.borderWidth = 0.5
        
        

    }
    
//    func sizeHeaderToFit() {
//        let headerView = tableView.tableHeaderView!
//        
//        headerView.setNeedsLayout()
//        headerView.layoutIfNeeded()
//        
//        let height = headerView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
//        var frame = headerView.frame
//        frame.size.height = height
//        headerView.frame = frame
//        
//        tableView.tableHeaderView = headerView
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        sizeHeaderToFit()
//    }

    
    
    
    @IBAction func followBtn_click(sender: AnyObject) {
        //let title = followBtn.titleForState(.Normal)
        let title = followButton.title(for: .normal)
        
        // to follow
        if title == "FOLLOW" {
            
            let date = NSDate()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            let dateString = dateFormatter.string(from: date as Date)

            
            self.followButton.setTitle("FOLLOWING", for: UIControlState.normal)
            self.followButton.backgroundColor = .green
            firebase.child("Followings").child((FIRAuth.auth()?.currentUser!.uid)!).child(username).setValue(["date": dateString])
            firebase.child("Followers").child(username).child((FIRAuth.auth()?.currentUser!.uid)!).setValue(["date": dateString])
//            let object = PFObject(className: "follow")
//            object["follower"] = PFUser.currentUser()?.username
//            object["following"] = guestname.last! //usernameLbl.text
//            object.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
//                if success {
//                    self.button.setTitle("FOLLOWING", forState: UIControlState.Normal)
//                    self.button.backgroundColor = .greenColor()
//                } else {
//                    print(error?.localizedDescription)
//                }
//            })
            
            // unfollow
        } else {
            
            self.followButton.setTitle("FOLLOW", for: UIControlState.normal)
            self.followButton.backgroundColor = .lightGray
            firebase.child("Followings").child((FIRAuth.auth()?.currentUser!.uid)!).child(username).removeValue()
            firebase.child("Followers").child(username).child((FIRAuth.auth()?.currentUser!.uid)!).removeValue()
//            let query = PFQuery(className: "follow")
//            query.whereKey("follower", equalTo: PFUser.currentUser()!.username!)
//            query.whereKey("following", equalTo: guestname.last!)
//            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
//                if error == nil {
//                    
//                    for object in objects! {
//                        object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
//                            if success {
//                                self.button.setTitle("FOLLOW", forState: UIControlState.Normal)
//                                self.button.backgroundColor = .lightGrayColor()
//                            } else {
//                                print(error?.localizedDescription)
//                            }
//                        })
//                    }
//                    
//                } else {
//                    print(error?.localizedDescription)
//                }
//            })
            
        }

    }
    


    
}
