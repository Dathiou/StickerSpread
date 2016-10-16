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


class postVC: UITableViewController, segueTo {
    
    var refresher = UIRefreshControl()
    
    let storage = FIRStorage.storage()
    let storageRef = FIRStorage.storage().reference(forURL: "gs://stickerspread-4f3a9.appspot.com")
    var modeSelf = false
    // arrays to hold information from server
    //var avaArray = [PFFile]()
    var avaArray = [UIImage]()
    var usernameArray = [String]()
    var nameArray = [String]()
    var dateArray = [Date]()
    //var picArray = [PFFile]()
    var picArray = [UIImage]()
    var uuidArray = [String]()
    var titleArray = [String]()
    var finish = String()
    var Month = String()
    var Color = [String]()
    var Layout = String()
    var UFG = String()
    
    
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
        
        
        // pull to refresh
        refresher.addTarget(self, action: #selector(postVC.loadPostInfo), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        
        
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem(title: "back", style: UIBarButtonItemStyle.plain, target: self, action: Selector(("back")))
        self.navigationItem.leftBarButtonItem = backBtn
        
        // swipe to go back
        let backSwipe = UISwipeGestureRecognizer(target: self, action: Selector(("back")))
        backSwipe.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(backSwipe)
        
        
        
        // swipe to go back
        //        let backSwipe = UISwipeGestureRecognizer(target: self, action: "back:")
        //        backSwipe.direction = UISwipeGestureRecognizerDirection.Right
        //        self.view.addGestureRecognizer(backSwipe)
        
        NotificationCenter.default.addObserver(self, selector: #selector(postVC.refresh), name: NSNotification.Name(rawValue: "likedFromPost"), object: nil)
        

        tableView.register(UINib(nibName: "postSelected", bundle: nil), forCellReuseIdentifier: "idPostSelectedCell")
        // dynamic cell heigth
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 800
        // find post
        
        //let r = postuuidArray.last!
        
        loadPostInfo()
        
    }
    
    func loadPostInfo(){
        firebase.child("Posts").child(postuuid.last!).queryOrdered(byChild: "date").observe(.value, with: { snapshot in
            
            // clean up
            self.usernameArray.removeAll(keepingCapacity: false)
            self.nameArray.removeAll(keepingCapacity: false)
            self.avaArray.removeAll(keepingCapacity: false)
            self.dateArray.removeAll(keepingCapacity: false)
            self.picArray.removeAll(keepingCapacity: false)
            //self.picArraySearch.removeAll(keepCapacity: false)
            self.titleArray.removeAll(keepingCapacity: false)
            self.uuidArray.removeAll(keepingCapacity: false)
            
            if snapshot.exists() {
                
                //sorted = (snapshot.value!.allValues as NSArray).sortedArrayUsingDescriptors([NSSortDescriptor(key: "date", ascending: false)])
                //for post in snapshot.children{
                let k = snapshot.key
                
                let userID = (snapshot.value! as AnyObject).value(forKey:"userID") as! String
                //let datestring = post.value.objectForKey("date") as! String
                if let datestring = (snapshot.value! as AnyObject).value(forKey:"date") as? String{
                    var dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                    let date = dateFormatter.date(from: datestring)
                    self.dateArray.append(date! as Date)
                    //  }
                    self.usernameArray.append(userID )
                    
                    self.titleArray.append((snapshot.value! as AnyObject).value(forKey:"title") as! String)
                    self.uuidArray.append(snapshot.key as String!)
                    
                    self.Layout = ((snapshot.value! as AnyObject).value(forKey:"Layout") as? String)!
                    self.finish = ((snapshot.value! as AnyObject).value(forKey:"Finish") as? String)!
                    self.Month = ((snapshot.value! as AnyObject).value(forKey:"Month") as? String)!
                    self.UFG = ((snapshot.value! as AnyObject).value(forKey:"Grab") as? String)!
                    self.Color = ((snapshot.value! as AnyObject).value(forKey:"Color") as? String)!.components(separatedBy: ",")
                    
                    firebase.child("Users").child(userID).observe(.value, with: { snapshot1 in
                        
                        objc_sync_enter(self.nameArray)
                        let first = ((snapshot1.value! as AnyObject).value(forKey:"first_name") as? String)
                        let last = ((snapshot1.value! as AnyObject).value(forKey:"last_name") as? String)
                        
                        let fullname = first!+" "+last!
                        self.nameArray.append(fullname)
                        

                        
                        let avaURL = ((snapshot1.value! as AnyObject).value(forKey:"ProfilPicUrl") as! String)
                        let url = NSURL(string: avaURL)
                        if let data = NSData(contentsOf: url! as URL){ //make sure your image in this url does exist, otherwise unwrap in a if let check
                            self.avaArray.append(UIImage(data: data as Data) as UIImage!)
                            objc_sync_exit(self.nameArray)
                            
                            // let i = snapshot.value!.objectForKey("photoUrl") as! String
                            
                            self.storage.reference(forURL:(snapshot.value!  as AnyObject).value(forKey:"photoUrl") as! String).data(withMaxSize: 25 * 1024 * 1024, completion: { (data, error) -> Void in
                                let image = UIImage(data: data!)
                                
                                objc_sync_enter(self.usernameArray)
                                self.picArray.append(image! as! UIImage)
                                objc_sync_exit(self.usernameArray)
                                //self.tableView.reloadData()
                                //self.scrollToBottom()
                                
                                DispatchQueue.main.async{
                                    self.tableView.reloadData()
                                    // self.collectionView.reloadData()
                                    
                                    self.refresher.endRefreshing()
                                }
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
    
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height
    }
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height
    }

    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernameArray.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // define cell
        //let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! postCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "idPostSelectedCell", for: indexPath as IndexPath) as! postCellSelected
        cell.backgroundColor = UIColor(patternImage: UIImage(named: "Background_Blue_Joint.jpg")!)
        //cell.segueDelegate = self
        //cell.backgroundColor = UIColor.clearColor()
        // connect objects with our information from arrays
        cell.usernameBtn.setTitle(nameArray[indexPath.row], for: UIControlState.normal)
        cell.postAuthorID = usernameArray[indexPath.row]
        cell.segueDelegate = self
        cell.usernameBtn.sizeToFit()
        cell.uuidLbl.text = self.uuidArray[indexPath.row]
        cell.titleLbl.text = self.titleArray[indexPath.row]
        cell.titleLbl.sizeToFit()
        cell.usernameHidden.setTitle(usernameArray[indexPath.row], for: UIControlState.normal)
        cell.LayoutLbl.text = Layout
        cell.FinishLbl.text = finish
        cell.monthLbl.text = Month
        cell.colorLbl1.text = Color[0]
        
        if self.Color.count == 2 {
            cell.colorLbl2.text = Color[1]
        } else if self.Color.count == 3 {
            cell.colorLbl2.text = Color[1]
            cell.colorLbl3.text = Color[2]
        }
        
        if self.UFG == "Not Available"{
            cell.Flag.isHidden = true
            cell.UFG.isHidden = true
        }
        
        
        
        
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
        let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfMonth])
        let difference = Date().offset(from: from)//NSCalendar.current.//dateComponents(components, from: from!, to: now)
        
//        // logic what to show: seconds, minuts, hours, days or weeks
//        if difference.second <= 0 {
//            cell.dateLbl.text = "now"
//        }
//        if difference.second > 0 && difference.minute == 0 {
//            cell.dateLbl.text = "\(difference.second)s."
//        }
//        if difference.minute > 0 && difference.hour == 0 {
//            cell.dateLbl.text = "\(difference.minute)m."
//        }
//        if difference.hour > 0 && difference.day == 0 {
//            cell.dateLbl.text = "\(difference.hour)h."
//        }
//        if difference.day > 0 && difference.weekOfMonth == 0 {
//            cell.dateLbl.text = "\(difference.day)d."
//        }
//        if difference.weekOfMonth > 0 {
//            cell.dateLbl.text = "\(difference.weekOfMonth)w."
//        }
    
        
        getLikeState(string: cell.uuidLbl.text! , Btn: cell.likeBtn)
        getLikeCount(string: cell.uuidLbl.text! , Lbl : cell.LikeLbl)
        
        
        // asign index
        cell.usernameBtn.layer.setValue(indexPath, forKey: "index")
        //cell.commentBtn.layer.setValue(indexPath, forKey: "index")
        cell.moreBtn.layer.setValue(indexPath, forKey: "index")
        
        return cell
    }
    
    
    
    @IBAction func usernameBtn_click(sender: AnyObject) {
        // call index of button
        let i = sender.layer.value(forKey: "index") as! NSIndexPath
        
        // call cell to call further cell data
        let cell = tableView.cellForRow(at: i as IndexPath) as! postCell
        
        // if user tapped on himself go home, else go guest
        
        
        if cell
            .usernameHidden.titleLabel?.text == (FIRAuth.auth()?.currentUser!.uid)!{
            let home = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as! homeVC1
            self.navigationController?.pushViewController(home, animated: true)
        } else {
//            guestname.append(cell.usernameHidden.titleLabel!.text!)
//            let guest = self.storyboard?.instantiateViewControllerWithIdentifier("guestVC") as! guestVC
//            self.navigationController?.pushViewController(guest, animated: true)
        }
        
    }
    
    
//    @IBAction func moreBtn_click(sender: AnyObject) {
//        
//        // call index of button
//        let i = sender.layer.value(forKey: "index") as! NSIndexPath
//        
//        // call cell to call further cell date
//        let cell = tableView.cellForRow(at: i as IndexPath) as! postCell
//        
//        
//        // DELET ACTION
//        let delete = UIAlertAction(title: "Delete", style: .default) { (UIAlertAction) -> Void in
//            
//            // STEP 1. Delete row from tableView
//            self.usernameArray.removeAtIndex(i.row)
//            self.avaArray.remove(at: i.row)
//            self.dateArray.remove(at: i.row)
//            self.picArray.remove(at: i.row)
//            self.titleArray.remove(at: i.row)
//            self.uuidArray.remove(at: i.row)
//            
//            // STEP 2. Delete post from server
//            let postQuery = PFQuery(className: "posts")
//            postQuery.whereKey("uuid", equalTo: cell.uuidLbl.text!)
//            postQuery.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
//                if error == nil {
//                    for object in objects! {
//                        object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
//                            if success {
//                                
//                                // send notification to rootViewController to update shown posts
//                                NSNotificationCenter.defaultCenter().postNotificationName("uploaded", object: nil)
//                                
//                                // push back
//                                self.navigationController?.popViewControllerAnimated(true)
//                            } else {
//                                print(error!.localizedDescription)
//                            }
//                        })
//                    }
//                } else {
//                    print(error?.localizedDescription)
//                }
//            })
//            
//            // STEP 2. Delete likes of post from server
//            let likeQuery = PFQuery(className: "likes")
//            likeQuery.whereKey("to", equalTo: cell.uuidLbl.text!)
//            likeQuery.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
//                if error == nil {
//                    for object in objects! {
//                        object.deleteEventually()
//                    }
//                }
//            })
//            //
//            //            // STEP 3. Delete comments of post from server
//            //            let commentQuery = PFQuery(className: "comments")
//            //            commentQuery.whereKey("to", equalTo: cell.uuidLbl.text!)
//            //            commentQuery.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
//            //                if error == nil {
//            //                    for object in objects! {
//            //                        object.deleteEventually()
//            //                    }
//            //                }
//            //            })
//            //
//            //            // STEP 4. Delete hashtags of post from server
//            //            let hashtagQuery = PFQuery(className: "hashtags")
//            //            hashtagQuery.whereKey("to", equalTo: cell.uuidLbl.text!)
//            //            hashtagQuery.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
//            //                if error == nil {
//            //                    for object in objects! {
//            //                        object.deleteEventually()
//            //                    }
//            //                }
//            //            })
//        }
//        
//        
//        // COMPLAIN ACTION
//        let complain = UIAlertAction(title: "Complain", style: .Default) { (UIAlertAction) -> Void in
//            
//            // send complain to server
//            let complainObj = PFObject(className: "complain")
//            complainObj["by"] = PFUser.currentUser()?.username
//            complainObj["to"] = cell.uuidLbl.text
//            complainObj["owner"] = cell.usernameBtn.titleLabel?.text
//            complainObj.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
//                if success {
//                    self.alert("Complain has been made successfully", message: "Thank You! We will consider your complain")
//                } else {
//                    self.alert("ERROR", message: error!.localizedDescription)
//                }
//            })
//        }
//        
//        // CANCEL ACTION
//        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
//        
//        
//        // create menu controller
//        let menu = UIAlertController(title: "Menu", message: nil, preferredStyle: .ActionSheet)
//        
//        
//        // if post belongs to user, he can delete post, else he can't
//        if cell.usernameBtn.titleLabel?.text == PFUser.currentUser()?.username {
//            menu.addAction(delete)
//            menu.addAction(cancel)
//        } else {
//            menu.addAction(complain)
//            menu.addAction(cancel)
//        }
//        
//        // show menu
//        self.presentViewController(menu, animated: true, completion: nil)
//    }
    
    // alert action
    func alert (title: String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    
    // go back function
    //func back(sender: UIBarButtonItem) {
    func back() {
        
        // push back
        self.navigationController?.popViewController(animated: true)
        
        // clean post uuid from last hold
        if !postuuid.isEmpty {
            postuuid.removeLast()
        }
        
    }
    
    func goToProfile(id : String!){
        print(id)
        modeSelf = false
        if id == (FIRAuth.auth()?.currentUser!.uid)! {
            modeSelf = true
        }
        
        let home = self.storyboard?.instantiateViewController(withIdentifier: "homeVC1") as! homeVC1
        home.userIdToDisplay = id
        home.goHome = modeSelf
        self.navigationController?.pushViewController(home, animated: true)
        
        //        if id == (FIRAuth.auth()?.currentUser!.uid)! {
        //            //if id == "aa" {
        //            let home = self.storyboard?.instantiateViewControllerWithIdentifier("homeVC") as! homeVC
        //
        //            self.navigationController?.pushViewController(home, animated: true)
        //        } else {
        //            guestname.append(id)
        //            goHome = true
        //            let guest = self.storyboard?.instantiateViewControllerWithIdentifier("guestVC") as! guestVC
        //            self.navigationController?.pushViewController(guest, animated: true)
        //        }
    }
    
    func goToPost(uuid : String!){
        // take relevant unique id of post to load post in postVC
        
        //print (uuid)
        postuuid.append(uuid)
        
        // present postVC programmaticaly
        let post = self.storyboard?.instantiateViewController(withIdentifier: "postVC") as! postVC
        self.navigationController?.pushViewController(post, animated: true)
        
        
        
    }
    
    func displayLikes(uuid: String!){
        
        user = uuid
        show1 = "Likes"
        
        // make references to followersVC
        let followers = self.storyboard?.instantiateViewController(withIdentifier: "followersVC") as! followersVC
        
        // present
        self.navigationController?.pushViewController(followers, animated: true)
    }
    
    
}
