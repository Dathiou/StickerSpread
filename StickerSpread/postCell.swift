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
    func displayLikes(uuid : String!)
}

func SetLike(title: String!, uuid: String! , Btn: UIButton, Lbl:UIButton, CellPos : Int, Origin: String){
    if title == "unlike" {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let dateString = dateFormatter.string(from: date as Date)
        
        firebase.child("Likes").child(uuid).child((FIRAuth.auth()?.currentUser!.uid)!).setValue(["Date" : dateString])
        firebase.child("LikesPerUser").child((FIRAuth.auth()?.currentUser!.uid)!).child(uuid).setValue(["Date" : dateString])
        print("liked")
        
        if Origin == "Feed" {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "likedFromFeed"), object: CellPos)
        } else if Origin == "Home" {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "likedFromHome"), object: CellPos)
        } else if Origin == "Post" {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "likedFromPost"), object: CellPos)
        }
        
        Btn.setTitle("like", for: .normal)
        Btn.setBackgroundImage(UIImage(named: "Heart 2.png"), for: .normal)
        print(Lbl.currentTitle)
        //Lbl.setTitle("\(Int(Lbl.currentTitle!)! + 1)", forState: .Normal)
        
    } else {
        
        firebase.child("Likes").child(uuid).child((FIRAuth.auth()?.currentUser!.uid)!).removeValue()
        firebase.child("LikesPerUser").child((FIRAuth.auth()?.currentUser!.uid)!).child(uuid).removeValue()
        print("disliked")
        if Origin == "Feed" {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "likedFromFeed"), object: CellPos)
        } else if Origin == "Home" {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "likedFromHome"), object: CellPos)
        } else if Origin == "Post" {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "likedFromPost"), object: CellPos)
        }
        Btn.setTitle("unlike", for: .normal)
        Btn.setBackgroundImage(UIImage(named: "Heart 1.png"), for: .normal)
        
        //Lbl.setTitle("\(Int(Lbl.currentTitle!)! + 1)", forState: .Normal)
        
        
        
    }

}


class postCell: UITableViewCell {


    
    
    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var usernameBtn: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var picImg: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    
    @IBOutlet weak var likelblbt: UILabel!
    //@IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
//    @IBOutlet weak var likeLbl: UILabel!
    
    @IBOutlet weak var LikeLbl: UIButton!
    @IBOutlet weak var usernameHidden: UIButton!
    
   @IBOutlet weak var titleLbl: UILabel!
     var segueDelegate : segueToPostFromFeed!
    //var segueDelegateUser : segueToUserFromFeed!
    //@IBOutlet weak var titleLbl: KILabel!
    @IBOutlet weak var uuidLbl: UILabel!
    var origin = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // clear like button title color
        likeBtn.setTitleColor(UIColor.clear, for: .normal)
        // double tap to like
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(postCell.likeTap))
        likeTap.numberOfTapsRequired = 2
        picImg.isUserInteractionEnabled = true
        picImg.addGestureRecognizer(likeTap)
        
        let selectTap = UITapGestureRecognizer(target: self, action: #selector(postCell.selectTap))
        //selectTap.numberOfTapsRequired = 2
        picImg.isUserInteractionEnabled = true
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
        let width = UIScreen.main.bounds.width
        
        
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
            
//            let object = PFObject(className: "likes")
//            object["by"] = PFUser.current()?.username
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
////                    // send notification as like
////                    if self.usernameBtn.titleLabel?.text != PFUser.currentUser()?.username {
////                        let newsObj = PFObject(className: "news")
////                        newsObj["by"] = PFUser.currentUser()?.username
////                        newsObj["ava"] = PFUser.currentUser()?.objectForKey("ava") as! PFFile
////                        newsObj["to"] = self.usernameBtn.titleLabel!.text
////                        newsObj["owner"] = self.usernameBtn.titleLabel!.text
////                        newsObj["uuid"] = self.uuidLbl.text
////                        newsObj["type"] = "like"
////                        newsObj["checked"] = "no"
////                        newsObj.saveEventually()
////                    }
//                    
//                }
//            })
            
        }
        
    }
    
    
    

    func selectTap(){
        if let st = uuidLbl.text as String! {
            segueDelegate.goToPost(uuid: st)
            //segueDelegateUser.goToProfile("aa")
        }
    }
    
    @IBAction func usernameBtn_click() {
        if let id = self.usernameHidden.titleLabel!.text as String!{
            segueDelegate.goToProfile(id: id)
        }
        
    }
    
    @IBAction func likeLblBtn_click() {
        if let id = self.uuidLbl.text as String!{
            segueDelegate.displayLikes(uuid: id)
        }
        
    }
    
    
    
    @IBAction func likeBtn_clicked(sender: UIButton) {
        // declare title of button
        let title = sender.title(for: .normal)
        let buttonRow = sender.tag
        SetLike(title: title,uuid: uuidLbl.text!,Btn: self.likeBtn, Lbl: self.LikeLbl, CellPos : buttonRow, Origin: self.origin)

    }
    
    
    


}
