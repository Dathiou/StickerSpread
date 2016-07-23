//
//  postCell.swift
//  StickerSpread
//
//  Created by Student iMac on 6/3/16.
//  Copyright © 2016 Student iMac. All rights reserved.
//

import UIKit
import Parse
import Firebase

//protocol segueToUserFromFeed{
//    func goToProfile(id : String!)
//}
protocol segueToPostFromFeed{
    func goToPost(uuid : String!)
    func goToProfile(id : String!)
}



class postCell: UITableViewCell {


    
    
    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var usernameBtn: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var picImg: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    
    //@IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var likeLbl: UILabel!
    
    @IBOutlet weak var usernameHidden: UIButton!
    
   @IBOutlet weak var titleLbl: UILabel!
     var segueDelegate : segueToPostFromFeed!
    //var segueDelegateUser : segueToUserFromFeed!
    //@IBOutlet weak var titleLbl: KILabel!
    @IBOutlet weak var uuidLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // clear like button title color
        likeBtn.setTitleColor(UIColor.clearColor(), forState: .Normal)
        // double tap to like
        let likeTap = UITapGestureRecognizer(target: self, action: "likeTap")
        likeTap.numberOfTapsRequired = 2
        picImg.userInteractionEnabled = true
        picImg.addGestureRecognizer(likeTap)
        
        let selectTap = UITapGestureRecognizer(target: self, action: "selectTap")
        //selectTap.numberOfTapsRequired = 2
        picImg.userInteractionEnabled = true
        picImg.addGestureRecognizer(selectTap)
        
        
//        // alignment
//        let width = UIScreen.mainScreen().bounds.width
//        
//        // allow constraints
//        avaImg.translatesAutoresizingMaskIntoConstraints = false
//        usernameBtn.translatesAutoresizingMaskIntoConstraints = false
//        dateLbl.translatesAutoresizingMaskIntoConstraints = false
//        
//        picImg.translatesAutoresizingMaskIntoConstraints = false
//        
//        likeBtn.translatesAutoresizingMaskIntoConstraints = false
//        commentBtn.translatesAutoresizingMaskIntoConstraints = false
//        moreBtn.translatesAutoresizingMaskIntoConstraints = false
//        
//        likeLbl.translatesAutoresizingMaskIntoConstraints = false
//        titleLbl.translatesAutoresizingMaskIntoConstraints = false
//        uuidLbl.translatesAutoresizingMaskIntoConstraints = false
//        
//        let pictureWidth = width - 20
//        
//        // constraints
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "V:|-5-[ava(30)]-10-[pic(\(pictureWidth))]-5-[like(30)]",
//            options: [], metrics: nil, views: ["ava":avaImg, "pic":picImg, "like":likeBtn]))
//        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "V:|-10-[username]",
//            options: [], metrics: nil, views: ["username":usernameBtn]))
//        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "V:[pic]-10-[comment]",
//            options: [], metrics: nil, views: ["pic":picImg, "comment":commentBtn]))
//        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "V:|-10-[date]",
//            options: [], metrics: nil, views: ["date":dateLbl]))
//        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "V:[like]-5-[title]-5-|",
//            options: [], metrics: nil, views: ["like":likeBtn, "title":titleLbl]))
//        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "V:[pic]-5-[more]",
//            options: [], metrics: nil, views: ["pic":picImg, "more":moreBtn]))
//        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "V:[pic]-10-[likes]",
//            options: [], metrics: nil, views: ["pic":picImg, "likes":likeLbl]))
//        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "H:|-10-[ava(30)]-10-[username]-10-|",
//            options: [], metrics: nil, views: ["ava":avaImg, "username":usernameBtn]))
//        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "H:|-10-[pic]-10-|",
//            options: [], metrics: nil, views: ["pic":picImg]))
//        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "H:|-15-[like(30)]-10-[likes]-20-[comment]",
//            options: [], metrics: nil, views: ["like":likeBtn, "likes":likeLbl, "comment":commentBtn]))
//        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "H:[more]-15-|",
//            options: [], metrics: nil, views: ["more":moreBtn]))
//        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "H:|-15-[title]-15-|",
//            options: [], metrics: nil, views: ["title":titleLbl]))
//        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "H:|[date]-10-|",
//            options: [], metrics: nil, views: ["date":dateLbl]))
//        
//    
//        
//        // round ava
//        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
//        avaImg.clipsToBounds = true
        
