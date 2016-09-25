//
//  OutgoingMessage.swift
//  quickChat
//
//  Created by David Kababyan on 07/03/2016.
//  Copyright © 2016 David Kababyan. All rights reserved.
//

import Foundation
import JSQMessagesViewController

class OutgoingMessage {
    
    //change
    //private let firebase = Firebase(url: "https://quickchataplication.firebaseio.com/Message")
    private let ref = firebase.child("Message")
    
    let messageDictionary: NSMutableDictionary
    
    init (message: String, senderId: String, senderName: String, date: NSDate, status: String, type: String) {
        
        messageDictionary = NSMutableDictionary(objects: [message, senderId, senderName, dateFormatter().string(from: date as Date), status, type], forKeys: ["message" as NSCopying, "senderId" as NSCopying, "senderName" as NSCopying, "date" as NSCopying, "status" as NSCopying, "type" as NSCopying])
    }
    
    init(message: String, latitude: NSNumber, longitude: NSNumber, senderId: String, senderName: String, date: NSDate, status: String, type: String) {
        
        messageDictionary = NSMutableDictionary(objects: [message, latitude, longitude, senderId, senderName, dateFormatter().string(from: date as Date), status, type], forKeys: ["message" as NSCopying, "latitude" as NSCopying, "longitude" as NSCopying, "senderId" as NSCopying, "senderName" as NSCopying, "date" as NSCopying, "status" as NSCopying, "type" as NSCopying])
    }
    
    init (message: String, pictureData: NSData, senderId: String, senderName: String, date: NSDate, status: String, type: String) {
        
        let pic = pictureData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        
        messageDictionary = NSMutableDictionary(objects: [message, pic, senderId, senderName, dateFormatter().string(from: date as Date), status, type], forKeys: ["message" as NSCopying, "picture" as NSCopying, "senderId" as NSCopying, "senderName" as NSCopying, "date" as NSCopying, "status" as NSCopying, "type" as NSCopying])
    }
    
    func sendMessage(chatRoomID: String, item: NSMutableDictionary) {
        
        let reference = ref.child(chatRoomID).childByAutoId()
        
        item["messageId"] = reference.key
        
        reference.setValue(item) { (error, ref) -> Void in
            if error != nil {
                print("Error, couldnt send message")
            }
        }
        
       // SendPushNotification(chatRoomID, message: (item["message"] as? String)!)
        UpdateRecents(chatRoomID: chatRoomID, lastMessage: (item["message"] as? String)!)
    }

    
    
}
