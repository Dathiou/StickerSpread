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
protocol ChooseUserDelegate {
    func chreatChatroom(withUser: String)
}

class postCellSelected: UITableViewCell {
    
    var delegate: startChatProtocol!
    
    @IBOutlet weak var ContactName: UITextView!
    @IBOutlet weak var Flag: UIImageView!
    @IBOutlet weak var UFG: UITextField!
    @IBOutlet weak var LayoutLbl: UILabel!
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var FinishLbl: UILabel!
    @IBOutlet weak var colorLbl1: UILabel!
    @IBOutlet weak var colorLbl2: UILabel!
    @IBOutlet weak var colorLbl3: UILabel!
    
    @IBOutlet weak var ConnectImage: UIImageView!
    @IBOutlet weak var ConnectView: UIView!

    var postAuthorID = String()
    
    @IBOutlet weak var connectBtn: UIButton!

    var myPost = Post()
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
    
    func connectClick(){
        delegate.startChatProt(toUser: postAuthorID)

    }
    
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

        
        let tap = UITapGestureRecognizer(target: self, action: #selector(postCellSelected.connectClick))
        tap.delegate = self
        ConnectView.addGestureRecognizer(tap)

        ConnectImage.layer.cornerRadius = 4.0
        ConnectImage.clipsToBounds = true
        ConnectImage.layer.borderColor = UIColor.white.cgColor
        ConnectImage.layer.borderWidth = 0.5
        

               
        
                // round ava
        avaImg.layer.cornerRadius = 4.0
        avaImg.clipsToBounds = true
        avaImg.layer.borderColor = UIColor.white.cgColor
        avaImg.layer.borderWidth = 0.5
        
        
//        let bgImage = avaImg
//        
//        bgImage?.frame = CGRect(x:0,y:0,width:10,height:10)
//    
//        let btn: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
//        btn.addSubview(bgImage!)
//        //self.addSubview(btn)
        
        
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
