//
//  FieldUploadCell.swift
//  StickerSpread
//
//  Created by Student on 9/10/16.
//  Copyright © 2016 Student iMac. All rights reserved.
//

import UIKit

class FieldUploadCell: UITableViewCell {
    
    @IBOutlet weak var Field: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    
    var isLast : Bool!
    var pos : Int!
    
    
    
    
    
    var delegate: AddShop1!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        if isLast != nil {
//            if isLast == true {
//                addBtn.setBackgroundImage(UIImage(named: "Plus.png")! as UIImage, forState: .Normal)
//            } else {
//                addBtn.setBackgroundImage(UIImage(named: "Back Arrow.png")! as UIImage, forState: .Normal)
//            }
//        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func AddShop(_ sender: AnyObject) {
        delegate.AddShop(isLast: isLast, pos: pos)
        if self.isLast == true {
            self.isLast = false
            addBtn.setBackgroundImage(UIImage(named: "Back Arrow.png")! as UIImage, for: .normal)
        }
        //self.isLast = self.isLast!
        
    }
    
}
