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
        let width = UIScreen.mainScreen().bounds.width
        picImg.frame = CGRectMake(0, 0, width / 3, width / 3)
    }
}
