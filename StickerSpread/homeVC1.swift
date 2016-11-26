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

class homeVC1: UICollectionViewController,SegueColl {
    
    var goHome = false
    var userIdToDisplay = "a"

    let storage = FIRStorage.storage()
    let storageRef = FIRStorage.storage().reference(forURL: "gs://stickerspread-4f3a9.appspot.com")
    
    var youtube = false
    var email = false
    var instagram = false
    var etsy = false
    var posts = [Post]()
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
    var UFGArray = [String]()
    var URLarray = [String]()
    var username = String()
    
    var avaUrl = String()
    var fullname = String()
    
    
    var myDictionaryURL = [Int: String]()
    var myDictionaryImage = [Int: UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if TriggeredFromTab == true {
            userIdToDisplay = userfromTabbar
            TriggeredFromTab = false
            self.goHome = true
        }

       
        
        // always vertical scroll
        self.collectionView?.alwaysBounceVertical = true
        //background
        collectionView?.backgroundColor = .white

        NotificationCenter.default.addObserver(self, selector: #selector(homeVC1.refreshLikes(_:)), name: NSNotification.Name(rawValue: "likedFromHome"), object: nil)
        
        // pull to refresh
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(homeVC1.refresh), for: UIControlEvents.valueChanged)
        collectionView?.addSubview(refresher)
        
        //receive notification from uploadVC
        NotificationCenter.default.addObserver(self, selector: "uploaded:", name: NSNotification.Name(rawValue: "uploaded"), object: nil)
        
        collectionView!.register(UINib(nibName: "collectionCell", bundle: nil), forCellWithReuseIdentifier: "idCollectionCell")
        
        //        self.collectionView.header.setNeedsUpdateConstraints()
        //        self.collectionView.updateConstraintsIfNeeded()
        //        self.collectionView.setNeedsLayout()
        //        self.collectionView.layoutIfNeeded()
        //        let newHeight = self.collectionView.sec.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        //        //newFrame.size.height = newSize.height
        //        self.collectionView.frame.size.height = 1000
        //self.collectionView.header
        
        
        
        // load posts func
        //loadPosts()
        loadpostsNew()
    }
    
    
    
    func refreshLikes(_ notification: NSNotification) {

        if let row = notification.object as? Int {
            
            let indexPath = NSIndexPath(row: row, section: 0)
            self.collectionView!.reloadItems(at: [indexPath as IndexPath])
            
        }
        
    }
    
    
    // refreshing func
    func refresh() {
        
        // reload posts
        //loadPosts()
        collectionView!.reloadData()
        
        // stop refresher animating
        refresher.endRefreshing()
    }
    
    func uploaded(notification: NSNotification){
        loadPosts()
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
    
    
    
    // load more while scrolling down
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.size.height {
            //loadMore()
        }
    }
    
    
    
