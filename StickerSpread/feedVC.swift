//
//  feedVC.swift
//  StickerSpread
//
//  Created by Student iMac on 6/4/16.
//  Copyright © 2016 Student iMac. All rights reserved.
//

import UIKit
import Parse





class feedVC: UITableViewController, UISearchBarDelegate ,UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    //@IBOutlet var tableViewSearch: UITableView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var refresher = UIRefreshControl()
    
    // arrays to hold server data
    var usernameArray = [String]()
    var avaArray = [PFFile]()
    var postPicSearch = [PFFile]()
    var nameArray = [String]()
    var dateArray = [NSDate?]()
    var picArray = [PFFile]()
    var picForColl = [PFFile]()
    var uuidArrayColl = [String]()
    var titleArray = [String]()
    var uuidArray = [String]()
    
    //var tableViewSearch : UITableView!
    
    var followArray = [String]()
    
    // page size
    var page : Int = 10
    
    //var tableViewSearch = UITableView()
    
    // collectionView UI
    var collectionView : UICollectionView!
    
    //for search
    // declare search bar
    var searchBar = UISearchBar()
    
    // tableView arrays to hold information from server
    var usernameArraySearch = [String]()
    var avaArraySearch = [PFFile]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //        // title at the top
        //        self.navigationItem.title = "FEED"
        
        //tableView.delegate = self;
        //tableViewSearch.delegate = self;
        
        // implement search bar
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.tintColor = UIColor.groupTableViewBackgroundColor()
        searchBar.frame.size.width = self.view.frame.size.width - 34
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = searchItem
        
        // automatic row height - dynamic cell
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 450
        
        // pull to refresh
        refresher.addTarget(self, action: "loadPosts", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refresher)
        
        // indicator's x(horizontal) center
        indicator.center.x = tableView.center.x
        
        // receive notification from postsCell if picture is liked, to update tableView
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refresh", name: "liked", object: nil)
        
        // receive notification from uploadVC
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "uploaded:", name: "uploaded", object: nil)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // calling function to load posts
        
        //        dispatch_async(dispatch_get_main_queue()) {
        //        self.loadPosts()
        //        }
        //            let delayTime = 0.13
        //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delayTime * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
        //
        //                self.tableView.reloadData()
        //                self.refresher.endRefreshing()
        //            }
        
        collectionViewLaunch()
        loadPosts()
        // usersVC().collectionViewLaunch()
        
        
        
        //SearchViewLaunch()
        collectionView.hidden = true
        
    }
    

    
    

    
    
    // search updated
    //func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    
    func searchBar( searchBar: UISearchBar,
                    textDidChange searchText: String) {
        
        if searchText.isEmpty == true {
            loadPostsforColl()
            self.collectionView.reloadData()
        } else {
            
            
            
            
            
            // find by username
            let usernameQuery = PFQuery(className: "posts")
            usernameQuery.whereKey("title", matchesRegex: "(?i)" + searchText)
            usernameQuery.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) -> Void in
                if error == nil {
                    
                    //                // if no objects are found according to entered text in usernaem colomn, find by fullname
                    //                if objects!.isEmpty {
                    //
                    //                    let fullnameQuery = PFUser.query()
                    //                    fullnameQuery?.whereKey("fullname", matchesRegex: "(?i)" + self.searchBar.text!)
                    //                    fullnameQuery?.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                    //                        if error == nil {
                    //
                    //                            // clean up
                    //                            self.usernameArraySearch.removeAll(keepCapacity: false)
                    //                            self.avaArraySearch.removeAll(keepCapacity: false)
                    //
                    //                            // found related objects
                    //                            for object in objects! {
                    //                                self.usernameArraySearch.append(object.objectForKey("username") as! String)
                    //                                //self.avaArraySearch.append(object.objectForKey("picture_file") as! PFFile)
                    //
                    //                            }
                    //
                    //                            // reload
                    //                            self.tableViewSearch.reloadData()
                    //
                    //                        }
                    //                    })
                    //                }
                    
                    // clean up
                    self.picForColl.removeAll(keepCapacity: false)
                    self.uuidArrayColl.removeAll(keepCapacity: false)
                    //self.usernameArraySearch.removeAll(keepCapacity: false)
                    //self.avaArraySearch.removeAll(keepCapacity: false)
                    
                    // found related objects
                    for object in objects! {
                        let desc = object.objectForKey("title") as! String
                        print(desc)
                        
                        self.picForColl.append(object.objectForKey("pic") as! PFFile)
                        self.uuidArrayColl.append(object.objectForKey("uuid") as! String)
                        //self.usernameArraySearch.append(object.objectForKey("username") as! String)
                        //self.avaArraySearch.append(object.objectForKey("picture_file") as! PFFile)
                    }
                    
                    // reload
                    self.collectionView.reloadData()
                    
                }
            })
        }
        
        // return true
    }
    
    
    // tapped on the searchBar
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {

        //tableView.hidden = true
        collectionView.hidden = false
        
        
        // show cancel button
        searchBar.showsCancelButton = true
        
        //SearchViewLaunch()
        //loadPostsforColl()
    }
    
    
    // clicked cancel button
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        //        // unhide collectionView when tapped cancel button
        //        collectionView.hidden = false
        
        // dismiss keyboard
        searchBar.resignFirstResponder()
        
        // hide cancel button
        searchBar.showsCancelButton = false
        
        // reset text
        searchBar.text = ""
        // tableViewSearch.hidden = true
        
        collectionView.hidden = true
        //tableView.hidden = false
        // reset shown users
       loadPostsforColl()
        
    }
    
    
    
