//
//  ChatViewController.swift
//  quickChat
//
//  Created by David Kababyan on 06/03/2016.
//  Copyright © 2016 David Kababyan. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Parse
import IDMPhotoBrowser

class ChatViewController: JSQMessagesViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let userDefaults = UserDefaults.standard
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //chaged
    //let ref = Firebase(url: "https://quickchataplication.firebaseio.com/Message")
    let ref = firebase.child("Message")

    var messages: [JSQMessage] = []
    var objects: [NSDictionary] = []
    var loaded: [NSDictionary] = []
    
    var avatarImagesDictionary: NSMutableDictionary?
    var avatarDictionary: NSMutableDictionary?

    var showAvatars: Bool = false
    var firstLoad: Bool?

    
    var withUser: PFUser?
    var recent: NSDictionary?
    
    var chatRoomId: String!
    
    var initialLoadComlete: Bool = false
    
    
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())

    override func viewWillAppear(_ animated: Bool) {
        loadUserDefaults()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //ClearRecentCounter(chatRoomId)
        ref.removeAllObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.senderId = PFUser.current()?.username //backendless.userService.currentUser.objectId
        self.senderDisplayName = PFUser.current()?.username //backendless.userService.currentUser.name
        
        
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
//        
//        if withUser?.objectId == nil {
//            getWithUserFromRecent(recent!, result: { (withUser) in
//                self.withUser = withUser
//                self.title = withUser.name
//                self.getAvatars()
//            })
//        } else {
//            self.title = withUser!.name
//            self.getAvatars()
//        }
        
        //load firebase messages
        loadmessages()
        
        self.inputToolbar?.contentView?.textView?.placeHolder = "New Message"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    //MARK: JSQMessages dataSource functions
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        
//        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
//        
//        let data = messages[indexPath.row]
//        
//        if data.senderId == PFUser.current()!.username {
//            cell.textView?.textColor = UIColor.whiteColor()
//        } else {
//            cell.textView?.textColor = UIColor.blackColor()
//        }
//        
//        return cell
//    }
    
    func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        
        let data = messages[indexPath.row]
        
       return data
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let data = messages[indexPath.row]
        
        if data.senderId == PFUser.current()?.username {
            return outgoingBubble
        } else {
            return incomingBubble
        }
    }
    
    func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        
        if indexPath.item % 3 == 0 {
            
            let message = messages[indexPath.item]
            
            return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
        }
        return nil
    }
    
    func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        
        if indexPath.item % 3 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        return 0.0
    }
    
    
    func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        
        let message = objects[indexPath.row]
        
        let status = message["status"] as! String
        
        if indexPath.row == (messages.count - 1) {
            return NSAttributedString(string: status)
        } else {
            return NSAttributedString(string: "")
        }
    }
    
    func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        
        if outgoing(item: objects[indexPath.row]) {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        } else {
            return 0.0
        }
    }
    
    func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        let message = messages[indexPath.row]
        let avatar = avatarDictionary!.object(forKey: message.senderId) as! JSQMessageAvatarImageDataSource
     
        return avatar
    }

    
    //MARK: JSQMessages Delegate function
    
    func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
        if text != "" {
            sendMessage(text: text, date: date, picture: nil, location: nil)
        }
        
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        
        let camera = Camera(delegate_: self)
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (alert: UIAlertAction!) -> Void in
            camera.PresentPhotoCamera(target: self, canEdit: true)
        }
        
        let sharePhoto = UIAlertAction(title: "Photo Library", style: .default) { (alert: UIAlertAction!) -> Void in
            camera.PresentPhotoLibrary(target: self, canEdit: true)
        }
        
