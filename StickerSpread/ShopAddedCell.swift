//
//  AddShopCell.swift
//  StickerSpread
//
//  Created by Student on 10/22/16.
//  Copyright © 2016 Student iMac. All rights reserved.
//

import UIKit

class ShopAddedCell: UITableViewCell {
    var delegate: AddShop1!
    @IBOutlet weak var Shopname : UITextView!
    
    var pos = Int()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func RemoveShopButton(_ sender: AnyObject) {
        delegate.RemoveShop(pos: pos)

        
    }

}
