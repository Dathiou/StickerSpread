//
//  followersVC.swift
//  StickerSpread
//
//  Created by Student iMac on 5/30/16.
//  Copyright © 2016 Student iMac. All rights reserved.
//

import UIKit
import Parse
import Firebase

var show = String()
var user = String()



class followersVC: UITableViewController, CustomCellDelegate {

    
    // arrays to hold data received from servers
    var nameArray = [String]()
    var usernameArray = [String]()
    var firstnameArray = [String]()
    var avaArray = [PFFile]()
    
    // array showing who do we follow or who followings us
    var followArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // title at the top
        self.navigationItem.title = show.uppercaseString

        // load followers if tapped on followers label
        if show == "followers" {
            loadFollowers()
        }
        
        // load followings if tapped on followings label
        if show == "followings" {
            loadFollowings()
        }
    }
    
    
    // loading followers
    func loadFollowers() {
        
        // STEP 1. Find in FOLLOW class people following User
        // find followers of user
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("following", equalTo: user)
        followQuery.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                
                // clean up
                self.followArray.removeAll(keepCapacity: false)
                
                // STEP 2. Hold received data
                // find related objects depending on query settings
                for object in objects! {
                    self.followArray.append(object.valueForKey("follower") as! String)
                }
                
                // STEP 3. Find in USER class data of users following "User"
                // find users following user
                let query = PFUser.query()
                query?.whereKey("username", containedIn: self.followArray)
                query?.addDescendingOrder("createdAt")
                query?.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                    if error == nil {
                        
                        // clean up
                        self.usernameArray.removeAll(keepCapacity: false)
                        self.firstnameArray.removeAll(keepCapacity: false)
                        self.nameArray.removeAll(keepCapacity: false)
                        self.avaArray.removeAll(keepCapacity: false)
                        
                        // find related objects in User class of Parse
                        for object in objects! {
                            
                            let first = (object.objectForKey("first_name") as? String)
                            let last = (object.objectForKey("last_name") as? String)
                            
                            
                            self.usernameArray.append(object.objectForKey("username") as! String)
                            self.firstnameArray.append(first!)
                            self.nameArray.append(first!+" "+last!)
                            self.avaArray.append(object.objectForKey("picture_file") as! PFFile)
                            self.tableView.reloadData()
                        }
                    } else {
                        print(error!.localizedDescription)
                    }
                })
                
            } else {
                print(error!.localizedDescription)
            }
        })
        
    }
    
    
    // loading followings
    func loadFollowings() {
        
        // STEP 1. Find people followed by User
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("follower", equalTo: user)
        followQuery.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                
                // clean up
                self.followArray.removeAll(keepCapacity: false)
                
                // STEP 2. Hold received data in followArray
                // find related objects in "follow" class of Parse
                for object in objects! {
                    self.followArray.append(object.valueForKey("following") as! String)
                }
                
                // STEP 3. Basing on followArray information (inside users) show infromation from User class of Parse
                // find users followeb by user
                let query = PFQuery(className: "_User")
                query.whereKey("username", containedIn: self.followArray)
                query.addDescendingOrder("createdAt")
                query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                    if error == nil {
                        
                        // clean up
                        self.usernameArray.removeAll(keepCapacity: false)
                        self.avaArray.removeAll(keepCapacity: false)
                        self.firstnameArray.removeAll(keepCapacity: false)
                        
                        // find related objects in "User" class of Parse
                        for object in objects! {
                            let first = (object.objectForKey("first_name") as? String)
                            let last = (object.objectForKey("last_name") as? String)
                            
                            
                            self.usernameArray.append(object.objectForKey("username") as! String)
                            self.nameArray.append(first!+" "+last!)
                            self.firstnameArray.append(first!)
                            self.avaArray.append(object.objectForKey("picture_file") as! PFFile)
                            self.tableView.reloadData()
                        }
                    } else {
                        print(error!.localizedDescription)
                    }
                })
                
            } else {
                print(error!.localizedDescription)
            }
        })
        
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
         cell.delegate = self
        // STEP 1. Connect data from serv to objects
        cell.usernameLbl.text = nameArray[indexPath.row]
        avaArray[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
            if error == nil {
                cell.avaImg.image = UIImage(data: data!)
            } else {
                print(error!.localizedDescription)
            }
        }
        
        
        // STEP 2. Show do user following or do not
        let query = PFQuery(className: "follow")
        query.whereKey("follower", equalTo: PFUser.currentUser()!.username!)
        query.whereKey("following", equalTo: usernameArray[indexPath.row])
        query.countObjectsInBackgroundWithBlock ({ (count:Int32, error:NSError?) -> Void in
            if error == nil {
                if count == 0 {
                    cell.followBtn.setTitle("FOLLOW", forState: UIControlState.Normal)
                    cell.followBtn.backgroundColor = .lightGrayColor()
                } else {
                    cell.followBtn.setTitle("FOLLOWING", forState: UIControlState.Normal)
                    cell.followBtn.backgroundColor = UIColor.greenColor()
                }
            }
        })
        
        
        // STEP 3. Hide follow button for current user
        let first = (PFUser.currentUser()!.objectForKey("first_name") as? String)?.uppercaseString
        let last = (PFUser.currentUser()!.objectForKey("last_name") as? String)?.uppercaseString
        
        
        if usernameArray[indexPath.row] == PFUser.currentUser()?.username  {
            cell.followBtn.hidden = true
        }
        
        
        
        
        
        
        
        return cell
    }
    
    
    // selected some user
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // recall cell to call further cell's data
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! followersCell
        
        // if user tapped on himself, go home, else go guest
        if self.usernameArray[indexPath.row] == PFUser.currentUser()!.username! {
            let home = self.storyboard?.instantiateViewControllerWithIdentifier("homeVC") as! homeVC
            self.navigationController?.pushViewController(home, animated: true)
        } else {
            guestname.append(self.usernameArray[indexPath.row])
            guestfirstname.append(self.firstnameArray[indexPath.row])
            let guest = self.storyboard?.instantiateViewControllerWithIdentifier("guestVC") as! guestVC
            self.navigationController?.pushViewController(guest, animated: true)
        }
    }
    
    
    
    
    private var selectedItems = [String]()
    
    func cellButtonTapped(cell: followersCell) {
        let indexPath = self.tableView.indexPathForRowAtPoint(cell.center)!
//        let selectedItem = usernameArray[indexPath.row]
        
//        if let selectedItemIndex = find(selectedItems, selectedItem) {
//            selectedItems.removeAtIndex(selectedItemIndex)
//        } else {
//            selectedItems.append(selectedItem)
//        }
        
        
        //let title = followBtn.titleForState(.Normal)
        let title = cell.followBtn.titleForState(.Normal)
        
        // to follow
        if title == "FOLLOW" {
            firebase.child("Followings").child((FIRAuth.auth()?.currentUser!.uid)!).child(self.usernameArray[indexPath.row]).setValue(true)
            firebase.child("Followers").child(self.usernameArray[indexPath.row]).child((FIRAuth.auth()?.currentUser!.uid)!).setValue(true)
            print("folowed")
            cell.followBtn.setTitle("FOLLOWING", forState: UIControlState.Normal)
            cell.followBtn.backgroundColor = .greenColor()
            //self.likeLbl.text = "\(Int(self.likeLbl.text!)! + 1)"
            

            
//            let object = PFObject(className: "follow")
//            object["follower"] = PFUser.currentUser()?.username
//            object["following"] = self.usernameArray[indexPath.row] //usernameLbl.text
//            object.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
//                if success {
//                    cell.followBtn.setTitle("FOLLOWING", forState: UIControlState.Normal)
//                    cell.followBtn.backgroundColor = .greenColor()
//                } else {
//                    print(error?.localizedDescription)
//                }
//            })
            
            // unfollow
        } else {
            firebase.child("Followings").child(self.usernameArray[indexPath.row]).child((FIRAuth.auth()?.currentUser!.uid)!).removeValue()
            firebase.child("Followers").child((FIRAuth.auth()?.currentUser!.uid)!).child(self.usernameArray[indexPath.row]).removeValue()
            print("unfollowed")
            cell.followBtn.setTitle("FOLLOW", forState: UIControlState.Normal)
            cell.followBtn.backgroundColor = .lightGrayColor()
            
            // send notification if we liked to refresh TableView
                       //self.likeLbl.text = "\(Int(self.likeLbl.text!)! - 1)"

//            let query = PFQuery(className: "follow")
//            query.whereKey("follower", equalTo: PFUser.currentUser()!.username!)
//            query.whereKey("following", equalTo: self.usernameArray[indexPath.row])
//            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
//                if error == nil {
//                    
//                    for object in objects! {
//                        object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
//                            if success {
//                                cell.followBtn.setTitle("FOLLOW", forState: UIControlState.Normal)
//                                cell.followBtn.backgroundColor = .lightGrayColor()
//                            } else {
//                                print(error?.localizedDescription)
//                            }
//                        })
//                    }
//                    
//                } else {
//                    print(error?.localizedDescription)
//                }
//            })
            
        }

    }

    
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