//        let shareLoction = UIAlertAction(title: "Share Location", style: .Default) { (alert: UIAlertAction!) -> Void in
//            
//            if self.haveAccessToLocation() {
//                self.sendMessage(nil, date: NSDate(), picture: nil, location: "location")
//            }
//        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert : UIAlertAction!) -> Void in
            
            print("Cancel")
        }
        
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        //optionMenu.addAction(shareLoction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    //MARK: Send Message
    
    func sendMessage(text: String?, date: NSDate, picture: UIImage?, location: String?) {
        
        //var outgoingMessage = OutgoingMessage?()
     
        //if text message
        if let text = text {
            var outgoingMessage = OutgoingMessage(message: text, senderId: (PFUser.current()?.username!)!, senderName: (PFUser.current()?.username!)!, date: date, status: "Delivered", type: "text")
            outgoingMessage.sendMessage(chatRoomID: chatRoomId, item: outgoingMessage.messageDictionary)
        }
        
        //send picture message
        if let pic = picture {
            
            let imageData = UIImageJPEGRepresentation(pic, 1.0)
            
            var outgoingMessage = OutgoingMessage(message: "Picture", pictureData: imageData! as NSData, senderId: (PFUser.current()?.username!)!, senderName: (PFUser.current()?.username!)!, date: date, status: "Delivered", type: "picture")
            outgoingMessage.sendMessage(chatRoomID: chatRoomId, item: outgoingMessage.messageDictionary)
        }
        
//        if let _ = location {
//
//            let lat: NSNumber = NSNumber(value: (appDelegate.coordinate?.latitude)!)
//            let lng: NSNumber = NSNumber(value: (appDelegate.coordinate?.longitude)!)
//            
//            let outgoingMessage = OutgoingMessage(message: "Location", latitude: lat, longitude: lng, senderId: (PFUser.current()?.username!)!, senderName: (PFUser.current()?.username!)!, date: date, status: "Delivered", type: "location")
//        }
        
        //play message sent sound
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        self.finishSendingMessage()
        
        //OutgoingMessage!.sendMessage(chatRoomID: chatRoomId, item: OutgoingMessage!.messageDictionary)
        //outgoingMessage!.sendMessage(chatRoomId, item: OutgoingMessage!.messageDictionary)
    }
    
    
    //MARK: Load Messages
    
    func loadmessages() {
    
        
        ref.child(chatRoomId).observe(.childAdded, with: {
            snapshot in
            
            if snapshot.exists() {
                let item = (snapshot.value as? NSDictionary)!
                
                if self.initialLoadComlete {
                    let incoming = self.insertMessage(item: item)
                    
                    if incoming {
                        JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
                    }
                    
                    self.finishReceivingMessage(animated: true)
                    
                } else {
                    self.loaded.append(item)
                }
            }
        })
        
        
        ref.child(chatRoomId).observe(.childChanged, with: {
            snapshot in
            
            //updated message
        })
        
        
        ref.child(chatRoomId).observe(.childRemoved, with: {
            snapshot in
            
            //Deleted message
        })
        
        ref.child(chatRoomId).observeSingleEvent(of: .value, with:{
            snapshot in
            
            self.insertMessages()
            self.finishReceivingMessage(animated: true)
            self.initialLoadComlete = true
        })
        
    }
    
    func insertMessages() {
        
        for item in loaded {
            //create message
            insertMessage(item: item)
        }
    }
    
    func insertMessage(item: NSDictionary) -> Bool {
        
        let incomingMessage = IncomingMessage(collectionView_: self.collectionView!)
        
        let message = incomingMessage.createMessage(dictionary: item)
        
        objects.append(item)
        messages.append(message!)
        
        return incoming(item: item)
    }
    
    func incoming(item: NSDictionary) -> Bool {
        
        if PFUser.current()!.username == item["senderId"] as! String {
            print("have location")
            return false
        } else {
            return true
        }
    }
    
    func outgoing(item: NSDictionary) -> Bool {

        if PFUser.current()!.username == item["senderId"] as! String {
            return true
        } else {
            return false
        }
    }
    
    
    //MARK: Helper functions
    
    func haveAccessToLocation() -> Bool {
        if let _ = appDelegate.coordinate?.latitude {
            return true
        } else {
            print("no access to location")
            return false
        }
    }
    
//    func getAvatars() {
//        
//        if showAvatars {
//            
//            print("showAvatar")
//            collectionView?.collectionViewLayout.incomingAvatarViewSize = CGSizeMake(30, 30)
//            collectionView?.collectionViewLayout.outgoingAvatarViewSize = CGSizeMake(30, 30)
//            
//            //download avatars
//            avatarImageFromBackendlessUser(backendless.userService.currentUser)
//            avatarImageFromBackendlessUser(withUser!)
//            
//            //create avatars
//            createAvatars(avatarImagesDictionary)
//        }
//    }
    
