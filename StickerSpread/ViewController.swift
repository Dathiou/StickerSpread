
//
//  ViewController.swift
//  StickerSpread
//
//  Created by Student iMac on 5/26/16.
//  Copyright © 2016 Student iMac. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(loginButton)
        loginButton.center = view.center
        loginButton.delegate = self
        
        if let token = FBSDKAccessToken.currentAccessToken(){
            fetchProfile()
        }
    }

func fetchProfile(){
    print("fetch profile")
    let parameters = ["fields":"email, first_name, last_name, picture.type(large)"]
    FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler({ (connection,result,error) -> Void in
        if error != nil{
            print(error)
            return
        }
        if let email = result["email"] as? String {
            print(email)
        }
        
        if let picture = result["picture"] as? NSDictionary, data = picture["data"] as? NSDictionary,
            url = data["url"] as? String{
                print(url)
            }
        print(result)
        })
}
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!){}

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result:
        FBSDKLoginManagerLoginResult!, error: NSError!){
        print("completed login")
        fetchProfile()
    }


    
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool{
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

