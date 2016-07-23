//
//  RecentTableViewCell.swift
//  quickChat
//
//  Created by David Kababyan on 06/03/2016.
//  Copyright © 2016 David Kababyan. All rights reserved.
//

import UIKit
import Parse

class RecentTableViewCell: UITableViewCell {
    
   // let backendless = Backendless.sharedInstance()
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var lastMessageLable: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func bindData(recent: NSDictionary) {
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width/2
        avatarImageView.layer.masksToBounds = true
        
//        let avaQuery = PFUser.currentUser()?.objectForKey("picture_file") as! PFFile
//        avaQuery.getDataInBackgroundWithBlock {(data:NSData?, error:NSError?) -> Void in
//            self.avatarImageView.image = UIImage(data:data!)
//        }
        
        //self.avatarImageView.image = UIImage(named: "avatarPlaceholder")
        
        let withUserId = (recent.objectForKey("withUserUserId") as? String)!
        
        //get the backendless user and download avatar
        
//        let whereClause = "objectId = '\(withUserId)'"
//        
//        let dataQuery = BackendlessDataQuery()
//        dataQuery.whereClause = whereClause
//        
//        let dataStore = backendless.persistenceService.of(BackendlessUser.ofClass())
//        
//        dataStore.find(dataQuery, response: { (users : BackendlessCollection!) -> Void in
//            
//            let withUser = users.data.first as! PFUser
//            
////            if let avatarURL = withUser.getProperty("Avatar") {
////                getImageFromURL(avatarURL as! String, result: { (image) -> Void in
////                    self.avatarImageView.image = image
////                })
////            }
//            
//            }) { (fault: Fault!) -> Void in
//                print("error, couldnt get user avatar: \(fault)")
//        }
        
        
        let query = PFQuery(className: "_User")
        query.whereKey("username", equalTo: withUserId)
        query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                

                
                // find related objects in "User" class of Parse
                for object in objects! {
                    let first = (object.objectForKey("first_name") as? String)
                    let last = (object.objectForKey("last_name") as? String)

                    self.nameLable.text = first!+" "+last!
                    
                    let avaQuery = object.objectForKey("picture_file") as! PFFile
                    avaQuery.getDataInBackgroundWithBlock {(data:NSData?, error:NSError?) -> Void in
                        self.avatarImageView.image = UIImage(data:data!)
                    }
                    
                   // self.avatarImageView = object.objectForKey("picture_file") as! PFFile
                    
                }
            } else {
                print(error!.localizedDescription)
            }
            })
        
        
        //nameLable.text = recent["withUserUsername"] as? String
        lastMessageLable.text = recent["lastMessage"] as? String
        counterLabel.text = ""
        
        if (recent["counter"] as? Int)! != 0 {
            self.counterLabel.text = "\(recent["counter"]!) New"
        }
        
        let date = dateFormatter().dateFromString((recent["date"] as? String)!)
        let seconds = NSDate().timeIntervalSinceDate(date!)
        dateLabel.text = TimeElapsed(seconds)
    }
    
    func TimeElapsed(seconds: NSTimeInterval) -> String {
        let elapsed: String?
        
        if (seconds < 60) {
            elapsed = "Just now"
        } else if (seconds < 60 * 60) {
            let minutes = Int(seconds / 60)
            
            var minText = "min"
            if minutes > 1 {
                minText = "mins"
            }
            elapsed = "\(minutes) \(minText)"
            
        } else if (seconds < 24 * 60 * 60) {
            let hours = Int(seconds / (60 * 60))
            var hourText = "hour"
            if hours > 1 {
                hourText = "hours"
            }
            elapsed = "\(hours) \(hourText)"
        } else {
            let days = Int(seconds / (24 * 60 * 60))
            var dayText = "day"
            if days > 1 {
                dayText = "days"
            }
            elapsed = "\(days) \(dayText)"
        }
        return elapsed!
    }
}