//    func getWithUserFromRecent(recent: NSDictionary, result: (_ withUser: PFUser) -> Void) {
//        
//        let withUserId = recent["withUserUserId"] as? String
////        
////        let whereClause = "objectId = '\(withUserId!)'"
////        let dataQuery = BackendlessDataQuery()
////        dataQuery.whereClause = whereClause
////        
////        let dataStore = backendless.persistenceService.of(BackendlessUser.ofClass())
////        
////        dataStore.find(dataQuery, response: { (users : BackendlessCollection!) -> Void in
////            
////            let withUser = users.data.first as! BackendlessUser
////            
////            result(withUser: withUser)
////            
////            }) { (fault : Fault!) -> Void in
////                print("Server report an error : \(fault)")
////        }
//        
//        
//        let query = PFQuery(className: "_User")
//        query.whereKey("username", equalTo: withUserId!)
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
//                    //                    let first = (object.objectForKey("first_name") as? String)
//                    //                    let last = (object.objectForKey("last_name") as? String)
//                    let withUser = object as! PFUser
//                    
//                    result(withUser: withUser)
//                   // result(object as! PFUser : )
//                    //self.users.append(object as! PFUser)
//                    //
//                    //                    self.usernameArray.append(object.objectForKey("username") as! String)
//                    //                    self.nameArray.append(first!+" "+last!)
//                    //                    self.firstnameArray.append(first!)
//                    //                    self.avaArray.append(object.objectForKey("picture_file") as! PFFile)
//                    //self.tableView.reloadData()
//                }
//            } else {
//                print(error!.localizedDescription)
//            }
//        })
//
//        
//        
//        
//    }
//
//    func createAvatars(avatars: NSMutableDictionary?) {
//        
//        var currentUserAvatar = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "avatarPlaceholder"), diameter: 70)
//        var withUserAvatar = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "avatarPlaceholder"), diameter: 70)
//        
//        
//        if let avat = avatars {
//            if let currentUserAvatarImage = avat.objectForKey(backendless.userService.currentUser.objectId) {
//                
//                currentUserAvatar = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(data: currentUserAvatarImage as! NSData), diameter: 70)
//                self.collectionView?.reloadData()
//            }
//        }
//        
//        if let avat = avatars {
//            if let withUserAvatarImage = avat.objectForKey(withUser!.objectId!) {
//                
//                withUserAvatar = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(data: withUserAvatarImage as! NSData), diameter: 70)
//                self.collectionView?.reloadData()
//            }
//        }
//        
//        avatarDictionary = [backendless.userService.currentUser.objectId! : currentUserAvatar, withUser!.objectId! : withUserAvatar] 
//    }
    
//    func avatarImageFromBackendlessUser(user: BackendlessUser) {
//        
//        if let imageLink = user.getProperty("Avatar") {
//            
//            getImageFromURL(imageLink as! String, result: { (image) -> Void in
//                
//                let imageData = UIImageJPEGRepresentation(image!, 1.0)
//                
//                if self.avatarImagesDictionary != nil {
//                    
//                    self.avatarImagesDictionary!.removeObjectForKey(user.objectId)
//                    self.avatarImagesDictionary!.setObject(imageData!, forKey: user.objectId!)
//                } else {
//                    self.avatarImagesDictionary = [user.objectId! : imageData!]
//                }
//                self.createAvatars(self.avatarImagesDictionary)
//                
//            })
//        }
//    }
    
    //MARK: JSQDelegate functions
    
    func collectionView(collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath!) {
        
        let object = objects[indexPath.row]
        
        if object["type"] as! String == "picture" {
            
            let message = messages[indexPath.row]
            
            let mediaItem = message.media as! JSQPhotoMediaItem
            
            let photos = IDMPhoto.photos(withImages: [mediaItem.image])
            let browser = IDMPhotoBrowser(photos: photos)
            
            self.present(browser!, animated: true, completion: nil)
        }
        
        if object["type"] as! String == "location" {
            
            self.performSegue(withIdentifier: "chatToMapSeg", sender: indexPath)
        }
        
    }
    
    
    //MARK: UIIMagePickerController functions
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let picture = info[UIImagePickerControllerEditedImage] as! UIImage
        
        self.sendMessage(text: nil, date: NSDate(), picture: picture, location: nil)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        if segue.identifier == "chatToMapSeg" {
//            
//            let indexPath = sender as! NSIndexPath
//            let message = messages[indexPath.row]
//            
//            let mediaItem = message.media as! JSQLocationMediaItem
//            
//            let mapView = segue.destinationViewController as! MapViewController
//            mapView.location = mediaItem.location
//        }
//    }

    //MARK: UserDefaults functions
    
    func loadUserDefaults() {
        firstLoad = userDefaults.bool(forKey: kFIRSTRUN)
        
        if !firstLoad! {
            userDefaults.set(true, forKey: kFIRSTRUN)
            userDefaults.set(showAvatars, forKey: kAVATARSTATE)
            userDefaults.synchronize()
        }
        
        showAvatars = userDefaults.bool(forKey: kAVATARSTATE)
    }

}
