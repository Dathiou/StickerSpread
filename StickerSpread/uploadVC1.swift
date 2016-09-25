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
    func loadStickerForm()
    func loadAnnoucementForm()
    // func zoomImg(picImg : UIImageView, removeBtn : UIButton)
    
}

protocol UploadInput{
    func checkBoxClicked()
}

protocol AddShop1{
    func AddShop(isLast : Bool, pos : Int)
}

class uploadVC1: UITableViewController,ImagePickerDelegate, UploadInput, AddShop1,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var cellDescriptorsStickers: NSMutableArray!
    var cellDescriptorsAnnouncement: NSMutableArray!
    
    var cellDescriptors: NSMutableArray!
    
    //var visibleRows = [Int]()
    var visibleRowsPerSection = [[Int]]()
    
    let ItemsStickers = ["Title*:","Shop*:","Layout*","Color*:","Months*:","Finish*:","UFG - Up For Grabs?*:"]
    var picked = false
    var tempImage : UIImage!
    var zoomTap = UITapGestureRecognizer()
    
    var myBigImage : UIImageView!
    
    var listShop = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
       // self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        
        // Add a background view to the table view
        let backgroundImage = UIImage(named: "Background_Blue_Joint.jpg")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFit
        self.tableView.backgroundView = imageView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        self.tableView.estimatedRowHeight = 88
        self.tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName: "HeaderUpload", bundle: nil), forCellReuseIdentifier: "idHeaderUpload")
        tableView.register(UINib(nibName: "FieldUpload", bundle: nil), forCellReuseIdentifier: "idFieldUpload")
        
        tableView.register(UINib(nibName: "NormalCell", bundle: nil), forCellReuseIdentifier: "idCellNormal")
        tableView.register(UINib(nibName: "childCell", bundle: nil), forCellReuseIdentifier: "idChildCell")
        tableView.register(UINib(nibName: "filterButtonCell", bundle: nil), forCellReuseIdentifier: "idFilterButtonCell")
        
        zoomTap = UITapGestureRecognizer(target: self, action: Selector("zoomImg:"))
        zoomTap.numberOfTapsRequired = 1
        cellDescriptorsAnnouncement = loadcellDescriptors(fileName: "AnnoucementUploadCellDescriptor")
        cellDescriptorsStickers = loadcellDescriptors(fileName: "StickersUploadCellDescriptor")
        
        cellDescriptors = cellDescriptorsStickers
        //tableView.reloadData()
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "Background_Blue_Joint.jpg")!)
        
        
    }
    
    func pickImage() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    // zooming in / out function
    func zoomImg(sender: UITapGestureRecognizer){//picImg : UIImageView,removeBtn: UIButton) {
        let myBigImage = sender.view as! UIImageView
        //let unzoomed = CGRect(x: 15, y: 15, width: self.view.frame.size.width / 4.5, height: self.view.frame.size.width / 4.5)
        
        let unzoomed = myBigImage.frame
        
        
        
        //let imageView = UIView()
        //imageView
        
        
        // define frame of zoomed image
        //let zoomed = CGRectMake(0, self.view.center.y - self.view.center.x, self.view.frame.size.width, self.view.frame.size.width)
        // let zoomed = CGRectMake(0, self.view.center.y - self.view.center.x - self.tabBarController!.tabBar.frame.size.height * 1.5, self.view.frame.size.width, self.view.frame.size.width)
        let zoomed = CGRect(x:0, y:UIScreen.main.bounds.height/2-UIScreen.main.bounds.width/2,width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        
        // frame of unzoomed (small) image
        //let unzoomed = CGRectMake(15, self.tabBarController!.tabBar.frame.size.height + 35 , self.view.frame.size.width / 4.5, self.view.frame.size.width / 4.5)
        //let unzoomed =  CGRectMake(15, self.navigationController!.navigationBar.frame.size.height + 35 , self.view.frame.size.width / 4.5, self.view.frame.size.width / 4.5)
        //let unzoomed = CGRectMake(15, 15, self.view.frame.size.width / 4.5, self.view.frame.size.width / 4.5)
        
        // if picture is unzoomed, zoom it
        if myBigImage.frame == unzoomed {
            
            // with animation
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                // resize image frame
                //self.parentView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
                
                self.navigationController!.view.addSubview(myBigImage)
                myBigImage.frame = zoomed
                
                
                // hide objects from background
                self.tableView.isHidden = true
                self.navigationController?.navigationBar.alpha = 0
                self.navigationController?.tabBarController?.tabBar.alpha = 0
                //self.titleTxt.alpha = 0
                //self.publishBtn.alpha = 0
                //removeBtn.alpha = 0
            })
            
            // to unzoom
        } else {
            
            // with animation
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                // resize image frame
                
                myBigImage.removeFromSuperview()
                self.tableView.isHidden = false
                self.navigationController?.navigationBar.alpha = 1
                self.navigationController?.tabBarController?.tabBar.alpha = 1
                myBigImage.frame = unzoomed
                
                // unhide objects from background
                //self.view.backgroundColor = .whiteColor()
                //self.titleTxt.alpha = 1
                //self.publishBtn.alpha = 1
                //removeBtn.alpha = 1
            })
        }
        
    }
    
    
    
    // hold selected image in picImg object and dissmiss PickerController()
    func imagePickerController(imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.picked = true
        tableView.reloadData()
        
        self.tempImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.dismiss(animated: true, completion: nil)
        
        //        // enable publish btn
        //        publishBtn.enabled = true
        //        publishBtn.backgroundColor = UIColor(red: 52.0/255.0, green: 169.0/255.0, blue: 255.0/255.0, alpha: 1)
        
        
        
        // implement second tap for zooming image
        
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 1
    //    }
    
    //    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        // #warning Incomplete implementation, return the number of rows
    //        return visibleRows.count
    //    }
    
    //    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        return UITableViewAutomaticDimension
    //    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        let indexOfTappedRow = visibleRowsPerSection[indexPath.section][indexPath.row]
        
        
        if ((cellDescriptors[indexPath.section] as AnyObject).object(at: indexOfTappedRow) as AnyObject).value(forKey:"isExpandable") as! Bool == true {
            var shouldExpandAndShowSubRows = false
            if ((cellDescriptors[indexPath.section] as AnyObject).object(at: indexOfTappedRow) as AnyObject).value(forKey:"isExpanded") as! Bool == false {
                // In this case the cell should expand.
                shouldExpandAndShowSubRows = true
            }
            
            ((cellDescriptors[indexPath.section] as! NSMutableArray).object(at: indexOfTappedRow) as! NSDictionary).setValue(shouldExpandAndShowSubRows, forKey: "isExpanded")
            
            for i in (indexOfTappedRow + 1)...(indexOfTappedRow + (((cellDescriptors[indexPath.section] as! NSMutableArray).object(at: indexOfTappedRow) as! NSDictionary).object(forKey: "additionalRows") as! Int)) {
                ((cellDescriptors[indexPath.section] as! NSMutableArray).object(at: i) as! NSDictionary).setValue(shouldExpandAndShowSubRows, forKey: "isVisible")
            }
        } else {
            if ((cellDescriptors[indexPath.section] as! NSMutableArray).object(at: indexOfTappedRow) as! NSDictionary).object(forKey: "cellIdentifier") as! String == "idChildCell"  {
                var indexOfParentCell: Int!
                
                for i in (1...indexOfTappedRow-1).reversed() {
                
                    if ((cellDescriptors[indexPath.section] as! NSMutableArray).object(at: i) as! NSDictionary).value(forKey:"isExpandable") as! Bool == true {
                        indexOfParentCell = i
                        break
                    }
                }
                
                if ((cellDescriptors[indexPath.section] as AnyObject).object(at: indexOfTappedRow) as AnyObject).value(forKey:"isChecked") as! Bool == false {
                    var t = ((cellDescriptors[indexPath.section] as! NSMutableArray).object(at: indexOfParentCell) as! NSDictionary).value(forKey:"oneChecked") as? Bool
                    if t != nil {
                        if t == true {
                            var additionalRows = ((cellDescriptors[indexPath.section] as! NSMutableArray).object(at: indexOfParentCell) as! NSDictionary)["additionalRows"] as! Int
                            //cell.SelectedOverview.text = primaryTitle as? String
                            for n in (1...additionalRows) {
                            
                                ((cellDescriptors[indexPath.section] as! NSMutableArray).object(at: n) as! NSDictionary).setValue(false,forKey: "isChecked")
                                let prop = ((cellDescriptors[indexPath.section] as! NSMutableArray).object(at: n) as! NSDictionary).value(forKey: "propertyForParent") as! String
                                ((cellDescriptors[indexPath.section] as! NSMutableArray).object(at: indexOfParentCell) as! NSDictionary).setValue(false, forKey: prop)
                                //let indexPath1 = NSIndexPath(forRow: n, inSection: indexPath.section)
                                //let myCell = tableView.cellForRowAtIndexPath(indexPath1) as! CustomCell
                                //myCell.checkBoxButton.isChecked = false
                                
                            }
                            tableView.reloadSections(NSIndexSet(index: indexPath.section) as IndexSet, with: .none)
                            ((cellDescriptors[indexPath.section] as! NSMutableArray).object(at: indexOfParentCell) as! NSDictionary).setValue("", forKey: "primaryTitle")
                        }
                        
                    }
                }
                
                
                let property = ((cellDescriptors[indexPath.section] as! NSMutableArray).object(at: indexOfTappedRow) as! NSDictionary).value(forKey: "propertyForParent") as! String
                
                let cell = self.tableView.cellForRow(at: indexPath as IndexPath) as! CustomCell
                cell.checkBoxButton.isChecked = !cell.checkBoxButton.isChecked
                ((cellDescriptors[indexPath.section] as! NSMutableArray).object(at: indexOfParentCell) as! NSDictionary).setValue(cell.checkBoxButton.isChecked, forKey: property)
                
                
                ((cellDescriptors[indexPath.section] as! NSMutableArray).object(at: indexOfTappedRow) as! NSDictionary).setValue(cell.checkBoxButton.isChecked, forKey: "isChecked")
                
                let typeSelected = ((cellDescriptors[indexPath.section] as! NSMutableArray).object(at: indexOfParentCell) as! NSDictionary)["type"] as! String
                var myList = [String]()
                
                if  typeSelected == "Layout" {
                    myList = ["Vertical","Horizontal"]
                } else if  typeSelected == "Month" {
                    myList = ["January","February","March","April","May","June","July","August","September","October","November","December"]
                } else if typeSelected == "Color" {
                    myList = ["Blue","Pink","Yellow"]
                } else if typeSelected == "Finish" {
                    myList = ["Matte","Glossy","Vinyl"]
                } else if typeSelected == "Grab" {
                    
                    myList = ["Available","Not Available"]
                } else if typeSelected == "TimeZone" {
                    
                    myList = ["PST","MST","CST" , "EST"]
                }
                
                var toBeDisplayed = ""
                for i in myList {
                    if ((cellDescriptors[indexPath.section] as! NSMutableArray).object(at: indexOfParentCell) as! NSDictionary).value(forKey: i ) as! Bool == true {
                        if toBeDisplayed != "" {
                            toBeDisplayed += ", "
                        }
                        toBeDisplayed += i 
                        
                        
                    }
                    ((cellDescriptors[indexPath.section] as! NSMutableArray).object(at: indexOfParentCell) as! NSDictionary).setValue(toBeDisplayed, forKey: "primaryTitle")
                    
                }
                //tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.None)
                
            }
            
            
        }
        getIndicesOfVisibleRows(cellDescriptors: cellDescriptors)
        //ExpListFilters.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
        tableView.reloadData()
        //adjustHeightOfTableview()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let currentCellDescriptor = getCellDescriptorForIndexPath(indexPath: indexPath)
        if currentCellDescriptor["cellIdentifier"] as! String == "idHeaderUpload" {
            if self.picked == false {
                let cell = tableView.dequeueReusableCell(withIdentifier: "idHeaderUpload", for: indexPath as IndexPath) as! HeaderUploadCell
                //cell.backgroundColor = UIColor.clearColor()
                cell.backgroundColor = UIColor(patternImage: UIImage(named: "Background_Blue_Joint.jpg")!)
                cell.delegate = self
                cell.removeBtn.isHidden = true
                
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "idHeaderUpload", for: indexPath as IndexPath) as! HeaderUploadCell
                //cell.backgroundColor = UIColor.clearColor()
                
                
                cell.delegate = self
                cell.picImg.image = self.tempImage
                // unhide remove button
                cell.removeBtn.isHidden = false
                cell.picImg.isUserInteractionEnabled = true
                cell.picImg.addGestureRecognizer(zoomTap)
                //self.picked = false
                return cell
                
            }
            
            
        } else if currentCellDescriptor["cellIdentifier"] as! String == "idFieldUpload" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "idField", for: indexPath as IndexPath) as! FieldUploadCell
            //cell.backgroundColor = UIColor.clearColor()
            cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
            
            //            if(indexPath.row > tableView.numberOfRowsInSection(1)){
            //                cell.Field.text = "Add Row";
            //            }
            cell.addBtn.isHidden = true
            if currentCellDescriptor["primaryTitle"] as? String == "Shop*:" {
                cell.addBtn.isHidden = false
                if visibleRowsPerSection[indexPath.section].count == indexPath.row + 1 {
                    //cell.addBtn.hidden = false
                    cell.isLast = true
                    
                    cell.addBtn.setBackgroundImage(UIImage(named: "Plus.png")! as UIImage, for: .normal)
                    
                } else {
                    //cell.addBtn.hidden = true
                    cell.isLast = false
                    cell.addBtn.setBackgroundImage(UIImage(named: "Back Arrow.png")! as UIImage, for: .normal)
                    
                }
                cell.pos = indexPath.row
                print(cell.pos)
            } else if currentCellDescriptor["primaryTitle"] as? String == "Title*:"{
                
                cell.addBtn.isHidden = true
            }
            
            
            cell.Field.attributedPlaceholder = NSAttributedString(string: (currentCellDescriptor["primaryTitle"] as? String)!, attributes: [NSForegroundColorAttributeName : UIColor(white: 0.6, alpha: 0.5)])
            
            //cell.addBtn.hidden = true
            cell.delegate = self
            return cell
            
        } else  {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: currentCellDescriptor["cellIdentifier"] as! String, for: indexPath as IndexPath) as! CustomCell
            //cell.backgroundColor = UIColor.clearColor()
            cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
            if currentCellDescriptor["cellIdentifier"] as! String == "idCellNormal" {
                
                if let primaryTitle = currentCellDescriptor["primaryTitle"] {
                    //cell.textLabel?.text = primaryTitle as? String
                    cell.SelectedOverview.text = primaryTitle as? String
                }
                
                
                if let secondaryTitle = currentCellDescriptor["secondaryTitle"] {
                    //cell.detailTextLabel?.text = secondaryTitle as? String
                    cell.ParentMainTxt.text = secondaryTitle as? String
                }
            }
            else if currentCellDescriptor["cellIdentifier"] as! String == "idChildCell" {
                //cell.textField.placeholder = currentCellDescriptor["primaryTitle"] as? String
                cell.TxtCell.text = currentCellDescriptor["primaryTitle"] as? String
                cell.checkBoxButton.isChecked = (currentCellDescriptor["isChecked"] as? Bool)!
            } else if currentCellDescriptor["cellIdentifier"] as! String == "idFilterButtonCell" {
                //cell.textField.placeholder = currentCellDescriptor["primaryTitle"] as? String
                cell.LastButton.setTitle(currentCellDescriptor["Title"] as? String, for: .normal)
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width)
            }
            cell.delegate = self
            return cell
            
            
        }
    }
    
    func getCellDescriptorForIndexPath(indexPath: NSIndexPath) -> [String: AnyObject] {
        let indexOfVisibleRow = visibleRowsPerSection[indexPath.section][indexPath.row]
        let cellDescriptor = (cellDescriptors[indexPath.section] as AnyObject).object(at: indexOfVisibleRow) as! [String: AnyObject]
        return cellDescriptor
    }
    func adjustHeightOfTableview(){
        var height : CGFloat = self.tableView.contentSize.height;
        let maxHeight : CGFloat = self.tableView.superview!.frame.size.height - self.tableView.frame.origin.y;
        if (height > maxHeight){
            height = maxHeight;
        }
        //        let frame : CGRect = self.ExpListFilters.frame;
        //        frame.size.height = height;
        //        self.ExpListFilters.frame = frame;
        UIView.animate(withDuration: 0.9, animations: {
            //self.filterViewHeightConstraints.constant = height
            self.tableView.setNeedsUpdateConstraints()
        })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if cellDescriptors != nil {
            return cellDescriptors.count
        }
        else {
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleRowsPerSection[section].count
    }
    
    
    func loadcellDescriptors(fileName : String!) -> NSMutableArray  {
        var cellDescriptors = NSMutableArray()
        if let path = Bundle.main.path(forResource: fileName, ofType: "plist") {
            cellDescriptors = NSMutableArray(contentsOfFile: path)!
            getIndicesOfVisibleRows(cellDescriptors: cellDescriptors)
            
            tableView.reloadData()
            //adjustHeightOfTableview()
            
        }
        return cellDescriptors
        
    }
    
    //    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        switch section {
    //        case 0:
    //            return "Personal"
    //
    //        case 1:
    //            return "Preferences"
    //
    //        default:
    //            return "Work Experience"
    //        }
    //    }
    
    func getIndicesOfVisibleRows(cellDescriptors : NSMutableArray) {
        visibleRowsPerSection.removeAll()
        for currentSectionCells in cellDescriptors{
            var visibleRows = [Int]()
            //for Cells in cellDescriptorsStickers {
            //var visibleRows = [Int]()
            // let y = (Cells as! [String: AnyObject]).count - 1
            
            for row in 0...((currentSectionCells as! [[String: AnyObject]]).count - 1) {
                
                
                if ((currentSectionCells as! NSMutableArray).object(at: row) as! NSDictionary).value(forKey:"isVisible") as! Bool == true {
                    visibleRows.append(row)
                    //print (cellDescriptors[row])
                }
            }
            visibleRowsPerSection.append(visibleRows)
            
        }
    }
    
    func checkBoxClicked(){
        //
        //        var indexOfParentCell: Int!
        //
        //        for var i=indexOfTappedRow - 1; i>=0; --i {
        //            if cellDescriptorsStickers[i]["isExpandable"] as! Bool == true {
        //                indexOfParentCell = i
        //                break
        //            }
        //        }
        //
        
        tableView.beginUpdates()
        let a = visibleRowsPerSection[0]
        tableView.insertRows(at: [
            
            NSIndexPath(row: a.count-1, section: 0) as IndexPath
            ], with: .automatic)
        tableView.endUpdates()
    }
    
    //    func saveShops(){
    //        let cell = tableView.cellForRowAtIndexPath(indexPath) as YourCustomCellClass
    //
    //    }
    
    func AddShop(isLast : Bool, pos : Int ){
        if isLast {
            visibleRowsPerSection[1].append(visibleRowsPerSection[1].last!)
            let a = visibleRowsPerSection[1]
            let indexPath = NSIndexPath(row: a.count-1, section: 1)
            
            tableView.insertRows(at: [indexPath as IndexPath], with: .none)
        } else {
            visibleRowsPerSection[1].remove(at: pos )
            
            let indexPath = NSIndexPath(row: pos , section: 1)
            
            tableView.deleteRows(at: [indexPath as IndexPath], with: .none)
            
            //we want to update the pos of the cells after
            //
            //            let indexPath1 = NSIndexPath(forRow: visibleRowsPerSection[1].count-1, inSection: 1)
            //
            //            self.tableView.reloadRowsAtIndexPaths([indexPath1],withRowAnimation: .None)
            
            
        }
        //tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .None)
        
        // print (visibleRowsPerSection[1].count)
        //try other animations
        //tableView.endUpdates()
        
        
        //        tableView.beginUpdates()
        //        tableView.insertRowsAtIndexPaths([
        //            NSIndexPath(forRow: visibleRowsPerSection[0].count+1, inSection: 0)
        //            ], withRowAnimation: .Automatic)
        //        tableView.endUpdates()
    }
    
    
    func loadStickerForm(){
        cellDescriptors = cellDescriptorsStickers
        getIndicesOfVisibleRows(cellDescriptors: cellDescriptors)
        //        tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .None)
        //        tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: .None)
        tableView.reloadData()
        
    }
    func loadAnnoucementForm(){
        cellDescriptors = cellDescriptorsAnnouncement
        getIndicesOfVisibleRows(cellDescriptors: cellDescriptors)
        //        tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .None)
        //        tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: .None)
        tableView.reloadData()
    }
    
    
    
}




