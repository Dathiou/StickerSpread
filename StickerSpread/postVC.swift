//
//  postVC.swift
//  StickerSpread
//
//  Created by Student iMac on 6/3/16.
//  Copyright © 2016 Student iMac. All rights reserved.
//

import UIKit
import Parse
import Firebase

var postuuid = [String]()

class postVC: UITableViewController {
    
    let storage = FIRStorage.storage()
    let storageRef = FIRStorage.storage().referenceForURL("gs://stickerspread-4f3a9.appspot.com")
    
    // arrays to hold information from server
    //var avaArray = [PFFile]()
    var avaArray = [UIImage]()
    var usernameArray = [String]()
    var nameArray = [String]()
    var dateArray = [NSDate?]()
    //var picArray = [PFFile]()
    var picArray = [UIImage]()
    var uuidArray = [String]()
    var titleArray = [String]()
    
    
    // default func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // title label at the top
        self.navigationItem.title = "PHOTO"
        
        //        // new back button
        //        self.navigationItem.hidesBackButton = true
        //        let backBtn = UIBarButtonItem(image: UIImage(named: "back.png"), style: .Plain, target: self, action: "back:")
        //        self.navigationItem.leftBarButtonItem = backBtn
        //self.tableView.backgroundColor = UIColor.redColor()
        //self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        // new back button
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem(title: "back", style: UIBarButtonItemStyle.Plain, target: self, action: "back:")
        self.navigationItem.leftBarButtonItem = backBtn
        
        // swipe to go back
        let backSwipe = UISwipeGestureRecognizer(target: self, action: "back:")
        backSwipe.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(backSwipe)
        
        
        
        // swipe to go back
        //        let backSwipe = UISwipeGestureRecognizer(target: self, action: "back:")
        //        backSwipe.direction = UISwipeGestureRecognizerDirection.Right
        //        self.view.addGestureRecognizer(backSwipe)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refresh", name: "liked", object: nil)
        

        tableView.registerNib(UINib(nibName: "postSelected", bundle: nil), forCellReuseIdentifier: "idPostSelectedCell")
        // dynamic cell heigth
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 800
        // find post
        
        //let r = postuuidArray.last!
        