//    // TABLEVIEW CODE
//     //cell numb
//        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return usernameArraySearch.count
//        }
    
    // cell height
    //    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        if  (tableView == self.tableViewSearch){
    //        return self.view.frame.size.width / 4
    //        } else {
    //            return 1
    //        }
    //    }
    
    //    // cell config
    //    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //
    //        // define cell
    //        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! followersCell
    //
    //        // hide follow button
    //        cell.followBtn.hidden = true
    //
    //        // connect cell's objects with received infromation from server
    //        cell.usernameLbl.text = usernameArraySearch[indexPath.row]
    //        avaArray[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
    //            if error == nil {
    //                cell.avaImg.image = UIImage(data: data!)
    //            }
    //        }
    //
    //        return cell
    //    }
    
    
//    // selected tableView cell - selected user
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if  (tableView == self.tableViewSearch){
//            // calling cell again to call cell data
//            let cell = tableView.cellForRowAtIndexPath(indexPath) as! followersCell
//            
//            // if user tapped on his name go home, else go guest
//            if cell.usernameLbl.text! == PFUser.currentUser()?.username {
//                let home = self.storyboard?.instantiateViewControllerWithIdentifier("homeVC") as! homeVC
//                self.navigationController?.pushViewController(home, animated: true)
//            } else {
//                guestname.append(cell.usernameLbl.text!)
//                let guest = self.storyboard?.instantiateViewControllerWithIdentifier("guestVC") as! guestVC
//                self.navigationController?.pushViewController(guest, animated: true)
//            }
//        }
//    }
    
    
    
    // refreshign function after like to update degit
    func refresh() {
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    
    //    override func viewWillAppear(animated: Bool) {
    //       loadPosts()
    //        tableView.reloadData()
    //       refresher.endRefreshing()
    //    }
    
    // reloading func with posts  after received notification
    func uploaded(notification:NSNotification) {
        loadPosts()
        
    }
    
    // load posts
    func loadPosts() {
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        // STEP 1. Find posts realted to people who we are following
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("follower", equalTo: PFUser.currentUser()!.username!)
        followQuery.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                
                // clean up
                self.followArray.removeAll(keepCapacity: false)
                
                // find related objects
                for object in objects! {
                    //objc_sync_enter(self.nameArray)
                    self.followArray.append(object.objectForKey("following") as! String)
                    //objc_sync_exit(self.nameArray)
                }
                
                // append current user to see own posts in feed
                self.followArray.append(PFUser.currentUser()!.username!)
                
                // STEP 2. Find posts made by people appended to followArray
                let query = PFQuery(className: "posts")
                query.whereKey("username", containedIn: self.followArray)
                query.limit = self.page
                query.addDescendingOrder("createdAt")
                
                //                let new_query = PFQuery(className: "_User")
                //                new_query.whereKey("Friend2", matchesQuery: query)
                
                query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                    
                    if error == nil {
                        
                        // clean up
                        self.usernameArray.removeAll(keepCapacity: false)
                        self.nameArray.removeAll(keepCapacity: false)
                        self.avaArray.removeAll(keepCapacity: false)
                        self.dateArray.removeAll(keepCapacity: false)
                        self.picArray.removeAll(keepCapacity: false)
                        self.picForColl.removeAll(keepCapacity: false)
                        self.titleArray.removeAll(keepCapacity: false)
                        self.uuidArray.removeAll(keepCapacity: false)
                        
                        // find related objects
                        for object in objects! {
                            let usernmae = object.valueForKey("username") as! String
                            let infoQuery1 = PFQuery(className: "_User")
                            infoQuery1.whereKey("username", equalTo: usernmae)
                            infoQuery1.findObjectsInBackgroundWithBlock ({ (objects1:[PFObject]?, error:NSError?) -> Void in
                                if error == nil {
                                    
                                    // shown wrong user
                                    if objects1!.isEmpty {
                                        // call alert
                                        let alert = UIAlertController(title: "\(guestname.last!.uppercaseString)", message: "is not existing", preferredStyle: UIAlertControllerStyle.Alert)
                                        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                                            self.navigationController?.popViewControllerAnimated(true)
                                        })
                                        alert.addAction(ok)
                                        self.presentViewController(alert, animated: true, completion: nil)
                                    }
                                    
                                    // find related to user information
                                    for object1 in objects1! {
                                        objc_sync_enter(self.nameArray)
                                        // get users data with connections to columns of PFUser class
                                        let first = (object1.objectForKey("first_name") as? String)
                                        let last = (object1.objectForKey("last_name") as? String)
                                        
                                        let fullname = first!+" "+last!
                                        self.nameArray.append(fullname)
                                        objc_sync_exit(self.nameArray)
                                        
                                        dispatch_async(dispatch_get_main_queue(), {
                                            self.tableView.reloadData()
                                            self.refresher.endRefreshing()
                                        });
                                        
                                    }
                                    
                                    
                                    
                                } else {
                                    print(error!.localizedDescription)
                                }
                            })
                            
                            
                            self.usernameArray.append(object.objectForKey("username") as! String)
                            self.avaArray.append(object.objectForKey("ava") as! PFFile)
                            self.dateArray.append(object.createdAt)
                            self.picArray.append(object.objectForKey("pic") as! PFFile)
                            self.picForColl.append(object.objectForKey("pic") as! PFFile)
                            self.titleArray.append(object.objectForKey("title") as! String)
                            self.uuidArray.append(object.objectForKey("uuid") as! String)
                            
                            
                            //                            dispatch_async(dispatch_get_main_queue(), {
                            //                                self.tableView.reloadData()
                            //                                self.refresher.endRefreshing()
                            //                            });
                            
                        }
                        
                        // reload tableView & end spinning of refresher
                        //                        dispatch_async(dispatch_get_main_queue(), {
                        //                            self.tableView.reloadData()
                        //                            self.refresher.endRefreshing()
                        //                           });
                        
                        
                    } else {
                        print(error!.localizedDescription)
                    }
                })
                
                
            } else {
                print(error!.localizedDescription)
            }
        })
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        
        
    }
    //    // scrolled down
    //    override func scrollViewDidScroll(scrollView: UIScrollView) {
    //        if scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.size.height * 2 {
    //            loadMore()
    //        }
    //    }
    
    // pagination
    func loadMore() {
        
        // if posts on the server are more than shown
        if page <= uuidArray.count {
            
            // start animating indicator
            indicator.startAnimating()
            
            // increase page size to load +10 posts
            page = page + 10
            
            // STEP 1. Find posts realted to people who we are following
            let followQuery = PFQuery(className: "follow")
            followQuery.whereKey("follower", equalTo: PFUser.currentUser()!.username!)
            followQuery.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) -> Void in
                if error == nil {
                    
                    // clean up
                    self.followArray.removeAll(keepCapacity: false)
                    
                    // find related objects
                    for object in objects! {
                        self.followArray.append(object.objectForKey("following") as! String)
                    }
                    
                    // append current user to see own posts in feed
                    self.followArray.append(PFUser.currentUser()!.username!)
                    
                    // STEP 2. Find posts made by people appended to followArray
                    let query = PFQuery(className: "posts")
                    query.whereKey("username", containedIn: self.followArray)
                    query.limit = self.page
                    query.addDescendingOrder("createdAt")
                    query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                        if error == nil {
                            
                            // clean up
                            self.usernameArray.removeAll(keepCapacity: false)
                            self.nameArray.removeAll(keepCapacity: false)
                            self.avaArray.removeAll(keepCapacity: false)
                            self.dateArray.removeAll(keepCapacity: false)
                            self.picArray.removeAll(keepCapacity: false)
                            self.titleArray.removeAll(keepCapacity: false)
                            self.uuidArray.removeAll(keepCapacity: false)
                            
                            // find related objects
                            for object in objects! {
                                self.usernameArray.append(object.objectForKey("username") as! String)
                                self.avaArray.append(object.objectForKey("ava") as! PFFile)
                                self.dateArray.append(object.createdAt)
                                self.picArray.append(object.objectForKey("pic") as! PFFile)
                                self.titleArray.append(object.objectForKey("title") as! String)
                                self.uuidArray.append(object.objectForKey("uuid") as! String)
                                
                                
                                let usernmae = object.valueForKey("username") as! String
                                let infoQuery = PFQuery(className: "_User")
                                infoQuery.whereKey("username", equalTo: usernmae)
                                infoQuery.findObjectsInBackgroundWithBlock ({ (objects1:[PFObject]?, error:NSError?) -> Void in
                                    if error == nil {
                                        
                                        // shown wrong user
                                        if objects1!.isEmpty {
                                            // call alert
                                            let alert = UIAlertController(title: "\(guestname.last!.uppercaseString)", message: "is not existing", preferredStyle: UIAlertControllerStyle.Alert)
                                            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                                                self.navigationController?.popViewControllerAnimated(true)
                                            })
                                            alert.addAction(ok)
                                            self.presentViewController(alert, animated: true, completion: nil)
                                        }
                                        
                                        // find related to user information
                                        for object1 in objects1! {
                                            
                                            
                                            
                                            // get users data with connections to columns of PFUser class
                                            let first = (object1.valueForKey("first_name") as? String)
                                            let last = (object1.valueForKey("last_name") as? String)
                                            
                                            let fullname = first!+" "+last!
                                            self.nameArray.append(fullname)
                                            //self.tableView.reloadData()
                                            //self.refresher.endRefreshing()
                                            
                                        }
                                        
                                        
                                    }
                                })
                            }
                            
                            //                            // reload tableView & end spinning of refresher
                            //                             self.tableView.reloadData()
                            //                            self.refresher.endRefreshing()
                            
                        } else {
                            print(error!.localizedDescription)
                        }
                    })
                } else {
                    print(error!.localizedDescription)
                }
            })
            
        }
        
    }
    
    // cell numb
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  //      if  (tableView == self.tableViewSearch){
   //         return usernameArraySearch.count
  //      } else {
            objc_sync_enter(self)
            return nameArray.count
            //objc_sync_exit(self)
