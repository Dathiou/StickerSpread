//
//  CustomCell.swift
//  Expandable
//
//  Created by Gabriel Theodoropoulos on 28/10/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

import UIKit
import FirebaseAuth


//protocol CustomCellDelegate {
//    func dateWasSelected(selectedDateString: String)
//    
//    func maritalStatusSwitchChangedState(isOn: Bool)
//    
//    func textfieldTextWasChanged(newText: String, parentCell: CustomCell)
//    
//    func sliderDidChangeValue(newSliderValue: String)
//}

class CustomCell: UITableViewCell, UITextFieldDelegate {

    // MARK: IBOutlet Properties
    
    @IBOutlet weak var ParentMainTxt: UILabel!
    @IBOutlet weak var SelectedOverview: UILabel!
    
    @IBOutlet weak var TxtCell: UILabel!
    
    @IBOutlet weak var checkBoxButton: CheckBox!
    
    @IBOutlet weak var LastButton: UIButton!
    

    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var lblSwitchLabel: UILabel!
    
    @IBOutlet weak var swMaritalStatus: UISwitch!
    
    @IBOutlet weak var slExperienceLevel: UISlider!
    
    
    // MARK: Constants
    
    let bigFont = UIFont(name: "Avenir-Book", size: 17.0)
    
    let smallFont = UIFont(name: "Avenir-Light", size: 17.0)
    
    let primaryColor = UIColor.black
    
    let secondaryColor = UIColor.lightGray
    
    
    // MARK: Variables
    
    var delegate: UploadInput!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if textLabel != nil {
            textLabel?.font = bigFont
            textLabel?.textColor = primaryColor
        }
        
        if detailTextLabel != nil {
            detailTextLabel?.font = smallFont
            detailTextLabel?.textColor = secondaryColor
        }
        
        if textField != nil {
            textField.font = bigFont
            textField.delegate = self
        }
        
        if lblSwitchLabel != nil {
            lblSwitchLabel.font = bigFont
        }
        
        if slExperienceLevel != nil {
            slExperienceLevel.minimumValue = 0.0
            slExperienceLevel.maximumValue = 10.0
            slExperienceLevel.value = 0.0
        }
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func ButtonClick(_ sender: AnyObject) {
        // dissmiss keyboard
        self.view.endEditing(true)
        
        
        // Get a reference to the storage service, using the default Firebase App
        let storage = FIRStorage.storage()
        // Create a storage reference from our storage service
        let storageRef = storage.reference(forURL: "gs://stickerspread-4f3a9.appspot.com")
        
        
        //
        //
        //        // send data to server to "posts" class in Parse
        //        let object = PFObject(className: "posts")
        //        object["username"] = PFUser.currentUser()!.username
        
        
        
        //
        //        let first = (object1.objectForKey("first_name") as? String)
        //        let last = (object1.objectForKey("last_name") as? String)
        //
        //        let fullname = first!+" "+last!
        //        self.nameArray.append(fullname)
        //        object["fullname"] = PFUser.currentUser()!.username
        //
        
        //        object["ava"] = PFUser.currentUser()!.valueForKey("picture_file") as! PFFile
        //
        let uuid = NSUUID().uuidString
        //        object["uuid"] = "\(PFUser.currentUser()!.username!) \(uuid)"
        //
        //        if titleTxt.text.isEmpty {
        //            object["title"] = ""
        //        } else {
        //            object["title"] = titleTxt.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        //        }
        
        
        // send pic to server after converting to FILE and comprassion
        let imageData : NSData = UIImageJPEGRepresentation(picImg.image!, 0.5)! as NSData
        
        
        //
        //
        //        let imageFile = PFFile(name: "post.jpg", data: imageData)
        //        object["pic"] = imageFile
        
        
        if let user = FIRAuth.auth()?.currentUser {
            let userID = user.uid;
            print(userID)
            
            
            // Create a reference to the file you want to upload
            let riversRef = storageRef.child("posts/\(userID) \(uuid).jpg")
            
            // Upload the file to the path "images/rivers.jpg"
            let uploadTask = riversRef.put(imageData as Data, metadata: nil) { metadata, error in
                if (error != nil) {
                    // Uh-oh, an error occurred!
                } else {
                    // Metadata contains file metadata such as size, content-type, and download URL.
                    let downloadURL = metadata?.downloadURL()?.absoluteURL
                    
                    let date = NSDate()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                    let dateString = dateFormatter.string(from: date as Date)
                    
                    
                    //                    let name = user.displayName
                    //                    let email = user.email
                    //                    let photoUrl = user.photoURL
                    let uid = user.uid;
                    print(downloadURL)
                    let userDict : [String : AnyObject] = [ "userID" : uid as AnyObject,
                                                            "title"    : "Day Dream Kit" as AnyObject ,
                                                            "layout"   : "vertical" as AnyObject,
                                                            "date" : dateString as AnyObject,
                                                            "photoUrl"    : (downloadURL?.absoluteString)! as AnyObject]
                    let postID = "\(userID) \(uuid)"
                    firebase.child("Posts").child(postID).setValue(userDict)
                    firebase.child("PostPerUser").child("\(userID)").child(postID).setValue(true)
                    
                    
                }
                
            }
        } else {
            // No user is signed in.
        }
        
        

    }
    

//    @IBAction func CheckBoxClicked(sender: AnyObject) {
//
//        delegate.checkBoxClicked()
//    }
    
    // MARK: IBAction Functions
    
//    @IBAction func setDate(sender: AnyObject) {
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
//        let dateString = dateFormatter.stringFromDate(datePicker.date)
//
//        if delegate != nil {
//            delegate.dateWasSelected(dateString)
//        }
//    }
//
//    @IBAction func handleSwitchStateChange(sender: AnyObject) {
//        if delegate != nil {
//            delegate.maritalStatusSwitchChangedState(swMaritalStatus.on)
//        }
//    }
//
//
//    @IBAction func handleSliderValueChange(sender: AnyObject) {
//        if delegate != nil {
//            delegate.sliderDidChangeValue("\(Int(slExperienceLevel.value))")
//        }
//    }
//    
//    
//    // MARK: UITextFieldDelegate Function
//    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        if delegate != nil {
//            delegate.textfieldTextWasChanged(textField.text!, parentCell: self)
//        }
//        
//        return true
//    }
    
}
