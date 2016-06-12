

import UIKit
//import Parse


class searchCell: UITableViewCell {
    
 
    
    
    //    @IBAction func buttonTapped(sender: AnyObject) {
    //        delegate?.cellButtonTapped(self)
    //    }
    
    
    
    
    
    //var delegate: CustomCellDelegate?
    //var tapped: ((followersCell) -> Void)?
    
    //    @IBAction func buttonTapped(sender: AnyObject) {
    //        tapped?(self)
    //    }
    
    
    
    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    
    
    
    
    
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
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
    }
    
    
    
    
    //    @IBAction func followBtn_click(sender: AnyObject) {
    //       // let indexPath = self.tableView.indexPathForRowAtPoint(cell.center)!
    //
    //        let title = followBtn.titleForState(.Normal)
    //
    //        // to follow
    //        if title == "FOLLOW" {
    //            let object = PFObject(className: "follow")
    //            object["follower"] = PFUser.currentUser()?.username
    //            object["following"] = self.usernameArray[indexPath.row] //usernameLbl.text
    //            object.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
    //                if success {
    //                    self.followBtn.setTitle("FOLLOWING", forState: UIControlState.Normal)
    //                    self.followBtn.backgroundColor = .greenColor()
    //                } else {
    //                    print(error?.localizedDescription)
    //                }
    //            })
    //
    //            // unfollow
    //        } else {
    //            let query = PFQuery(className: "follow")
    //            query.whereKey("follower", equalTo: PFUser.currentUser()!.username!)
    //            query.whereKey("following", equalTo: usernameLbl.text!)
    //            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
    //                if error == nil {
    //
    //                    for object in objects! {
    //                        object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
    //                            if success {
    //                                self.followBtn.setTitle("FOLLOW", forState: UIControlState.Normal)
    //                                self.followBtn.backgroundColor = .lightGrayColor()
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
    //
    //        }
    //        
    //    }
    
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
