//
//  tabbarVC.swift
//  StickerSpread
//
//  Created by Student iMac on 6/4/16.
//  Copyright © 2016 Student iMac. All rights reserved.
//

import UIKit
import Firebase

var userfromTabbar = String()

class tabbarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // color of item
        self.tabBar.tintColor = .whiteColor()
        
        // color of background
        self.tabBar.barTintColor = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.1)
        
        // disable translucent
        self.tabBar.translucent = true
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if item.tag == 5 {
//            var VC2: UIViewController = vcArray.objectAtIndex(1) as UIViewController
//            var nextVC = VC2 as HomeVC1
            userfromTabbar = (FIRAuth.auth()?.currentUser!.uid)!
        }
    }
    



}