//        }
    }
    
    //    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    //        objc_sync_enter(self)
    //        return uuidArray.count
    //        objc_sync_exit(self)
    //    }
    
    
    

    
    
    // cell config
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       // if  (tableView == self.tableViewSearch){
            // define cell
            //let cell1 = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? searchCell
          //  let cell1 = tableView.dequeueReusableCellWithIdentifier("CellSearch") as! searchCell
            
            
            //            //variable type is inferred
            //            var cell1 = tableView.dequeueReusableCellWithIdentifier("CellSearch") as? searchCell
            //
            //            if cell1 == nil {
            //                cell1 = searchCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CellSearch")
            //            }
            
            //            var cell1: followersCell! = tableView.dequeueReusableCellWithIdentifier("CellSearch") as? followersCell
            //
            //            if cell1 == nil {
            //                tableView.registerNib(UINib(nibName: "CellSearch", bundle: nil), forCellReuseIdentifier: "CellSearch")
            //                cell1 = tableView.dequeueReusableCellWithIdentifier("CellSearch") as? followersCell
            //            }
            
            
            //           let cell1: followersCell! = tableView.dequeueReusableCellWithIdentifier("CellSearch") as? followersCell
            
            //            if cell == nil {
            //                cell = followersCell(style: .Default, reuseIdentifier: "CellSearch")
            //            }
            
            
            
            
            //        // hide follow button
            //        cell1.followBtn.hidden = true
            //
            //        // connect cell's objects with received infromation from server
            //        cell1.usernameLbl.text = usernameArraySearch[indexPath.row]
            //        avaArray[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
            //            if error == nil {
            //                cell1.avaImg.image = UIImage(data: data!)
            //            }
            //        }
         //   return cell1
       // } else {
            
            
            
            
            // define cell
            
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! postCell
            
            // connect objects with our information from arrays
            //objc_sync_enter(self.nameArray)
            cell.usernameBtn.setTitle(nameArray[indexPath.row], forState: UIControlState.Normal)
            cell.usernameBtn.sizeToFit()
            //objc_sync_exit(self.nameArray)
            cell.uuidLbl.text = self.uuidArray[indexPath.row]
            cell.titleLbl.text = self.titleArray[indexPath.row]
            cell.titleLbl.sizeToFit()
            cell.usernameHidden.setTitle(usernameArray[indexPath.row], forState: UIControlState.Normal)
            
            // place profile picture
            avaArray[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
                cell.avaImg.image = UIImage(data: data!)
            }
            
            // place post picture
            picArray[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
                cell.picImg.image = UIImage(data: data!)
            }
            
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
            
            
            // manipulate like button depending on did user like it or not
            let didLike = PFQuery(className: "likes")
            didLike.whereKey("by", equalTo: PFUser.currentUser()!.username!)
            didLike.whereKey("to", equalTo: cell.uuidLbl.text!)
            didLike.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) -> Void in
                // if no any likes are found, else found likes
                if count == 0 {
                    cell.likeBtn.setTitle("unlike", forState: .Normal)
                    cell.likeBtn.setBackgroundImage(UIImage(named: "unlike.png"), forState: .Normal)
                } else {
                    cell.likeBtn.setTitle("like", forState: .Normal)
                    cell.likeBtn.setBackgroundImage(UIImage(named: "like.png"), forState: .Normal)
                }
            }
            
            // count total likes of shown post
            let countLikes = PFQuery(className: "likes")
            countLikes.whereKey("to", equalTo: cell.uuidLbl.text!)
            countLikes.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) -> Void in
                cell.likeLbl.text = "\(count)"
            }
            // asign index
            cell.usernameBtn.layer.setValue(indexPath, forKey: "index")
            cell.commentBtn.layer.setValue(indexPath, forKey: "index")
            cell.moreBtn.layer.setValue(indexPath, forKey: "index")
            
            return cell
     //   }
        
        
    }
    
    @IBAction func usernameBtn_click(sender: AnyObject) {
        // call index of button
        let i = sender.layer.valueForKey("index") as! NSIndexPath
        
        // call cell to call further cell data
        let cell = tableView.cellForRowAtIndexPath(i) as! postCell
        
        // if user tapped on himself go home, else go guest
        
        
        if cell.usernameHidden.titleLabel?.text == PFUser.currentUser()?.username {
            let home = self.storyboard?.instantiateViewControllerWithIdentifier("homeVC") as! homeVC
            self.navigationController?.pushViewController(home, animated: true)
        } else {
            guestname.append(cell.usernameHidden.titleLabel!.text!)
            let guest = self.storyboard?.instantiateViewControllerWithIdentifier("guestVC") as! guestVC
            self.navigationController?.pushViewController(guest, animated: true)
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
            
            // STEP 3. Delete comments of post from server
            let commentQuery = PFQuery(className: "comments")
            commentQuery.whereKey("to", equalTo: cell.uuidLbl.text!)
            commentQuery.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                if error == nil {
                    for object in objects! {
                        object.deleteEventually()
                    }
                }
            })
            
            // STEP 4. Delete hashtags of post from server
            let hashtagQuery = PFQuery(className: "hashtags")
            hashtagQuery.whereKey("to", equalTo: cell.uuidLbl.text!)
            hashtagQuery.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                if error == nil {
                    for object in objects! {
                        object.deleteEventually()
                    }
                }
            })
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // COLLECTION VIEW CODE
    func collectionViewLaunch() {
        
        // layout of collectionView
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        // item size
        layout.itemSize = CGSizeMake(self.view.frame.size.width / 2, self.view.frame.size.width / 2+25)
        
        // direction of scrolling
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        
        // define frame of collectionView
        let frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+10000)
        //let frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.tabBarController!.tabBar.frame.size.height - self.navigationController!.navigationBar.frame.size.height - 20)

        // declare collectionView
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .whiteColor()
        self.view.addSubview(collectionView)
        
        // define cell for collectionView
        collectionView.registerClass(searchCollCell.self, forCellWithReuseIdentifier: "Cellsearch")
        
        // call function to load posts
        loadPostsforColl()
    }
    
    
    // cell line spasing
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    // cell inter spasing
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    // cell numb
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picForColl.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath:NSIndexPath)->UICollectionViewCell
    {
        var  cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cellsearch", forIndexPath: indexPath) as! searchCollCell
        //cell.uuidLbl.text = self.uuidArray[indexPath.row]
       // cell.titleShop.text="cellText"
        
        cell.backgroundColor = UIColor.whiteColor()
        cell.uuid.text = uuidArrayColl[indexPath.row]
        cell.uuid.hidden = true
        
        
        // manipulate like button depending on did user like it or not
        let didLike = PFQuery(className: "likes")
        didLike.whereKey("by", equalTo: PFUser.currentUser()!.username!)
        didLike.whereKey("to", equalTo: uuidArrayColl[indexPath.row])
        didLike.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) -> Void in
            // if no any likes are found, else found likes
            if count == 0 {
                cell.likeButton.setTitle("unlike", forState: .Normal)
                cell.likeButton.setImage(UIImage(named: "unlike.png"), forState: .Normal)
                
            } else {
                cell.likeButton.setTitle("like", forState: .Normal)
                cell.likeButton.setImage(UIImage(named: "like.png"), forState: .Normal)
                 //cell.likeButton.addTarget(self, action: "unlikeTouchedColl:", forControlEvents:.TouchUpInside)
            }
        }
        
        let countLikes = PFQuery(className: "likes")
        countLikes.whereKey("to", equalTo: uuidArrayColl[indexPath.row])
        countLikes.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) -> Void in
            cell.likeLabel.text = String(count) //"\(count)"
        }
        
        cell.likeButton.layer.setValue(indexPath, forKey: "index")
        cell.nameLabel.text = "Two Little Bees"
       
        //cell.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-35-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
         cell.likeButton.addTarget(self, action: "likeTouchedColl:", forControlEvents:.TouchUpInside)
        
        
                // get loaded images from array
                picForColl[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
                    if error == nil {
                        cell.picImg.image = UIImage(data: data!)
                    } else {
                        print(error!.localizedDescription)
                    }
                }
        

     

        


        
        //cell.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-4-[v0]-110-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": like]))
        
