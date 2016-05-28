//
//  signInVC.swift
//  StickerSpread
//
//  Created by Student iMac on 5/26/16.
//  Copyright © 2016 Student iMac. All rights reserved.
//

import UIKit

class signInVC: UIViewController {

    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var forgotBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
//clicked signin button
    @IBAction func signInBtn_click(sender: AnyObject) {
        print(" sign in pressed")
    }

}
