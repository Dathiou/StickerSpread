//
//  HeaderUploadCellTableViewCell.swift
//  StickerSpread
//
//  Created by Student on 9/10/16.
//  Copyright © 2016 Student iMac. All rights reserved.
//

import UIKit



class HeaderUploadCell: UITableViewCell {

    
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var picImg: UIImageView!
    var a = 1
    
    var delegate : ImagePickerDelegate?
    
    func selectImg() {
        
        delegate?.pickImage()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        picImg.image = UIImage(named: "pbg.jpg")
        
        
//        // hide kyeboard tap
//        let hideTap = UITapGestureRecognizer(target: self, action: "hideKeyboardTap")
//        hideTap.numberOfTapsRequired = 1
//        self.userInteractionEnabled = true
//        self.addGestureRecognizer(hideTap)

        
        // select image tap
        let picTap = UITapGestureRecognizer(target: self, action: #selector(HeaderUploadCell.selectImg))
        picTap.numberOfTapsRequired = 1
        picImg.isUserInteractionEnabled = true
        picImg.addGestureRecognizer(picTap)
        
//        hideTap.cancelsTouchesInView = false
        picTap.cancelsTouchesInView = false
        

    }


    
    @IBAction func StickersClick(_ sender: AnyObject) {
        delegate?.loadStickerForm()
        
    }
    @IBAction func AnoucementClick(_ sender: AnyObject) {
        delegate?.loadAnnoucementForm()
    }
    
    




    
    

    
    // zooming in / out function
//    func zoomImg1() {
//        delegate?.zoomImg(picImg, removeBtn: removeBtn)
//    }
    

}
