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
        let checkedImage = UIImage(named: "Dash Box 2.png")! as UIImage
        let uncheckedImage = UIImage(named: "Dash Box 1.png")! as UIImage
        
        // Bool property
        var isChecked: Bool = false {
            didSet{
                if isChecked == true {
                    self.setImage(checkedImage, for: .normal)
                    
                } else {
                    self.setImage(uncheckedImage, for: .normal)
                }
            }
        }
        
        override func awakeFromNib() {
            self.addTarget(self, action: #selector(buttonClicked(_:)), for: UIControlEvents.touchUpInside)
            self.isChecked = false
        }
        
        func buttonClicked(_ sender: UIButton) {
            if sender == self {
                isChecked = !isChecked
            }
        }
    }


