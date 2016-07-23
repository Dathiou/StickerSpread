//
//  homeVC.swift
//  StickerSpread
//
//  Created by Student iMac on 5/27/16.
//  Copyright © 2016 Student iMac. All rights reserved.
//

import UIKit
import Parse
import FBSDKLoginKit
import FirebaseAuth
import Firebase



class homeVC1: UICollectionViewController {
    
    var goHome = false
    var userIdToDisplay = "a"
    
    
    let storage = FIRStorage.storage()
    let storageRef = FIRStorage.storage().referenceForURL("gs://stickerspread-4f3a9.appspot.com")
    
    var youtube = false
    var email = false
    var instagram = false
    var etsy = false
    
    // refresher variable
    var refresher : UIRefreshControl!
    
    // size of page
    var page : Int = 12
    
    // arrays to hold server information
    var uuidArray = [String]()
    //var picArray = [PFFile]()
    
    var usernameArray = [String]()
    //var avaArray = [PFFile]()
    //var avaArrayF = [UIImage]()
    var avaArray = [UIImage]()
    var postpicArraySearch = [PFFile]()
    var nameArray = [String]()
    var nameArraySearch = [String]()
    var dateArray = [NSDate?]()
    var dateArraySearch = [NSDate?]()
    //var picArray = [PFFile]()
    //var picArrayF = [UIImage]()
    var picArray = [UIImage]()
    var picArraySearch = [PFFile]()
    var uuidArraySearch = [String]()
    var titleArray = [String]()
    var urls = [String]()
    //var uuidArray = [String]()
    var bottomheader = CGFloat()
    
    var username = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // always vertical scroll
        self.collectionView?.alwaysBounceVertical = true
        //background
        collectionView?.backgroundColor = .whiteColor()
        
        //title at the top
        //self.navigationItem.title=(PFUser.currentUser()!.objectForKey("first_name") as? String)?.uppercaseString
        
        
        // pull to refresh
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        collectionView?.addSubview(refresher)
        
