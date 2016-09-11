//
//  uploadVC1TableViewController.swift
//  StickerSpread
//
//  Created by Student on 9/10/16.
//  Copyright © 2016 Student iMac. All rights reserved.
//

import UIKit

protocol ImagePickerDelegate {
    
    func pickImage()
    func zoomImg(picImg : UIImageView, removeBtn : UIButton)
    
}

class uploadVC1: UITableViewController,ImagePickerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var picked = false
    var tempImage : UIImage!
    var zoomTap = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        
        self.tableView.estimatedRowHeight = 88
        self.tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "HeaderUpload", bundle: nil), forCellReuseIdentifier: "idHeaderUpload")
        
        zoomTap = UITapGestureRecognizer(target: self, action: "zoomImg")
        zoomTap.numberOfTapsRequired = 1
        
        tableView.reloadData()
        
    }
    
    func pickImage() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.allowsEditing = false
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    

    // zooming in / out function
    func zoomImg(picImg : UIImageView,removeBtn: UIButton) {
        
        // define frame of zoomed image
        //let zoomed = CGRectMake(0, self.view.center.y - self.view.center.x, self.view.frame.size.width, self.view.frame.size.width)
        let zoomed = CGRectMake(0, self.view.center.y - self.view.center.x - self.tabBarController!.tabBar.frame.size.height * 1.5, self.view.frame.size.width, self.view.frame.size.width)
        
        // frame of unzoomed (small) image
        //let unzoomed = CGRectMake(15, self.tabBarController!.tabBar.frame.size.height + 35 , self.view.frame.size.width / 4.5, self.view.frame.size.width / 4.5)
        //let unzoomed =  CGRectMake(15, self.navigationController!.navigationBar.frame.size.height + 35 , self.view.frame.size.width / 4.5, self.view.frame.size.width / 4.5)
        let unzoomed = CGRectMake(15, 15, self.view.frame.size.width / 4.5, self.view.frame.size.width / 4.5)
        
        // if picture is unzoomed, zoom it
        if picImg.frame == unzoomed {
            
            // with animation
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                // resize image frame
                picImg.frame = zoomed
                
                // hide objects from background
                //self.view.backgroundColor = .blackColor()
                //self.titleTxt.alpha = 0
                //self.publishBtn.alpha = 0
                removeBtn.alpha = 0
            })
            
            // to unzoom
        } else {
            
            // with animation
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                // resize image frame
                picImg.frame = unzoomed
                
                // unhide objects from background
                //self.view.backgroundColor = .whiteColor()
                //self.titleTxt.alpha = 1
                //self.publishBtn.alpha = 1
                removeBtn.alpha = 1
            })
        }
        
    }
    
    
    
    // hold selected image in picImg object and dissmiss PickerController()
    func imagePickerController(imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.picked = true
        tableView.reloadData()
        
        self.tempImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
        
        //        // enable publish btn
        //        publishBtn.enabled = true
        //        publishBtn.backgroundColor = UIColor(red: 52.0/255.0, green: 169.0/255.0, blue: 255.0/255.0, alpha: 1)
        

        
        // implement second tap for zooming image
        

    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //if indexPath.row == 0{
        if self.picked == false {
            let cell = tableView.dequeueReusableCellWithIdentifier("idHeaderUpload", forIndexPath: indexPath) as! HeaderUploadCell
                   cell.backgroundColor = UIColor(patternImage: UIImage(named: "Background_Blue_Joint.jpg")!)
            cell.delegate = self
            cell.removeBtn.hidden = true
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("idHeaderUpload", forIndexPath: indexPath) as! HeaderUploadCell
                   cell.backgroundColor = UIColor(patternImage: UIImage(named: "Background_Blue_Joint.jpg")!)
            cell.delegate = self
            cell.picImg.image = self.tempImage
            // unhide remove button
            cell.removeBtn.hidden = false
            cell.picImg.userInteractionEnabled = true
            cell.picImg.addGestureRecognizer(zoomTap)
            //self.picked = false
            return cell
        }
        
    }
}



