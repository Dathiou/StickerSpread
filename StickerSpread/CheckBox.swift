//
//  CheckBox.swift
//  StickerSpread
//
//  Created by Student iMac on 6/23/16.
//  Copyright © 2016 Student iMac. All rights reserved.
//



    import UIKit
    
    class CheckBox: UIButton {
        // Images
        let checkedImage = UIImage(named: "like.png")! as UIImage
        let uncheckedImage = UIImage(named: "unlike.png")! as UIImage
        
        // Bool property
        var isChecked: Bool = false {
            didSet{
                if isChecked == true {
                    self.setImage(checkedImage, forState: .Normal)
                } else {
                    self.setImage(uncheckedImage, forState: .Normal)
                }
            }
        }
        
        override func awakeFromNib() {
            self.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            self.isChecked = false
        }
        
        func buttonClicked(sender: UIButton) {
            if sender == self {
                isChecked = !isChecked
            }
        }
    }


