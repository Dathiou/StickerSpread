//
//  searchCollCell.swift
//  StickerSpread
//
//  Created by Student iMac on 6/16/16.
//  Copyright © 2016 Student iMac. All rights reserved.
//

import UIKit
import Parse
import Firebase

protocol segueToPost{
    func goToPost(uuid : String!)
}



class testsearchcell: UICollectionViewCell {
    
    var uuid = String()
    
    //@IBOutlet weak var usernameBtn: UIButton!
    //@IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var picImg1: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    
    //@IBOutlet weak var commentBtn: UIButton!
    //@IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var likeLbl: UILabel!
    
    @IBOutlet weak var usernameHidden: UIButton!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    //@IBOutlet weak var titleLbl: KILabel!
    @IBOutlet weak var uuidLbl: UILabel!
    var segueDelegate : segueToPost!
    override func awakeFromNib() {
        super.awakeFromNib()
        //print(uuid)
        //getLikeState(uuid , Btn: self.likeBtn)
        //getLikeCount(uuid, Lbl : self.likeLbl)
        
        //cell.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-2-[v1(20)]-1-[v0]-5-[v2]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": likeLbl,"v1": like,"v2": titleShop]))
        // round ava
        //avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        //avaImg.clipsToBounds = true
        
        // clear like button title color
        likeBtn.setTitleColor(UIColor.clearColor(), forState: .Normal)
        // double tap to like
        let selectTap = UITapGestureRecognizer(target: self, action: "selectTap")
        //selectTap.numberOfTapsRequired = 2
        picImg1.userInteractionEnabled = true
        picImg1.addGestureRecognizer(selectTap)
        
        //picImg.frame = CGRect(x: 0, y: 0, width: 90, height: 90)
        
        //self.picImg1.frame = CGRectMake(0,0,32,32)
        
//        picImg1.translatesAutoresizingMaskIntoConstraints = false
//        
//        likeBtn.translatesAutoresizingMaskIntoConstraints = false
//        
//        
//        likeLbl.translatesAutoresizingMaskIntoConstraints = false
//        titleLbl.translatesAutoresizingMaskIntoConstraints = false
//        uuidLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //likeLbl.font.fontWithSize(11)
        //titleLbl.font.fontWithSize(12)
        
        //let width1 = UIScreen.mainScreen().bounds.width/2
        //self.picImg1.frame = CGRect(x: 0,y: 0, width: width1, height: width1)
        //self.picImg1.frame = CGRectMake(0,0,self.frame.width/2,self.frame.width/2)
        
//        var lineView = UIView(frame: CGRectMake(25,self.frame.size.height+1,self.frame.size.width - 50,0.5))
//        lineView.layer.borderWidth = 0.5
//        lineView.layer.borderColor = UIColor.blackColor().CGColor
//        self.addSubview(lineView)
        
        
        //self.addSubview(likeButton)
        //self.addSubview(nameLabel)
        //self.addSubview(like)
        //self.addSubview(likeLabel)
        // picImg.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)
        // self.addSubview(picImg)
        let width = UIScreen.mainScreen().bounds.width/2 - 10
        //print(width)
               // self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[pic(\(width))]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["pic": picImg1]))
//        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[pic(wid)]-0-|", options: NSLayoutFormatOptions(), metrics: ["wid": width], views: ["pic": picImg1]))
//        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[pic(wid)]", options: NSLayoutFormatOptions(), metrics: ["wid": width], views: ["pic": picImg1]))
//        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[likeBtn(18)]-2-|", options: NSLayoutFormatOptions(), metrics: ["wid": width], views: ["pic": picImg1,"likeBtn": likeBtn]))
//        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[likeLbl]-2-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["pic": picImg1,"likeLbl": likeLbl]))
//        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[titleLbl]-1-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["pic": picImg1,"titleLbl": titleLbl]))
//        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-4-[likeBtn(18)]-30-[likeLbl]", options: NSLayoutFormatOptions(), metrics: nil, views: ["likeLbl": likeLbl,"likeBtn": likeBtn]))
        
//        picImg1.translatesAutoresizingMaskIntoConstraints = false
//        let leftConstraint = NSLayoutConstraint(item: self.picImg1, attribute:.Width, relatedBy:.LessThanOrEqual,toItem:nil,attribute:.NotAnAttribute, multiplier:1.0, constant:width);
//
//        self.addConstraint(leftConstraint )
        
                //self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-50-[titleLbl]-1-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["titleLbl": titleLbl]))
        
        
    }
    
    
    