        firebase.child("Posts").child(postuuid.last!).queryOrderedByChild("date").observeEventType(.Value, withBlock: { snapshot in
            
            // clean up
            self.usernameArray.removeAll(keepCapacity: false)
            self.nameArray.removeAll(keepCapacity: false)
            self.avaArray.removeAll(keepCapacity: false)
            self.dateArray.removeAll(keepCapacity: false)
            self.picArray.removeAll(keepCapacity: false)
            //self.picArraySearch.removeAll(keepCapacity: false)
            self.titleArray.removeAll(keepCapacity: false)
            self.uuidArray.removeAll(keepCapacity: false)
            
            if snapshot.exists() {
                
                //sorted = (snapshot.value!.allValues as NSArray).sortedArrayUsingDescriptors([NSSortDescriptor(key: "date", ascending: false)])
                //for post in snapshot.children{
                let k = snapshot.key
                
                let userID = snapshot.value!.objectForKey("userID") as! String
                //let datestring = post.value.objectForKey("date") as! String
                if let datestring = snapshot.value!.objectForKey("date") as? String{
                    var dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                    let date = dateFormatter.dateFromString(datestring)
                    self.dateArray.append(date)
                    //  }
                    self.usernameArray.append(userID as! String)
                    
                    self.titleArray.append(snapshot.value!.objectForKey("title") as! String)
                    self.uuidArray.append(snapshot.key as String!)
                    
                    
                    
                    
                    firebase.child("Users").child(userID).observeEventType(.Value, withBlock: { snapshot1 in
                        
                        objc_sync_enter(self.nameArray)
                        let first = (snapshot1.value!.objectForKey("first_name") as? String)
                        let last = (snapshot1.value!.objectForKey("last_name") as? String)
                        
                        let fullname = first!+" "+last!
                        self.nameArray.append(fullname)
                        
                        let avaURL = (snapshot1.value!.objectForKey("ProfilPicUrl") as! String)
                        let url = NSURL(string: avaURL)
                        if let data = NSData(contentsOfURL: url!){ //make sure your image in this url does exist, otherwise unwrap in a if let check
                            self.avaArray.append(UIImage(data: data) as UIImage!)
                            objc_sync_exit(self.nameArray)
                            
                            // let i = snapshot.value!.objectForKey("photoUrl") as! String
                            
                            self.storage.referenceForURL(snapshot.value!.objectForKey("photoUrl") as! String).dataWithMaxSize(25 * 1024 * 1024, completion: { (data, error) -> Void in
                                let image = UIImage(data: data!)
                                
                                objc_sync_enter(self.usernameArray)
                                self.picArray.append(image! as! UIImage)
                                objc_sync_exit(self.usernameArray)
                                //self.tableView.reloadData()
                                //self.scrollToBottom()
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.tableView.reloadData()
                                    // self.collectionView.reloadData()
                                    
                                    //self.refresher.endRefreshing()
                                });
                            })
                            
                        }
                        
                        // self.avaArray.append(snapshot.value!.objectForKey("ava") as! String)
                        
                        //self.picArray.append(snapshot.value!.objectForKey("pic") as! String)
                        //self.picArraySearch.append(object.objectForKey("pic") as! PFFile)
                        
                        
                        //self.comments.append(snapshot)
                        //self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.comments.count-1, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Automatic)
                        }
                        
                    ){ (error) in
                        print(error.localizedDescription)
                    }
                    
                    
                }}
            
            
            
            
            
            
            //self.comments.append(snapshot)
            //self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.comments.count-1, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Automatic)
        }){ (error) in
            print(error.localizedDescription)
        }
        
        
        
        
        //
        //        let postQuery = PFQuery(className: "posts")
        //        postQuery.whereKey("uuid", equalTo: postuuid.last!)
        //        postQuery.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) -> Void in
        //            if error == nil {
        //
        //                // clean up
        //                self.avaArray.removeAll(keepCapacity: false)
        //                self.usernameArray.removeAll(keepCapacity: false)
        //                self.nameArray.removeAll(keepCapacity: false)
        //                self.dateArray.removeAll(keepCapacity: false)
        //                self.picArray.removeAll(keepCapacity: false)
        //                self.uuidArray.removeAll(keepCapacity: false)
        //                self.titleArray.removeAll(keepCapacity: false)
        //
        //                // find related objects
        //                for object in objects! {
        //
        //                    self.avaArray.append(object.valueForKey("ava") as! PFFile)
        //                    self.usernameArray.append(object.valueForKey("username") as! String)
        //                    self.dateArray.append(object.createdAt)
        //                    self.picArray.append(object.valueForKey("pic") as! PFFile)
        //                    self.uuidArray.append(object.valueForKey("uuid") as! String)
        //                    self.titleArray.append(object.valueForKey("title") as! String)
        //
        //                    let usernmae = object.valueForKey("username") as! String
        //                    let infoQuery = PFQuery(className: "_User")
        //                    infoQuery.whereKey("username", equalTo: usernmae)
        //                    infoQuery.findObjectsInBackgroundWithBlock ({ (objects1:[PFObject]?, error:NSError?) -> Void in
        //                        if error == nil {
        //
        //                            // shown wrong user
        //                            if objects1!.isEmpty {
        //                                // call alert
        //                                let alert = UIAlertController(title: "\(guestname.last!.uppercaseString)", message: "is not existing", preferredStyle: UIAlertControllerStyle.Alert)
        //                                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
        //                                    self.navigationController?.popViewControllerAnimated(true)
        //                                })
        //                                alert.addAction(ok)
        //                                self.presentViewController(alert, animated: true, completion: nil)
        //                            }
        //
        //                            // find related to user information
        //                            for object1 in objects1! {
        //
        //
        //
        //                                // get users data with connections to columns of PFUser class
        //                                let first = (object1.objectForKey("first_name") as? String)
        //                                let last = (object1.objectForKey("last_name") as? String)
        //
        //                                let fullname = first!+" "+last!
        //                                self.nameArray.append(fullname)
        //
        //
        //                            }
        //
        //              self.tableView.reloadData()
        //                }
        //                        })
        //
        //            }
        //
        //        }
        //        })
        
    }
    
    // refreshing function
    func refresh() {
        self.tableView.reloadData()
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.size.height
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.size.height
    }
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernameArray.count
    }
    
    // cell config
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // define cell
        //let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! postCell
        let cell = tableView.dequeueReusableCellWithIdentifier("idPostSelectedCell", forIndexPath: indexPath) as! postCellSelected
        cell.backgroundColor = UIColor.clearColor()
        // connect objects with our information from arrays
        cell.usernameBtn.setTitle(nameArray[indexPath.row], forState: UIControlState.Normal)
        cell.usernameBtn.sizeToFit()
        cell.uuidLbl.text = self.uuidArray[indexPath.row]
        cell.titleLbl.text = self.titleArray[indexPath.row]
        cell.titleLbl.sizeToFit()
        cell.usernameHidden.setTitle(usernameArray[indexPath.row], forState: UIControlState.Normal)
        
        //        // place profile picture
        //        avaArray[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
        //            cell.avaImg.image = UIImage(data: data!)
        //        }
        cell.avaImg.image = avaArray[indexPath.row]
        //        // place post picture
        //        picArray[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
        //            cell.picImg.image = UIImage(data: data!)
        //        }
        cell.picImg.image = picArray[indexPath.row]
        
        
        // calculate post date
        let from = dateArray[indexPath.row]
        let now = NSDate()
        let components : NSCalendarUnit = [.Second, .Minute, .Hour, .Day, .WeekOfMonth]
        let difference = NSCalendar.currentCalendar().components(components, fromDate: from!, toDate: now, options: [])
        
        // logic what to show: seconds, minuts, hours, days or weeks
        if difference.second <= 0 {
            cell.dateLbl.text = "now"
        }
        if difference.second > 0 && difference.minute == 0 {
            cell.dateLbl.text = "\(difference.second)s."
        }
        if difference.minute > 0 && difference.hour == 0 {
            cell.dateLbl.text = "\(difference.minute)m."
        }
        if difference.hour > 0 && difference.day == 0 {
            cell.dateLbl.text = "\(difference.hour)h."
        }
        if difference.day > 0 && difference.weekOfMonth == 0 {
            cell.dateLbl.text = "\(difference.day)d."
        }
        if difference.weekOfMonth > 0 {
            cell.dateLbl.text = "\(difference.weekOfMonth)w."
        }
    
        
        getLikeState(cell.uuidLbl.text! , Btn: cell.likeBtn)
        getLikeCount(cell.uuidLbl.text! , Lbl : cell.likeLbl)
        
        
        // asign index
        cell.usernameBtn.layer.setValue(indexPath, forKey: "index")
        //cell.commentBtn.layer.setValue(indexPath, forKey: "index")
        cell.moreBtn.layer.setValue(indexPath, forKey: "index")
        
        return cell
    }
    
    
    
    @IBAction func usernameBtn_click(sender: AnyObject) {
        // call index of button
        let i = sender.layer.valueForKey("index") as! NSIndexPath
        
        // call cell to call further cell data
        let cell = tableView.cellForRowAtIndexPath(i) as! postCell
        
        // if user tapped on himself go home, else go guest
        
        
        if cell.usernameHidden.titleLabel?.text == (FIRAuth.auth()?.currentUser!.uid)!{
            let home = self.storyboard?.instantiateViewControllerWithIdentifier("homeVC") as! homeVC
            self.navigationController?.pushViewController(home, animated: true)
        } else {
//            guestname.append(cell.usernameHidden.titleLabel!.text!)
//            let guest = self.storyboard?.instantiateViewControllerWithIdentifier("guestVC") as! guestVC
//            self.navigationController?.pushViewController(guest, animated: true)
        }
        
    }
    
    
    @IBAction func moreBtn_click(sender: AnyObject) {
        
        // call index of button
        let i = sender.layer.valueForKey("index") as! NSIndexPath
        
        // call cell to call further cell date
        let cell = tableView.cellForRowAtIndexPath(i) as! postCell
        
        
        // DELET ACTION
        let delete = UIAlertAction(title: "Delete", style: .Default) { (UIAlertAction) -> Void in
            
            // STEP 1. Delete row from tableView
            self.usernameArray.removeAtIndex(i.row)
            self.avaArray.removeAtIndex(i.row)
            self.dateArray.removeAtIndex(i.row)
            self.picArray.removeAtIndex(i.row)
            self.titleArray.removeAtIndex(i.row)
            self.uuidArray.removeAtIndex(i.row)
            
            // STEP 2. Delete post from server
            let postQuery = PFQuery(className: "posts")
            postQuery.whereKey("uuid", equalTo: cell.uuidLbl.text!)
            postQuery.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                if error == nil {
                    for object in objects! {
                        object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                            if success {
                                
                                // send notification to rootViewController to update shown posts
                                NSNotificationCenter.defaultCenter().postNotificationName("uploaded", object: nil)
                                
                                // push back
                                self.navigationController?.popViewControllerAnimated(true)
                            } else {
                                print(error!.localizedDescription)
                            }
                        })
                    }
                } else {
                    print(error?.localizedDescription)
                }
            })
            
            // STEP 2. Delete likes of post from server
            let likeQuery = PFQuery(className: "likes")
            likeQuery.whereKey("to", equalTo: cell.uuidLbl.text!)
            likeQuery.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                if error == nil {
                    for object in objects! {
                        object.deleteEventually()
                    }
                }
            })
            //
            //            // STEP 3. Delete comments of post from server
            //            let commentQuery = PFQuery(className: "comments")
            //            commentQuery.whereKey("to", equalTo: cell.uuidLbl.text!)
            //            commentQuery.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
            //                if error == nil {
            //                    for object in objects! {
            //                        object.deleteEventually()
            //                    }
            //                }
            //            })
            //
            //            // STEP 4. Delete hashtags of post from server
            //            let hashtagQuery = PFQuery(className: "hashtags")
            //            hashtagQuery.whereKey("to", equalTo: cell.uuidLbl.text!)
            //            hashtagQuery.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
            //                if error == nil {
            //                    for object in objects! {
            //                        object.deleteEventually()
            //                    }
            //                }
            //            })
        }
        
        
        // COMPLAIN ACTION
        let complain = UIAlertAction(title: "Complain", style: .Default) { (UIAlertAction) -> Void in
            
            // send complain to server
            let complainObj = PFObject(className: "complain")
            complainObj["by"] = PFUser.currentUser()?.username
            complainObj["to"] = cell.uuidLbl.text
            complainObj["owner"] = cell.usernameBtn.titleLabel?.text
            complainObj.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                if success {
                    self.alert("Complain has been made successfully", message: "Thank You! We will consider your complain")
                } else {
                    self.alert("ERROR", message: error!.localizedDescription)
                }
            })
        }
        
        // CANCEL ACTION
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        
        // create menu controller
        let menu = UIAlertController(title: "Menu", message: nil, preferredStyle: .ActionSheet)
        
        
        // if post belongs to user, he can delete post, else he can't
        if cell.usernameBtn.titleLabel?.text == PFUser.currentUser()?.username {
            menu.addAction(delete)
            menu.addAction(cancel)
        } else {
            menu.addAction(complain)
            menu.addAction(cancel)
        }
        
        // show menu
        self.presentViewController(menu, animated: true, completion: nil)
    }
    
    // alert action
    func alert (title: String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(ok)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    // go back function
    func back(sender: UIBarButtonItem) {
        
        // push back
        self.navigationController?.popViewControllerAnimated(true)
        
        // clean post uuid from last hold
        if !postuuid.isEmpty {
            postuuid.removeLast()
        }
        
    }
    
    
}