//        cell.addSubview(nameLabel)
//        cell.addSubview(like)
//        cell.addSubview(likeLabel)
//        cell.addSubview(picImg)
//        cell.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-161-[v0(18)]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": like]))
//        cell.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-2-[v1(18)]-1-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": likeLabel,"v1": like]))
//        cell.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-50-[v2]-1-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v2": nameLabel]))
//        cell.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-153-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": likeLabel]))
//        cell.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-152-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        
        
        
        //let likeImg = UIImageView(frame: CGRectMake(0, 0, 10, 10))
        //cell.addSubview(likeImg)
        
        return cell
    }
    
//    // cell config
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        
//        // define cell
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
//        
//        // create picture imageView in cell to show loaded pictures
//        let picImg = UIImageView(frame: CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height))
//        cell.addSubview(picImg)
//        
//        // get loaded images from array
//        picForColl[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
//            if error == nil {
//                picImg.image = UIImage(data: data!)
//            } else {
//                print(error!.localizedDescription)
//            }
//        }
//        
//        return cell
//    }
    
    // cell's selected
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        
//        // take relevant unique id of post to load post in postVC
//        postuuid.append(uuidArrayColl[indexPath.row])
//        
//        // present postVC programmaticaly
//        let post = self.storyboard?.instantiateViewControllerWithIdentifier("postVC") as! postVC
//        self.navigationController?.pushViewController(post, animated: true)
//    }
    
    // load posts
    func loadPostsforColl() {
        let query = PFQuery(className: "posts")
        query.limit = page
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                
                // clean up
                self.picForColl.removeAll(keepCapacity: false)
                self.uuidArrayColl.removeAll(keepCapacity: false)
                
                // found related objects
                for object in objects! {
                    self.picForColl.append(object.objectForKey("pic") as! PFFile)
                    self.uuidArrayColl.append(object.objectForKey("uuid") as! String)
                }
                
                // reload collectionView to present images
                self.collectionView.reloadData()
                
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    // scrolled down
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        // scroll down for paging
        if scrollView.contentOffset.y >= scrollView.contentSize.height / 6 {
            self.loadMore()
        }
    }
    