        // alignment
        let width = UIScreen.mainScreen().bounds.width
        
        
//       LayoutLbl.translatesAutoresizingMaskIntoConstraints = false
//        monthLbl.translatesAutoresizingMaskIntoConstraints = false
//        FinishLbl.translatesAutoresizingMaskIntoConstraints = false
//       colorLbl1.translatesAutoresizingMaskIntoConstraints = false
//       colorLbl2.translatesAutoresizingMaskIntoConstraints = false
//      colorLbl3.translatesAutoresizingMaskIntoConstraints = false
//        connectBtn.translatesAutoresizingMaskIntoConstraints = false
        
//        // allow constraints
//        avaImg.translatesAutoresizingMaskIntoConstraints = false
//        usernameBtn.translatesAutoresizingMaskIntoConstraints = false
//        dateLbl.translatesAutoresizingMaskIntoConstraints = false
//        
//    picImg.translatesAutoresizingMaskIntoConstraints = false
//        
//        likeBtn.translatesAutoresizingMaskIntoConstraints = false
//        //commentBtn.translatesAutoresizingMaskIntoConstraints = false
//        moreBtn.translatesAutoresizingMaskIntoConstraints = false
//        
//        likeLbl.translatesAutoresizingMaskIntoConstraints = false
//        titleLbl.translatesAutoresizingMaskIntoConstraints = false
//        uuidLbl.translatesAutoresizingMaskIntoConstraints = false
//        
//        let pictureWidth = width
//        
//        // constraints
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "V:|-10-[ava(30)]-10-[pic(\(pictureWidth))]-5-[like(30)]",
//            options: [], metrics: nil, views: ["ava":avaImg, "pic":picImg, "like":likeBtn]))
//        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "V:|-10-[username]",
//            options: [], metrics: nil, views: ["username":usernameBtn]))
//        
////        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
////            "V:[pic]-5-[comment(30)]",
////            options: [], metrics: nil, views: ["pic":picImg, "comment":commentBtn]))
//        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "V:|-15-[date]",
//            options: [], metrics: nil, views: ["date":dateLbl]))
//        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "V:[like]-5-[title]-5-|",
//            options: [], metrics: nil, views: ["like":likeBtn, "title":titleLbl]))
//        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "V:[pic]-5-[more(30)]",
//            options: [], metrics: nil, views: ["pic":picImg, "more":moreBtn]))
//        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "V:[pic]-10-[likes]",
//            options: [], metrics: nil, views: ["pic":picImg, "likes":likeLbl]))
//        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "H:|-10-[ava(30)]-10-[username]",
//            options: [], metrics: nil, views: ["ava":avaImg, "username":usernameBtn]))
//        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "H:|-0-[pic]-0-|",
//            options: [], metrics: nil, views: ["pic":picImg]))
//        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "H:|-15-[like(30)]-10-[likes]",
//            options: [], metrics: nil, views: ["like":likeBtn, "likes":likeLbl]))
//        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "H:[more(30)]-15-|",
//            options: [], metrics: nil, views: ["more":moreBtn]))
//        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "H:|-15-[title]-15-|",
//            options: [], metrics: nil, views: ["title":titleLbl]))
//        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "H:|[date]-10-|",
//            options: [], metrics: nil, views: ["date":dateLbl]))
        
