//
//  followersVC.swift
//  StickerSpread
//
//  Created by Student iMac on 5/30/16.
//  Copyright © 2016 Student iMac. All rights reserved.
//

import UIKit
import Firebase

var show = String()
var user = String()



class followersVC: UITableViewController {
    
    var modeSelf = false
    // arrays to hold data received from servers
    var nameArray = [String]()
    var usernameArray = [String]()
    var firstnameArray = [String]()
    var avaArray = [UIImage]()
    
    // array showing who do we follow or who followings us
    var followArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // title at the top
        self.navigationItem.title = show.uppercaseString
        
        // load followers if tapped on followers label
        loadFollowers(show)
        
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "Background_Blue_Joint.jpg")!)
        
    }
    
    
    // loading followers
    func loadFollowers(type: String) {
        firebase.child(type).child(user).observeEventType(.Value, withBlock: { snapshot in
            if snapshot.exists() {
                //sorted = (snapshot.value!.allValues as NSArray).sortedArrayUsingDescriptors([NSSortDescriptor(key: "date", ascending: false)])
                self.usernameArray.removeAll(keepCapacity: false)
                self.nameArray.removeAll(keepCapacity: false)
                self.avaArray.removeAll(keepCapacity: false)

                for post1 in snapshot.children{
                    // let k = post.key!
                    //dispatch_group_enter(picturesGroup)
                    let post = post1 as! FIRDataSnapshot
                    //print(post.key)
                    let userID = post.key as! String
                    
                    
                    //                    self.storage.referenceForURL(post.value.objectForKey("photoUrl") as! String).dataWithMaxSize(25 * 1024 * 1024, completion: { (data, error) -> Void in
                    //                        let image = UIImage(data: data!)
                    //
                    //                        // objc_sync_enter(self.nameArray)
                    //                        // objc_sync_enter(self.nameArray)
                    //                        self.picArray.append(image! as! UIImage)
                    //
                    //                        //objc_sync_exit(self.nameArray)
                    //                        //self.tableView.reloadData()
                    //                        //self.scrollToBottom()
                    //
                    //                        // objc_sync_exit(self.nameArray)
                    //
                    //                    })
                    
                    //self.DLImages()
                    //                    self.picArrayURL.append(post.value.objectForKey("photoUrl") as! String)
                    //                    let url = post.value.objectForKey("photoUrl") as! String
                    //                    //var d = self.myDictionaryURL
                    //                    self.myDictionaryURL.updateValue(url, forKey: i)
                    //                    i = i + 1
                    
                    
                    firebase.child("Users").child(userID).observeEventType(.Value, withBlock: { snapshot in
                        
                        let first = (snapshot.value!.objectForKey("first_name") as? String)
                        let last = (snapshot.value!.objectForKey("last_name") as? String)
                        
                        let fullname = first!+" "+last!
                        self.nameArray.append(fullname)
                        
                        //                        self.tableView.reloadData()
                        //                        self.collectionView.reloadData()
                        let avaURL = (snapshot.value!.objectForKey("ProfilPicUrl") as! String)
                        let url = NSURL(string: avaURL)
                        if let data = NSData(contentsOfURL: url!){ //make sure your image in this url does exist, otherwise unwrap in a if let check
                            self.avaArray.append(UIImage(data: data) as UIImage!)
                            self.avaArray = self.avaArray.reverse()
                            self.nameArray = self.nameArray.reverse()
                            
                            self.tableView.reloadData()
                        }
                        
                        }
                        
                        
                    ){ (error) in
                        print(error.localizedDescription)
                    }
                    
                    
                    //                    //let datestring = post.value.objectForKey("date") as! String
                    //                    if let datestring = post.value.objectForKey("date") as? String{
                    //                        var dateFormatter = NSDateFormatter()
                    //                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                    //                        let date = dateFormatter.dateFromString(datestring)
                    //                        self.dateArray.append(date)
                    //                    }
                    self.usernameArray.append(userID as! String)
                    
                    //                    self.titleArray.append(post.value.objectForKey("title") as! String)
                    //                    self.uuidArray.append(post.key! as String!)
                    
                    
                    
                    // dispatch_async(dispatch_get_main_queue(), {
                    //  self.tableView.reloadData()
                    //self.collectionView.reloadData()
                    //                    self.refresher.endRefreshing()
                    // });
                    
                    
                    
                    
                }}
            
            //self.picArray = self.picArray.reverse()
            
            //
            //            for (bookid, title) in self.myDictionaryURL {
            //                //println("Book ID: \(bookid) Title: \(title)")
            //                self.storage.referenceForURL(title).dataWithMaxSize(25 * 1024 * 1024, completion: { (data, error) -> Void in
            //                    let image = UIImage(data: data!)
            //                    self.myDictionaryImage[bookid] = image!
            //
            //
            //
            //
            //                    self.titleArray = self.titleArray.reverse()
            //                    //self.picArray.append(image! as! UIImage)
            //
            //                    dispatch_group_leave(picturesGroup)
            //                })
            //            }
            
            
            
            //            for url in self.picArrayURL{
            //                self.storage.referenceForURL(url).dataWithMaxSize(25 * 1024 * 1024, completion: { (data, error) -> Void in
            //                    let image = UIImage(data: data!)
            //
            //
            //                    self.picArray.append(image! as! UIImage)
            //
            //                    dispatch_group_leave(picturesGroup)
            //                })
            //            }
            
            
            //
            //            dispatch_group_notify(picturesGroup, dispatch_get_main_queue()) {
            //                let imagesSorted = Array(self.myDictionaryImage.keys).sort(>)
            //                print(imagesSorted)
            //                // let y = sort(imagesSorted)  //{self.myDictionaryImage[$0] < self.myDictionaryImage[$1]}) //self.myDictionaryImage.sorted() { $0.0 < $1.0 }
            //
            //                for a in imagesSorted as! [Int] {
            //                    self.picArray.append(self.myDictionaryImage[a]!)
            //                }
            //                //self.picArray.reverse()
            //                self.tableView.reloadData()
            //
            //            }
            
            
            //self.comments.append(snapshot)
            //self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.comments.count-1, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Automatic)
        }){ (error) in
            print(error.localizedDescription)
        }
        
        
        //        // STEP 1. Find in FOLLOW class people following User
        //        // find followers of user
        //        let followQuery = PFQuery(className: "follow")
        //        followQuery.whereKey("following", equalTo: user)
        //        followQuery.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) -> Void in
        //            if error == nil {
        //
        //                // clean up
        //                self.followArray.removeAll(keepCapacity: false)
        //
        //                // STEP 2. Hold received data
        //                // find related objects depending on query settings
        //                for object in objects! {
        //                    self.followArray.append(object.valueForKey("follower") as! String)
        //                }
        //
        //                // STEP 3. Find in USER class data of users following "User"
        //                // find users following user
        //                let query = PFUser.query()
        //                query?.whereKey("username", containedIn: self.followArray)
        //                query?.addDescendingOrder("createdAt")
        //                query?.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
        //                    if error == nil {
        //
        //                        // clean up
        //                        self.usernameArray.removeAll(keepCapacity: false)
        //                        self.firstnameArray.removeAll(keepCapacity: false)
        //                        self.nameArray.removeAll(keepCapacity: false)
        //                        self.avaArray.removeAll(keepCapacity: false)
        //
        //                        // find related objects in User class of Parse
        //                        for object in objects! {
        //
        //                            let first = (object.objectForKey("first_name") as? String)
        //                            let last = (object.objectForKey("last_name") as? String)
        //
        //
        //                            self.usernameArray.append(object.objectForKey("username") as! String)
        //                            self.firstnameArray.append(first!)
        //                            self.nameArray.append(first!+" "+last!)
        //                            self.avaArray.append(object.objectForKey("picture_file") as! PFFile)
        //                            self.tableView.reloadData()
        //                        }
        //                    } else {
        //                        print(error!.localizedDescription)
        //                    }
        //                })
        //
        //            } else {
        //                print(error!.localizedDescription)
        //            }
        //        })
        
    }
    
    
    
    //class ViewController: CustomCellDelegate
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    
    // cell numb
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernameArray.count
    }
    
    
    // cell height
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.size.width / 4
    }
    
    
    
    // cell config
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // define cell
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! followersCell
        cell.backgroundColor = UIColor(patternImage: UIImage(named: "Background_Blue_Joint.jpg")!)
        cell.username = usernameArray[indexPath.row]
        //cell.userShown =
        if usernameArray[indexPath.row] == (FIRAuth.auth()?.currentUser!.uid)! {
            cell.followBtn.hidden = true
        }
        // STEP 1. Connect data from serv to objects
        cell.usernameLbl.text = nameArray[indexPath.row]
        cell.avaImg.image = avaArray[indexPath.row]
        //        avaArray[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
        //            if error == nil {
        //                cell.avaImg.image = UIImage(data: data!)
        //            } else {
        //                print(error!.localizedDescription)
        //            }
        //        }
        
        firebase.child("Followings").child((FIRAuth.auth()?.currentUser!.uid)! ).child(usernameArray[indexPath.row]).observeSingleEventOfType(.Value, withBlock: { snapshot in
            if snapshot.exists() {
                cell.followBtn.setTitle("FOLLOWING", forState: UIControlState.Normal)
                cell.followBtn.backgroundColor = UIColor.greenColor()
            } else {
                cell.followBtn.setTitle("FOLLOW", forState: UIControlState.Normal)
                cell.followBtn.backgroundColor = .lightGrayColor()
            }
        })
        
        return cell
    }
    
    
    // selected some user
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if self.usernameArray[indexPath.row] == (FIRAuth.auth()?.currentUser!.uid)! {
            modeSelf = true
        }
        
        let home = self.storyboard?.instantiateViewControllerWithIdentifier("homeVC1") as! homeVC1
        home.userIdToDisplay = self.usernameArray[indexPath.row]
        home.goHome = modeSelf
        self.navigationController?.pushViewController(home, animated: true)
        modeSelf = false
        
        
        
    }
    
    
    
    
    //    private var selectedItems = [String]()
    //
    //    func cellButtonTapped(cell: followersCell) {
    //        let indexPath = self.tableView.indexPathForRowAtPoint(cell.center)!
    ////        let selectedItem = usernameArray[indexPath.row]
    //
    ////        if let selectedItemIndex = find(selectedItems, selectedItem) {
    ////            selectedItems.removeAtIndex(selectedItemIndex)
    ////        } else {
    ////            selectedItems.append(selectedItem)
    ////        }
    //
    //
    //        //let title = followBtn.titleForState(.Normal)
    //        let title = cell.followBtn.titleForState(.Normal)
    //
    //        // to follow
    //        if title == "FOLLOW" {
    //            firebase.child("Followings").child((FIRAuth.auth()?.currentUser!.uid)!).child(self.usernameArray[indexPath.row]).setValue(true)
    //            firebase.child("Followers").child(self.usernameArray[indexPath.row]).child((FIRAuth.auth()?.currentUser!.uid)!).setValue(true)
    //            print("folowed")
    //            cell.followBtn.setTitle("FOLLOWING", forState: UIControlState.Normal)
    //            cell.followBtn.backgroundColor = .greenColor()
    //            //self.likeLbl.text = "\(Int(self.likeLbl.text!)! + 1)"
    //
    //
    //
    ////            let object = PFObject(className: "follow")
    ////            object["follower"] = PFUser.currentUser()?.username
    ////            object["following"] = self.usernameArray[indexPath.row] //usernameLbl.text
    ////            object.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
    ////                if success {
    ////                    cell.followBtn.setTitle("FOLLOWING", forState: UIControlState.Normal)
    ////                    cell.followBtn.backgroundColor = .greenColor()
    ////                } else {
    ////                    print(error?.localizedDescription)
    ////                }
    ////            })
    //
    //            // unfollow
    //        } else {
    //            firebase.child("Followings").child(self.usernameArray[indexPath.row]).child((FIRAuth.auth()?.currentUser!.uid)!).removeValue()
    //            firebase.child("Followers").child((FIRAuth.auth()?.currentUser!.uid)!).child(self.usernameArray[indexPath.row]).removeValue()
    //            print("unfollowed")
    //            cell.followBtn.setTitle("FOLLOW", forState: UIControlState.Normal)
    //            cell.followBtn.backgroundColor = .lightGrayColor()
    //
    //            // send notification if we liked to refresh TableView
    //                       //self.likeLbl.text = "\(Int(self.likeLbl.text!)! - 1)"
    //
    ////            let query = PFQuery(className: "follow")
    ////            query.whereKey("follower", equalTo: PFUser.currentUser()!.username!)
    ////            query.whereKey("following", equalTo: self.usernameArray[indexPath.row])
    ////            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
    ////                if error == nil {
    ////
    ////                    for object in objects! {
    ////                        object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
    ////                            if success {
    ////                                cell.followBtn.setTitle("FOLLOW", forState: UIControlState.Normal)
    ////                                cell.followBtn.backgroundColor = .lightGrayColor()
    ////                            } else {
    ////                                print(error?.localizedDescription)
    ////                            }
    ////                        })
    ////                    }
    ////                    
    ////                } else {
    ////                    print(error?.localizedDescription)
    ////                }
    ////            })
    //            
    //        }
    //
    //    }
    

    
}
