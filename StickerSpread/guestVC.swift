////
////  guestVC.swift
////  StickerSpread
////
////  Created by Student iMac on 6/1/16.
////  Copyright © 2016 Student iMac. All rights reserved.
////
//
//import UIKit
//import Parse
//
//var guestname = [String]()
//var guestfirstname = [String]()
//
//private let reuseIdentifier = "Cell"
//
//class guestVC: UICollectionViewController {
//    
//    
//    // UI objects
//    var refresher : UIRefreshControl!
//    var page : Int = 12
//    
//    // arrays to hold data from server
//    var uuidArray = [String]()
//    var picArray = [PFFile]()
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        
//        // allow vertical scroll
//        self.collectionView!.alwaysBounceVertical = true
//        
//        // backgroung color
//        self.collectionView?.backgroundColor = .whiteColor()
//        
//        // top title
//        self.navigationItem.title = guestfirstname.last?.uppercaseString
//        
//        //title at the top
//      //  self.navigationItem.title=(PFUser.currentUser()!.objectForKey("first_name") as? String)?.uppercaseString
//        
//        // new back button
//        self.navigationItem.hidesBackButton = true
//        let backBtn = UIBarButtonItem(title: "back", style: .Plain, target: self, action: "back:")
//        self.navigationItem.leftBarButtonItem = backBtn
//        
//        // swipe to go back
//        let backSwipe = UISwipeGestureRecognizer(target: self, action: "back:")
//        backSwipe.direction = UISwipeGestureRecognizerDirection.Right
//        self.view.addGestureRecognizer(backSwipe)
//        
//        // pull to refresh
//        refresher = UIRefreshControl()
//        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
//        collectionView?.addSubview(refresher)
//        
//        // call load posts function
//        loadPosts()
//    }
//    
//    // back function
//    func back(sender : UIBarButtonItem) {
//        
//        // push back
//        self.navigationController?.popViewControllerAnimated(true)
//        
//        // clean guest username or deduct the last guest userame from guestname = Array
//        if !guestname.isEmpty {
//            guestname.removeLast()
//         
//            
//        }
//        
//        if !guestfirstname.isEmpty {
//           
//            guestfirstname.removeLast()
//            
//        }
//    }
//    
//    // refresh function
//    func refresh() {
//        refresher.endRefreshing()
//        loadPosts()
//    }
//    
//    
//    // posts loading function
//    func loadPosts() {
//        
//        // load posts
//        let query = PFQuery(className: "posts")
//        query.whereKey("username", equalTo: guestname.last!)
//        query.limit = page
//        query.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) -> Void in
//            if error == nil {
//                
//                // clean up
//                self.uuidArray.removeAll(keepCapacity: false)
//                self.picArray.removeAll(keepCapacity: false)
//                
//                // find related objects
//                for object in objects! {
//                    
//                    // hold found information in arrays
//                    self.uuidArray.append(object.valueForKey("uuid") as! String)
//                    self.picArray.append(object.valueForKey("pic") as! PFFile)
//                }
//                
//                self.collectionView?.reloadData()
//                
//            } else {
//                print(error!.localizedDescription)
//            }
//        })
//        
//    }
//    
//    
//    
//    // load more while scrolling down
//    override func scrollViewDidScroll(scrollView: UIScrollView) {
//        if scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.size.height {
//            loadMore()
//        }
//    }
//    
//    
//    // paging
//    func loadMore() {
//        
//        // if there is more objects
//        if page <= picArray.count {
//            
//            // increase page size
//            page = page + 12
//            
//            // load more posts
//            let query = PFQuery(className: "posts")
//            query.whereKey("username", equalTo: guestname.last!)
//            query.limit = page
//            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
//                if error == nil {
//                    
//                    // clean up
//                    self.uuidArray.removeAll(keepCapacity: false)
//                    self.picArray.removeAll(keepCapacity: false)
//                    
//                    // find related objects
//                    for object in objects! {
//                        self.uuidArray.append(object.valueForKey("uuid") as! String)
//                        self.picArray.append(object.valueForKey("pic") as! PFFile)
//                    }
//                    
//                    self.collectionView?.reloadData()
//                    
//                } else {
//                    print(error?.localizedDescription)
//                }
//            })
//            
//        }
//        
//    }
//    
//    // cell numb
//    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return picArray.count
//    }
//    
//    // cell size
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        let size = CGSize(width: self.view.frame.size.width / 3, height: self.view.frame.size.width / 3)
//        return size
//    }
//    
//    // cell config
//    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        
//        // define cell
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! pictureCell
//        
//        // connect data from array to picImg object from pictureCell class
//        picArray[indexPath.row].getDataInBackgroundWithBlock ({ (data:NSData?, error:NSError?) -> Void in
//            if error == nil {
//                cell.picImg.image = UIImage(data: data!)
//            } else {
//                print(error!.localizedDescription)
//            }
//        })
//        
//        return cell
//    }
//    
//    
//    
//    // header config
//    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        
//        // define header
//        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath) as! headerView
//        
//        
//        // STEP 1. Load data of guest
//        let infoQuery = PFQuery(className: "_User")
//        infoQuery.whereKey("username", equalTo: guestname.last!)
//        infoQuery.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) -> Void in
//            if error == nil {
//                
//                // shown wrong user
//                if objects!.isEmpty {
//                    // call alert
//                    let alert = UIAlertController(title: "\(guestname.last!.uppercaseString)", message: "is not existing", preferredStyle: UIAlertControllerStyle.Alert)
//                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
//                        self.navigationController?.popViewControllerAnimated(true)
//                    })
//                    alert.addAction(ok)
//                    self.presentViewController(alert, animated: true, completion: nil)
//                }
//                
//                // find related to user information
//                for object in objects! {
//                    
//                    
//                    
//                    // get users data with connections to columns of PFUser class
//                    let first = (object.objectForKey("first_name") as? String)?.uppercaseString
//                    let last = (object.objectForKey("last_name") as? String)?.uppercaseString
//                    
////                    header.fullnameLbl.text = first!+" "+last!
////                    
////                    if let web = object.objectForKey("web") as? String {
////                        header.webTxt.text = web
////                        header.webTxt.sizeToFit()
////                    }
////                    
////                    if let bio = object.objectForKey("bio") as? String {
////                        header.bioLbl.text = bio
////                        header.bioLbl.sizeToFit()
////                    }
////                    
//                    
//                    let avaQuery = object.objectForKey("picture_file") as! PFFile
//                    avaQuery.getDataInBackgroundWithBlock {(data:NSData?, error:NSError?) -> Void in
//                        header.avaImg.image = UIImage(data:data!)
//                    }
////                    header.button.setTitle("edit profile", forState: UIControlState.Normal)
////
////                    
////                    
////                    
////                    header.fullnameLbl.text = (object.objectForKey("fullname") as? String)?.uppercaseString
////                    header.bioLbl.text = object.objectForKey("bio") as? String
////                    header.bioLbl.sizeToFit()
////                    header.webTxt.text = object.objectForKey("web") as? String
////                    header.webTxt.sizeToFit()
////                    let avaFile : PFFile = (object.objectForKey("picture_file") as? PFFile)!
////                    avaFile.getDataInBackgroundWithBlock({ (data:NSData?, error:NSError?) -> Void in
////                        header.avaImg.image = UIImage(data: data!)
////                    })
//                }
//                
//            } else {
//                print(error?.localizedDescription)
//            }
//        })
//        
//        
//        // STEP 2. Show do current user follow guest or do not
//        let followQuery = PFQuery(className: "follow")
//        followQuery.whereKey("follower", equalTo: PFUser.currentUser()!.username!)
//        followQuery.whereKey("following", equalTo: guestname.last!)
//        followQuery.countObjectsInBackgroundWithBlock ({ (count:Int32, error:NSError?) -> Void in
//            if error == nil {
//                if count == 0 {
//                    header.button.setTitle("FOLLOW", forState: .Normal)
//                    header.button.backgroundColor = .lightGrayColor()
//                } else {
//                    header.button.setTitle("FOLLOWING", forState: UIControlState.Normal)
//                    header.button.backgroundColor = .greenColor()
//                }
//            } else {
//                print(error?.localizedDescription)
//            }
//        })
//        
//        
//        // STEP 3. Count statistics
//        // count posts
//        let posts = PFQuery(className: "posts")
//        posts.whereKey("username", equalTo: guestname.last!)
//        posts.countObjectsInBackgroundWithBlock ({ (count:Int32, error:NSError?) -> Void in
//            if error == nil {
//                header.posts.text = "\(count)"
//            } else {
//                print(error?.localizedDescription)
//            }
//        })
//        
//        // count followers
//        let followers = PFQuery(className: "follow")
//        followers.whereKey("following", equalTo: guestname.last!)
//        followers.countObjectsInBackgroundWithBlock ({ (count:Int32, error:NSError?) -> Void in
//            if error == nil {
//                header.followers.text = "\(count)"
//            } else {
//                print(error?.localizedDescription)
//            }
//        })
//        
//        // count followings
//        let followings = PFQuery(className: "follow")
//        followings.whereKey("follower", equalTo: guestname.last!)
//        followings.countObjectsInBackgroundWithBlock ({ (count:Int32, error:NSError?) -> Void in
//            if error == nil {
//                header.followings.text = "\(count)"
//            } else {
//                print(error?.localizedDescription)
//            }
//        })
//        
//        
//        // STEP 4. Implement tap gestures
//        // tap to posts label
//        let postsTap = UITapGestureRecognizer(target: self, action: "postsTap")
//        postsTap.numberOfTapsRequired = 1
//        header.posts.userInteractionEnabled = true
//        header.posts.addGestureRecognizer(postsTap)
//        
//        // tap to followers label
//        let followersTap = UITapGestureRecognizer(target: self, action: "followersTap")
//        followersTap.numberOfTapsRequired = 1
//        header.followers.userInteractionEnabled = true
//        header.followers.addGestureRecognizer(followersTap)
//        
//        // tap to followings label
//        let followingsTap = UITapGestureRecognizer(target: self, action: "followingsTap")
//        followingsTap.numberOfTapsRequired = 1
//        header.followings.userInteractionEnabled = true
//        header.followings.addGestureRecognizer(followingsTap)
//        
//        
//        return header
//    }
//    
//    // tapped posts label
//    func postsTap() {
//        if !picArray.isEmpty {
//            let index = NSIndexPath(forItem: 0, inSection: 0)
//            self.collectionView?.scrollToItemAtIndexPath(index, atScrollPosition: UICollectionViewScrollPosition.Top, animated: true)
//        }
//    }
//    
//    // tapped followers label
//    func followersTap() {
//        user = guestname.last!
//        show = "followers"
//        
//        // defind followersVC
//        let followers = self.storyboard?.instantiateViewControllerWithIdentifier("followersVC") as! followersVC
//        
//        // navigate to it
//        self.navigationController?.pushViewController(followers, animated: true)
//        
//    }
//    
//    // tapped followings label
//    func followingsTap() {
//        user = guestname.last!
//        show = "followings"
//        
//        // define followersVC
//        let followings = self.storyboard?.instantiateViewControllerWithIdentifier("followersVC") as! followersVC
//        
//        // navigate to it
//        self.navigationController?.pushViewController(followings, animated: true)
//        
//    }
//    
//    // go post
//    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        
//        // send post uuid to "postuuid" variable
//        postuuid.append(uuidArray[indexPath.row])
//        
//        // navigate to post view controller
//        let post = self.storyboard?.instantiateViewControllerWithIdentifier("postVC") as! postVC
//        self.navigationController?.pushViewController(post, animated: true)
//    }
//    
//    
//
//    
//}
