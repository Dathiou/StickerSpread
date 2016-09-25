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
        let width = UIScreen.main.bounds.width
        
        avaImg.frame = CGRect(x:10, y: 10, width: width / 5.3, height:width / 5.3)
        usernameLbl.frame = CGRect(x:avaImg.frame.size.width + 20,y: 28,width: width / 3.2, height: 30)
        followBtn.frame = CGRect(x:width - width / 3.5 - 10, y:  30, width:width / 3.5,height: 30)
        followBtn.layer.cornerRadius = followBtn.frame.size.width / 20
        
        // round ava
        avaImg.layer.cornerRadius = 4.0
        avaImg.clipsToBounds = true
        avaImg.layer.borderColor = UIColor.white.cgColor
        avaImg.layer.borderWidth = 0.5
        

    }

    
   
    
    @IBAction func followBtn_click(sender: AnyObject) {
       // let indexPath = self.tableView.indexPathForRowAtPoint(cell.center)!
        
        let title = followBtn.title(for: .normal)
        
        // to follow
        if title == "FOLLOW" {
            
            let date = NSDate()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            let dateString = dateFormatter.string(from: date as Date)
            
            
            self.followBtn.setTitle("FOLLOWING", for: UIControlState.normal)
            self.followBtn.backgroundColor = .green
            firebase.child("Followings").child((FIRAuth.auth()?.currentUser!.uid)!).child(username).setValue(["date": dateString])
            firebase.child("Followers").child(username).child((FIRAuth.auth()?.currentUser!.uid)!).setValue(["date": dateString])

            
            // unfollow
        } else {
            
            self.followBtn.setTitle("FOLLOW", for: UIControlState.normal)
            self.followBtn.backgroundColor = .lightGray
            firebase.child("Followings").child((FIRAuth.auth()?.currentUser!.uid)!).child(username).removeValue()
            firebase.child("Followers").child(username).child((FIRAuth.auth()?.currentUser!.uid)!).removeValue()
            
        }
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
