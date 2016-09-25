//
//  pictureCell.swift
//  StickerSpread
//
//  Created by Student iMac on 5/30/16.
//  Copyright © 2016 Student iMac. All rights reserved.
//

import UIKit

class pictureCell: UICollectionViewCell {
    @IBOutlet weak var picImg: UIImageView!
    
    
    // default func
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // alignment
        let width = UIScreen.main.bounds.width
        picImg.frame = CGRect(x:0, y:0, width: width / 3,height: width / 3)
    }
}
