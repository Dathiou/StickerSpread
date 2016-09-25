//
//  SettingsVC.swift
//  StickerSpread
//
//  Created by Student iMac on 7/2/16.
//  Copyright © 2016 Student iMac. All rights reserved.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {
    
    let storage = FIRStorage.storage()
    let storageRef = FIRStorage.storage().reference(forURL: "gs://stickerspread-4f3a9.appspot.com")

    
    // UI objects
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var instaURL: UITextField!
    @IBOutlet weak var youtubeURL: UITextField!
    @IBOutlet weak var ETSYURL: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    
    // value to hold keyboard frmae size
    var keyboard = CGRect()
    
    override func viewDidLoad() {
        super.viewDidLoad()


        information()
        
        // check notifications of keyboard - shown or not
        NotificationCenter.default.addObserver(self, selector: "keyboardWillShow:", name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: "keyboardWillHide:", name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)

    }
    
    
    // func to hide keyboard
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    
//    // func when keyboard is shown
//    func keyboardWillShow(notification: NSNotification) {
//        
//        // define keyboard frame size
//        keyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey]!.CGRectValue)!
//        
//        // move up with animation
//        UIView.animate(withDuration: 0.4) { () -> Void in
//            self.scrollView.contentSize.height = self.view.frame.size.height + self.keyboard.height / 2
//        }
//    }
    
    
    // func when keyboard is hidden
    func keyboardWillHide(notification: NSNotification) {
        
        // move down with animation
        UIView.animate(withDuration: 0.4) { () -> Void in
            self.scrollView.contentSize.height = 0
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func upload_click(sender: AnyObject) {
        let userID = FIRAuth.auth()?.currentUser?.uid
        firebase.child("Users").child(userID!).child("youtubeURL").setValue(self.youtubeURL.text)
        firebase.child("Users").child(userID!).child("instagramURL").setValue(self.instaURL.text)
        firebase.child("Users").child(userID!).child("etsyURL").setValue(self.ETSYURL.text)
        firebase.child("Users").child(userID!).child("emailDisplay").setValue(self.instaURL.text)
        
    }
    // clicked cancel button
    @IBAction func cancel_clicked(sender: AnyObject) {
        
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    // user information function
    func information() {
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        firebase.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let firstname = (snapshot.value! as AnyObject).value(forKey:"first_name") as! String
            let lastname = (snapshot.value! as AnyObject).value(forKey:"last_name") as! String
            self.navigationItem.title = firstname + " " + lastname
            
            self.youtubeURL.text = (snapshot.value! as AnyObject).value(forKey:"youtubeURL") as! String
            self.instaURL.text = (snapshot.value! as AnyObject).value(forKey:"instagramURL") as! String
            self.ETSYURL.text = (snapshot.value! as AnyObject).value(forKey:"etsyURL") as! String
            self.emailTxt.text = (snapshot.value! as AnyObject).value(forKey:"emailDisplay") as! String
            
            let avaURL = ((snapshot.value! as AnyObject).value(forKey:"ProfilPicUrl") as! String)
            let url = NSURL(string: avaURL)
            if let data = NSData(contentsOf: url! as URL){ //make sure your image in this url does exist, otherwise unwrap in a if let check
                //self.avaArray.append(UIImage(data: data) as UIImage!)
                self.image.image = UIImage(data: data as Data) as UIImage!
                
            }
            
            
// self.storage.referenceForURL(snapshot.value!.objectForKey("ProfilPicUrl") as! String).dataWithMaxSize(25 * 1024 * 1024, completion: { (data, error) -> Void in
//                        let image = UIImage(data: data!)
//            
//            self.image.image = image
//            })
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        
        
//        // receive profile picture
//        let ava = PFUser.currentUser()?.objectForKey("ava") as! PFFile
//        ava.getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
//            self.avaImg.image = UIImage(data: data!)
//        }
        

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
