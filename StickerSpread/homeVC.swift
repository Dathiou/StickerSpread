////
////  homeVC.swift
////  StickerSpread
////
////  Created by Student iMac on 5/27/16.
////  Copyright © 2016 Student iMac. All rights reserved.
////
//
//import UIKit
//import Parse
//import FBSDKLoginKit
//import FirebaseAuth
//import Firebase
//
//
//
//
//class homeVC: UIViewController /*, UITableViewDelegate, UITableViewDataSource */,UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
//    
//    let storage = FIRStorage.storage()
//    let storageRef = FIRStorage.storage().referenceForURL("gs://stickerspread-4f3a9.appspot.com")
//    
//    
//    @IBOutlet weak var firstConstr: NSLayoutConstraint!
//    @IBOutlet weak var secondConstr: NSLayoutConstraint!
//    @IBOutlet weak var thirdConstr: NSLayoutConstraint!
//    @IBOutlet weak var fourthConstr: NSLayoutConstraint!
//    
//    @IBOutlet weak var avaImg: UIImageView!
//    
//    @IBOutlet weak var instaImage: UIImageView!
//    
//    
//    
//    
//    @IBOutlet weak var first_Lbl: UILabel!
//    @IBOutlet weak var second_Lbl: UILabel!
//    @IBOutlet weak var third_Lbl: UILabel!
//    @IBOutlet weak var fourth_Lbl: UILabel!
//    
//    @IBOutlet weak var posts: UILabel!
//    @IBOutlet weak var followers: UILabel!
//    @IBOutlet weak var followings: UILabel!
//    
//    @IBOutlet weak var postsTitle: UILabel!
//    @IBOutlet weak var followersTitle: UILabel!
//    @IBOutlet weak var followingsTitle: UILabel!
//    
//    @IBOutlet weak var button: UIButton!
//    
//    
//    var youtube = false
//    var email = false
//    var instagram = false
//    var etsy = false
//    
//    
//    // refresher variable
//    var refresher : UIRefreshControl!
//    
//    // size of page
//    var page : Int = 12
//    
//    // arrays to hold server information
//    var uuidArray = [String]()
//    //var picArray = [PFFile]()
//    
//    var usernameArray = [String]()
//    //var avaArray = [PFFile]()
//    //var avaArrayF = [UIImage]()
//    var avaArray = [UIImage]()
//    var postpicArraySearch = [PFFile]()
//    var nameArray = [String]()
//    var nameArraySearch = [String]()
//    var dateArray = [NSDate?]()
//    var dateArraySearch = [NSDate?]()
//    //var picArray = [PFFile]()
//    //var picArrayF = [UIImage]()
//    var picArray = [UIImage]()
//    var picArraySearch = [PFFile]()
//    var uuidArraySearch = [String]()
//    var titleArray = [String]()
//    var urls = [String]()
//    //var uuidArray = [String]()
//    
//    @IBOutlet weak var collectionView: UICollectionView!
//    
//    
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        
//   
//        loadData()
//collectionViewLaunch()
//        collectionView.registerNib(UINib(nibName: "collectionCell", bundle: nil), forCellWithReuseIdentifier: "idCollectionCell")
//        loadPosts()
//        
//        
//        
//        // always vertical scroll
//        collectionView?.alwaysBounceVertical = true
////background
//        collectionView?.backgroundColor = .whiteColor()
//        
// 
//
//        
//        // pull to refresh
//        refresher = UIRefreshControl()
//        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
//        collectionView?.addSubview(refresher)
//        
//        //receive notification from uploadVC
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "uploaded:", name: "uploaded", object: nil)
//        
//        // load posts func
//        
//    }
//    
//    
//    // refreshing func
//    func refresh() {
//        
//        // reload posts
//        //loadPosts()
//        collectionView?.reloadData()
//        
//        // stop refresher animating
//        refresher.endRefreshing()
//    }
//    
//    func uploaded(notification: NSNotification){
//        loadPosts()
//    }
//    
////    
////    // load posts func
////    func loadPosts() {
////        
////        // request infomration from server
////        let query = PFQuery(className: "posts")
////        query.whereKey("username", equalTo: PFUser.currentUser()!.username!)
////        query.limit = page
////        query.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) -> Void in
////            if error == nil {
////                
////                // clean up
////                self.uuidArray.removeAll(keepCapacity: false)
////                self.picArray.removeAll(keepCapacity: false)
////                
////                // find objects related to our request
////                for object in objects! {
////                    
////                    // add found data to arrays (holders)
////                    self.uuidArray.append(object.valueForKey("uuid") as! String)
////                    self.picArray.append(object.valueForKey("pic") as! PFFile)
////                }
////                self.collectionView?.reloadData()
////            } else {
////                print(error!.localizedDescription)
////            }
////        })
////    }
////    
//    
////    // load more while scrolling down
////    override func scrollViewDidScroll(scrollView: UIScrollView) {
////        if scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.size.height {
////            loadMore()
////        }
////    }
//    
////    
////    // paging
////    func loadMore() {
////        
////        // if there is more objects
////        if page <= picArray.count {
////            
////            // increase page size
////            page = page + 12
////            
////            // load more posts
////            let query = PFQuery(className: "posts")
////            query.whereKey("username", equalTo: PFUser.currentUser()!.username!)
////            query.limit = page
////            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
////                if error == nil {
////                    
////                    // clean up
////                    self.uuidArray.removeAll(keepCapacity: false)
////                    self.picArray.removeAll(keepCapacity: false)
////                    
////                    // find related objects
////                    for object in objects! {
////                        self.uuidArray.append(object.valueForKey("uuid") as! String)
////                        self.picArray.append(object.valueForKey("pic") as! PFFile)
////                    }
////                    
////                    self.collectionView?.reloadData()
////                    
////                } else {
////                    print(error?.localizedDescription)
////                }
////            })
////            
////        }
////        
////    }
//    
//    
//    
//    
//    
//    
//    // load posts
//    func loadPosts() {
//
//        firebase.child("PostPerUser").child((FIRAuth.auth()?.currentUser?.uid)!).observeEventType(.Value, withBlock: { snapshot1 in
//            
//            if snapshot1.exists() {
//                print(snapshot1)
//                for postperUser1 in snapshot1.children{
//                    let postperUser = postperUser1 as! FIRDataSnapshot
//                    let postID = postperUser.key
//                    print (postID)
//        firebase.child("Posts").child(postID as! String).queryOrderedByChild("date").observeEventType(.Value, withBlock: { snapshot in
//            
//            // clean up
//            self.usernameArray.removeAll(keepCapacity: false)
//            self.nameArray.removeAll(keepCapacity: false)
//            self.avaArray.removeAll(keepCapacity: false)
//            self.dateArray.removeAll(keepCapacity: false)
//            self.picArray.removeAll(keepCapacity: false)
//            //self.picArraySearch.removeAll(keepCapacity: false)
//            self.titleArray.removeAll(keepCapacity: false)
//            self.uuidArray.removeAll(keepCapacity: false)
//            
//            if snapshot.exists() {
//                let post = snapshot
//                print(post)
//                
//                    print(post)
//                    let userID = post.value!.objectForKey("userID") as! String
//                    self.storage.referenceForURL(post.value!.objectForKey("photoUrl") as! String).dataWithMaxSize(25 * 1024 * 1024, completion: { (data, error) -> Void in
//                        let image = UIImage(data: data!)
//  
//                        self.picArray.append(image! as! UIImage)
//                        self.uuidArray.append(post.key as String!)
//                        
//                        //objc_sync_exit(self.nameArray)
//                        //self.tableView.reloadData()
//                        //self.scrollToBottom()
//                        firebase.child("Users").child(userID).observeEventType(.Value, withBlock: { snapshot in
//                            
//                            let first = (snapshot.value!.objectForKey("first_name") as? String)
//                            let last = (snapshot.value!.objectForKey("last_name") as? String)
//                            
//                            let fullname = first!+" "+last!
//                            self.nameArray.append(fullname)
//                           //self.tableView.reloadData()
//                           self.collectionView.reloadData()
//                            let avaURL = (snapshot.value!.objectForKey("ProfilPicUrl") as! String)
//                            let url = NSURL(string: avaURL)
//                            if let data = NSData(contentsOfURL: url!){ //make sure your image in this url does exist, otherwise unwrap in a if let check
//                                self.avaArray.append(UIImage(data: data) as UIImage!)
//                                
//                            }
//                            
//                            //self.comments.append(snapshot)
//                            //self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.comments.count-1, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Automatic)
//                            }
//                            
//                            
//                        ){ (error) in
//                            print(error.localizedDescription)
//                        }
//                        
//                        // objc_sync_exit(self.nameArray)
//                        
//                    })
//                    
//                    //let datestring = post.value.objectForKey("date") as! String
//                    if let datestring = post.value!.objectForKey("date") as? String{
//                        var dateFormatter = NSDateFormatter()
//                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
//                        let date = dateFormatter.dateFromString(datestring)
//                        self.dateArray.append(date)
//                    }
//                    self.usernameArray.append(userID as! String)
//                    
//                    self.titleArray.append(post.value!.objectForKey("title") as! String)
//                    
//                    
//                    
//                    
//                    // dispatch_async(dispatch_get_main_queue(), {
//                    //  self.tableView.reloadData()
//                    //self.collectionView.reloadData()
//                    self.refresher.endRefreshing()
//                    // });
//                    
//                    
//                    
//                    
//                }
//
//            
//            //self.comments.append(snapshot)
//            //self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.comments.count-1, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Automatic)
//                })}
//            }
//        }){ (error) in
//            print(error.localizedDescription)
//        }
//    }
//    
//    
//    
//    
//    // cell numb
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return picArray.count
//    }
//    
//    // cell size
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        let size = CGSize(width: UIScreen.mainScreen().bounds.width/2 , height: UIScreen.mainScreen().bounds.width/2 + 35)//self.view.frame.size.width / 2, height: self.view.frame.size.width / 2)
//        return size
//    }
//    
//    // cell config
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        
//        // define cell
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("idCollectionCell", forIndexPath: indexPath) as! testsearchcell
//        cell.backgroundColor = UIColor(patternImage: UIImage(named: "Background_Blue_Joint.jpg")!)
//        
//        
//        getLikeState(uuidArray[indexPath.row] , Btn: cell.likeBtn)
//        getLikeCount(uuidArray[indexPath.row] , Lbl : cell.likeLbl)
//        
//        cell.uuidLbl.text = uuidArray[indexPath.row]
//        
//        
//        
//        //let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellSearch", forIndexPath: indexPath) as! testsearchcell
//       // cell.frame.size.width = UIScreen.mainScreen().bounds.width/2 - 20
////        // get picture from the picArray
////        picArray[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
////            if error == nil {
////                cell.picImg.image = UIImage(data: data!)
////            } else {
////                print(error!.localizedDescription)
////            }
//        
//        
//            cell.picImg1.image = picArray[indexPath.row]
//       // }
//        
//        return cell
//    }
//    
//    func loadData(){
//        firebase.child("Users").child((FIRAuth.auth()?.currentUser!.uid)!).observeEventType(.Value, withBlock: { snapshot in
//            
//            let first = (snapshot.value!.objectForKey("first_name") as? String)
//            let last = (snapshot.value!.objectForKey("last_name") as? String)
//            
//            //title at the top
//            self.navigationItem.title = first!+" "+last!
//            let avaURL = (snapshot.value!.objectForKey("ProfilPicUrl") as! String)
//            let url = NSURL(string: avaURL)
//            if let data = NSData(contentsOfURL: url!){ //make sure your image in this url does exist, otherwise unwrap in a if let check
//                self.avaImg.image = UIImage(data: data)
//                self.avaImg.layer.cornerRadius = 4.0
//                self.avaImg.clipsToBounds = true
//                self.avaImg.layer.borderColor = UIColor.whiteColor().CGColor
//                self.avaImg.layer.borderWidth = 0.5
//                
//            }
//            
//            let q = snapshot.value!.objectForKey("youtubeURL") as? String
//            let w = snapshot.value!.objectForKey("instagramURL") as? String
//            let e = snapshot.value!.objectForKey("etsyURL") as? String
//            let r = snapshot.value!.objectForKey("emailDisplay") as? String
//            var display = 0
//            if q != "" {
//                self.youtube = true
//                display += 1
//                self.urls.append(q!)
//            }
//            if w != "" {
//                self.instagram = true
//                display += 1
//                self.urls.append(w!)
//            }
//            if e != "" {
//                self.etsy = true
//                display += 1
//                self.urls.append(e!)
//            }
//            if r != "" {
//                self.email = true
//                display += 1
//                self.urls.append(r!)
//            }
//            if display == 0 {
//                                    self.first_Lbl.text = ""
//                                    self.instaImage.image = nil
//                
//            } else if display == 1 {
//                self.firstConstr.priority = 750
//                self.first_Lbl.text = self.urls[0]
//            } else if display == 2{
//                self.secondConstr.priority = 750
//                self.first_Lbl.text = self.urls[0]
//                self.second_Lbl.text = self.urls[1]
//            } else if display == 3{
//                self.thirdConstr.priority = 750
//                self.first_Lbl.text = self.urls[0]
//                self.second_Lbl.text = self.urls[1]
//                self.third_Lbl.text = self.urls[2]
//            } else if display == 4{
//                self.fourthConstr.priority = 750
//                self.first_Lbl.text = self.urls[0]
//                self.second_Lbl.text = self.urls[1]
//                self.third_Lbl.text = self.urls[2]
//                self.fourth_Lbl.text = self.urls[3]
//            }
//            
////            self.instaLbl.text = snapshot.value!.objectForKey("instagramURL") as! String
////            self.youtubeLbl.text = snapshot.value!.objectForKey("youtubeURL") as? String
////            self.etsyLbl.text = snapshot.value!.objectForKey("etsyURL") as! String
////            self.emailLbl.text = snapshot.value!.objectForKey("email") as! String
//            
////            if let a = snapshot.value!.objectForKey("instagramURL") {
////                if a as! String == "" {
////                    self.instaLbl = nil
////                    self.instaImage.image = nil
////                    
////                   // self.headerConstr.secondItem = self.youtubeLbl
////                }
////            }
//            
////            var imageViewObject :UIImageView
////            imageViewObject = UIImageView(frame:CGRectMake(0, 0, 30, 30));
////            imageViewObject.image = UIImage(named:"Heart 2.png")
////            self.view.addSubview(imageViewObject)
//            
//            
//            
//            
//            
//            
//            
//            
//            }
//            
//            
//        ){ (error) in
//            print(error.localizedDescription)
//        }
//        
////                let url = NSURL(string: avaURL)
////        if let data = NSData(contentsOfURL: url!){ //make sure your image in this url does exist, otherwise unwrap in a if let check
////            //self.avaArray.append(UIImage(data: data) as UIImage!)
////            avaImg.image = UIImage(data: data) as UIImage!
////            
////        }
//        
////        let avaQuery = PFUser.currentUser()?.objectForKey("picture_file") as! PFFile
////        avaQuery.getDataInBackgroundWithBlock {(data:NSData?, error:NSError?) -> Void in
////            avaImg.image = UIImage(data:data!)
////        }
//        
//
//        //self.button.setTitle("edit profile", forState: UIControlState.Normal)
//
//        firebase.child("PostPerUser").child((FIRAuth.auth()?.currentUser!.uid)!).observeEventType(.Value, withBlock: { snapshot in
//            if snapshot.exists() {
//                
//                self.posts.text =  "\(snapshot.childrenCount)"
//                
//            }
//        })
//        
//
//        
//        firebase.child("Followers").child((FIRAuth.auth()?.currentUser!.uid)!).observeEventType(.Value, withBlock: { snapshot in
//            if snapshot.exists() {
//                self.followers.text =  "\(snapshot.childrenCount)"
//            }
//        })
//        
//        firebase.child("Followings").child((FIRAuth.auth()?.currentUser!.uid)!).observeEventType(.Value, withBlock: { snapshot in
//            if snapshot.exists() {
//                self.followings.text =  "\(snapshot.childrenCount)"
//            }
//        })
//        
//        // STEP 3. Implement tap gestures
//        // tap posts
//        let postsTap = UITapGestureRecognizer(target: self, action: "postsTap")
//        postsTap.numberOfTapsRequired = 1
//        posts!.userInteractionEnabled = true
//        posts!.addGestureRecognizer(postsTap)
//        
//        // tap followers
//        let followersTap = UITapGestureRecognizer(target: self, action: "followersTap")
//        followersTap.numberOfTapsRequired = 1
//        followers.userInteractionEnabled = true
//        followers.addGestureRecognizer(followersTap)
//        
//        // tap followings
//        let followingsTap = UITapGestureRecognizer(target: self, action: "followingsTap")
//        followingsTap.numberOfTapsRequired = 1
//        followings.userInteractionEnabled = true
//        followings.addGestureRecognizer(followingsTap)
//    }
//    
//    // cell line spasing
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
//        return 0
//    }
//    
//    // cell inter spasing
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
//        return 0
//    }
//    
////    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
////        return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
////    }
//    
//    
////    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
////        //define header
////        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath) as! headerView
////        
////       
////            //let image = UIImage(data: data!)
////            
////            // objc_sync_enter(self.nameArray)
////            // objc_sync_enter(self.nameArray)
////           // self.picArray.append(image! as! UIImage)
////            
////            //objc_sync_exit(self.nameArray)
////            //self.tableView.reloadData()
////            //self.scrollToBottom()
////            firebase.child("Users").child((FIRAuth.auth()?.currentUser!.uid)!).observeEventType(.Value, withBlock: { snapshot in
////                
////                let first = (snapshot.value!.objectForKey("first_name") as? String)
////                let last = (snapshot.value!.objectForKey("last_name") as? String)
////                
////                //header.fullnameLbl.text  = first!+" "+last!
////         
////                let avaURL = (snapshot.value!.objectForKey("ProfilPicUrl") as! String)
////                let url = NSURL(string: avaURL)
////                if let data = NSData(contentsOfURL: url!){ //make sure your image in this url does exist, otherwise unwrap in a if let check
////                    header.avaImg.image = UIImage(data: data)
////                    
////                }
////
////                }
////                
////                
////            ){ (error) in
////                print(error.localizedDescription)
////            }
////       
////        
////        
////
////        
//////        if let web = PFUser.currentUser()?.objectForKey("web") as? String {
//////            header.webTxt.text = web
//////            header.webTxt.sizeToFit()
//////        }
//////        
//////        if let bio = PFUser.currentUser()?.objectForKey("bio") as? String {
//////            header.bioLbl.text = bio
//////            header.bioLbl.sizeToFit()
//////        }
////     
////        
////        let avaQuery = PFUser.currentUser()?.objectForKey("picture_file") as! PFFile
////        avaQuery.getDataInBackgroundWithBlock {(data:NSData?, error:NSError?) -> Void in
////            header.avaImg.image = UIImage(data:data!)
////        }
////        header.button.setTitle("edit profile", forState: UIControlState.Normal)
////
////        
////        // STEP 2. Count statistics
////        // count total posts
//////        let posts = PFQuery(className: "posts")
//////        posts.whereKey("username", equalTo: PFUser.currentUser()!.username!)
//////        posts.countObjectsInBackgroundWithBlock ({ (count:Int32, error:NSError?) -> Void in
//////            if error == nil {
//////                header.posts.text = "\(count)"
//////            }
//////        })
////        
////        
////        
////        firebase.child("LikesPerUser").child((FIRAuth.auth()?.currentUser!.uid)!).observeEventType(.Value, withBlock: { snapshot in
////            if snapshot.exists() {
////                
////                self.posts.text =  "\(snapshot.childrenCount)"
////                
////            }
////        })
////        
////        
////        // count total followers
//////        let followers = PFQuery(className: "follow")
//////        followers.whereKey("following", equalTo: PFUser.currentUser()!.username!)
//////        followers.countObjectsInBackgroundWithBlock ({ (count:Int32, error:NSError?) -> Void in
//////            if error == nil {
//////                header.followers.text = "\(count)"
//////            }
//////        })
////        
////        firebase.child("Followers").child((FIRAuth.auth()?.currentUser!.uid)!).observeEventType(.Value, withBlock: { snapshot in
////            if snapshot.exists() {
////                header.followers.text =  "\(snapshot.childrenCount)"
////            }
////        })
////        
////        
////        
////        // count total followings
//////        let followings = PFQuery(className: "follow")
//////        followings.whereKey("follower", equalTo: PFUser.currentUser()!.username!)
//////        followings.countObjectsInBackgroundWithBlock ({ (count:Int32, error:NSError?) -> Void in
//////            if error == nil {
//////                header.followings.text = "\(count)"
//////            }
//////        })
////        
////        firebase.child("Followings").child((FIRAuth.auth()?.currentUser!.uid)!).observeEventType(.Value, withBlock: { snapshot in
////            if snapshot.exists() {
////                header.followings.text =  "\(snapshot.childrenCount)"
////            }
////        })
////
////        // STEP 3. Implement tap gestures
////        // tap posts
////        let postsTap = UITapGestureRecognizer(target: self, action: "postsTap")
////        postsTap.numberOfTapsRequired = 1
////        header.posts.userInteractionEnabled = true
////        header.posts.addGestureRecognizer(postsTap)
////        
////        // tap followers
////        let followersTap = UITapGestureRecognizer(target: self, action: "followersTap")
////        followersTap.numberOfTapsRequired = 1
////        header.followers.userInteractionEnabled = true
////        header.followers.addGestureRecognizer(followersTap)
////        
////        // tap followings
////        let followingsTap = UITapGestureRecognizer(target: self, action: "followingsTap")
////        followingsTap.numberOfTapsRequired = 1
////        header.followings.userInteractionEnabled = true
////        header.followings.addGestureRecognizer(followingsTap)
////        
////        
////        return header
////    }
//    
//    
//    // taped posts label
//    func postsTap() {
//        if !picArray.isEmpty {
//            let index = NSIndexPath(forItem: 0, inSection: 0)
//            self.collectionView?.scrollToItemAtIndexPath(index, atScrollPosition: UICollectionViewScrollPosition.Top, animated: true)
//        }
//    }
//    
//    // tapped followers label
//    func followersTap() {
//        
//        user = (FIRAuth.auth()?.currentUser!.uid)!
//        show = "followers"
//        
//        // make references to followersVC
//        let followers = self.storyboard?.instantiateViewControllerWithIdentifier("followersVC") as! followersVC
//        
//        // present
//        self.navigationController?.pushViewController(followers, animated: true)
//    }
//    
//    // tapped followings label
//    func followingsTap() {
//        
//        user = (FIRAuth.auth()?.currentUser!.uid)!
//        show = "followings"
//        
//        // make reference to followersVC
//        let followings = self.storyboard?.instantiateViewControllerWithIdentifier("followersVC") as! followersVC
//        
//        // present
//        self.navigationController?.pushViewController(followings, animated: true)
//    }
//
//    //clicked logout
//    @IBAction func logout(sender: AnyObject) {
//        // implement log out
//        let loginManager = FBSDKLoginManager()
//        loginManager.logOut() // this is an instance function
//        print("logged out from FB")
//        try! FIRAuth.auth()!.signOut()
//        PFUser.logOut()
//        let signin = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
//        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        appDelegate.window?.rootViewController = signin
//        
////        PFUser.logOutInBackgroundWithBlock { (error:NSError?) -> Void in
////            if error == nil {
////                
////                // remove logged in user from App memory
////                NSUserDefaults.standardUserDefaults().removeObjectForKey("username")
////                NSUserDefaults.standardUserDefaults().synchronize()
////                
////                let signin = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
////                let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
////                appDelegate.window?.rootViewController = signin
////                
////            } else
////            {
////                print("parse log out failed")
////            }
////        }
//        
//    }
//    
//    
//    // go post
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        
//        // send post uuid to "postuuid" variable
//        postuuid.append(uuidArray[indexPath.row])
//        
//        // navigate to post view controller
//        let post = self.storyboard?.instantiateViewControllerWithIdentifier("postVC") as! postVC
//        self.navigationController?.pushViewController(post, animated: true)
//    }
//    
//    @IBAction func settingsBtn_clicked(sender: AnyObject) {
//        
//        
//    }
//    
//    
//    // COLLECTION VIEW CODE
//    func collectionViewLaunch() {
//        
////                // layout of collectionView
////                let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
////        
////                // item size
////                layout.estimatedItemSize = CGSizeMake(UIScreen.mainScreen().bounds.width / 2, self.view.frame.size.width)
////          collectionView.setCollectionViewLayout(layout, animated: true)
//        //
//        //        // direction of scrolling
//        //        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
//        //
//        //        layout.minimumInteritemSpacing = 0
//        //        layout.minimumLineSpacing = 0
//        // define frame of collectionView
//        //let frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+10000)
//        //let frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.tabBarController!.tabBar.frame.size.height - self.navigationController!.navigationBar.frame.size.height - 20)
//        
//        // declare collectionView
//        //collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
//       
//        //collectionView.siz
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.alwaysBounceVertical = true
//        collectionView.backgroundColor = .whiteColor()
//        //collectionView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - self.tabBarController!.tabBar.frame.size.height - self.navigationController!.navigationBar.frame.size.height - 20)
//        //collectionView.la
//        //collectionView.contentSize = CGSizeMake(self.view.frame.size.width / 2, self.view.frame.size.width / 2+25)
//        //collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.tabBarController!.tabBar.frame.size.height - self.navigationController!.navigationBar.frame.size.height - 20)
//        self.view.addSubview(collectionView)
//        
//        // define cell for collectionView
//        //collectionView.registerClass(searchCollCell.self, forCellWithReuseIdentifier: "Cellsearch")
//        
//        // call function to load posts
//        //loadPostsforColl()
//    }
//   
//  
//}
