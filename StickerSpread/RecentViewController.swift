//
//  RecentViewController.swift
//  quickChat
//
//  Created by David Kababyan on 06/03/2016.
//  Copyright © 2016 David Kababyan. All rights reserved.
//

import UIKit

import FirebaseAuth
import FirebaseStorage

class RecentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{ //ChooseUserDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var recents: [NSDictionary] = []
    var nameArray = [String]()
    let storage = FIRStorage.storage()
    let storageRef = FIRStorage.storage()
        .reference(forURL: "gs://stickerspread-4f3a9.appspot.com")
    var profPicURL = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Connections"
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background_Blue_Joint.jpg")!)
        //self.view.alpha = 0.5
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "Background_Blue_Joint.jpg")!)
        //let bot =
        //bot.backgroundColor = UIColor.clear.withAlphaComponent(0.5)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        //tableView.tableFooterView?.alpha = 0.9
        loadRecents()
        //self.tableView.allowsMultipleSelectionDuringEditing = false
    }
//    override func viewDidAppear(_ animated: Bool) {
//        
//        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height:tableView.contentSize.height)
//
//    }
//
//    override func viewDidLayoutSubviews(){
//        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height:tableView.contentSize.height)
//        tableView.reloadData()
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITableviewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! RecentTableViewCell
        
        let recent = recents[indexPath.row]
        
        cell.bindData(recent: recent)
        print(recent)
       // cell.avatarImageView.loadImageUsingCacheWithUrlString(urlString: (recent.object(forKey: "ProfilPicUrl") as? String)!)
        cell.avatarImageView.loadImageUsingCacheWithUrlString(urlString: profPicURL[indexPath.row])
        cell.nameLable.text = nameArray[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.alpha = 0
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
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
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "recentToChooseUserVC" {
            //let vc = segue.destination as! ChooseUserViewController
            //vc.delegate = self
        }
        
        if segue.identifier == "recentToChatSeg" {
            let indexPath = sender as! NSIndexPath
            let chatVC = segue.destination as! ChatViewController
            //chatVC.hidesBottomBarWhenPushed = true
            
            
            let recent = recents[indexPath.row]
            chatVC.withUserIDProfPicUrl = profPicURL[indexPath.row]
            chatVC.recent = recent
            chatVC.from = "RecentVC"
            chatVC.withUserID = (recent["withUserUserId"] as? String)!
            chatVC.WithName = nameArray[indexPath.row]
            chatVC.chatRoomId = recent["chatRoomID"] as? String
            chatVC.recentId = recent["recentId"] as? String
            // let a = recent["chatRoomID"] as? String
        }
        
    }
    
    //MARK: ChooseUserDelegate
    
//    func chreatChatroom(withUser: String) {
//        
//        let chatVC = ChatViewController()
//        //chatVC.hidesBottomBarWhenPushed = true
//        
//        navigationController?.pushViewController(chatVC, animated: true)
//        self.hidesBottomBarWhenPushed = true
//        chatVC.withUserID = withUser
//        chatVC.chatRoomId = startChat(userId1: (FIRAuth.auth()?.currentUser?.uid)!, userId2: withUser)
//    }
    
    //MARK: Load Recents from firebase
    func loadRecents() {
        //firebase.child("Recent").removeValue()
        //firebase.child("Message").removeValue()
        let picturesGroup = DispatchGroup()
        let queue = DispatchQueue.global(qos: .default)
        let userID = FIRAuth.auth()?.currentUser?.uid
        firebase.child("Recent").queryOrdered(byChild: "userId").queryEqual(toValue: userID)
            .observe(.value, with: { snapshot in
           
            self.recents.removeAll()
            self.profPicURL.removeAll()
            self.nameArray.removeAll()
            
            if snapshot.exists() {
                
                let sorted = ((snapshot.value! as AnyObject).allValues as NSArray).sortedArray(using: [NSSortDescriptor(key: "date", ascending: false)])
                
                for recent in sorted {
                    
                    
                    let withUserID = (recent as AnyObject).object(forKey : "withUserUserId") as! String
                    picturesGroup.enter()
                    queue.async(execute: {
                    firebase.child("Users").child(withUserID).observe(.value, with: { snapshot1 in
                        
                        if snapshot1.exists() {
                        let first = ((snapshot1.value! as AnyObject).value(forKey:"first_name") as? String)
                        let last = ((snapshot1.value! as AnyObject).value(forKey:"last_name") as? String)
                        
                        let fullname = first!+" "+last!
                        self.nameArray.append(fullname)

                        let avaURL = ((snapshot1.value! as AnyObject).value(forKey:"ProfilPicUrl") as! String)
                        self.profPicURL.append(avaURL)
                        (recent as! NSDictionary).setValue(avaURL,forKey:"ProfilPicUrl")
                        self.recents.append(recent as! NSDictionary)
                        picturesGroup.leave()
                        }
                        }
                        
                    ){ (error) in
                        print(error.localizedDescription)
                    }
                        
                    })
                    
                    
                    //add functio to have offline access as well, this will download with user recent as well so that we will not create it again
                    //let a = recent["chatRoomID"]! as! String
//                    firebase.child("Recent").queryOrdered(byChild: "chatRoomID").queryEqual( toValue: (recent as AnyObject).value(forKey: "chatRoomID")! as! String).observe(.value, with: {
//                        snapshot in
//                    })
                    
                    
                    
                }
                picturesGroup.notify(queue: DispatchQueue.main, execute:{
                    
                    self.tableView.reloadData()
//                    self.tableView.frame = CGRect(x: self.tableView.frame.origin.x, y: self.tableView.frame.origin.y, width: self.tableView.frame.size.width, height:self.tableView.contentSize.height)
                })

            }

        })
        
    }

}