    // cell numb
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    
    // cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: self.view.frame.size.width / 2, height: self.view.frame.size.width / 2 + 30)
        return size
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath:IndexPath)->UICollectionViewCell{
        
        // define cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "idCollectionCell", for: indexPath as IndexPath) as! testsearchcell
        
        let post = posts[indexPath.row]
        cell.cellpos = indexPath.row
        cell.thisPost = post
        cell.backgroundColor = UIColor(patternImage: UIImage(named: "Background_Blue_Joint.jpg")!)
        cell.origin = "Home"
        cell.titleLbl.text = post.title
        getLikeState(string: post.uuid! , Btn: cell.likeBtn)
        getLikeCount(string: post.uuid!, Lbl : cell.LikeLbl)
        cell.mySeg = self
        //cell.uuidLbl.text = uuidArray[indexPath.row]
        //cell.picImg1.image = picArray[indexPath.row]
        cell.picImg1.loadImageUsingCacheWithUrlString(urlString: post.photoURL!)
        if post.Grab == "Not Available"{
            cell.Flag.isHidden = true
            cell.UFG.isHidden = true
        } else {
            cell.Flag.isHidden = false
            cell.UFG.isHidden = false
        }

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        return CGSize(width: collectionView.frame.width, height: max(20,bottomheader + 5))//self.bottomheader)
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //define header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath as IndexPath) as! headerView
        //header.frame.size.height = 100
        // get users data with connections to columns of PFUser class
        
        firebase.child("Users").child(userIdToDisplay).observe(.value, with: { snapshot in
            
            let first = (snapshot.value as? [String:AnyObject])?["first_name"] as! String
            let last = (snapshot .value as? [String:AnyObject])?["last_name"] as! String
            print ( snapshot.key)
            self.username = snapshot.key
            //title at the top
            self.fullname = first+" "+last
            self.navigationItem.title = self.fullname
            self.avaUrl = ((snapshot.value! as AnyObject).value(forKey:"ProfilPicUrl") as! String)
            header.avaImg.loadImageUsingCacheWithUrlString(urlString: self.avaUrl)

//            if self.goHome == true {
//            header.followButton.hidden = true
//            }
            
            let q = (snapshot.value as? [String:AnyObject])?["youtubeURL"] as? String
            let w = (snapshot.value as? [String:AnyObject])?["instagramURL"] as? String
            let e = (snapshot.value as? [String:AnyObject])?["etsyURL"] as? String
            let r = (snapshot.value as? [String:AnyObject])?["emailDisplay"] as? String
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
            header.Settingsbutton.isHidden = true
            header.followButton.isHidden = false
            // STEP 2. Show do current user follow guest or do not
            firebase.child("Followings").child((FIRAuth.auth()?.currentUser!.uid)!).child(self.userIdToDisplay).observe(.value, with: { snapshot in
                if snapshot.exists() {
                    header.followButton.setTitle("FOLLOWING", for: UIControlState.normal)
                    header.followButton.backgroundColor = .green
                }
                else {
                    header.followButton.setTitle("FOLLOW", for: .normal)
                    header.followButton.backgroundColor = .lightGray
                }
                
                
                
            })
            
        } else if self.goHome == true {
            header.followButton.isHidden = true
            header.Settingsbutton.isHidden = false
        }
        
        firebase.child("PostPerUser").child(userIdToDisplay).observe(.value, with: { snapshot in
            if snapshot.exists() {
                
                header.posts.text =  "\(snapshot.childrenCount)"
                
            }
        })
        
        firebase.child("Followers").child(userIdToDisplay).observe(.value, with: { snapshot in
            if snapshot.exists() {
                header.followers.text =  "\(snapshot.childrenCount)"
            } else {
                header.followers.text = "0"
            }
        })
        
        firebase.child("Followings").child(userIdToDisplay).observe(.value, with: { snapshot in
            if snapshot.exists() {
                header.followings.text =  "\(snapshot.childrenCount)"
            } else {
                header.followings.text =  "0"
            }
        })
        
        // STEP 3. Implement tap gestures
        // tap posts
        let postsTap = UITapGestureRecognizer(target: self, action: #selector(homeVC1.postsTap))
        postsTap.numberOfTapsRequired = 1
        header.posts!.isUserInteractionEnabled = true
        header.posts!.addGestureRecognizer(postsTap)
        
        // tap followers
        let followersTap = UITapGestureRecognizer(target: self, action: #selector(homeVC1.followersTap))
        followersTap.numberOfTapsRequired = 1
        header.followers.isUserInteractionEnabled = true
        header.followers.addGestureRecognizer(followersTap)
        
        // tap followings
        let followingsTap = UITapGestureRecognizer(target: self, action: #selector(homeVC1.followingsTap))
        followingsTap.numberOfTapsRequired = 1
        header.followings.isUserInteractionEnabled = true
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
        user = userIdToDisplay
        show1 = "Followers"
        
        // make references to followersVC
        let followers = self.storyboard?.instantiateViewController(withIdentifier: "followersVC") as! followersVC
        
        // present
        self.navigationController?.pushViewController(followers, animated: true)
    }
    
    // tapped followings label
    func followingsTap() {
        
        user = userIdToDisplay
        show1 = "Followings"
        
        // make reference to followersVC
        let followings = self.storyboard?.instantiateViewController(withIdentifier: "followersVC") as! followersVC
        
        // present
        self.navigationController?.pushViewController(followings, animated: true)
    }
    
    //clicked logout
    @IBAction func logout(_ sender: AnyObject) {
        // implement log out
        let loginManager = FBSDKLoginManager()
        loginManager.logOut() // this is an instance function
        print("logged out from FB")
        try! FIRAuth.auth()!.signOut()
        //PFUser.logOut()
        let signin = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: NSIndexPath) {
        
        // send post uuid to "postuuid" variable
        postuuid.append(uuidArray[indexPath.row])
        
        // navigate to post view controller
        let post = self.storyboard?.instantiateViewController(withIdentifier: "postVC") as! postVC
        self.navigationController?.pushViewController(post, animated: true)
    }
    
    func loadpostsNew(){
        //.queryOrdered(byChild: "date")
        
        firebase.child("PostPerUser").child(userIdToDisplay).observe(.childAdded, with: { snapshot1 in
            if snapshot1.exists() {
                self.posts.removeAll(keepingCapacity: false)
                
                //let sorted = ((snapshot1.value! as AnyObject).allValues as NSArray).sortedArray(using: [NSSortDescriptor(key: "date", ascending: false)])
                print(snapshot1)
//                for postperUser1 in sorted{
               // for postperUser1 in snapshot1.children{
                    //let postperUser = postperUser1 as! FIRDataSnapshot
                    let postID = snapshot1.key//postperUser.key

                        firebase.child("Posts").child(postID ).observe(.value, with: { snapshot in
                            if let dictionary = snapshot.value as? [String: AnyObject] {
                                let post = Post()
                                post.uuid = postID
                                //self.uuidArray.append(post.key as String!)
                                print(post)
                                
                                post.UserID = dictionary["userID"] as! String?

                                if let datestring = dictionary["date"]{
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                                    let date = dateFormatter.date(from: datestring as! String)
                                    post.date = date
                                    
                                }
                                post.profUrl = self.avaUrl
                                post.NameAuthor = self.fullname
                                post.title = dictionary["title"] as! String?
                                post.Grab = dictionary["Grab"] as! String?
                                
                                
                                post.photoURL = dictionary["photoUrl"] as! String?
                                
                                self.posts.append(post)
                                DispatchQueue.main.async(execute: {
                                    self.posts.reverse()
                                self.collectionView?.reloadData()
                                self.refresher.endRefreshing()
                                })

                            }

                        })
                    
                    
                //}
                
                
            }
            
            
        }){ (error) in
            print(error.localizedDescription)
        }    }
    
    
    // load posts
    func loadPosts() {
        let picturesGroup = DispatchGroup()
        let lastGroup = DispatchGroup()
        let queue = DispatchQueue.global(qos: .default)
        let queue1 = DispatchQueue.global(qos: .default)
        
        firebase.child("PostPerUser").child(userIdToDisplay).queryOrdered(byChild: "date").observe(.value, with: { snapshot1 in
            print(snapshot1)
            if snapshot1.exists() {
                self.usernameArray.removeAll(keepingCapacity: false)
                self.nameArray.removeAll(keepingCapacity: false)
                self.avaArray.removeAll(keepingCapacity: false)
                self.dateArray.removeAll(keepingCapacity: false)
                self.picArray.removeAll(keepingCapacity: false)
                //self.picArraySearch.removeAll(keepCapacity: false)
                self.titleArray.removeAll(keepingCapacity: false)
                self.uuidArray.removeAll(keepingCapacity: false)
                self.UFGArray.removeAll(keepingCapacity: false)
                self.URLarray.removeAll(keepingCapacity: false)
                var i = 0
                //print(snapshot1)
                for postperUser1 in snapshot1.children{
                    let postperUser = postperUser1 as! FIRDataSnapshot
                    let postID = postperUser.key
                    //print (postID)
                    
                    picturesGroup.enter()
                    queue.async(execute: {
                    firebase.child("Posts").child(postID ).observe(.value, with: { snapshot in
                        
                        if snapshot.exists() {
                            
                            
                            let post = snapshot
                            self.uuidArray.append(post.key as String!)
                            print(post)
                            
                            let userID = ((post as! FIRDataSnapshot).value as? [String:AnyObject])?["userID"]
                            //                            self.storage.reference(forURL: url as! String).data(withMaxSize: 25 * 1024 * 1024, completion: { (data, error) -> Void in
//                                let image = UIImage(data: data!)
//                                
//                                self.picArray.append(image! )
//                                self.uuidArray.append(post.key as String!)
//                                
//                                picturesGroup.leave()
//                                //objc_sync_exit(self.nameArray)
//                                //self.tableView.reloadData()
//                                //self.scrollToBottom()
////                                firebase.child("Users").child(userID as! String).observe(.value, with: { snapshot in
////                                    
//////                                    let first = (snapshot.value!.objectForKey("first_name") as? String)
//////                                    let last = (snapshot.value!.objectForKey("last_name") as? String)
//////                                    
//////                                    let fullname = first!+" "+last!
//////                                    self.nameArray.append(fullname)
////                                    //self.tableView.reloadData()
////                                    self.collectionView!.reloadData()
////                                    let avaURL = ((snapshot.value! as AnyObject).value(forKey: "ProfilPicUrl") as! String)
////                                    let url = NSURL(string: avaURL)
////                                    if let data = NSData(contentsOf: url! as URL){ //make sure your image in this url does exist, otherwise unwrap in a if let check
////                                        self.avaArray.append(UIImage(data: data as Data) as UIImage!)
////                                        
////                                    }
////                                    
////                                    //self.comments.append(snapshot)
////                                    //self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.comments.count-1, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Automatic)
////                                    }
////                                    
////                                    
////                                ){ (error) in
////                                    print(error.localizedDescription)
////                                }
//                                
//                                // objc_sync_exit(self.nameArray)
//                                
//                            })
                            
                            //let datestring = post.value.objectForKey("date") as! String
                            if let datestring = ((post as! FIRDataSnapshot).value as? [String:AnyObject])?["date"]{
                                var dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                                let date = dateFormatter.date(from: datestring as! String)
                                self.dateArray.append(date as NSDate?)
                            }
                            self.usernameArray.append(userID as! String )
                            
                            self.titleArray.append((((post as! FIRDataSnapshot).value as? [String:AnyObject])?["title"])! as! String)
                            let UFG = ((post as! FIRDataSnapshot).value as? [String:AnyObject])?["Grab"] as! String
                            self.UFGArray.append(UFG)

                            // dispatch_async(dispatch_get_main_queue(), {
                            //  self.tableView.reloadData()
                            //self.collectionView.reloadData()
                            
                            let url = ((post as! FIRDataSnapshot).value as? [String:AnyObject])?["photoUrl"] as! String
                            self.URLarray.append(url)
                            self.myDictionaryURL.updateValue(url, forKey: i)
//                            queue1.async(execute: {
//                                self.storage.reference(forURL: url).data(withMaxSize: 25 * 1024 * 1024, completion: { (data, error) -> Void in
//                                    let image = UIImage(data: data!)
//                                    self.myDictionaryImage[i] = image!
//                                    
//                                    
//                                    //self.picArray.append(image! as! UIImage)
//                                    
//                                    picturesGroup.leave()
//                                })
//                            })
                            i+=1
                            

                            
                            // });
                                                     picturesGroup.leave()
                        }



                        //self.comments.append(snapshot)
                        //self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.comments.count-1, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Automatic)
                    })
                })
                
                }
             
                
//                picturesGroup.notify(queue: queue, execute:{
//                for (bookid, title) in self.myDictionaryURL {
//                    //println("Book ID: \(bookid) Title: \(title)")
//                    //print(title)
//                    lastGroup.enter()
//                    queue1.async(execute: {
//                        self.storage.reference(forURL: title).data(withMaxSize: 25 * 1024 * 1024, completion: { (data, error) -> Void in
//                            let image = UIImage(data: data!)
//                            self.myDictionaryImage[bookid] = image!
//                            
//                            //self.picArray.append(image! as! UIImage)
//                            
//                            lastGroup.leave()
//                        })
//                    })
//                }
////
////
//                })
                
                
                lastGroup.notify(queue: DispatchQueue.global(), execute:{
                    let imagesSorted = Array(self.myDictionaryImage.keys).sorted(by: >)
//                    self.usernameArray = self.usernameArray.reversed()
//                    self.nameArray = self.nameArray.reversed()
//                    self.avaArray = self.avaArray.reversed()
//                    self.dateArray = self.dateArray.reversed()
//                    //self.picArray = self.picArray.reversed()
//                    //self.picArraySearch.removeAll(keepCapacity: false)
//                    self.titleArray = self.titleArray.reversed()
//                    self.uuidArray = self.uuidArray.reversed()
//                    self.UFGArray = self.UFGArray.reversed()
                    for a in imagesSorted {
                        self.picArray.append(self.myDictionaryImage[a]!)
                    }
                    self.refresher.endRefreshing()
                    self.collectionView?.reloadData()
                })
                
                }
                
            
        }){ (error) in
            print(error.localizedDescription)
        }

    }
    
    @IBAction func SettingsClick(_ sender: AnyObject) {
        self.hidesBottomBarWhenPushed = true
    }

    
    
    
    
    
    
}
