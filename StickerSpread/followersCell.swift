//
//  followersCell.swift
//  StickerSpread
//
//  Created by Student iMac on 5/31/16.
//  Copyright © 2016 Student iMac. All rights reserved.
//

import UIKit
//import Parse
import Firebase



class followersCell: UITableViewCell {

    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!

    
    var username = String()
    
    
    // default func
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // alignment
        let width = UIScreen.mainScreen().bounds.width
        
        avaImg.frame = CGRectMake(10, 10, width / 5.3, width / 5.3)
        usernameLbl.frame = CGRectMake(avaImg.frame.size.width + 20, 28, width / 3.2, 30)
        followBtn.frame = CGRectMake(width - width / 3.5 - 10, 30, width / 3.5, 30)
        followBtn.layer.cornerRadius = followBtn.frame.size.width / 20
        
        // round ava
        avaImg.layer.cornerRadius = 4.0
        avaImg.clipsToBounds = true
        avaImg.layer.borderColor = UIColor.whiteColor().CGColor
        avaImg.layer.borderWidth = 0.5
        

    }

    
   
    
    @IBAction func followBtn_click(sender: AnyObject) {
       // let indexPath = self.tableView.indexPathForRowAtPoint(cell.center)!
        
        let title = followBtn.titleForState(.Normal)
        
        // to follow
        if title == "FOLLOW" {
            
            let date = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            let dateString = dateFormatter.stringFromDate(date)
            
            
            self.followBtn.setTitle("FOLLOWING", forState: UIControlState.Normal)
            self.followBtn.backgroundColor = .greenColor()
            firebase.child("Followings").child((FIRAuth.auth()?.currentUser!.uid)!).child(username).setValue(["date": dateString])
            firebase.child("Followers").child(username).child((FIRAuth.auth()?.currentUser!.uid)!).setValue(["date": dateString])

            
            // unfollow
        } else {
            
            self.followBtn.setTitle("FOLLOW", forState: UIControlState.Normal)
            self.followBtn.backgroundColor = .lightGrayColor()
            firebase.child("Followings").child((FIRAuth.auth()?.currentUser!.uid)!).child(username).removeValue()
            firebase.child("Followers").child(username).child((FIRAuth.auth()?.currentUser!.uid)!).removeValue()
            
        }
    }
    
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
