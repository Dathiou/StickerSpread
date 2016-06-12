//
//  ChatVC.swift
//  StickerSpread
//
//  Created by Student iMac on 6/9/16.
//  Copyright © 2016 Student iMac. All rights reserved.
//


import UIKit
import Firebase
//import FirebaseStorage
import FirebaseAnalytics
import FirebaseDatabase
import JSQMessagesViewController
import Parse

class ChatViewController: JSQMessagesViewController {
    
    // MARK: Properties
//   let rootRef = Firebase(url: "https://stickerspread.firebaseio.com/")
   // FIRApp.configure()
    var rootRef = FIRDatabase.database().reference()
    //var messageRef: Firebase!
    var messageRef: FIRDatabaseReference!
   // var messages = [JSQMessage]()
    
    var userIsTypingRef :FIRDatabaseReference!
  // var usersTypingQuery: FQuery!
    private var localTyping = false
    
    
    
    var messages = [ ]()
    let defaults = NSUserDefaults.standardUserDefaults()
    var conversation: Conversation?
    var incomingBubble: JSQMessagesBubbleImage?
    var outgoingBubble: JSQMessagesBubbleImage?
    

    
    
    var isTyping: Bool {
        get {
            return localTyping
        }
        set {
            localTyping = newValue
            userIsTypingRef.setValue(newValue)
        }
    }
    
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
            if let error = error {
                print("Sign in failed:", error.localizedDescription)
            } else {
                print ("Signed in with uid:", user?.email)
            }
 
          
        }
        
//        ref.authAnonymouslyWithCompletionBlock { (error, authData) in
//            if error != nil { print(error.description); return }
//            self.performSegueWithIdentifier("LoginToChat", sender: nil)
//        }

        //let navVc = segue.destinationViewController as! UINavigationController
        //let chatVc = navVc.viewControllers.first as! ChatViewController
        //chatVc.senderId = ref.authData.uid
        //chatVc.senderDisplayName = ""
        
       setupBubbles()
        //messageRef = rootRef.child("messages")
        
        // No avatars
        //collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
       // collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        
        
        
        
        
        
        
        
        
        //
        // Override point:
        //
        // Here is an exaple of how you can cusomize the bubble appearence for incoming and outgoing messages.
        // Based on the Settigns of the user we will display two differnent type of bubbles.
        //
        
 
        
        // This is how you remove Avatars from the messagesView
        collectionView?.collectionViewLayout.incomingAvatarViewSize = .zero
        collectionView?.collectionViewLayout.outgoingAvatarViewSize = .zero
        
        // Show Button to simulate incoming messages
       // self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.jsq_defaultTypingIndicatorImage(), style: .Plain, target: self, action: #selector(receiveMessagePressed))
        
        // This is a beta feature that mostly works but to make things more stable I have diabled it.
        collectionView?.collectionViewLayout.springinessEnabled = false
        
        //Set the SenderId  to the current User
        // For this Demo we will use Woz's ID
        // Anywhere that AvatarIDWoz is used you should replace with you currentUserVariable
        senderId = PFUser.currentUser()!.username //user.email //AvatarIdWoz
        senderDisplayName = "bla"  //conversation?.firstName ?? conversation?.preferredName ?? conversation?.lastName ?? ""
        automaticallyScrollsToMostRecentMessage = true
        
        //Get Messages
        self.messages = makeConversation()
        self.collectionView?.reloadData()
        self.collectionView?.layoutIfNeeded()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //observeMessages()
        //observeTyping()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        
        if message.senderId == senderId { // 1
            cell.textView!.textColor = UIColor.whiteColor() // 2
        } else {
            cell.textView!.textColor = UIColor.blackColor() // 3
        }
        
        return cell
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
//    private func observeMessages() {
//        // 1
//        let messagesQuery = messageRef.queryLimitedToLast(25)
//        // 2
//        messagesQuery.observeEventType(.ChildAdded,withBlock:  { snapshot in
//            // 3
//            let id = snapshot.value!["senderId"] as! String
//            let text = snapshot.value!["text"] as! String
//            
//            // 4
//            self.addMessage(id, text: text)
//            
//            // 5
//            self.finishReceivingMessage()
//        })
//    }
    
    private func observeTyping() {
        let typingIndicatorRef = rootRef.child("typingIndicator")
        userIsTypingRef = typingIndicatorRef.child(senderId)
        userIsTypingRef.onDisconnectRemoveValue()
        let usersTypingQuery = typingIndicatorRef.queryOrderedByValue().queryEqualToValue(true)
        
        usersTypingQuery.observeEventType(.ChildAdded,withBlock:  { data in
            
            // You're the only typing, don't show the indicator
            if data.childrenCount == 1 && self.isTyping {
                return
            }
            
            // Are there others typing?
            self.showTypingIndicator = data.childrenCount > 0
            self.scrollToBottomAnimated(true)
        })
        
    }
    
    func addMessage(id: String, text: String) {
        let message = JSQMessage(senderId: id, displayName: "", text: text)
        messages.append(message)
    }
    
    override func textViewDidChange(textView: UITextView) {
        super.textViewDidChange(textView)
        // If the text is not empty, the user is typing
        isTyping = textView.text != ""
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
        let itemRef = messageRef.childByAutoId() // 1
        let messageItem = [ // 2
            "text": text,
            "senderId": senderId
        ]
        itemRef.setValue(messageItem) // 3
        
        // 4
        //JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        // 5
        finishSendingMessage()
        isTyping = false
    }
    
    private func setupBubbles() {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageView = bubbleImageFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
        incomingBubbleImageView = bubbleImageFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    }
    
}