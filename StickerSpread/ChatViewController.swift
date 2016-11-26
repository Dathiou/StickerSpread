//
//  ChatViewController.swift
//  quickChat
//
//  Created by David Kababyan on 06/03/2016.
//  Copyright © 2016 David Kababyan. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import FirebaseAuth
import FirebaseStorage
import IDMPhotoBrowser

class ChatViewController: JSQMessagesViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let userDefaults = UserDefaults.standard
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //chaged
    //let ref = Firebase(url: "https://quickchataplication.firebaseio.com/Message")
    let ref = firebase.child("Message")
    
    let storage = FIRStorage.storage()
    let storageRef = FIRStorage.storage().reference(forURL: "gs://stickerspread-4f3a9.appspot.com")

    var messages: [JSQMessage] = []
    var objects: [NSDictionary] = []
    var loaded: [NSDictionary] = []
    
    var avatarUrlDictionary: NSMutableDictionary?
    var avatarDictionary: NSMutableDictionary?
    
    var avatars = [String: JSQMessagesAvatarImage]()

    var showAvatars: Bool = true
    var firstLoad: Bool?
    
    var withUserIDProfPicUrl = String()

    
    var withUserID = String()
    var WithName = String()
    var recent: NSDictionary?
    
    var chatRoomId: String!
    var recentId: String!
    
    var initialLoadComlete: Bool = false
    var from = String()
    
    
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.white)
    
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.white)

    override func viewWillAppear(_ animated: Bool) {
        loadUserDefaults()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ClearRecentCounter(chatRoomID: chatRoomId)
//        ClearRecentCounter(chatRoomID: String)
//firebase.child("Recent").child(recentId).updateChildValues(["counter": 0])
//

        ref.removeAllObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        //self.navigationController?.navigationBar.barStyle = UIBarStyle.
        //UIApplication.shared.statusBarStyle = .lightContent
        self.senderId = FIRAuth.auth()?.currentUser?.uid
        firebase.child("Users").child((FIRAuth.auth()?.currentUser?.uid)!).observe(.value, with: { snapshot in
            
            let first = (snapshot.value as? [String:AnyObject])?["first_name"] as! String
            let last = (snapshot .value as? [String:AnyObject])?["last_name"] as! String


            self.senderDisplayName = first+" "+last
            
            let avaURL = ((snapshot.value! as AnyObject).value(forKey:"ProfilPicUrl") as! String)
            //self.createAvatar(senderId: (FIRAuth.auth()?.currentUser?.uid)!,photoUrl: avaURL)
            //self.avatarUrlDictionary?[self.senderId] = avaURL
            self.loadmessages()
            })
  
        
        //collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        //collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = UIColor(patternImage: UIImage(named: "Background_Blue_Joint.jpg")!)
        
//        if withUserID == nil {
//            getWithUserFromRecent(recent!, result: { (withUserID) in
//                self.withUserID = withUserID
//                self.title = withUser.name
//                self.getAvatars()
//            })
//        } else {
//            self.title = withUserID!.name
//            self.getAvatars()
//        }
        self.title = WithName
        self.createAvatar(senderId: self.withUserID,photoUrl: self.withUserIDProfPicUrl)
        //self.CreateAvatarDictUrl()
        //collectionView?.collectionViewLayout.incomingAvatarViewSize = CGSize(width:30, height:30)
        collectionView?.collectionViewLayout.outgoingAvatarViewSize = .zero
        //load firebase messages
        
        self.edgesForExtendedLayout = []
        self.inputToolbar?.contentView?.textView?.placeHolder = "New Message"

        
        firebase.child("Recent").queryOrdered(byChild: "chatRoomId").queryEqual(toValue: chatRoomId).observe(.value, with: { snapshot in

            if snapshot.exists() {
                self.recentId = snapshot.value as! String!
            }
        })

        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    //MARK: JSQMessages dataSource functions

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        let data = messages[indexPath.row]
        
        if data.senderId == FIRAuth.auth()?.currentUser?.uid {
            cell.textView?.textColor = UIColor.black
        } else {
            cell.textView?.textColor = UIColor.black
        }
        cell.avatarImageView.layer.cornerRadius = 4.0
        cell.avatarImageView.clipsToBounds = true
        cell.avatarImageView.layer.borderColor = UIColor.white.cgColor
        cell.avatarImageView.layer.borderWidth = 0.5
        
        return cell
    
    }
    
    

    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        let data = messages[indexPath.row]
        
        return data

    }

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return messages.count
    }
    

    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let data = messages[indexPath.row]
        
        if data.senderId == FIRAuth.auth()?.currentUser?.uid {
            return self.outgoingBubble
        } else {
            return self.incomingBubble
        }
    }
    

    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
    if indexPath.item % 3 == 0 {
    
    let message = messages[indexPath.item]
    
    return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
    }
    return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        if indexPath.item % 3 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        return 0.0
    }
   
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = objects[indexPath.row]
        
        let status = message["status"] as! String
        
        if indexPath.row == (messages.count - 1) {
            return NSAttributedString(string: status)
        } else {
            return NSAttributedString(string: "")
        }
    }
    

    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAt indexPath: IndexPath!) -> CGFloat {
        if outgoing(item: objects[indexPath.row]) {
            //return kJSQMessagesCollectionViewCellLabelHeightDefault
            return 0.0
        } else {
            return 0.0
        }
    }

    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
