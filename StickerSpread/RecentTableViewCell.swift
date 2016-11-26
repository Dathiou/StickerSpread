//
//  RecentTableViewCell.swift
//  quickChat
//
//  Created by David Kababyan on 06/03/2016.
//  Copyright © 2016 David Kababyan. All rights reserved.
//

import UIKit


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
        avatarImageView.layer.cornerRadius = 4.0
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.layer.borderWidth = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func bindData(recent: NSDictionary) {
        

        
        
        let withUserId = (recent.object(forKey: "withUserUserId") as? String)!
        //nameLable.text = recent["withUserUsername"] as? String
        lastMessageLable.text = recent["lastMessage"] as? String
        counterLabel.text = ""
        
        if (recent["counter"] as? Int)! != 0 {
            self.counterLabel.text = "\(recent["counter"]!) New"
        }
        
        let date = dateFormatter().date(from: (recent["date"] as? String)!)
        let seconds = NSDate().timeIntervalSince(date!)
        dateLabel.text = TimeElapsed(seconds: seconds)
    }
    
    func TimeElapsed(seconds: TimeInterval) -> String {
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
