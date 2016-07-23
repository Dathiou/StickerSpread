
//
//  ViewController.swift
//  StickerSpread
//
//  Created by Student iMac on 5/26/16.
//  Copyright © 2016 Student iMac. All rights reserved.
//

import UIKit
import Parse
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
//import SVProgressHUD



class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    //let storage =
   // let storageRef = FIRStorage.storage().referenceForURL("gs://stickerspread-4f3a9.appspot.com")

    
    var fbLoginSuccess = false
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email", "public_profile","user_birthday"]
        return button
    }()
    
    override func viewDidAppear(animated: Bool) {
        if (FBSDKAccessToken.currentAccessToken() != nil || fbLoginSuccess == true)
        {
            let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.login()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //if fbLoginSuccess == true {
        view.addSubview(loginButton)
        loginButton.center = view.center
        loginButton.delegate = self
        //  }
        //signUp()
        
        //if (FBSDKAccessToken.currentAccessToken() != nil || PFUser.currentUser() != nil ){
        //            let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //                    appDelegate.login()
        //} else {
        //    view.addSubview(loginButton)
        //    loginButton.center = view.center
        //    loginButton.delegate = self
        //        }
        
        //        if (FBSDKAccessToken.currentAccessToken() != nil || PFUser.currentUser() != nil || fbLoginSuccess == true){
        //            let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //            appDelegate.login()
        //        }
        
        //        if let t = PFUser.currentUser(){
        //            print("user already logged in")
        //            if let token = FBSDKAccessToken.currentAccessToken(){
        //                print("token valid")
        //                 let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //
        //                 appDelegate.login()
        //
        //
        //                //            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //                //            let myTabBar = storyboard.instantiateViewControllerWithIdentifier("tabBar") as! UITabBarController
        //                //            window?.rootViewController = myTabBar
        //            }
        //        }
        
        
        
        //        var currentUser = PFUser.currentUser()
        //        if currentUser != nil {
        //            // Do stuff with the user
        //        } else {
        //            // Show the signup or login screen
        //
        //        }
        //PFUser.logOut()
        
    }
    
    func fetchProfile(){
        print("fetch profile")
        let parameters = ["fields":"id, email, first_name, last_name, picture.type(large),birthday"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler({ (connection,result,error) -> Void in
            if error != nil{
                print(error)
                return
            }
            
            
            
            if let dict = result as? [String:AnyObject]{
                let userId:String = dict["id"] as! String
                let userFirstName:String? = dict["first_name"] as? String
                let userLastName:String? = dict["last_name"] as? String
                let userEmail:String? = dict["email"] as? String
                if let picture = dict["picture"] as? NSDictionary{
                    
                    if let data = picture["data"] as? NSDictionary{
                        let url = data["url"] as? String
                        print(url)
                    }
                }
                
                //        if let email = result["email"] as? String {
                //            print(email)
                //        }
                //
                //        if let picture = result["picture"] as? NSDictionary, data = picture["data"] as? NSDictionary,
                //            url = data["url"] as? String{
                //                print(url)
                //            }
                //        print(result)
                
                
                
                
                /*
                 if let facebookID : NSString = result.valueForKey("id") as? NSString {
                 println("User FbId is: \(facebookID)")
                 } else {println("No facebookID fetched")}
                 
                 if let name : NSString = result.valueForKey("first_name") as? NSString {
                 println("User's Name is: \(name)")
                 } else {println("No name fetched")}
                 
                 if let gender : NSString = result.valueForKey("gender") as? NSString {
                 println("User's gender is: \(gender)")
                 } else {println("No gender fetched")}
                 
                 if let name : NSString = result.valueForKey("first_name") as? NSString {
                 println("User's Name is: \(name)")
                 } else {println("No name fetched")}
                 
                 if let birthday : NSString = result.valueForKey("birthday") as? NSString {
                 println("User's birthday is: \(birthday)")
                 } else {println("No birthday fetched")}
                 */
                
                var facebookID: AnyObject? = dict["id"]
                PFUser.currentUser()!.setObject(facebookID!, forKey: "fbid")
                
                var name: AnyObject? = dict["first_name"]
                PFUser.currentUser()!.setObject(name!, forKey: "username")
                
                var gender: AnyObject? = dict["gender"]
                PFUser.currentUser()!.setObject(gender!, forKey: "gender")
                
                var birthday: AnyObject? = dict["birthday"]
                PFUser.currentUser()!.setObject(birthday!, forKey: "birthday")
                
                //var pictureURL = "https://graph.facebook.com/\(facebookID)/picture?type=large&return_ssl_resources=1"
                var pictureURL = "https://graph.facebook.com/\(facebookID)/picture?type=square"
                
                var URLRequest = NSURL(string: pictureURL)
                var URLRequestNeeded = NSURLRequest(URL: URLRequest!)
                
                
                //        NSURLConnection.sendAsynchronousRequest(URLRequestNeeded, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!, error: NSError!) -> Void in
                //            if error == nil {
                //                var picture = PFFile(data: data)
                //                PFUser.currentUser()!.setObject(picture, forKey: "picture")
                //                PFUser.currentUser()!.saveInBackground()
                //            }
                //            else {
                //                println("Error: \(error.localizedDescription)")
                //            }
                //            })
                
                let task = NSURLSession.sharedSession().dataTaskWithURL(URLRequest!) { (data, response, error) -> Void in
                    
                    if error != nil {
                        print("thers an error in the log")
                    } else {
                        
                        var picture = PFFile(data: data!)
                        PFUser.currentUser()!.setObject(picture!, forKey: "picture")
                        PFUser.currentUser()!.saveInBackground()
                        
                    }
                }
                
                
                
                task.resume()
                
                
                
            }
            
            
            
            
        })
    }
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!){
        print("User Logged Out")
    }
    
    //when login with facebook clicked
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result:FBSDKLoginManagerLoginResult!, error: NSError!){
        print("starting function singup done")
        
        if ((error) != nil) {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email") {
                
                // signUp()
                
                
                SVProgressHUD.show()
                
                let qualityOfServiceClass = QOS_CLASS_BACKGROUND
                let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
                dispatch_async(backgroundQueue, {
                    print("This is run on the background queue")
                    self.signUp()
                    
                    print("function singup done")
                    
                    
                    //dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 1 * Int64(NSEC_PER_SEC))
                    dispatch_after(time, dispatch_get_main_queue()) {
                        
                        print("This is run on the main queue, after the previous code in outer block")
                        SVProgressHUD.dismiss()
                        self.fbLoginSuccess = true
                        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        appDelegate.login()
                    }
                })
            }
        }
        
        //print("completed login")
        
        
        // fetchProfile()
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool{
        
        return true
    }
    
    //    override func didReceiveMemoryWarning() {
    //        super.didReceiveMemoryWarning()
    //        // Dispose of any resources that can be recreated.
    //    }
    
    
    func signUp(){
        
        
        // other fields can be set just like with PFObject
        
        let parameters = ["fields":"id, email, first_name, last_name, picture.type(large),birthday"]
        dispatch_async(dispatch_get_main_queue(),{
            FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler({ (connection,result,error) -> Void in
                if error != nil{
                    print(error)
                    return
                }
                
                
                
                if let dict = result as? [String:AnyObject]{
                    
                    //get id from fb
                    let userId:String = dict["id"] as! String
                    
                    //try sign up
                    
                    
                    
                    var user = PFUser()
                    user.password="0000"
                    user.username = userId
                    print(userId)
                    
                    
                    let userEmail:String = dict["email"] as! String
                    user.email = userEmail
                    
                    let userFirstName:String = dict["first_name"] as! String
                    
                    let userLastName:String = dict["last_name"] as! String
                    
                    let userBirthday:String = dict["birthday"] as! String
                    
                    
                    var pictureURL = "https://graph.facebook.com/\(userId)/picture?width=150&height=150"
                    //var URLRequest = NSURL(string: pictureURL)
                   // var URLRequestNeeded = NSURLRequest(URL: URLRequest!)
//                    var downloadURL = ""
//                    var imageData = NSData(contentsOfURL: URLRequest!)
//                    let storageRef = FIRStorage.storage().referenceForURL("gs://stickerspread-4f3a9.appspot.com")
//                    // Upload the file to the path "images/rivers.jpg"
//                    //let riversRef = storageRef.child("users/profilPic/\(FIRAuth.auth()?.currentUser).jpg")
//                    let riversRef = storageRef.child("users/profilPic/aa.jpg")
//                    let uploadTask = riversRef.putData(imageData!, metadata: nil) { metadata, error in
//                        if (error != nil) {
//                            // Uh-oh, an error occurred!
//                        } else {
//                            // Metadata contains file metadata such as size, content-type, and download URL.
//                            downloadURL = metadata!.downloadURL()!.path!
//                            
//                            
//                        }
//                    }

//
//                    let task = NSURLSession.sharedSession().dataTaskWithURL(URLRequest!) { (data, response, error) -> Void in
//                        
//                        if error != nil {
//                            print("thers an error in the log")
//                        } else {
//                                                        }
//                        }}
//                    
                    
                    
                    var myUser = ["email": userEmail]
                    
                    let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
                    FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                        if error != nil {
                            print ("error firebase auth")
                        }
                        else {
                            print ("user logged in firebase")
                            
                            firebase.childByAppendingPath("Users").queryEqualToValue("\(user!.uid)")
                                .observeSingleEventOfType(.Value, withBlock: { snapshot in
                                    
                                    if ( snapshot.value is NSNull ) {
                                        print("not found)") //didnt find it, ok to proceed
                                        
                                        //firebase.childByAppendingPath("Users").childByAppendingPath("\(user!.uid)").setValue("\(user!.uid)")
                                        
                                        let date = NSDate()
                                        var dateFormatter = NSDateFormatter()
                                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                                        var dateString = dateFormatter.stringFromDate(date)
                                        
                                        
                                        if let user = FIRAuth.auth()?.currentUser {
                                            let name = user.displayName
                                            let email = user.email
                                            let photoUrl = user.photoURL
                                            let uid = user.uid;
                                            //print(downloadURL()!.path!)
                                            let userDict : [String : AnyObject] =
                                                [ "userID" : uid,
                                                    "email" : userEmail,
                                                    "first_name"    : userFirstName ,
                                                    "last_name"   : userLastName,
                                                    "date" : dateString,
                                                    "birthday": userBirthday,
                                                    "ProfilPicUrl"  : pictureURL,
                                                    "youtubeURL" : "",
                                                    "instagramURL": "",
                                                    "etsyURL": "",
                                                    "emailDisplay":""
                                                    
                                            ]
                                            
                                            firebase.child("Users").child("\(user.uid)").setValue(userDict)
                                            
                                        } else {
                                            // No user is signed in.
                                        }
                                        
                                        
                                        
                                    } else {
                                        print("user already in db")
                                        print(snapshot.value) //found it, stop!
                                    }
                                })
                            
                            
                        }
                    }
                    //
                    //
                    //                ref.createUser("bobtony@example.com", password: "correcthorsebatterystaple",
                    //                    withValueCompletionBlock: { error, result in
                    //                        if error != nil {
                    //                            // There was an error creating the account
                    //                        } else {
                    //                            let uid = result["uid"] as? String
                    //                            println("Successfully created user account with uid: \(uid)")
                    //                        }
                    //                })
                    
                    
                    //try sign up user
                    user.signUpInBackgroundWithBlock {
                        (succeeded: Bool, error: NSError?) -> Void in
                        if let error = error {
                            let errorString = error.userInfo["error"] as! NSString
                            print(errorString)
                            print("try log in")
                            //test log in
                            PFUser.logInWithUsernameInBackground(userId, password:"0000") {
                                (user: PFUser?, error: NSError?) -> Void in
                                if user != nil {
                                    // Do stuff after successful login.
                                    
                                    
                                    print("login successful")
                                }
                            }
                        } else {
                            
                            let userFirstName:String = dict["first_name"] as! String
                            user.setObject(userFirstName, forKey: "first_name")
                            
                            let userLastName:String = dict["last_name"] as! String
                            user.setObject(userLastName, forKey: "last_name")
                            
                            
                            
                            
                            
                            //print(userLastName)
                            // user["last_name"] = "aaa"
                            
                            
                            let userBirthday:String = dict["birthday"] as! String
                            user.setObject(userBirthday, forKey: "birthday")
                            
                            if let picture = dict["picture"] as? NSDictionary{
                                
                                if let data = picture["data"] as? NSDictionary{
                                    let url = data["url"] as! String
                                    user.setObject(url, forKey: "picture")
                                    print("pic uploaded url")
                                }
                            }
                            
                            //var pictureURL = "https://graph.facebook.com/\(facebookID)/picture?type=large&return_ssl_resources=1"
                            var pictureURL = "https://graph.facebook.com/\(userId)/picture?width=150&height=150"
                            print(pictureURL)
                            var URLRequest = NSURL(string: pictureURL)
                            var URLRequestNeeded = NSURLRequest(URL: URLRequest!)
                            
                            
                            //        NSURLConnection.sendAsynchronousRequest(URLRequestNeeded, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!, error: NSError!) -> Void in
                            //            if error == nil {
                            //                var picture = PFFile(data: data)
                            //                PFUser.currentUser()!.setObject(picture, forKey: "picture")
                            //                PFUser.currentUser()!.saveInBackground()
                            //            }
                            //            else {
                            //                println("Error: \(error.localizedDescription)")
                            //            }
                            //            })
                            
                            let task = NSURLSession.sharedSession().dataTaskWithURL(URLRequest!) { (data, response, error) -> Void in
                                
                                if error != nil {
                                    print("thers an error in the log")
                                } else {
                                    
                                    var picture = PFFile(data: data!)
                                    user.setObject(picture!, forKey: "picture_file")
                                    user.saveInBackground()
                                    print("pic uploaded2")
                                    
                                }
                            }
                            
                            
                            
                            task.resume()
                            user.saveInBackground()
                            
                            print ("signed up")
                        }
                    }
                }
                
                
                //
                //                var user = PFUser.currentUser()
                //                user.setValue(newEmail, forKey: "username")
                //                user.saveInBackgroundWithBlock {
                //                    (succeeded: Bool!, error: NSError!) -> Void in
                //                    if error == nil {
                //                        print("Profile Updated.")
                //                    } else {
                //                        print("Failed")
                //                        //present alert to user to let them know that it failed
                //                        //ask them to try a new email address
                //                    }
                //                }
                //
                //                
                //                if
                
                
                
                //                //test log in
                //                PFUser.logInWithUsernameInBackground(userId, password:"0000") {
                //                    (user: PFUser?, error: NSError?) -> Void in
                //                    if user != nil {
                //                        // Do stuff after successful login.
                //                       
                //                       
                //                         print("login successful")
                //                    } else {
                //                        print("trying to sign up")
                //                        //log in failed - try sign up
                //                        
                //                        
                //                  
                //                        
                //                        
                //                    }
                //                }
                
                
                //user.password="0000"
                
                
                //user.username = "ooo"
                
                
                
                
                //user.saveInBackground()
                
                
                
                
                
                
                //    }
                
                //    func saveNewUser() {
                //    var parseUser = ParseUser.getCurrentUser();
                //    parseUser.setUsername(name);
                //    parseUser.setEmail(email);
                //    //        Saving profile photo as a ParseFile
                //    ByteArrayOutputStream stream = new ByteArrayOutputStream();
                //    Bitmap bitmap = ((BitmapDrawable) mProfileImage.getDrawable()).getBitmap();
                //    bitmap.compress(Bitmap.CompressFormat.JPEG, 70, stream);
                //    byte[] data = stream.toByteArray();
                //    String thumbName = parseUser.getUsername().replaceAll("\\s+", "");
                //    final ParseFile parseFile = new ParseFile(thumbName + "_thumb.jpg", data);
                //    parseFile.saveInBackground(new SaveCallback() {
                //    @Override
                //    public void done(ParseException e) {
                //    parseUser.put("profileThumb", parseFile);
                //    //Finally save all the user details
                //    parseUser.saveInBackground(new SaveCallback() {
                //    @Override
                //    public void done(ParseException e) {
                //    Toast.makeText(MainActivity.this, "New user:" + name + " Signed up", Toast.LENGTH_SHORT).show();
                //    }
                //    });
                //    }
                //    });
                //    }
                
                
            })
        })
        
        
    }
}
