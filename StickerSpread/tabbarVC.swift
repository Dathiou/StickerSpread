//
//  tabbarVC.swift
//  StickerSpread
//
//  Created by Student iMac on 6/4/16.
//  Copyright © 2016 Student iMac. All rights reserved.
//

import UIKit

class tabbarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // color of item
        self.tabBar.tintColor = .whiteColor()
        
        // color of background
        self.tabBar.barTintColor = UIColor(red: 37.0 / 255.0, green: 39.0 / 255.0, blue: 42.0 / 255.0, alpha: 1)
        
        // disable translucent
        self.tabBar.translucent = false
    }


}
