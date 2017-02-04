//
//  Recent.swift
//  quickChat
//
//  Created by David Kababyan on 06/03/2016.
//  Copyright © 2016 David Kababyan. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase


//------Constants--------\\
public let kAVATARSTATE = "avatarState"
public let kFIRSTRUN = "firstRun"
//--------\\



//let firebase = Firebase(url: "https://quickchataplication.firebaseio.com/")
var firebase = FIRDatabase.database().reference()
//let backendless = Backendless.sharedInstance()


//MARK: Create Chatroom

func startChat(userId1: String, userId2: String) -> String {

    //user 1 is current user

    
    var chatRoomId: String = ""
    
    let value = userId1.compare(userId2).rawValue
    
    if value < 0 {
        chatRoomId = userId1.appendingFormat(userId2)
    } else {
        chatRoomId = userId2.appendingFormat(userId1)
    }
    
    let members = [userId1, userId2]
    
    //create recent
    CreateRecent(userId: userId1, chatRoomID: chatRoomId, members: members, withUserUsername: userId1, withUseruserId: userId2)
    CreateRecent(userId: userId2, chatRoomID: chatRoomId, members: members, withUserUsername: userId2, withUseruserId: userId1)
    
    return chatRoomId
}

//MARK: Create RecentItem

func CreateRecent(userId: String, chatRoomID: String, members: [String], withUserUsername: String, withUseruserId: String) {
    
    //change
    firebase.child("Recent").queryOrdered(byChild: "chatRoomID").queryEqual(toValue: chatRoomID).observeSingleEvent(of: .value, with:{
        snapshot in
        
        var createRecent = true
        
        //check if we have a result
        if snapshot.exists() {
            for recent in (snapshot.value! as AnyObject).allValues {
                print(recent)
              //  print (recent["userId"])
                //if we already have recent with passed userId, we dont create a new one
                //let a = recent.objectForKey(["userId"]) as? String
               // if a == userId {
                if (recent as AnyObject).value(forKey:"userId")! as! String == userId {
                    createRecent = false
                }
            }
        }
        
        if createRecent {
            
            CreateRecentItem(userId: userId, chatRoomID: chatRoomID, members: members, withUserUsername: withUserUsername, withUserUserId: withUseruserId)
        }
    })
}


func CreateRecentItem(userId: String, chatRoomID: String, members: [String], withUserUsername: String, withUserUserId: String) {
    
    let ref = firebase.child("Recent").childByAutoId()
    
    let recentId = ref.key
    let date = dateFormatter().string(from: NSDate() as Date)
    
    let recent = ["recentId" : recentId, "userId" : userId, "chatRoomID" : chatRoomID, "members" : members, "withUserUsername" : withUserUsername, "lastMessage" : "", "counter" : 0, "date" : date, "withUserUserId" : withUserUserId] as [String : Any]
    
    //save to firebase
    ref.setValue(recent) { (error, ref) -> Void in
        if error != nil {
            print("error creating recent \(error)")
        }
    }
}

//MARK: Update Recent

func UpdateRecents(chatRoomID: String, lastMessage: String) {
    
    firebase.child("Recent").queryOrdered(byChild: "chatRoomID").queryEqual(toValue: chatRoomID).observeSingleEvent(of: .value, with: {
        snapshot in
        
        if snapshot.exists() {
            
            for recent in (snapshot.value! as AnyObject).allValues {
                UpdateRecentItem(recent: recent as! NSDictionary, lastMessage: lastMessage)
            }
        }
    })
}

func UpdateRecentItem(recent: NSDictionary, lastMessage: String) {
    let date = dateFormatter().string(from: NSDate() as Date)
    
    var counter = recent["counter"] as! Int
    
    if recent["userId"] as? String != FIRAuth.auth()?.currentUser?.uid {
        counter += 1
    }
    
    let values = ["lastMessage" : lastMessage, "counter" : counter, "date" : date] as [String : Any]
    
    //change
    firebase.child("Recent").child((recent["recentId"] as? String)!).updateChildValues(values as [NSObject : AnyObject], withCompletionBlock: {
        (error, ref) -> Void in
        
        if error != nil {
            print("Error couldnt update recent item")
        }
    })
}

//MARK: Restart Recent Chat

func RestartRecentChat(recent: NSDictionary) {
    
    for userId in recent["members"] as! [String] {
        
        if userId != FIRAuth.auth()?.currentUser?.uid {
            
            CreateRecent(userId: userId, chatRoomID: (recent["chatRoomID"] as? String)!, members: recent["members"] as! [String], withUserUsername: (FIRAuth.auth()?.currentUser?.uid)!, withUseruserId: (FIRAuth.auth()?.currentUser?.uid)! )
        }
    }
}


//MARK: Delete Recent functions

func DeleteRecentItem(recent: NSDictionary) {
    firebase.child("Recent").child((recent["recentId"] as? String)!).removeValue { (error, ref) -> Void in
        if error != nil {
            print("Error deleting recent item: \(error)")
        }
    }
}

//MARK: Clear recent counter function

func ClearRecentCounter(chatRoomID: String) {
    firebase.child("Recent").queryOrdered(byChild: "chatRoomID").queryEqual(toValue: chatRoomID).observeSingleEvent(of: .value, with: {
        snapshot in
      
        if snapshot.exists() {
            for recent in (snapshot.value! as AnyObject).allValues {
                if (recent as AnyObject).object(forKey:"userId") as? String == FIRAuth.auth()?.currentUser?.uid {
                    ClearRecentCounterItem(recent: recent as! NSDictionary)
                }
            }
        }
    })
}

func ClearRecentCounterItem(recent: NSDictionary) {
    
    firebase.child("Recent").child((recent["recentId"] as? String)!).updateChildValues(["counter" : 0]) { (error, ref) -> Void in
        if error != nil {
            print("Error couldnt update recents counter: \(error!.localizedDescription)")
        }
    }
}


//MARK: Helper functions

private let dateFormat = "yyyyMMddHHmmss"

func dateFormatter() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    
    return dateFormatter
}
