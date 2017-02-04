//
//  AppDelegate.swift
//  StickerSpread
//
//  Created by Student iMac on 5/26/16.
//  Copyright © 2016 Student iMac. All rights reserved.
//

import UIKit
//import Parse
//import Bolts
import Firebase



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    var coordinate: CLLocationCoordinate2D?

    var window: UIWindow?
    

    //func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //Parse.enableLocalDatastore()
        //Parse.setApplicationId("y7yHA6fQwxhktMAkFntZdnFDvjW6HTGzKnJMEsOl",clientKey:"N9xwixCfHmxgucpHvFNPUzA48XkynlRDWY8vt7aW")
        
        FIRApp.configure()
          FIRDatabase.database().persistenceEnabled = true

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance()
            .application(app,
                         open: url,
                         sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
                         annotation: options[UIApplicationOpenURLOptionsKey.annotation])

    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        locationManagerStart()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        locationManagerStop()
    }
    
    func login(){
        // remember user's login
       // let username : String? = PFUser.current()?.username
            //NSUserDefaults.standardUserDefaults().stringForKey("username")
        
    
        // if loged in
        if let user = FIRAuth.auth()?.currentUser {
            
            
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
            let myTabBar = storyboard.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
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