    //    override init(frame: CGRect) {
    //        super.init(frame: frame)
    //
    //
    //        //setupViews(frame)
    //    }
    
    //    let uuidLbl: UILabel = {
    //        let label = UILabel()
    //        //label.text = "My Custom CollectionView"
    //        //label.translatesAutoresizingMaskIntoConstraints = false
    //        return label
    //    }()
    
    //    let nameLabel: UILabel = {
    //        let label = UILabel()
    //        //label.text = "My Custom CollectionView"
    //        label.translatesAutoresizingMaskIntoConstraints = false
    //        label.font = label.font.fontWithSize(13)
    //        return label
    //    }()
    //
    //    let likeLabel: UILabel = {
    //        let label = UILabel()
    //        // count total likes of shown post
    //
    //        //
    //
    //        //label.frame = CGRectMake(21, 140, 10, 10)
    //        //label.text = "9"
    //        label.translatesAutoresizingMaskIntoConstraints = false
    //        label.font = label.font.fontWithSize(9)
    //        return label
    //    }()
    //
    //    let likeButton: UIButton = {
    //
    //        let image = UIImage(named: "unlike.png")
    ////        let likeImg = UIImageView(image: image!)
    ////        //likeImg.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
    ////        likeImg.translatesAutoresizingMaskIntoConstraints = false
    //
    //        let button   = UIButton(type: UIButtonType.Custom) as UIButton
    //        //button.frame = CGRectMake(100, 100, 100, 100)
    //        //button.setImage(image, forState: .Normal)
    //        button.translatesAutoresizingMaskIntoConstraints = false
    //        //button.addTarget(self, action: "btnTouched:", forControlEvents:.TouchUpInside)
    //
    //        return button
    //    }()
    //
    //    let uuid = UILabel()
    //
    //    let picImg = UIImageView()
    //
    ////    let image = UIImage(named: "name") as UIImage?
    ////    let button   = UIButton(type: UIButtonType.Custom) as UIButton
    ////    //button.frame = CGRectMake(100, 100, 100, 100)
    ////    button.setImage(image, forState: .Normal)
    ////    button.addTarget(self, action: "btnTouched:", forControlEvents:.TouchUpInside)
    ////    self.view.addSubview(button)
    //
    //
    ////    let likeLabel: UILabel = {
    ////        let label = UILabel()
    ////        // count total likes of shown post
    ////        let countLikes = PFQuery(className: "likes")
    ////        countLikes.whereKey("to", equalTo: uuidArrayColl[indexPath.row])
    ////        countLikes.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) -> Void in
    ////            label.text = String(count) //"\(count)"
    ////        }
    ////    }()
    //
    //    func setupViews(frame: CGRect) {
    ////        backgroundColor = UIColor.redColor()
    ////
    ////        addSubview(nameLabel)
    ////        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-12-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
    ////        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
    //
    //
    //        var lineView = UIView(frame: CGRectMake(25,self.frame.size.height - 2,self.frame.size.width - 50,0.5))
    //        lineView.layer.borderWidth = 0.5
    //        lineView.layer.borderColor = UIColor.blackColor().CGColor
    //        self.addSubview(lineView)
    //        self.addSubview(likeButton)
    //        self.addSubview(nameLabel)
    //        //self.addSubview(like)
    //        self.addSubview(likeLabel)
    //        picImg.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)
    //        self.addSubview(picImg)
    //        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-161-[v0(18)]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": likeButton]))
    //        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-2-[v1(18)]-1-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": likeLabel,"v1": likeButton]))
    //        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-50-[v2]-1-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v2": nameLabel]))
    //        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-153-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": likeLabel]))
    //        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-152-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
    //
    //
    //    }
    //
    ////    required init?(coder aDecoder: NSCoder) {
    ////        fatalError("init(coder:) has not been implemented")
    ////    }
    ////
    //
    //
    
    
    func selectTap(){
        print(uuidLbl.text!)
        if let st = uuidLbl.text as String! {
        segueDelegate.goToPost(st)
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
            //self.likeBtn.setTitle("like", forState: .Normal)
            //self.likeBtn.setBackgroundImage(UIImage(named: "Heart 2.png"), forState: .Normal)
            
            getLikeState(uuid , Btn: self.likeBtn)
            getLikeCount(uuid, Lbl : self.likeLbl)
           //// self.likeLbl.text = "\(Int(self.likeLbl.text!)! + 1)"
            
            // send notification if we liked to refresh TableView
          //  NSNotificationCenter.defaultCenter().postNotificationName("liked", object: nil)
            
            
            //
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
            
            // to dislike
        } else {
            
            firebase.child("Likes").child(uuidLbl.text!).child((FIRAuth.auth()?.currentUser!.uid)!).removeValue()
            firebase.child("LikesPerUser").child((FIRAuth.auth()?.currentUser!.uid)!).child(uuidLbl.text!).removeValue()
            print("disliked")
            //self.likeBtn.setTitle("unlike", forState: .Normal)
            //self.likeBtn.setBackgroundImage(UIImage(named: "unlHeart 1.png"), forState: .Normal)
            
            getLikeState(uuid , Btn: self.likeBtn)
            getLikeCount(uuid, Lbl : self.likeLbl)
            
            // send notification if we liked to refresh TableView
          //  NSNotificationCenter.defaultCenter().postNotificationName("liked", object: nil)
         //   self.likeLbl.text = "\(Int(self.likeLbl.text!)! - 1)"
            
            
            
            //            // request existing likes of current user to show post
            //            let query = PFQuery(className: "likes")
            //            query.whereKey("by", equalTo: PFUser.currentUser()!.username!)
            //            query.whereKey("to", equalTo: uuidLbl.text!)
            //            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
            //
            //                // find objects - likes
            //                for object in objects! {
            //
            //                    // delete found like(s)
            //                    object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
            //                        if success {
            //                            print("disliked")
            //                            self.likeBtn.setTitle("unlike", forState: .Normal)
            //                            self.likeBtn.setBackgroundImage(UIImage(named: "unlike.png"), forState: .Normal)
            //
            //                            // send notification if we liked to refresh TableView
            //                            NSNotificationCenter.defaultCenter().postNotificationName("liked", object: nil)
            //
            //
            //                            //                            // delete like notification
            //                            //                            let newsQuery = PFQuery(className: "news")
            //                            //                            newsQuery.whereKey("by", equalTo: PFUser.currentUser()!.username!)
            //                            //                            newsQuery.whereKey("to", equalTo: self.usernameBtn.titleLabel!.text!)
            //                            //                            newsQuery.whereKey("uuid", equalTo: self.uuidLbl.text!)
            //                            //                            newsQuery.whereKey("type", equalTo: "like")
            //                            //                            newsQuery.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
            //                            //                                if error == nil {
            //                            //                                    for object in objects! {
            //                            //                                        object.deleteEventually()
            //                            //                                    }
            //                            //                                }
            //                            //                            })
            //
            //
            //                        }
            //                    })
            //                }
            //            })
            
        }
    }

    
    
//    @IBAction func likeBtn_clicked(sender: AnyObject) {
//        // declare title of button
//        let title = sender.titleForState(.Normal)
//        
//        // to like
//        if title == "unlike" {
//            
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
//            // to dislike
//        } else {
//            
//            // request existing likes of current user to show post
//            let query = PFQuery(className: "likes")
//            query.whereKey("by", equalTo: PFUser.currentUser()!.username!)
//            query.whereKey("to", equalTo: uuidLbl.text!)
//            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
//                
//                // find objects - likes
//                for object in objects! {
//                    
//                    // delete found like(s)
//                    object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
//                        if success {
//                            print("disliked")
//                            self.likeBtn.setTitle("unlike", forState: .Normal)
//                            self.likeBtn.setBackgroundImage(UIImage(named: "unlike.png"), forState: .Normal)
//                            
//                            // send notification if we liked to refresh TableView
//                            NSNotificationCenter.defaultCenter().postNotificationName("liked", object: nil)
//                            
//                            
//                            //                            // delete like notification
//                            //                            let newsQuery = PFQuery(className: "news")
//                            //                            newsQuery.whereKey("by", equalTo: PFUser.currentUser()!.username!)
//                            //                            newsQuery.whereKey("to", equalTo: self.usernameBtn.titleLabel!.text!)
//                            //                            newsQuery.whereKey("uuid", equalTo: self.uuidLbl.text!)
//                            //                            newsQuery.whereKey("type", equalTo: "like")
//                            //                            newsQuery.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
//                            //                                if error == nil {
//                            //                                    for object in objects! {
//                            //                                        object.deleteEventually()
//                            //                                    }
//                            //                                }
//                            //                            })
//                            
//                            
//                        }
//                    })
//                }
//            })
//            
//        }
//    }
    
    
}
