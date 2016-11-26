//
//  followersVC.swift
//  StickerSpread
//
//  Created by Student iMac on 5/30/16.
//  Copyright © 2016 Student iMac. All rights reserved.
//

import UIKit
import Firebase

var show1 = String()
var user = String()



class followersVC: UITableViewController {
    
    var modeSelf = false
    // arrays to hold data received from servers
    var nameArray = [String]()
    var usernameArray = [String]()
    var firstnameArray = [String]()
    var avaArray = [UIImage]()
    var profilPicURL = [String]()
    
    // array showing who do we follow or who followings us
    var followArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // title at the top
        self.navigationItem.title = show1.uppercased()
        
        // load followers if tapped on followers label
        loadFollowers(type: show1)
        
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "Background_Blue_Joint.jpg")!)
        
    }
    
    
    // loading followers
    func loadFollowers(type: String) {
        
        let picturesGroup = DispatchGroup()
        //.queryOrderedByChild("date")
        firebase.child(type).child(user).queryOrdered(byChild: "Date").observe(.value, with: { snapshot in
            if snapshot.exists() {
                //sorted = (snapshot.value!.allValues as NSArray).sortedArrayUsingDescriptors([NSSortDescriptor(key: "date", ascending: false)])
                self.usernameArray.removeAll(keepingCapacity: false)
                self.nameArray.removeAll(keepingCapacity: false)
                self.avaArray.removeAll(keepingCapacity: false)
                self.profilPicURL.removeAll(keepingCapacity: false)

                for post1 in snapshot.children{
                     picturesGroup.enter()
                    // let k = post.key!
                    //dispatch_group_enter(picturesGroup)
                    let post = post1 as! FIRDataSnapshot
                    //print(post.key)
                    let userID = post.key 
                    
                    
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
                    
                    
                    firebase.child("Users").child(userID).observe(.value, with: { snapshot in
                        print(snapshot)
                        let first = (snapshot.value! as AnyObject).value(forKey: "first_name") as! String
                        let last = (snapshot.value! as AnyObject).value(forKey: "last_name") as! String
                        
                        let fullname = first+" "+last
                        self.nameArray.append(fullname)
 
                        let avaURL = (snapshot.value! as AnyObject).value(forKey: "ProfilPicUrl") as! String
                        self.profilPicURL.append(avaURL)
//                        let url = NSURL(string: avaURL)
//                        if let data = NSData(contentsOf: url! as URL){ //make sure your image in this url does exist, otherwise unwrap in a if let check
//                            self.avaArray.append(UIImage(data: data as Data) as UIImage!)
//                            self.avaArray = self.avaArray.reversed()
//                            self.nameArray = self.nameArray.reversed()
//                            
//                            //self.tableView.reloadData()
//                        }
                        picturesGroup.leave()
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
                    
                    picturesGroup.notify(queue:  DispatchQueue.main){
                    
                        self.usernameArray.append(userID )
                        self.usernameArray = self.usernameArray.reversed()
                        
                        self.tableView.reloadData()

                    }
                    
                    //                    self.titleArray.append(post.value.objectForKey("title") as! String)
                    //                    self.uuidArray.append(post.key! as String!)
                    
                    
                    
                    // dispatch_async(dispatch_get_main_queue(), {
                    //  self.tableView.reloadData()
                    //self.collectionView.reloadData()
                    //                    self.refresher.endRefreshing()
                    // });
                    
                    
                    
                    
                }}
            
            //self.picArray = self.picArray.reverse()
            
                     
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
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernameArray.count
    }
    
    
    // cell height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.width / 4
    }
    
    
    
    // cell config
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // define cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! followersCell
        cell.backgroundColor = UIColor(patternImage: UIImage(named: "Background_Blue_Joint.jpg")!)
        cell.username = usernameArray[indexPath.row]
        //cell.userShown =
        if usernameArray[indexPath.row] == (FIRAuth.auth()?.currentUser!.uid)! {
            cell.followBtn.isHidden = true
        }
        // STEP 1. Connect data from serv to objects
        cell.usernameLbl.text = nameArray[indexPath.row]
        cell.avaImg.loadImageUsingCacheWithUrlString(urlString: profilPicURL[indexPath.row])//.image = avaArray[indexPath.row]
        //        avaArray[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
        //            if error == nil {
        //                cell.avaImg.image = UIImage(data: data!)
        //            } else {
        //                print(error!.localizedDescription)
        //            }
        //        }
        
        firebase.child("Followings").child((FIRAuth.auth()?.currentUser!.uid)! ).child(usernameArray[indexPath.row]).observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                cell.followBtn.setTitle("FOLLOWING", for: UIControlState.normal)
                cell.followBtn.backgroundColor = UIColor.green
            } else {
                cell.followBtn.setTitle("FOLLOW", for: UIControlState.normal)
                cell.followBtn.backgroundColor = .lightGray
            }
        })
        
        return cell
    }
    
    
    // selected some user
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.usernameArray[indexPath.row] == (FIRAuth.auth()?.currentUser!.uid)! {
            modeSelf = true
        }
        
        let home = self.storyboard?.instantiateViewController(withIdentifier: "homeVC1") as! homeVC1
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
