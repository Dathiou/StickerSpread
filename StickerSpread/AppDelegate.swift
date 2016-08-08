//
//  AppDelegate.swift
//  StickerSpread
//
//  Created by Student iMac on 5/26/16.
//  Copyright © 2016 Student iMac. All rights reserved.
//

import UIKit
import Parse
//import Bolts
import Firebase



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    var coordinate: CLLocationCoordinate2D?
    let APP_ID = "BADDD42C-3E07-A223-FF5F-20C0E7934700"
    let SECRET_KEY = "601848B1-12F3-7D05-FF31-770C359B0800"
    let VERSION_NUM = "v1"

    var window: UIWindow?
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
       
        // If you plan to use Backendless Media Service, uncomment the following line (iOS ONLY!)
        // backendless.mediaService = MediaService()
     
        
        
        
        
        //let configuration = ParseClientConfiguration {
        //    $0.applicationId = "y7yHA6fQwxhktMAkFntZdnFDvjW6HTGzKnJMEsOl"
        //    $0.server = "http://N9xwixCfHmxgucpHvFNPUzA48XkynlRDWY8vt7aW:1337/parse"
        //}
        Parse.enableLocalDatastore()
        Parse.setApplicationId("y7yHA6fQwxhktMAkFntZdnFDvjW6HTGzKnJMEsOl",clientKey:"N9xwixCfHmxgucpHvFNPUzA48XkynlRDWY8vt7aW")
        
        FIRApp.configure()
          FIRDatabase.database().persistenceEnabled = true
       // Parse.initializeWithConfiguration(configuration)        // Override point for customization after application launch.
        
//        let testObject = PFObject(className: "TestObject")
//        testObject["foo"] = "bar"
//        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//            print("Object has been saved.")
//        }
        return true
    }
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool{
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        locationManagerStart()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        locationManagerStop()
    }
    
    func login()
{
        // remember user's login
        let username : String? = PFUser.currentUser()?.username
            //NSUserDefaults.standardUserDefaults().stringForKey("username")
        
        
        // if loged in
        if let us = PFUser.currentUser() {
            
            
//            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
//            FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
//                // ...
//            }
//            if let user = FIRAuth.auth()?.currentUser {
//                let name = user.displayName
//                let email = user.email
//                let photoUrl = user.photoURL
//                let uid = user.uid;  // The user's ID, unique to the Firebase project.
//                // Do NOT use this value to authenticate with
//                // your backend server, if you have one. Use
//                // getTokenWithCompletion:completion: instead.
//            } else {
//                // No user is signed in.
//            }
            
            
            
            print("username dispo")
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let myTabBar = storyboard.instantiateViewControllerWithIdentifier("tabBar") as! UITabBarController
            window?.rootViewController = myTabBar
            
    
        } 
 
        
        
    }
    
    
    //MARK:  LocationManger fuctions
    
    func locationManagerStart() {
        
        if locationManager == nil {
            print("init locationManager")
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.requestWhenInUseAuthorization()
        }
        
        print("have location manager")
        locationManager!.startUpdatingLocation()
    }
    
    func locationManagerStop() {
        locationManager!.stopUpdatingLocation()
    }



}

