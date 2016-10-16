//
//  FieldUploadCell.swift
//  StickerSpread
//
//  Created by Student on 9/10/16.
//  Copyright © 2016 Student iMac. All rights reserved.
//

import UIKit

class FieldUploadCell: UITableViewCell ,UITextFieldDelegate{
    
    @IBOutlet weak var Field: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    
    var isFirst : Bool!
    var pos : Int!
    
    var delegateField : CustomCellDelegate!
    
    
    
    var delegate: AddShop1!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Field.delegate = self
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
        delegate.AddShop(isFirst: isFirst, pos: pos)
        if self.isFirst == true {
            self.isFirst = false
            addBtn.setBackgroundImage(UIImage(named: "Back Arrow.png")! as UIImage, for: .normal)
        }
        //self.isLast = self.isLast!
        
    }
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
       if self.pos != nil {
        
                        if isFirst == true {
                            if Field.text != "" {
                                addBtn.isHidden = false
                            } else {
                                addBtn.isHidden = true
                            }
                        }
        }

        return true
    }
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        
//        if self.pos != nil {
//            
//            if isLast == true {
//                if Field.text != "" {
//                    addBtn.isHidden = false
//                }
//            }
//        }
//
//    }
    func textFieldDidEndEditing(_ textField : UITextField) {
        var ind = Int()
        if self.pos == nil {
           ind = 0
        } else {
           ind = pos+1
            if isFirst == true {
                if Field.text != "" {
                    addBtn.isHidden = false
                } else {
                    addBtn.isHidden = true
                }
            }
        }

        delegateField?.didEditTextField(test: self.Field.text!, atIndex: ind)
        // call back with the delegate here
        // delegate?.didEditTextField(textfield.text, atIndex: self.index)
    }
    
}
