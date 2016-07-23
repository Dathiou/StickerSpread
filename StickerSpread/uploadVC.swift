//
//  uploadVC.swift
//  StickerSpread
//
//  Created by Student iMac on 6/3/16.
//  Copyright © 2016 Student iMac. All rights reserved.
//

import UIKit
import Parse
import Firebase

class uploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var picImg: UIImageView!
    
    @IBOutlet weak var titleTxt: UITextView!
    
    
    @IBOutlet weak var publishBtn: UIButton!
    
    @IBOutlet weak var removeBtn: UIButton!
    
    
    // default func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // disable publish btn
        publishBtn.enabled = false
        publishBtn.backgroundColor = .lightGrayColor()
        
        // hide remove button
        removeBtn.hidden = true
        
        // standart UI containt
        picImg.image = UIImage(named: "pbg.jpg")
        //titleTxt.resignFirstResponder()
        //titleTxt.layoutIfNeeded()
        
        titleTxt.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        // hide kyeboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: "hideKeyboardTap")
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // select image tap
        let picTap = UITapGestureRecognizer(target: self, action: "selectImg")
        picTap.numberOfTapsRequired = 1
        picImg.userInteractionEnabled = true
        picImg.addGestureRecognizer(picTap)
    }
    
    
    // preload func
    override func viewWillAppear(animated: Bool) {
        // call alignment function
        alignment()
    }
    
    // hide kyeboard function
    func hideKeyboardTap() {
        self.view.endEditing(true)
    }
    
    // func to cal pickerViewController
    func selectImg() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }
    
    
    // hold selected image in picImg object and dissmiss PickerController()
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
        
        // enable publish btn
        publishBtn.enabled = true
        publishBtn.backgroundColor = UIColor(red: 52.0/255.0, green: 169.0/255.0, blue: 255.0/255.0, alpha: 1)
        
        // unhide remove button
        removeBtn.hidden = false
        
        // implement second tap for zooming image
        let zoomTap = UITapGestureRecognizer(target: self, action: "zoomImg")
        zoomTap.numberOfTapsRequired = 1
        picImg.userInteractionEnabled = true
        picImg.addGestureRecognizer(zoomTap)
    }
    
    // zooming in / out function
    func zoomImg() {
        
        // define frame of zoomed image
        //let zoomed = CGRectMake(0, self.view.center.y - self.view.center.x, self.view.frame.size.width, self.view.frame.size.width)
        let zoomed = CGRectMake(0, self.view.center.y - self.view.center.x - self.tabBarController!.tabBar.frame.size.height * 1.5, self.view.frame.size.width, self.view.frame.size.width)

        // frame of unzoomed (small) image
        //let unzoomed = CGRectMake(15, self.tabBarController!.tabBar.frame.size.height + 35 , self.view.frame.size.width / 4.5, self.view.frame.size.width / 4.5)
        //let unzoomed =  CGRectMake(15, self.navigationController!.navigationBar.frame.size.height + 35 , self.view.frame.size.width / 4.5, self.view.frame.size.width / 4.5)
let unzoomed = CGRectMake(15, 15, self.view.frame.size.width / 4.5, self.view.frame.size.width / 4.5)
        
        // if picture is unzoomed, zoom it
        if picImg.frame == unzoomed {
            
            // with animation
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                // resize image frame
                self.picImg.frame = zoomed
                
                // hide objects from background
                self.view.backgroundColor = .blackColor()
                self.titleTxt.alpha = 0
                self.publishBtn.alpha = 0
                self.removeBtn.alpha = 0
            })
            
            // to unzoom
        } else {
            
            // with animation
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                // resize image frame
                self.picImg.frame = unzoomed
                
                // unhide objects from background
                self.view.backgroundColor = .whiteColor()
                self.titleTxt.alpha = 1
                self.publishBtn.alpha = 1
                self.removeBtn.alpha = 1
            })
        }
        
    }
    
    // alignment
    func alignment() {
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
//        picImg.frame = CGRectMake(15, self.navigationController!.navigationBar.frame.size.height + 35 , width / 4.5, width / 4.5)
//       titleTxt.frame = CGRectMake(picImg.frame.size.width + 25, picImg.frame.origin.y, width - titleTxt.frame.origin.x - 10, picImg.frame.size.height)
//        //titleTxt.frame = CGRectMake(picImg.frame.size.width + 25, picImg.frame.origin.y, width / 1.488, picImg.frame.size.height)
//        publishBtn.frame = CGRectMake(0, self.tabBarController!.tabBar.frame.origin.y - width / 8, width, width / 8)
//        removeBtn.frame = CGRectMake(picImg.frame.origin.x, picImg.frame.origin.y + picImg.frame.size.height , picImg.frame.size.width, 30)
        
        picImg.frame = CGRectMake(15, 15, width / 4.5, width / 4.5)
        titleTxt.frame = CGRectMake(picImg.frame.size.width + 25, picImg.frame.origin.y, width / 1.488, picImg.frame.size.height)
        publishBtn.frame = CGRectMake(0, height / 1.09, width, width / 8)
        removeBtn.frame = CGRectMake(picImg.frame.origin.x, picImg.frame.origin.y + picImg.frame.size.height, picImg.frame.size.width, 20)

    }
    
    
    
    
    @IBAction func publishBtn_clicked(sender: AnyObject) {
        // dissmiss keyboard
        self.view.endEditing(true)
        
        
        // Get a reference to the storage service, using the default Firebase App
        let storage = FIRStorage.storage()
        // Create a storage reference from our storage service
        let storageRef = storage.referenceForURL("gs://stickerspread-4f3a9.appspot.com")
        
        
//        
//        
//        // send data to server to "posts" class in Parse
//        let object = PFObject(className: "posts")
//        object["username"] = PFUser.currentUser()!.username
        
        
        
//        
//        let first = (object1.objectForKey("first_name") as? String)
//        let last = (object1.objectForKey("last_name") as? String)
//        
//        let fullname = first!+" "+last!
//        self.nameArray.append(fullname)
//        object["fullname"] = PFUser.currentUser()!.username
//        
        
//        object["ava"] = PFUser.currentUser()!.valueForKey("picture_file") as! PFFile
//        
        let uuid = NSUUID().UUIDString
//        object["uuid"] = "\(PFUser.currentUser()!.username!) \(uuid)"
//        
//        if titleTxt.text.isEmpty {
//            object["title"] = ""
//        } else {
//            object["title"] = titleTxt.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
//        }
        
        
        // send pic to server after converting to FILE and comprassion
        let imageData : NSData = UIImageJPEGRepresentation(picImg.image!, 0.5)!
        
        
//        
//        
//        let imageFile = PFFile(name: "post.jpg", data: imageData)
//        object["pic"] = imageFile
        
        
        if let user = FIRAuth.auth()?.currentUser {
            let userID = user.uid;
        print(userID)
        
        
        // Create a reference to the file you want to upload
        let riversRef = storageRef.child("posts/\(userID) \(uuid).jpg")
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = riversRef.putData(imageData, metadata: nil) { metadata, error in
            if (error != nil) {
                // Uh-oh, an error occurred!
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata?.downloadURL()?.absoluteURL
                
                let date = NSDate()
                var dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                var dateString = dateFormatter.stringFromDate(date)
                
                
                    let name = user.displayName
                    let email = user.email
                    let photoUrl = user.photoURL
                    let uid = user.uid;
                    print(downloadURL)
                    let userDict : [String : AnyObject] = [ "userID" : uid,
                                     "title"    : "Day Dream Kit" ,
                                     "layout"   : "vertical",
                                     "date" : dateString,
                                     "photoUrl"    : (downloadURL?.absoluteString)!]
                    let postID = "\(userID) \(uuid)"
                    firebase.child("Posts").child(postID).setValue(userDict)
                    firebase.child("PostPerUser").child("\(userID)").child(postID).setValue(true)
                    
                
            }
            
        }
        } else {
            // No user is signed in.
        }
       
        
        
        
      
        
    
        
//        
//        // finally save information
//        object.saveInBackgroundWithBlock ({ (success:Bool, error:NSError?) -> Void in
//            if error == nil {
//                
//                // send notification wiht name "uploaded"
//                NSNotificationCenter.defaultCenter().postNotificationName("uploaded", object: nil)
//                
//                // switch to another ViewController at 0 index of tabbar
//                self.tabBarController!.selectedIndex = 0
//                
//                // reset everything
//                self.viewDidLoad()
//                self.titleTxt.text = ""
//            }
//        })
        
    }
    

   //clicked remove button
    @IBAction func removeBtn_clicked(sender: AnyObject) {
        self.viewDidLoad()
    }

}
