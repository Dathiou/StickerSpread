////
////  ChooseUserViewController.swift
////  quickChat
////
////  Created by David Kababyan on 06/03/2016.
////  Copyright © 2016 David Kababyan. All rights reserved.
////
//
//import UIKit
//import Parse
//
//protocol ChooseUserDelegate {
//    func chreatChatroom(withUser: PFUser)
//}
//
//class ChooseUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    
//    @IBOutlet weak var tableView: UITableView!
//    
//    
//    var delegate: ChooseUserDelegate!
//    //var users: [BackendlessUser] = []
//    var users: [PFUser] = []
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//       loadUsers()
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    
//    //MARK: UITableviewDataSorce
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return users.count
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath as IndexPath)
//        
//        let user = users[indexPath.row]
//        
//        cell.textLabel?.text = user.username
//        
//        return cell
//    }
//    
//    //MARK: UITableviewDelegate
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        let user = users[indexPath.row]
//        
//        delegate.chreatChatroom(withUser: user)
//        
//        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
//        self.dismiss(animated: true, completion: nil)
//    }
//    
//    
//    //MARK: IBactions
//    @IBAction func cancelButtonPressed(sender: AnyObject) {
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    //MARK: Load Backendless Users
//    
//    func loadUsers() {
//        
//        let query = PFQuery(className: "_User")
//        query.whereKey("username", notEqualTo: PFUser.current()!.username!)
//        
//        
//        //let query = PFQuery(className: "_User")
//        //query.whereKey("username", containedIn: self.followArray)
//        query.addDescendingOrder("createdAt")
//        query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
//            if error == nil {
//                
//               
//                
//                // find related objects in "User" class of Parse
//                for object in objects! {
////                    let first = (object.objectForKey("first_name") as? String)
////                    let last = (object.objectForKey("last_name") as? String)
//                    
//                    self.users.append(object as! PFUser)
////                    
////                    self.usernameArray.append(object.objectForKey("username") as! String)
////                    self.nameArray.append(first!+" "+last!)
////                    self.firstnameArray.append(first!)
////                    self.avaArray.append(object.objectForKey("picture_file") as! PFFile)
//                    self.tableView.reloadData()
//                }
//            } else {
//                print(error!.localizedDescription)
//            }
//        })
//        
//        
//        
////        let whereClause = "objectId != '\(backendless.userService.currentUser.objectId)'"
////        
////        let dataQuery = BackendlessDataQuery()
////        dataQuery.whereClause = whereClause
////        
////        let dataStore = backendless.persistenceService.of(BackendlessUser.ofClass())
////        dataStore.find(dataQuery, response: { (users : BackendlessCollection!) -> Void in
////            
////            self.users = users.data as! [BackendlessUser]
////            
////            self.tableView.reloadData()
////            
////            
////            }) { (fault : Fault!) -> Void in
////                print("Error, couldnt retrive users: \(fault)")
////        }
//    }
//    
//}
