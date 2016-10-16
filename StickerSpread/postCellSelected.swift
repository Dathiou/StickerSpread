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

protocol segueTo{
    
    func goToProfile(id : String!)
    func displayLikes(uuid : String!)
}


class postCellSelected: UITableViewCell {
    
    @IBOutlet weak var Flag: UIImageView!
    @IBOutlet weak var UFG: UITextField!
    @IBOutlet weak var LayoutLbl: UILabel!
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var FinishLbl: UILabel!
    @IBOutlet weak var colorLbl1: UILabel!
    @IBOutlet weak var colorLbl2: UILabel!
    @IBOutlet weak var colorLbl3: UILabel!
    
    var postAuthorID = String()
    
    @IBOutlet weak var connectBtn: UIButton!
    @IBAction func connect_click(sender: AnyObject) {
        print("connnect click")
    }
    
    var segueDelegate : segueTo!
    
    
    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var usernameBtn: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var picImg: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    
    //@IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
//    @IBOutlet weak var likeLbl: UILabel!
    
    @IBOutlet weak var LikeLbl: UIButton!
    @IBOutlet weak var usernameHidden: UIButton!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    //@IBOutlet weak var titleLbl: KILabel!
    @IBOutlet weak var uuidLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //self.backgroundColor = UIColor(patternImage: UIImage(named: "Background_Blue_Joint.jpg")!)
        // clear like button title color
        likeBtn.setTitleColor(UIColor.clear, for: .normal)
        // double tap to like
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(postCellSelected.likeTap))
        likeTap.numberOfTapsRequired = 2
        picImg.isUserInteractionEnabled = true
        picImg.addGestureRecognizer(likeTap)
        
               let width = UIScreen.main.bounds.width

        
        //picImg.frame = CGRectMake(0, 10, width, width)
        
        
//               LayoutLbl.translatesAutoresizingMaskIntoConstraints = false
//                monthLbl.translatesAutoresizingMaskIntoConstraints = false
//                FinishLbl.translatesAutoresizingMaskIntoConstraints = false
//               colorLbl1.translatesAutoresizingMaskIntoConstraints = false
//               colorLbl2.translatesAutoresizingMaskIntoConstraints = false
//              colorLbl3.translatesAutoresizingMaskIntoConstraints = false
//                connectBtn.translatesAutoresizingMaskIntoConstraints = false
        
        // allow constraints
//        avaImg.translatesAutoresizingMaskIntoConstraints = false
//        usernameBtn.translatesAutoresizingMaskIntoConstraints = false
//        dateLbl.translatesAutoresizingMaskIntoConstraints = false
//        
//        //picImg.translatesAutoresizingMaskIntoConstraints = false
//        
//        likeBtn.translatesAutoresizingMaskIntoConstraints = false
        //commentBtn.translatesAutoresizingMaskIntoConstraints = false
//        moreBtn.translatesAutoresizingMaskIntoConstraints = false
//        
//        likeLbl.translatesAutoresizingMaskIntoConstraints = false
//        titleLbl.translatesAutoresizingMaskIntoConstraints = false
//        uuidLbl.translatesAutoresizingMaskIntoConstraints = false
        
        _ = width
        
        // constraints
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "V:|-10-[ava(30)]-10-[pic(\(pictureWidth))]",
//            options: [], metrics: nil, views: ["ava":avaImg, "pic":picImg, "like":likeBtn]))
        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "V:|-10-[username]",
//            options: [], metrics: nil, views: ["username":usernameBtn]))
//        
//  
//        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "V:|-15-[date]",
//            options: [], metrics: nil, views: ["date":dateLbl]))
        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "V:[like]-5-[layout]-5-[month]-5-[finish]-5-[connect]|",