//    // pagination
//    func loadMoreColl() {
//        
//        // if more posts are unloaded, we wanna load them
//        if page <= picArray.count {
//            
//            // increase page size
//            page = page + 15
//            
//            // load additional posts
//            let query = PFQuery(className: "posts")
//            query.limit = page
//            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
//                if error == nil {
//                    
//                    // clean up
//                    self.picArray.removeAll(keepCapacity: false)
//                    self.uuidArray.removeAll(keepCapacity: false)
//                    
//                    // find related objects
//                    for object in objects! {
//                        self.picArray.append(object.objectForKey("pic") as! PFFile)
//                        self.uuidArray.append(object.objectForKey("uuid") as! String)
//                    }
//                    
//                    // reload collectionView to present loaded images
//                    self.collectionView.reloadData()
//                    
//                } else {
//                    print(error!.localizedDescription)
//                }
//            })
//            
//        }
//        
//    }
    
    func unlikeTouchedColl(sender: AnyObject){
        let i = sender.layer.valueForKey("index") as! NSIndexPath
        // call cell to call further cell data
        let cell = collectionView.cellForItemAtIndexPath(i) as! searchCollCell
        print(cell.uuid.text)

        
        // request existing likes of current user to show post
        let query = PFQuery(className: "likes")
        query.whereKey("by", equalTo: PFUser.currentUser()!.username!)
        query.whereKey("to", equalTo: cell.uuid.text!)
        query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
            
            // find objects - likes
            for object in objects! {
                
                // delete found like(s)
                object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                    if success {
                        print("disliked")
                        //self.likeBtn.setTitle("unlike", forState: .Normal)
                        cell.likeButton.setImage(UIImage(named: "unlike.png"), forState: .Normal)
                        
                        // send notification if we liked to refresh TableView
                        NSNotificationCenter.defaultCenter().postNotificationName("liked", object: nil)
                        
                        
                    }
                })
            }
        })


    }
    
    func likeTouchedColl(sender: AnyObject){
        
    
        // call index of button
        let i = sender.layer.valueForKey("index") as! NSIndexPath
        // call cell to call further cell data
        let cell = collectionView.cellForItemAtIndexPath(i) as! searchCollCell
        print(cell.uuid.text)
        
        // declare title of button
        let title = sender.titleForState(.Normal)
        
        
        // to like
        if title == "unlike" {

        let object = PFObject(className: "likes")
        object["by"] = PFUser.currentUser()?.username
        object["to"] = cell.uuid.text!
        object.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
            if success {
                print("liked")
                //self.likeBtn.setTitle("like", forState: .Normal)
                cell.likeButton.setImage(UIImage(named: "like.png"), forState: .Normal)
                
                // send notification if we liked to refresh TableView
                NSNotificationCenter.defaultCenter().postNotificationName("liked", object: nil)
                
                
            }
        })
        
         } else {
            // request existing likes of current user to show post
            let query = PFQuery(className: "likes")
            query.whereKey("by", equalTo: PFUser.currentUser()!.username!)
            query.whereKey("to", equalTo: cell.uuid.text!)
            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                
                // find objects - likes
                for object in objects! {
                    
                    // delete found like(s)
                    object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                        if success {
                            print("disliked")
                            //self.likeBtn.setTitle("unlike", forState: .Normal)
                            cell.likeButton.setImage(UIImage(named: "unlike.png"), forState: .Normal)
                            
                            // send notification if we liked to refresh TableView
                            NSNotificationCenter.defaultCenter().postNotificationName("liked", object: nil)
                            
                            
                        }
                    })
                }
            })

            
        }
        
            
        }

        
        
        
        
               // if user tapped on himself go home, else go guest
        
        