        // round ava
        avaImg.layer.cornerRadius = 4.0
        avaImg.clipsToBounds = true
        avaImg.layer.borderColor = UIColor.whiteColor().CGColor
        avaImg.layer.borderWidth = 0.5

        
    }
    
    // double tap to like
    func likeTap() {
        
        // create large like gray heart
        let likePic = UIImageView(image: UIImage(named: "unlike.png"))
        likePic.frame.size.width = picImg.frame.size.width / 1.5
        likePic.frame.size.height = picImg.frame.size.width / 1.5
        likePic.center = picImg.center
        likePic.alpha = 0.8
        self.addSubview(likePic)
        
        // hide likePic with animation and transform to be smaller
        UIView.animateWithDuration(0.4) { () -> Void in
            likePic.alpha = 0
            likePic.transform = CGAffineTransformMakeScale(0.1, 0.1)
        }
        
        // declare title of button
        let title = likeBtn.titleForState(.Normal)
        
        if title == "unlike" {
            
            let object = PFObject(className: "likes")
            object["by"] = PFUser.currentUser()?.username
            object["to"] = uuidLbl.text
            object.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                if success {
                    print("liked")
                    self.likeBtn.setTitle("like", forState: .Normal)
                    self.likeBtn.setBackgroundImage(UIImage(named: "like.png"), forState: .Normal)
                    
                    // send notification if we liked to refresh TableView
                    NSNotificationCenter.defaultCenter().postNotificationName("liked", object: nil)
                    
                    
//                    // send notification as like
//                    if self.usernameBtn.titleLabel?.text != PFUser.currentUser()?.username {
//                        let newsObj = PFObject(className: "news")
//                        newsObj["by"] = PFUser.currentUser()?.username
//                        newsObj["ava"] = PFUser.currentUser()?.objectForKey("ava") as! PFFile
//                        newsObj["to"] = self.usernameBtn.titleLabel!.text
//                        newsObj["owner"] = self.usernameBtn.titleLabel!.text
//                        newsObj["uuid"] = self.uuidLbl.text
//                        newsObj["type"] = "like"
//                        newsObj["checked"] = "no"
//                        newsObj.saveEventually()
//                    }
                    
                }
            })
            
        }
        
    }
    

    func selectTap(){
        if let st = uuidLbl.text as String! {
            segueDelegate.goToPost(st)
            //segueDelegateUser.goToProfile("aa")
        }
    }
    
    @IBAction func usernameBtn_click() {
        if let id = self.usernameHidden.titleLabel!.text as String!{
            segueDelegate.goToProfile(id)
        }
        
    }
    
    @IBAction func likeBtn_clicked(sender: AnyObject) {
        // declare title of button
        let title = sender.titleForState(.Normal)
        
        // to like
        if title == "unlike" {
            
            firebase.child("Likes").child(uuidLbl.text!).child((FIRAuth.auth()?.currentUser!.uid)!).setValue(true)
            firebase.child("LikesPerUser").child((FIRAuth.auth()?.currentUser!.uid)!).child(uuidLbl.text!).setValue(true)
            print("liked")
            self.likeBtn.setTitle("like", forState: .Normal)
            self.likeBtn.setBackgroundImage(UIImage(named: "Heart 2.png"), forState: .Normal)
           // self.likeLbl.text = "\(Int(self.likeLbl.text!)! + 1)"
            
            // send notification if we liked to refresh TableView
           // NSNotificationCenter.defaultCenter().postNotificationName("liked", object: nil)
            
            
            // to dislike
        } else {
            
            firebase.child("Likes").child(uuidLbl.text!).child((FIRAuth.auth()?.currentUser!.uid)!).removeValue()
            firebase.child("LikesPerUser").child((FIRAuth.auth()?.currentUser!.uid)!).child(uuidLbl.text!).removeValue()
            print("disliked")
            self.likeBtn.setTitle("unlike", forState: .Normal)
            self.likeBtn.setBackgroundImage(UIImage(named: "Heart 1.png"), forState: .Normal)
            
            // send notification if we liked to refresh TableView
           // NSNotificationCenter.defaultCenter().postNotificationName("liked", object: nil)
           // self.likeLbl.text = "\(Int(self.likeLbl.text!)! - 1)"
            

            
        }
    }
    
    
    


}
