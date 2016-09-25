//
//  searchCollCell.swift
//  StickerSpread
//
//  Created by Student iMac on 6/16/16.
//  Copyright © 2016 Student iMac. All rights reserved.
//

import UIKit
import Parse

class searchCollCell: UICollectionViewCell {
    
    
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //cell.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-2-[v1(20)]-1-[v0]-5-[v2]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": likeLbl,"v1": like,"v2": titleShop]))
        // round ava
        //avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        //avaImg.clipsToBounds = true
        
        // clear like button title color
        likeBtn.setTitleColor(UIColor.clear, for: .normal)
        // double tap to like
        //let likeTap = UITapGestureRecognizer(target: self, action: "likeTap")
        //likeTap.numberOfTapsRequired = 2
        //picImg.userInteractionEnabled = true
        //picImg.addGestureRecognizer(likeTap)
        
        //picImg.frame = CGRect(x: 0, y: 0, width: 90, height: 90)
        
        self.picImg1.frame = CGRect(x:0,y:0,width:32,height:32)
        
        picImg1.translatesAutoresizingMaskIntoConstraints = false
        
        likeBtn.translatesAutoresizingMaskIntoConstraints = false
  
        
        likeLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        uuidLbl.translatesAutoresizingMaskIntoConstraints = false


        let lineView = UIView(frame: CGRect(x: 25,y: self.frame.size.height - 2,width: self.frame.size.width - 50,height: 0.5))
        lineView.layer.borderWidth = 0.5
        lineView.layer.borderColor = UIColor.black.cgColor
        self.addSubview(lineView)
        //self.addSubview(likeButton)
        //self.addSubview(nameLabel)
        //self.addSubview(like)
        //self.addSubview(likeLabel)
       // picImg.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)
       // self.addSubview(picImg)
     
        
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-161-[v0(18)]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": likeBtn]))
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-2-[v1(18)]-1-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": likeLbl,"v1": likeBtn]))
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-50-[v2]-1-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v2": titleLbl]))
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-153-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": likeLbl]))
//        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-152-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": titleLbl]))
        
        
        
    }

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
     
        //setupViews(frame)
    }
    
//    let uuidLbl: UILabel = {
//        let label = UILabel()
//        //label.text = "My Custom CollectionView"
//        //label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        //label.text = "My Custom CollectionView"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(13)
        return label
    }()
    
    let likeLabel: UILabel = {
        let label = UILabel()
        // count total likes of shown post
        
        //
        
        //label.frame = CGRectMake(21, 140, 10, 10)
        //label.text = "9"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(9)
        return label
    }()
    
    let likeButton: UIButton = {
        
        let image = UIImage(named: "unlike.png")
//        let likeImg = UIImageView(image: image!)
//        //likeImg.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
//        likeImg.translatesAutoresizingMaskIntoConstraints = false
        
        let button   = UIButton(type: UIButtonType.custom) as UIButton
        //button.frame = CGRectMake(100, 100, 100, 100)
        //button.setImage(image, forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.addTarget(self, action: "btnTouched:", forControlEvents:.TouchUpInside)
        
        return button
    }()
    
    let uuid = UILabel()
    
    let picImg = UIImageView()
    
//    let image = UIImage(named: "name") as UIImage?
//    let button   = UIButton(type: UIButtonType.Custom) as UIButton
//    //button.frame = CGRectMake(100, 100, 100, 100)
//    button.setImage(image, forState: .Normal)
//    button.addTarget(self, action: "btnTouched:", forControlEvents:.TouchUpInside)
//    self.view.addSubview(button)
    
    
//    let likeLabel: UILabel = {
//        let label = UILabel()
//        // count total likes of shown post
//        let countLikes = PFQuery(className: "likes")
//        countLikes.whereKey("to", equalTo: uuidArrayColl[indexPath.row])
//        countLikes.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) -> Void in
//            label.text = String(count) //"\(count)"
//        }
//    }()
    
    func setupViews(frame: CGRect) {
//        backgroundColor = UIColor.redColor()
//        
//        addSubview(nameLabel)
//        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-12-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
//        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
       
        
        let lineView = UIView(frame: CGRect(x: 25,y: self.frame.size.height - 2,width: self.frame.size.width - 50,height: 0.5))
        lineView.layer.borderWidth = 0.5
        lineView.layer.borderColor = UIColor.black.cgColor
        self.addSubview(lineView)
        self.addSubview(likeButton)
        self.addSubview(nameLabel)
        //self.addSubview(like)
        self.addSubview(likeLabel)
        picImg.frame = CGRect(x: 0,y: 0,width: self.frame.size.width,height: self.frame.size.width)
        self.addSubview(picImg)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-161-[v0(18)]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": likeButton]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-2-[v1(18)]-1-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": likeLabel,"v1": likeButton]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-50-[v2]-1-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v2": nameLabel]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-153-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": likeLabel]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-152-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    @IBAction func likeBtn_clicked(sender: UIButton) {
        // declare title of button
        let title = sender.title(for: .normal)
        
        // to like
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
            
//            // request existing likes of current user to show post
//            let query = PFQuery(className: "likes")
//            query.whereKey("by", equalTo: PFUser.current()!.username!)
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

    
}