//            options: [], metrics: nil, views: ["like":likeBtn, "title":titleLbl, "layout":LayoutLbl, "month": monthLbl, "finish":FinishLbl, "connect": connectBtn]))
//        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "V:[like]-5-[colorLbl1]-5-[colorLbl2]-5-[colorLbl3]-5-[connect]|",
//            options: [], metrics: nil, views: ["like":likeBtn, "title":titleLbl, "colorLbl1":colorLbl1, "colorLbl2": colorLbl2, "colorLbl3":colorLbl3, "connect": connectBtn]))
//        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "H:|-30-[layout]-20-[colorLbl1]",
//            options: [], metrics: nil, views: [ "layout":LayoutLbl, "colorLbl1":colorLbl1]))
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "H:|-30-[month]-20-[colorLbl2]",
//            options: [], metrics: nil, views: [ "month": monthLbl, "colorLbl2":colorLbl1]))
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "H:|-30-[finish]-20-[colorLbl3]",
//            options: [], metrics: nil, views: [ "finish":FinishLbl, "colorLbl3":colorLbl1]))
//        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "V:[pic]-5-[more(30)]",
//            options: [], metrics: nil, views: ["pic":picImg, "more":moreBtn]))
//
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "V:[pic]-10-[likes(30)]",
//            options: [], metrics: nil, views: ["pic":picImg, "likes":likeBtn]))
//
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "H:|-10-[ava(30)]-10-[username]",
//            options: [], metrics: nil, views: ["ava":avaImg, "username":usernameBtn]))
//        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "H:|-0-[pic]-0-|",
//            options: [], metrics: nil, views: ["pic":picImg]))
        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "H:|-15-[like(30)]-10-[likes]",
//            options: [], metrics: nil, views: ["like":likeBtn, "likes":likeLbl]))
        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//            "H:[more(30)]-15-|",
//            options: [], metrics: nil, views: ["more":moreBtn]))
        
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
        avaImg.layer.borderColor = UIColor.white.cgColor
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
        UIView.animate(withDuration: 0.4) { () -> Void in
            likePic.alpha = 0
            likePic.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }
        
        // declare title of button
        let title = likeBtn.title(for: .normal)
        
        if title == "unlike" {
            
            
            firebase.child("Likes").child(uuidLbl.text!).child((FIRAuth.auth()?.currentUser!.uid)!).setValue(true)
            print("liked")
            self.likeBtn.setTitle("like", for: .normal)
            self.likeBtn.setBackgroundImage(UIImage(named: "like.png"), for: .normal)
            
            // send notification if we liked to refresh TableView
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liked"), object: nil)
        }
