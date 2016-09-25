//
//  RecentViewController.swift
//  quickChat
//
//  Created by David Kababyan on 06/03/2016.
//  Copyright © 2016 David Kababyan. All rights reserved.
//

import UIKit
import Parse

class RecentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{ //ChooseUserDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var recents: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadRecents()
        //self.tableView.allowsMultipleSelectionDuringEditing = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITableviewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! RecentTableViewCell
        
        let recent = recents[indexPath.row]
        
        cell.bindData(recent: recent)
        
        return cell
    }
    
    //MARK: UITableviewDelegate functions
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let recent = recents[indexPath.row]
        
        //create recent for user2 users
        RestartRecentChat(recent: recent)
        
        
        performSegue(withIdentifier: "recentToChatSeg", sender: indexPath)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
     //   if (editingStyle == UITableViewCellEditingStyle.Delete){
            let recent = recents[indexPath.row]
            
            //remove recent from the array
            recents.remove(at: indexPath.row)
            
            //delete recent from firebase
            DeleteRecentItem(recent: recent)
            
            tableView.reloadData()
    //    }
    }
    

    //MARK: IBActions
    
    @IBAction func startNewChatBarButtonItemPressed(sender: AnyObject) {
        performSegue(withIdentifier: "recentToChooseUserVC", sender: self)
    }
    
    //MARK: Navigation
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "recentToChooseUserVC" {
            //let vc = segue.destination as! ChooseUserViewController
            //vc.delegate = self
        }
        
        if segue.identifier == "recentToChatSeg" {
            let indexPath = sender as! NSIndexPath
            let chatVC = segue.destination as! ChatViewController
            //chatVC.hidesBottomBarWhenPushed = true
            
            
            let recent = recents[indexPath.row]
            
            chatVC.recent = recent
            
            chatVC.chatRoomId = recent["chatRoomID"] as? String
            // let a = recent["chatRoomID"] as? String
        }
        
    }
    
    //MARK: ChooseUserDelegate
    
    func chreatChatroom(withUser: PFUser) {
        
        let chatVC = ChatViewController()
        //chatVC.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(chatVC, animated: true)

        chatVC.withUser = withUser
        chatVC.chatRoomId = startChat(user1: PFUser.current()!, user2: withUser)
    }
    
    //MARK: Load Recents from firebase
    
    func loadRecents() {
        let userparse = PFUser.current()!.username!
        firebase.child("Recent").queryOrdered(byChild: "userId").queryEqual(toValue: userparse).observe(.value, with: { snapshot in
           
            self.recents.removeAll()
            
            if snapshot.exists() {
                
                let sorted = ((snapshot.value! as AnyObject).allValues as NSArray).sortedArray(using: [NSSortDescriptor(key: "date", ascending: false)])
                
                for recent in sorted {
                    
                    self.recents.append(recent as! NSDictionary)
                    
                    //add functio to have offline access as well, this will download with user recent as well so that we will not create it again
                    //let a = recent["chatRoomID"]! as! String
                    firebase.child("Recent").queryOrdered(byChild: "chatRoomID").queryEqual( toValue: (recent as AnyObject).value(forKey: "chatRoomID")! as! String).observe(.value, with: {
                        snapshot in
                    })
                    
                    
                    
                }

            }
            
            self.tableView.reloadData()
        })
        
    }

}