//        if cell.usernameHidden.titleLabel?.text == PFUser.currentUser()?.username {
//            let home = self.storyboard?.instantiateViewControllerWithIdentifier("homeVC") as! homeVC
//            self.navigationController?.pushViewController(home, animated: true)
//        } else {
//            guestname.append(cell.usernameHidden.titleLabel!.text!)
//            let guest = self.storyboard?.instantiateViewControllerWithIdentifier("guestVC") as! guestVC
//            self.navigationController?.pushViewController(guest, animated: true)
//        }
//    }
    
    
    
    
//    func SearchViewLaunch() {
//        
//        // layout of collectionView
//        //let layout : UITableViewLayout = UICollectionViewFlowLayout()
//        //
//        //        // item size
//        //        layout.itemSize = CGSizeMake(self.view.frame.size.width / 3, self.view.frame.size.width / 3)
//        //
//        //        // direction of scrolling
//        //        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
//        
//        // define frame of collectionView
//        //let frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.tabBarController!.tabBar.frame.size.height - self.navigationController!.navigationBar.frame.size.height - 20)
//        
//        // declare collectionView
//        
//        //tableViewSearch = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//        //tableViewSearch = UITableView(frame: frame, collectionViewLayout: layout)
//        //tableViewSearch = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
//        tableViewSearch.delegate = self
//        tableViewSearch.dataSource = self
//        tableViewSearch.alwaysBounceVertical = true
//        tableViewSearch.backgroundColor = .whiteColor()
//        tableViewSearch.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(tableViewSearch)
//        
//        // define cell for collectionView
//        //tableViewSearch.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
//        
//        
//        tableViewSearch.registerClass(searchCell.self, forCellReuseIdentifier: "CellSearch")
//        
//        
//        // call function to load posts
//        //loadPosts()
//        
//        loadUsers()
//    }
    
    
//    // SEARCHING CODE
//    // load users function
//    func loadUsers() {
//        
//        let usersQuery = PFQuery(className: "_User")
//        usersQuery.addDescendingOrder("createdAt")
//        usersQuery.limit = 20
//        usersQuery.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) -> Void in
//            if error == nil {
//                
//                // clean up
//                self.usernameArraySearch.removeAll(keepCapacity: false)
//                self.avaArraySearch.removeAll(keepCapacity: false)
//                
//                // found related objects
//                for object in objects! {
//                    self.usernameArraySearch.append(object.valueForKey("username") as! String)
//                    self.avaArraySearch.append(object.valueForKey("picture_file") as! PFFile)
//                }
//                
//                // reload
//                self.tableViewSearch.reloadData()
//                
//            } else {
//                print(error!.localizedDescription)
//            }
//        })
//        
//    }
    
    
    
}