//            let object = PFObject(className: "likes")
//            object["by"] = PFUser.currentUser()?.username
//            object["to"] = uuidLbl.text
//            object.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
//                if success {
//                    print("liked")
//                    self.likeBtn.setTitle("like", forState: .Normal)
//                    self.likeBtn.setBackgroundImage(UIImage(named: "like.png"), forState: .Normal)
//                    
//                    // send notification if we liked to refresh TableView
//                    NSNotificationCenter.defaultCenter().postNotificationName("liked", object: nil)
//                    
//                    
//                    //                    // send notification as like
//                    //                    if self.usernameBtn.titleLabel?.text != PFUser.currentUser()?.username {
//                    //                        let newsObj = PFObject(className: "news")
//                    //                        newsObj["by"] = PFUser.currentUser()?.username
//                    //                        newsObj["ava"] = PFUser.currentUser()?.objectForKey("ava") as! PFFile
//                    //                        newsObj["to"] = self.usernameBtn.titleLabel!.text
//                    //                        newsObj["owner"] = self.usernameBtn.titleLabel!.text
//                    //                        newsObj["uuid"] = self.uuidLbl.text
//                    //                        newsObj["type"] = "like"
//                    //                        newsObj["checked"] = "no"
//                    //                        newsObj.saveEventually()
//                    //                    }
//                    
//                }
//            })
//            
//        }
        
    }
    
    
    @IBAction func UsernameClick(_ sender: AnyObject) {
        
        segueDelegate.goToProfile(id: postAuthorID)
    }
    
    @IBAction func likeLblBtn_click() {
        if let id = self.uuidLbl.text as String!{
            segueDelegate.displayLikes(uuid: id)
        }
        
    }
    

    
    @IBAction func likeBtn_clicked(_ sender: UIButton) {
        // declare title of button
        let title = sender.title(for: .normal)
        let buttonRow = sender.tag
        
        SetLike(title: title,uuid: uuidLbl.text!,Btn: self.likeBtn, Lbl: self.LikeLbl, CellPos : buttonRow, Origin: "Post")
//        
//        // to like
//        if title == "unlike" {
//            
//            firebase.child("Likes").child(uuidLbl.text!).child((FIRAuth.auth()?.currentUser!.uid)!).setValue(true)
//            print("liked")
//            self.likeBtn.setTitle("like", forState: .Normal)
//            //self.likeBtn.setBackgroundImage(UIImage(named: "like.png"), forState: .Normal)
//            
//            // send notification if we liked to refresh TableView
//            NSNotificationCenter.defaultCenter().postNotificationName("liked", object: nil)
//
//        
////        
////            let object = PFObject(className: "likes")
////            object["by"] = PFUser.currentUser()?.username
////            object["to"] = uuidLbl.text
////            object.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
////                if success {
////                    print("liked")
////                    self.likeBtn.setTitle("like", forState: .Normal)
////                    self.likeBtn.setBackgroundImage(UIImage(named: "like.png"), forState: .Normal)
////                    
////                    // send notification if we liked to refresh TableView
////                    NSNotificationCenter.defaultCenter().postNotificationName("liked", object: nil)
////                    
////                    //                    // send notification as like
////                    //                    if self.usernameBtn.titleLabel?.text != PFUser.currentUser()?.username {
////                    //                        let newsObj = PFObject(className: "news")
////                    //                        newsObj["by"] = PFUser.currentUser()?.username
////                    //                        newsObj["ava"] = PFUser.currentUser()?.objectForKey("ava") as! PFFile
////                    //                        newsObj["to"] = self.usernameBtn.titleLabel!.text
////                    //                        newsObj["owner"] = self.usernameBtn.titleLabel!.text
////                    //                        newsObj["uuid"] = self.uuidLbl.text
////                    //                        newsObj["type"] = "like"
////                    //                        newsObj["checked"] = "no"
////                    //                        newsObj.saveEventually()
////                    //                    }
////                    
////                }
////            })
//            
//            // to dislike
//        } else {
//    
//    firebase.child("Likes").child(uuidLbl.text!).child((FIRAuth.auth()?.currentUser!.uid)!).removeValue()
//            print("disliked")
//            self.likeBtn.setTitle("unlike", forState: .Normal)
//           // self.likeBtn.setBackgroundImage(UIImage(named: "unlike.png"), forState: .Normal)
//            
//            // send notification if we liked to refresh TableView
//            NSNotificationCenter.defaultCenter().postNotificationName("liked", object: nil)
//
//    
//    
////            // request existing likes of current user to show post
////            let query = PFQuery(className: "likes")
////            query.whereKey("by", equalTo: PFUser.currentUser()!.username!)
////            query.whereKey("to", equalTo: uuidLbl.text!)
////            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
////                
////                // find objects - likes
////                for object in objects! {
////                    
////                    // delete found like(s)
////                    object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
////                        if success {
////                            print("disliked")
////                            self.likeBtn.setTitle("unlike", forState: .Normal)
////                            self.likeBtn.setBackgroundImage(UIImage(named: "unlike.png"), forState: .Normal)
////                            
////                            // send notification if we liked to refresh TableView
////                            NSNotificationCenter.defaultCenter().postNotificationName("liked", object: nil)
////                            
////                            
////                            //                            // delete like notification
////                            //                            let newsQuery = PFQuery(className: "news")
////                            //                            newsQuery.whereKey("by", equalTo: PFUser.currentUser()!.username!)
////                            //                            newsQuery.whereKey("to", equalTo: self.usernameBtn.titleLabel!.text!)
////                            //                            newsQuery.whereKey("uuid", equalTo: self.uuidLbl.text!)
////                            //                            newsQuery.whereKey("type", equalTo: "like")
////                            //                            newsQuery.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
////                            //                                if error == nil {
////                            //                                    for object in objects! {
////                            //                                        object.deleteEventually()
////                            //                                    }
////                            //                                }
////                            //                            })
////                            
////                            
////                        }
////                    })
////                }
////            })
//            
//        }
    }
    
}
