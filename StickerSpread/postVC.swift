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

protocol startChatProtocol{
   func startChatProt(toUser: String)
}


class postVC: UITableViewController, segueTo,startChatProtocol {
    
    var refresher = UIRefreshControl()
    
    let storage = FIRStorage.storage()
    let storageRef = FIRStorage.storage().reference(forURL: "gs://stickerspread-4f3a9.appspot.com")
    var modeSelf = false
    // arrays to hold information from server
    //var avaArray = [PFFile]()
//    var avaArray = [UIImage]()
//    var usernameArray = [String]()
//    var nameArray = [String]()
//    var dateArray = [Date]()
//    //var picArray = [PFFile]()
//    var picArray = [UIImage]()
//    var uuidArray = [String]()
//    var titleArray = [String]()
//    var finish = String()
//    var Month = String()
//    var Color = [String]()
//    var Layout = String()
//    var UFG = String()
    
    var myPost = Post()
    
    
    // default func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // title label at the top
        self.navigationItem.title = "Post"
        
        //        // new back button
        //        self.navigationItem.hidesBackButton = true
        //        let backBtn = UIBarButtonItem(image: UIImage(named: "back.png"), style: .Plain, target: self, action: "back:")
        //        self.navigationItem.leftBarButtonItem = backBtn
        //self.tableView.backgroundColor = UIColor.redColor()
        //self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        // new back button
        
        
        // pull to refresh
        refresher.addTarget(self, action: #selector(postVC.loadAdditionalInfo(uuid:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        
        
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem(title: "back", style: UIBarButtonItemStyle.plain, target: self, action: Selector(("back")))
        self.navigationItem.leftBarButtonItem = backBtn
        
        // swipe to go back
        let backSwipe = UISwipeGestureRecognizer(target: self, action: Selector(("back")))
        backSwipe.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(backSwipe)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 800
        
        // swipe to go back
        //        let backSwipe = UISwipeGestureRecognizer(target: self, action: "back:")
        //        backSwipe.direction = UISwipeGestureRecognizerDirection.Right
        //        self.view.addGestureRecognizer(backSwipe)
        
        NotificationCenter.default.addObserver(self, selector: #selector(postVC.refresh), name: NSNotification.Name(rawValue: "likedFromPost"), object: nil)
        

        tableView.register(UINib(nibName: "postSelected", bundle: nil), forCellReuseIdentifier: "idPostSelectedCell")
        //tableView.reloadData()
        // dynamic cell heigth
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 800
        // find post
        
        //let r = postuuidArray.last!
        
        //loadPostInfo()
        loadAdditionalInfo(uuid: myPost.uuid!)
        
    }
    func loadAdditionalInfo(uuid : String){
        firebase.child("Posts").child(uuid).queryOrdered(byChild: "date").observe(.value, with: { snapshot in
            
            if snapshot.exists() {
        
                    self.myPost.Layout = ((snapshot.value! as AnyObject).value(forKey:"Layout") as? String)!
                    self.myPost.Finish = ((snapshot.value! as AnyObject).value(forKey:"Finish") as? String)!
                    self.myPost.Month = ((snapshot.value! as AnyObject).value(forKey:"Month") as? String)!
                    self.myPost.Grab = ((snapshot.value! as AnyObject).value(forKey:"Grab") as? String)!
                    self.myPost.Color = ((snapshot.value! as AnyObject).value(forKey:"Color") as? String)!.components(separatedBy: ",")
                self.tableView.reloadData()
                
            }

        }){ (error) in
            print(error.localizedDescription)
        }
    }
    

    
    // refreshing function
    func refresh() {
        self.tableView.reloadData()
    }
    
    

//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return self.view.frame.size.height
//    }
//    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return self.view.frame.size.height
//    }

    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if myPost.Layout != nil{
            return 1
        } else {
            return 0
        }
        
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // define cell
        //let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! postCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "idPostSelectedCell", for: indexPath as IndexPath) as! postCellSelected
        cell.backgroundColor = UIColor(patternImage: UIImage(named: "Background_Blue_Joint.jpg")!)
        //cell.segueDelegate = self
        //cell.backgroundColor = UIColor.clearColor()
        // connect objects with our information from arrays
        cell.delegate = self
        cell.segueDelegate = self
        
        cell.myPost = myPost
        
        
        cell.usernameBtn.setTitle(myPost.NameAuthor, for: UIControlState.normal)
        cell.postAuthorID = myPost.UserID!//usernameArray[indexPath.row]
        
        cell.usernameBtn.sizeToFit()
        cell.uuidLbl.text = myPost.uuid//cell.uuidArray[indexPath.row]
        cell.titleLbl.text = myPost.title//cell.titleArray[indexPath.row]
        cell.titleLbl.sizeToFit()
        cell.usernameHidden.setTitle(myPost.uuid, for: UIControlState.normal)
        cell.LayoutLbl.text = myPost.Layout
        cell.FinishLbl.text = myPost.Finish
        cell.monthLbl.text = myPost.Month
        cell.colorLbl1.text = myPost.Color[0]
        
        //cell.avaImg.loadImageUsingCacheWithUrlString(urlString: thisPost.profUrl!)
        
        cell.ConnectImage.loadImageUsingCacheWithUrlString(urlString: myPost.profUrl!)
        cell.ContactName.text = myPost.NameAuthor
        
        if myPost.uuid == FIRAuth.auth()?.currentUser?.uid {
            cell.ConnectView.isHidden = true
        } else {
            cell.ConnectView.isHidden = false
        }
        
        if myPost.Color.count == 2 {
            cell.colorLbl2.text = myPost.Color[1]
        } else if myPost.Color.count == 3 {
            cell.colorLbl2.text = myPost.Color[1]
            cell.colorLbl3.text = myPost.Color[2]
        }
        
        if myPost.Grab == "Not Available"{
            cell.Flag.isHidden = true
            cell.UFG.isHidden = true
        }

        cell.avaImg.loadImageUsingCacheWithUrlString(urlString: myPost.profUrl!)
        cell.picImg.loadImageUsingCacheWithUrlString(urlString: myPost.photoURL!)
        
        
        // calculate post date
        let from = myPost.date
        let now = NSDate()
        let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfMonth])
        let difference = Date().offset(from: from!)//NSCalendar.current.//dateComponents(components, from: from!, to: now)

        getLikeState(string: cell.uuidLbl.text! , Btn: cell.likeBtn)
        getLikeCount(string: cell.uuidLbl.text! , Lbl : cell.LikeLbl)
        
        
        // asign index
        cell.usernameBtn.layer.setValue(indexPath, forKey: "index")
        //cell.commentBtn.layer.setValue(indexPath, forKey: "index")
        cell.moreBtn.layer.setValue(indexPath, forKey: "index")
        
        return cell
    }
    
    func startChatProt(toUser: String){
        let chatVC = ChatViewController()
        //chatVC.hidesBottomBarWhenPushed = true
        self.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(chatVC, animated: true)
        //chatVC.withUserIDProfPicUrl =
        chatVC.withUserID = toUser
        chatVC.from = "FeedVC"
        chatVC.chatRoomId = startChat(userId1: (FIRAuth.auth()?.currentUser?.uid)!, userId2: toUser)
        //chreatChatroom(withUser: toUser)
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
    
    func goToPost(thisPost : Post!){
        // take relevant unique id of post to load post in postVC
        
        //print (uuid)
        //postuuid.append(uuid)
        
        // present postVC programmaticaly
        let post = self.storyboard?.instantiateViewController(withIdentifier: "postVC") as! postVC
        post.myPost = thisPost
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