        //receive notification from uploadVC
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "uploaded:", name: "uploaded", object: nil)
        collectionView!.registerNib(UINib(nibName: "collectionCell", bundle: nil), forCellWithReuseIdentifier: "idCollectionCell")
        
        //        self.collectionView.header.setNeedsUpdateConstraints()
        //        self.collectionView.updateConstraintsIfNeeded()
        //        self.collectionView.setNeedsLayout()
        //        self.collectionView.layoutIfNeeded()
        //        let newHeight = self.collectionView.sec.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        //        //newFrame.size.height = newSize.height
        //        self.collectionView.frame.size.height = 1000
        //self.collectionView.header
        
        
        
        // load posts func
        loadPosts()
    }
    
    
    // refreshing func
    func refresh() {
        
        // reload posts
        //loadPosts()
        collectionView?.reloadData()
        
        // stop refresher animating
        refresher.endRefreshing()
    }
    
    func uploaded(notification: NSNotification){
        loadPosts()
    }
    
    
    
    // load more while scrolling down
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.size.height {
            //loadMore()
        }
    }
    
    
    
    // cell numb
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picArray.count
    }
    
    // cell size
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size = CGSize(width: self.view.frame.size.width / 2, height: self.view.frame.size.width / 2 + 30)
        return size
    }
    
    
    // cell config
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // define cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("idCollectionCell", forIndexPath: indexPath) as! testsearchcell
        cell.backgroundColor = UIColor(patternImage: UIImage(named: "Background_Blue_Joint.jpg")!)
        
        
        getLikeState(uuidArray[indexPath.row] , Btn: cell.likeBtn)
        getLikeCount(uuidArray[indexPath.row] , Lbl : cell.likeLbl)
        
        cell.uuidLbl.text = uuidArray[indexPath.row]
        cell.picImg1.image = picArray[indexPath.row]
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        return CGSize(width: collectionView.frame.width, height: max(20,bottomheader + 5))//self.bottomheader)
    }
    
    
    
    
    
    
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        //define header
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath) as! headerView
        //header.frame.size.height = 100
        // get users data with connections to columns of PFUser class
        
        firebase.child("Users").child(userIdToDisplay).observeEventType(.Value, withBlock: { snapshot in
            
            let first = (snapshot.value!.objectForKey("first_name") as? String)
            let last = (snapshot.value!.objectForKey("last_name") as? String)
            print ( snapshot.key)
            self.username = snapshot.key
            //title at the top
            self.navigationItem.title = first!+" "+last!
            let avaURL = (snapshot.value!.objectForKey("ProfilPicUrl") as! String)
            let url = NSURL(string: avaURL)
            if let data = NSData(contentsOfURL: url!){ //make sure your image in this url does exist, otherwise unwrap in a if let check
                header.avaImg.image = UIImage(data: data)
                header.avaImg.layer.cornerRadius = 4.0
                header.avaImg.clipsToBounds = true
                header.avaImg.layer.borderColor = UIColor.whiteColor().CGColor
                header.avaImg.layer.borderWidth = 0.5
                
            }
            
            
            
            
            let q = snapshot.value!.objectForKey("youtubeURL") as? String
            let w = snapshot.value!.objectForKey("instagramURL") as? String
            let e = snapshot.value!.objectForKey("etsyURL") as? String
            let r = snapshot.value!.objectForKey("emailDisplay") as? String
            var display = 0
            self.urls.removeAll()
            if q != "" {
                self.youtube = true
                display += 1
                self.urls.append(q!)
            }
            if w != "" {
                self.instagram = true
                display += 1
                self.urls.append(w!)
            }
            if e != "" {
                self.etsy = true
                display += 1
                self.urls.append(e!)
            }
            if r != "" {
                self.email = true
                display += 1
                self.urls.append(r!)
            }
            if display == 0 {
                header.first_Lbl.text = ""
                
                header.firstConstr.priority = 750
                self.bottomheader =  header.avaImg.frame.maxY
                
            } else if display == 1 {
                header.firstConstr.priority = 750
                header.first_Lbl.text = self.urls[0]
                self.bottomheader =  header.ic1.frame.maxY
            } else if display == 2{
                header.secondConstr.priority = 750
                header.first_Lbl.text = self.urls[0]
                header.second_Lbl.text = self.urls[1]
                self.bottomheader =  header.ic2.frame.maxY
            } else if display == 3{
                header.thirdConstr.priority = 750
                header.first_Lbl.text = self.urls[0]
                header.second_Lbl.text = self.urls[1]
                header.third_Lbl.text = self.urls[2]
                self.bottomheader =  header.ic3.frame.maxY
            } else if display == 4{
                header.fourthConstr.priority = 750
                header.first_Lbl.text = self.urls[0]
                header.second_Lbl.text = self.urls[1]
                header.third_Lbl.text = self.urls[2]
                header.fourth_Lbl.text = self.urls[3]
                self.bottomheader =  header.ic4.frame.maxY
            }
            
            
            }
            
            
        ){ (error) in
            print(error.localizedDescription)
        }
        
        header.username = self.userIdToDisplay
        
        //        header.setNeedsLayout()
        //        header.layoutIfNeeded()
        //        let height = header.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        //        let a = header.ic1.frame.minY
        //        let b = header.ic1.frame.maxY
        //        print(b)
        header.backgroundColor = UIColor(patternImage: UIImage(named: "Background_Blue_Joint.jpg")!)
        header.frame.size.height = bottomheader + 5
        
        //self.button.setTitle("edit profile", forState: UIControlState.Normal)
        
        if self.goHome == false {
            header.Settingsbutton.hidden = true
            // STEP 2. Show do current user follow guest or do not
            firebase.child("Followings").child((FIRAuth.auth()?.currentUser!.uid)!).child(self.userIdToDisplay).observeEventType(.Value, withBlock: { snapshot in
                if snapshot.exists() {
                    header.followButton.setTitle("FOLLOWING", forState: UIControlState.Normal)
                    header.followButton.backgroundColor = .greenColor()
                }
                else {
                    header.followButton.setTitle("FOLLOW", forState: .Normal)
                    header.followButton.backgroundColor = .lightGrayColor()
                }
                
                
                
            })
            
        } else if self.goHome == true {
            header.followButton.hidden = true
        }
        
        firebase.child("PostPerUser").child(userIdToDisplay).observeEventType(.Value, withBlock: { snapshot in
            if snapshot.exists() {
                
                header.posts.text =  "\(snapshot.childrenCount)"
                
            }
        })
        
        firebase.child("Followers").child(userIdToDisplay).observeEventType(.Value, withBlock: { snapshot in
            if snapshot.exists() {
                header.followers.text =  "\(snapshot.childrenCount)"
            } else {
                header.followers.text = "0"
            }
        })
        
        firebase.child("Followings").child(userIdToDisplay).observeEventType(.Value, withBlock: { snapshot in
            if snapshot.exists() {
                header.followings.text =  "\(snapshot.childrenCount)"
            } else {
                header.followings.text =  "0"
            }
        })
        
        
        
        // STEP 3. Implement tap gestures
        // tap posts
        let postsTap = UITapGestureRecognizer(target: self, action: "postsTap")
        postsTap.numberOfTapsRequired = 1
        header.posts!.userInteractionEnabled = true
        header.posts!.addGestureRecognizer(postsTap)
        
        // tap followers
        let followersTap = UITapGestureRecognizer(target: self, action: "followersTap")
        followersTap.numberOfTapsRequired = 1
        header.followers.userInteractionEnabled = true
        header.followers.addGestureRecognizer(followersTap)
        
        // tap followings
        let followingsTap = UITapGestureRecognizer(target: self, action: "followingsTap")
        followingsTap.numberOfTapsRequired = 1
        header.followings.userInteractionEnabled = true
        header.followings.addGestureRecognizer(followingsTap)
        
        header.sizeToFit()
        
        return header
    }
    
    
    // taped posts label
    func postsTap() {
        if !picArray.isEmpty {
            //let index = NSIndexPath(forItem: 0, inSection: 0)
            //self.collectionView!.scrollToItemAtIndexPath(index, atScrollPosition: UICollectionViewScrollPosition.Bottom, animated: true)
            self.collectionView!.setContentOffset(CGPoint(x: 0, y: bottomheader + 5), animated: true)
        }
    }
    
    // tapped followers label
    func followersTap() {
        
        user = PFUser.currentUser()!.username!
        show = "followers"
        
        // make references to followersVC
        let followers = self.storyboard?.instantiateViewControllerWithIdentifier("followersVC") as! followersVC
        
        // present
        self.navigationController?.pushViewController(followers, animated: true)
    }
    
    // tapped followings label
    func followingsTap() {
        
        user = PFUser.currentUser()!.username!
        show = "followings"
        
        // make reference to followersVC
        let followings = self.storyboard?.instantiateViewControllerWithIdentifier("followersVC") as! followersVC
        
        // present
        self.navigationController?.pushViewController(followings, animated: true)
    }
    
    //clicked logout
    @IBAction func logout(sender: AnyObject) {
        // implement log out
        let loginManager = FBSDKLoginManager()
        loginManager.logOut() // this is an instance function
        print("logged out from FB")
        try! FIRAuth.auth()!.signOut()
        PFUser.logOut()
        let signin = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = signin
        
        //        PFUser.logOutInBackgroundWithBlock { (error:NSError?) -> Void in
        //            if error == nil {
        //
        //                // remove logged in user from App memory
        //                NSUserDefaults.standardUserDefaults().removeObjectForKey("username")
        //                NSUserDefaults.standardUserDefaults().synchronize()
        //
        //                let signin = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        //                let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //                appDelegate.window?.rootViewController = signin
        //
        //            } else
        //            {
        //                print("parse log out failed")
        //            }
        //        }
        
    }
    
    
    // go post
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // send post uuid to "postuuid" variable
        postuuid.append(uuidArray[indexPath.row])
        
        // navigate to post view controller
        let post = self.storyboard?.instantiateViewControllerWithIdentifier("postVC") as! postVC
        self.navigationController?.pushViewController(post, animated: true)
    }
    
    
    
    // load posts
    func loadPosts() {
        
        firebase.child("PostPerUser").child(userIdToDisplay).observeEventType(.Value, withBlock: { snapshot1 in
            print(snapshot1)
            if snapshot1.exists() {
                print(snapshot1)
                for postperUser1 in snapshot1.children{
                    let postperUser = postperUser1 as! FIRDataSnapshot
                    let postID = postperUser.key
                    print (postID)
                    firebase.child("Posts").child(postID as! String).queryOrderedByChild("date").observeEventType(.Value, withBlock: { snapshot in
                        
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
                            let post = snapshot
                            print(post)
                            
                            print(post)
                            let userID = post.value!.objectForKey("userID") as! String
                            self.storage.referenceForURL(post.value!.objectForKey("photoUrl") as! String).dataWithMaxSize(25 * 1024 * 1024, completion: { (data, error) -> Void in
                                let image = UIImage(data: data!)
                                
                                self.picArray.append(image! as! UIImage)
                                self.uuidArray.append(post.key as String!)
                                
                                //objc_sync_exit(self.nameArray)
                                //self.tableView.reloadData()
                                //self.scrollToBottom()
                                firebase.child("Users").child(userID).observeEventType(.Value, withBlock: { snapshot in
                                    
                                    let first = (snapshot.value!.objectForKey("first_name") as? String)
                                    let last = (snapshot.value!.objectForKey("last_name") as? String)
                                    
                                    let fullname = first!+" "+last!
                                    self.nameArray.append(fullname)
                                    //self.tableView.reloadData()
                                    self.collectionView!.reloadData()
                                    let avaURL = (snapshot.value!.objectForKey("ProfilPicUrl") as! String)
                                    let url = NSURL(string: avaURL)
                                    if let data = NSData(contentsOfURL: url!){ //make sure your image in this url does exist, otherwise unwrap in a if let check
                                        self.avaArray.append(UIImage(data: data) as UIImage!)
                                        
                                    }
                                    
                                    //self.comments.append(snapshot)
                                    //self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.comments.count-1, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Automatic)
                                    }
                                    
                                    
                                ){ (error) in
                                    print(error.localizedDescription)
                                }
                                
                                // objc_sync_exit(self.nameArray)
                                
                            })
                            
                            //let datestring = post.value.objectForKey("date") as! String
                            if let datestring = post.value!.objectForKey("date") as? String{
                                var dateFormatter = NSDateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                                let date = dateFormatter.dateFromString(datestring)
                                self.dateArray.append(date)
                            }
                            self.usernameArray.append(userID as! String)
                            
                            self.titleArray.append(post.value!.objectForKey("title") as! String)
                            
                            
                            
                            
                            // dispatch_async(dispatch_get_main_queue(), {
                            //  self.tableView.reloadData()
                            //self.collectionView.reloadData()
                            self.refresher.endRefreshing()
                            // });
                            
                            
                            
                            
                        }
                        
                        
                        //self.comments.append(snapshot)
                        //self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.comments.count-1, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Automatic)
                    })}
            }
        }){ (error) in
            print(error.localizedDescription)
        }
    }
    
    
    
    
    
    
}