//        let message = messages[indexPath.row]
//        print(avatarDictionary)
//        let avatar = avatarDictionary!.object(forKey: message.senderId) as! JSQMessageAvatarImageDataSource
//        //let avatar =
//        return avatar

        let message = messages[indexPath.row]
        return avatars[message.senderId]
        
    }

    
    //MARK: JSQMessages Delegate function

    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        if text != "" {
            sendMessage(text: text, date: date as NSDate, picture: nil, location: nil)
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
            var outgoingMessage = OutgoingMessage(message: text, senderId: (FIRAuth.auth()?.currentUser?.uid)! , senderName: senderDisplayName, date: date, status: "Delivered", type: "text")
            outgoingMessage.sendMessage(chatRoomID: chatRoomId, item: outgoingMessage.messageDictionary)
        }
        
        //send picture message
        if let pic = picture {
            
            let imageData = UIImageJPEGRepresentation(pic, 1.0)
            
            var outgoingMessage = OutgoingMessage(message: "Picture", pictureData: imageData! as NSData, senderId: senderDisplayName, senderName: (FIRAuth.auth()?.currentUser?.uid)! , date: date, status: "Delivered", type: "picture")
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
        
        if FIRAuth.auth()?.currentUser?.uid == item["senderId"] as! String {
            print("have location")
            return false
        } else {
            return true
        }
    }
    
    func outgoing(item: NSDictionary) -> Bool {

        if FIRAuth.auth()?.currentUser?.uid == item["senderId"] as! String {
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
    
    
    func createAvatar(senderId: String,photoUrl: String)
    {
        if self.avatars[senderId] == nil
        {
            //as you can see, I use cache
            let img = imageCache.object(forKey:photoUrl as AnyObject) as? UIImage
            
            if img != nil
            {
                self.avatars[senderId] = JSQMessagesAvatarImage.init(avatarImage: img, highlightedImage: img, placeholderImage: img)
                
                // print("from cache")
            }
            else if photoUrl != "" {
                // the images are very small, so the following methods work just fine, no need for Alamofire here
                
                if photoUrl.contains("https://firebasestorage.googleapis.com"){
                    self.storage.reference(forURL: photoUrl).data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                        if (error != nil)
                        {
                            //deal with error
                        }
                        else
                        {
                            let newImage = UIImage(data: data!)
                            
                            self.avatars[senderId] = JSQMessagesAvatarImage.init(avatarImage: newImage, highlightedImage: newImage, placeholderImage: newImage)//JSQMessagesAvatarImageFactory.avatarImage(with: newImage,diameter: 1000)
                            
                            imageCache.setObject(newImage!, forKey: senderId as AnyObject)
                        }
                    }.resume()
                }
                else if let data = NSData(contentsOf: NSURL(string:photoUrl)! as URL)
                {
                    let newImage = UIImage(data: data as Data)!
                    
                    //self.avatars[senderId] = JSQMessagesAvatarImageFactory.avatarImage(with: newImage,diameter: 1000)
                    self.avatars[senderId] = JSQMessagesAvatarImage.init(avatarImage: newImage, highlightedImage: newImage, placeholderImage: newImage)
                    imageCache.setObject(newImage, forKey: senderId as AnyObject)
                }
                else
                {
                    //etc. blank image or image with initials
                }
            }
        }
        else
        {
            //etc. blank image or image with initials
        }
    }
    
    
    
    
    
    
    
//    func CreateAvatarDictUrl() {
//        
//        if showAvatars {
//            
//            //print("showAvatar")
//            collectionView?.collectionViewLayout.incomingAvatarViewSize = CGSize(width:30, height:30)
//            collectionView?.collectionViewLayout.outgoingAvatarViewSize = CGSize(width:30,height: 30)
//            
//            //self.avatarUrlDictionary?[withUserID] = recent?["ProfilPicURL"]
//            
////                    firebase.child("Users").child((FIRAuth.auth()?.currentUser?.uid)!).observe(.value, with: { snapshot1 in
////            
////                        //objc_sync_enter(self.nameArray)
//////                        let first = ((snapshot1.value! as AnyObject).value(forKey:"first_name") as? String)
//////                        let last = ((snapshot1.value! as AnyObject).value(forKey:"last_name") as? String)
//////            
//////                        let fullname = first!+" "+last!
//////                        //self.nameArray.append(fullname)
////            
////            
////                        
////                        let avaURL = ((snapshot1.value! as AnyObject).value(forKey:"ProfilPicUrl") as! String)
////                        self.avatarUrlDictionary?[FIRAuth.auth()?.currentUser?.uid] = avaURL
////                        //self.createAvatars(avatars: avatarUrlDictionary)
////                        })
//            firebase.child("Users").child(self.senderId).observe(.value, with: { snapshot1 in
//                
//                //objc_sync_enter(self.nameArray)
//                //                        let first = ((snapshot1.value! as AnyObject).value(forKey:"first_name") as? String)
//                //                        let last = ((snapshot1.value! as AnyObject).value(forKey:"last_name") as? String)
//                //
//                //                        let fullname = first!+" "+last!
//                //                        //self.nameArray.append(fullname)
//                
//                
//                
//                let avaURL = ((snapshot1.value! as AnyObject).value(forKey:"ProfilPicUrl") as! String)
//                self.avatarUrlDictionary?[self.senderId] = avaURL
//                self.avatarUrlDictionary?[self.withUserID] = self.withUserIDProfPicUrl
//                self.createAvatars(avatars: self.avatarUrlDictionary)
//            })
//            
//            //download avatars
//            //avatarImageFromFireBase(userID: (FIRAuth.auth()?.currentUser?.uid)!)
//            //avatarImageFromFireBase(userID: withUserID)
//            
//            //create avatars
//            //createAvatars(avatars: avatarUrlDictionary)
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




//    func createAvatars(avatars: NSMutableDictionary?) {
//        let cutt = JSQMessagesAvatarImage()
//        let currentUserAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "avatarPlaceholder"), diameter: 70)
//        let withUserAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "avatarPlaceholder"), diameter: 70)
//        cutt = currentUserAvatar
//        
//        if let avat = avatars {
//            if let currentUserAvatarURL = avat.object(forKey: FIRAuth.auth()?.currentUser?.uid) {
//                //let uiimagev = UIImageView(image: UIImage(named: "avatarPlaceholder"))
//                //let uiCache = uiimagev.loadImageUsingCacheWithUrlString(urlString: currentUserAvatarURL as! String)
//                currentUserAvatar?.loadImageUsingCacheWithUrlString(urlString: currentUserAvatarURL as! String)
//                //let currentUserAvatar = currentUserAvatar.//JSQMessagesAvatarImageFactory//.avatarImage(with: uiCache.image, diameter: 70)
//                //self.collectionView?.reloadData()
//            } else if let withUserAvatarURL = avat.object(forKey: withUserID) {
//                //let uiimagev = UIImageView(image: (UIImage(named: "avatarPlaceholder"))
//                //let uiCache = uiimagev.loadImageUsingCacheWithUrlString(urlString: currentUserAvatar)
//                //withUserAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: uiCache.image, diameter: 70)
//                withUserAvatar?.loadImageUsingCacheWithUrlString(urlString: withUserAvatarURL as! String)
//               // self.collectionView?.reloadData()
//            }
//            
//        }
//        
//            
//        
//        
//        avatarDictionary = [FIRAuth.auth()?.currentUser?.uid : currentUserAvatar, withUserID : withUserAvatar]
//    }
    
//    func avatarImageFromFireBase(userID: String) {
//        
//        firebase.child("Users").child(userID).observe(.value, with: { snapshot1 in
//            
//            //objc_sync_enter(self.nameArray)
//            let first = ((snapshot1.value! as AnyObject).value(forKey:"first_name") as? String)
//            let last = ((snapshot1.value! as AnyObject).value(forKey:"last_name") as? String)
//            
//            let fullname = first!+" "+last!
//            //self.nameArray.append(fullname)
//            
//            
//            
//            let avaURL = ((snapshot1.value! as AnyObject).value(forKey:"ProfilPicUrl") as! String)
//            let url = NSURL(string: avaURL)
//            if let data = NSData(contentsOf: url! as URL){ //make sure your image in this url does exist, otherwise unwrap in a if let check
//
//                
//                // let i = snapshot.value!.objectForKey("photoUrl") as! String
//                
//                self.storage.reference(forURL:avaURL).data(withMaxSize: 25 * 1024 * 1024, completion: { (data, error) -> Void in
//                    let image = UIImage(data: data!)
//
//                    if self.avatarUrlDictionary != nil {
//                        
//                        self.avatarUrlDictionary!.removeObject(forKey: userID)
//                        self.avatarUrlDictionary!.setObject(image!, forKey: userID as NSCopying)
//                    } else {
//                        self.avatarUrlDictionary = [userID : image!]
//                    }
//                    self.createAvatars(avatars: self.avatarUrlDictionary)
//
//                })
//                
//            }
//            
//
//            }
//            
//        ){ (error) in
//            print(error.localizedDescription)
//        }
//
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
