

//
//  feedVC.swift
//  StickerSpread
//
//  Created by Student iMac on 6/4/16.
//  Copyright © 2016 Student iMac. All rights reserved.
//

import UIKit
//import Parse
import Firebase






func getLikeState(string: String , Btn :UIButton){
    
    firebase.child("Likes").child(string).child((FIRAuth.auth()?.currentUser!.uid)!).observeSingleEvent(of: .value, with: { snapshot in//observeEventType(.Value, withBlock: { snapshot in
        //print(snapshot.value)
        if snapshot.exists() {
            
            Btn.setTitle("like", for: .normal)
            Btn.setBackgroundImage(UIImage(named: "Heart 2.png"), for: .normal)
        } else {
            
            _ = false
            Btn.setTitle("unlike", for: .normal)
            Btn.setBackgroundImage(UIImage(named: "Heart 1.png"), for: .normal)
        }
    })
    
    //    if exists {
    //        Btn.setTitle("like", forState: .Normal)
    //        Btn.setBackgroundImage(UIImage(named: "Heart 2.png"), forState: .Normal)
    //    }else {
    //        Btn.setTitle("unlike", forState: .Normal)
    //        Btn.setBackgroundImage(UIImage(named: "Heart 1.png"), forState: .Normal)
    //    }
    
    
}

func getLikeCount(string: String , Lbl :UIButton){
    
    var num = "r"
    firebase.child("Likes").child(string).observeSingleEvent(of: .value, with: { snapshot in
        if snapshot.exists() {
            num = "\(snapshot.childrenCount)"
            //Lbl.setTitle("\(snapshot.childrenCount)", forState: UIControlState.Normal)
            //Lbl.text =  "\(snapshot.childrenCount)"
            Lbl.setTitle(num, for: .normal)
            
        } else {
            num = "0"
            //Lbl.setTitle("0", forState: .Normal)
            Lbl.setTitle(num, for: .normal)
        }
    })
    
    
    
}

//protocol ExpandDelegate {
//    func loadCellDescriptors(fileName : String!)
//    func getIndicesOfVisibleRows()
//    func getCellDescriptorForIndexPath(indexPath: NSIndexPath) -> [String: AnyObject]
//}


class feed1VC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate ,UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout, SegueColl, segueToPostFromFeed{
    var modeSelf = false
    let storage = FIRStorage.storage()
    let storageRef = FIRStorage.storage().reference(forURL: "gs://stickerspread-4f3a9.appspot.com")
    
    @IBOutlet weak var filterViewHeightConstraints: NSLayoutConstraint!
    
    //@IBOutlet var tableViewSearch: UITableView!
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var ExpListFilters: UITableView!
    
    // MARK: Variables
    
    var cellDescriptors: NSMutableArray!
    
    var visibleRows = [Int]()
    
    
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var refresher = UIRefreshControl()
    
    // arrays to hold server data
    var usernameArray = [String]()
    //var avaArray = [PFFile]()
    //var avaArrayF = [UIImage]()
    var avaArray = [UIImage]()
    //var postpicArraySearch = [PFFile]()
    var nameArray = [String]()
    var nameArraySearch = [String]()
    var dateArray = [Date]()
    var dateArraySearch = [Date]()
    //var picArray = [PFFile]()
    var picArray = [UIImage]()
    var picArrayURL = [String]()
    //var picArraySearch = [PFFile]()
    var uuidArraySearch = [String]()
    var titleArray = [String]()
    var titleArraySearch = [String]()
    var uuidArray = [String]()
    
    var myDictionaryURL = [Int: String]()
    var myDictionaryImage = [Int: UIImage]()
    
    
    //var tableViewSearch : UITableView!
    
    var followArray = [String]()
    
    // page size
    var page : Int = 10
    
    var showColl = false
    var showList = true
    var changeviewwhilesearching = false
    var alreadyInColl = false
    
    //var tableViewSearch = UITableView()
    
    // collectionView UI
    //var collectionView : UICollectionView!
    
    //for search
    // declare search bar
    var searchBar = UISearchBar()
    
    // tableView arrays to hold information from server
    var usernameArraySearch = [String]()
    //var avaArraySearch = [PFFile]()
    
    
    var shouldShowSearchResults = false
    
    var searchController: UISearchController!
    
    let btn1 = UIButton()
    
    let btn2 = UIButton()
    
    var initialized = 0
    
    //var likeArray = [String]()
    
    //var customSearchController: CustomSearchController!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //        // Initialize the Dictionary
        //        var dict = ["name": "John", "surname": "Doe"]
        //
        //        // Add a new key with a value
        //
        //        dict["email"] = "john.doe@email.com"
        //
        //        print(dict)
        
        
        //        // title at the top
        //        self.navigationItem.title = "FEED"
        
        //tableView.delegate = self;
        //tableViewSearch.delegate = self;
        
        //self.tableView.backgroundView = UIImage(named: "View Changer 1-1.png")
        //view.backgroundColor = UIColor.redColor()//UIColor(patternImage: UIImage(named: "background.jpg")!)
        //        let frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.tabBarController!.tabBar.frame.size.height - self.navigationController!.navigationBar.frame.size.height - 20)

        let adjustForTabbarInsets = UIEdgeInsetsMake(0, 0, self.tabBarController!.tabBar.frame.height + 3, 0);
        self.tableView.contentInset = adjustForTabbarInsets
        self.tableView.scrollIndicatorInsets = adjustForTabbarInsets
        self.collectionView.contentInset = adjustForTabbarInsets
        self.collectionView.scrollIndicatorInsets = adjustForTabbarInsets
        
        
        //newView.release
        //        newView.backgroundColor = UIColor.redColor()
        //        view.addSubview(newView)
        //self.view.backgroundColor = UIColor.redColor()
        //self.tableView.opaque = false
        //self.tableView.backgroundView = nil
        
        
        btn1.setImage(UIImage(named: "View Changer 1-1.png"), for: .normal)
        //btn1.setImage(UIImage(named: "like.png"), forState: .Highlighted)
        btn1.frame = CGRect(x:0, y:0, width:20, height:20)
        btn1.addTarget(self, action: #selector(feed1VC.switchView), for: .touchUpInside)
        let item1 = UIBarButtonItem()
        item1.customView = btn1
        
        
        btn2.setImage(UIImage(named: "Down Arrow 1.png"), for: .normal)
        btn2.frame = CGRect(x:0,y: 0,width: 20,height: 20)
        btn2.addTarget(self, action: #selector(feed1VC.filterView), for: .touchUpInside)
        let item2 = UIBarButtonItem()
        item2.customView = btn2
        
        self.navigationItem.leftBarButtonItems = [item1,item2]
        
        let btnMore = UIButton()
        btnMore.setImage(UIImage(named: "Dots.png"), for: .normal)
        btnMore.frame = CGRect(x:0, y:0, width:5, height:15)
        btnMore.addTarget(self, action: Selector("action2"), for: .touchUpInside)
        let item3 = UIBarButtonItem()
        item3.customView = btnMore
        
        //self.navigationItem.rightBarButtonItem = item3
        
        // implement search bar
        searchBar.delegate = self
        searchBar.sizeToFit()
        //searchBar.showsCancelButton = false
        searchBar.placeholder = "Search Shops         "//\u{200B}\u{200B}\u{200B}\u{200B}\u{200B}\u{200B}\u{200B}\u{200B}"
        searchBar.searchBarStyle = UISearchBarStyle.minimal
        searchBar.tintColor = UIColor.groupTableViewBackground
        searchBar.frame.size.width = UIScreen.main.bounds.width - btn1.frame.width - btn2.frame.width - 60
        let searchItem = UIBarButtonItem(customView: searchBar)
        
        var negativeSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        negativeSpace.width = -10.0
        
        self.navigationItem.rightBarButtonItems = [negativeSpace,item3 , searchItem]
        self.edgesForExtendedLayout = []
        
        
        // pull to refresh
        refresher.addTarget(self, action: "loadPosts", for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 600
        
        // indicator's x(horizontal) center
        indicator.center.x = tableView.center.x
        
        // receive notification from postsCell if picture is liked, to update tableView
        NotificationCenter.default.addObserver(self, selector: "refreshLikes:", name: NSNotification.Name(rawValue: "likedFromFeed"), object: nil)
        
        // receive notification from uploadVC
        NotificationCenter.default.addObserver(self, selector: "uploaded:", name: NSNotification.Name(rawValue: "uploaded"), object: nil)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // calling function to load posts
        
        //        dispatch_async(dispatch_get_main_queue()) {
        //        self.loadPosts()
        //        }
        //            let delayTime = 0.13
        //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delayTime * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
        //
        //                self.tableView.reloadData()
        //                self.refresher.endRefreshing()
        //            }
        
        
        
        // usersVC().collectionViewLaunch()
        
        
        
        //tableView.frame = frame
        //        let newView = UIImageView(image: UIImage(named: "background.jpg"))
        //        newView.frame = UIScreen.mainScreen().bounds
        //        self.tableView.backgroundView = newView
        //        //self.collectionView.backgroundView = newView
        
        
        //self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!) //UIColor.redColor()
        
        self.collectionView.frame = UIScreen.main.bounds
        //self.collectionView.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!) //UIColor.redColor()
        
        //firebase.child("Posts").removeValue()

        self.tableViewLaunch()
        self.collectionViewLaunch()
            self.loadPosts()

        

        
        collectionView.register(UINib(nibName: "collectionCell", bundle: nil), forCellWithReuseIdentifier: "idCollectionCell")
        //
        //        dispatch_async(dispatch_get_main_queue(), {
        //            self.tableView.reloadData()
        //            self.collectionView.reloadData()
        //
        //            self.refresher.endRefreshing()
        //        });
        collectionView.isHidden = true
        //tableView.reloadData()
        //collectionView.reloadData()
        
        //configureCustomSearchController()
        
        configureTableView()
        
        loadCellDescriptors(fileName: "FilterCellDescriptor")


        
    }
    
    func goToProfile(id : String!){
        print(id)
        modeSelf = false
        if id == (FIRAuth.auth()?.currentUser!.uid)! {
            modeSelf = true
        }
        
        let home = self.storyboard?.instantiateViewController(withIdentifier: "homeVC1") as! homeVC1
        home.userIdToDisplay = id
        home.goHome = modeSelf
        self.navigationController?.pushViewController(home, animated: true)
        
        //        if id == (FIRAuth.auth()?.currentUser!.uid)! {
        //            //if id == "aa" {
        //            let home = self.storyboard?.instantiateViewControllerWithIdentifier("homeVC") as! homeVC
        //
        //            self.navigationController?.pushViewController(home, animated: true)
        //        } else {
        //            guestname.append(id)
        //            goHome = true
        //            let guest = self.storyboard?.instantiateViewControllerWithIdentifier("guestVC") as! guestVC
        //            self.navigationController?.pushViewController(guest, animated: true)
        //        }
    }
    
    func goToPost(uuid : String!){
        // take relevant unique id of post to load post in postVC
        
        //print (uuid)
        postuuid.append(uuid)
        
        // present postVC programmaticaly
        let post = self.storyboard?.instantiateViewController(withIdentifier: "postVC") as! postVC
        self.navigationController?.pushViewController(post, animated: true)
        
        
        
    }
    
    func displayLikes(uuid: String!){
        
        user = uuid
        show1 = "Likes"
        
        // make references to followersVC
        let followers = self.storyboard?.instantiateViewController(withIdentifier: "followersVC") as! followersVC
        
        // present
        self.navigationController?.pushViewController(followers, animated: true)
    }
    
    //    override func viewWillAppear(animated: Bool) {
    //        super.viewWillAppear(animated)
    //
    //
    //        print(cellDescriptors)
    //    }
    
    
    func filterView(){
        
        if  ExpListFilters.isHidden == true {
            btn2.setImage(UIImage(named: "Down Arrow 2.png"), for: .normal)
            ExpListFilters.isHidden = false
        } else {
            ExpListFilters.isHidden = true
            btn2.setImage(UIImage(named: "Down Arrow 1.png"), for: .normal)
        }
        
    }
    
    
    func configureTableView() {
        ExpListFilters.delegate = self
        ExpListFilters.dataSource = self
        ExpListFilters.tableFooterView = UIView(frame: CGRect.zero)
        ExpListFilters.sizeToFit()
        ExpListFilters.superview!.bringSubview(toFront: ExpListFilters)
        ExpListFilters.bounces = false
        
        ExpListFilters.register(UINib(nibName: "NormalCell", bundle: nil), forCellReuseIdentifier: "idCellNormal")
        ExpListFilters.register(UINib(nibName: "childCell", bundle: nil), forCellReuseIdentifier: "idChildCell")
        ExpListFilters.register(UINib(nibName: "filterButtonCell", bundle: nil), forCellReuseIdentifier: "idFilterButtonCell")
        //        ExpListFilters.registerNib(UINib(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "idCellSwitch")
        //        ExpListFilters.registerNib(UINib(nibName: "ValuePickerCell", bundle: nil), forCellReuseIdentifier: "idCellValuePicker")
        //        ExpListFilters.registerNib(UINib(nibName: "SliderCell", bundle: nil), forCellReuseIdentifier: "idCellSlider")
        ExpListFilters.isHidden = true
    }
    
    // MARK: UITableView Delegate and Datasource Functions
    
    //    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    //        if cellDescriptors != nil {
    //            return cellDescriptors.count
    //        }
    //        else {
    //            return 0
    //        }
    //    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == ExpListFilters {
            
            let indexOfTappedRow = visibleRows[indexPath.row]
            
            if (cellDescriptors[indexOfTappedRow] as AnyObject)["isExpandable"] as! Bool == true {
                var shouldExpandAndShowSubRows = false
                if (cellDescriptors[indexOfTappedRow] as AnyObject)["isExpandable"]  as! Bool == false {
                    // In this case the cell should expand.
                    shouldExpandAndShowSubRows = true
                }
                
                (cellDescriptors[indexOfTappedRow] as AnyObject).setValue(shouldExpandAndShowSubRows, forKey: "isExpanded")
                
                for i in (indexOfTappedRow + 1)...(indexOfTappedRow + ((cellDescriptors[indexOfTappedRow] as AnyObject)["additionalRows"] as! Int)) {
                    (cellDescriptors[i] as AnyObject).setValue(shouldExpandAndShowSubRows, forKey: "isVisible")
                }
            }
            else {
                //                if cellDescriptors[indexPath.section][indexOfTappedRow]["cellIdentifier"] as! String == "idCellValuePicker" {
                //                    var indexOfParentCell: Int!
                //
                //                    for var i=indexOfTappedRow - 1; i>=0; --i {
                //                        if cellDescriptors[indexPath.section][i]["isExpandable"] as! Bool == true {
                //                            indexOfParentCell = i
                //                            break
                //                        }
                //                    }
                //
                //                    cellDescriptors[indexPath.section][indexOfParentCell].setValue((tblExpandable.cellForRowAtIndexPath(indexPath) as! CustomCell).textLabel?.text, forKey: "primaryTitle")
                //                    cellDescriptors[indexPath.section][indexOfParentCell].setValue(false, forKey: "isExpanded")
                //
                //                    for i in (indexOfParentCell + 1)...(indexOfParentCell + (cellDescriptors[indexPath.section][indexOfParentCell]["additionalRows"] as! Int)) {
                //                        cellDescriptors[indexPath.section][i].setValue(false, forKey: "isVisible")
                //                    }
                //                }
            }
            
            getIndicesOfVisibleRows()
            //ExpListFilters.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
            ExpListFilters.reloadData()
            adjustHeightOfTableview()
            
        }
    }
    
    func getCellDescriptorForIndexPath(indexPath: NSIndexPath) -> [String: AnyObject] {
        let indexOfVisibleRow = visibleRows[indexPath.row]
        let cellDescriptor = cellDescriptors[indexOfVisibleRow] as! [String: AnyObject]
        return cellDescriptor
    }
    func adjustHeightOfTableview(){
        var height : CGFloat = self.ExpListFilters.contentSize.height;
        let maxHeight : CGFloat = self.ExpListFilters.superview!.frame.size.height - self.ExpListFilters.frame.origin.y;
        if (height > maxHeight){
            height = maxHeight;
        }
        //        let frame : CGRect = self.ExpListFilters.frame;
        //        frame.size.height = height;
        //        self.ExpListFilters.frame = frame;
        UIView.animate(withDuration: 0.9, animations: {
            self.filterViewHeightConstraints.constant = height
            self.ExpListFilters.setNeedsUpdateConstraints()
        })
    }
    
    
    
    func loadCellDescriptors(fileName : String!) {
        if let path = Bundle.main.path(forResource: fileName, ofType: "plist") {
            cellDescriptors = NSMutableArray(contentsOfFile: path)
            getIndicesOfVisibleRows()
            
            ExpListFilters.reloadData()
            adjustHeightOfTableview()
            
        }
    }
    
    func getIndicesOfVisibleRows() {
        visibleRows.removeAll()
        
        //for Cells in cellDescriptors {
        //var visibleRows = [Int]()
        // let y = (Cells as! [String: AnyObject]).count - 1
        
        for row in 0...((cellDescriptors as! [[String: AnyObject]]).count - 1) {
            
            
            if (cellDescriptors[row] as AnyObject)["isVisible"]  as! Bool == true {
                visibleRows.append(row)
                //print (cellDescriptors[row])
            }
        }
        
        
        //  }
    }
    
    
    func switchView() {
        if showColl {
            btn1.setImage(UIImage(named: "View Changer 1-1.png"), for: .normal)
            showColl = false
            showList = true
            collectionView.isHidden = true
            tableView.isHidden = false
            print("show list")
            
        } else if showList {
            btn1.setImage(UIImage(named: "View Changer 2-2.png"), for: .normal)
            showColl = true
            showList = false
            collectionView.isHidden = false
            tableView.isHidden = true
            print("show Coll")
        }
        
        if (shouldShowSearchResults) {
            changeviewwhilesearching = true
        }
        
    }
    
    //    func configureSearchController() {
    //        // Initialize and perform a minimum configuration to the search controller.
    //        searchController = UISearchController(searchResultsController: nil)
    //        searchController.searchResultsUpdater = self
    //        searchController.dimsBackgroundDuringPresentation = false
    //        searchController.searchBar.placeholder = "Search here..."
    //        searchController.searchBar.delegate = self
    //        searchController.searchBar.sizeToFit()
    //
    //        // Place the search bar view to the tableview headerview.
    //        tblSearchResults.tableHeaderView = searchController.searchBar
    //    }
    //
    
    // search updated
    //func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    
    //    func searchBar( searchBar: UISearchBar,
    //                    textDidChange searchText: String) {
    //
    //        if searchText.isEmpty == true {
    //            //loadPostsforColl()
    //            shouldShowSearchResults = false
    //            self.collectionView.reloadData()
    //            self.tableView.reloadData()
    //        } else {
    //
    //            shouldShowSearchResults = true
    //            // find by username
    //            let usernameQuery = PFQuery(className: "posts")
    //            usernameQuery.whereKey("title", matchesRegex: "(?i)" + searchText)
    //            usernameQuery.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) -> Void in
    //                if error == nil {
    //
    //
    //                    // clean up
    //                    self.picArraySearch.removeAll(keepCapacity: false)
    //                    self.uuidArraySearch.removeAll(keepCapacity: false)
    //                    //self.usernameArraySearch.removeAll(keepCapacity: false)
    //                    //self.avaArraySearch.removeAll(keepCapacity: false)
    //                    self.usernameArraySearch.removeAll(keepCapacity: false)
    //                    self.nameArraySearch.removeAll(keepCapacity: false)
    //                    self.avaArraySearch.removeAll(keepCapacity: false)
    //                    self.dateArraySearch.removeAll(keepCapacity: false)
    //
    //                    self.titleArraySearch.removeAll(keepCapacity: false)
    //
    //                    for object in objects! {
    //                        let usernmae = object.valueForKey("username") as! String
    //                        let infoQuery1 = PFQuery(className: "_User")
    //                        infoQuery1.whereKey("username", equalTo: usernmae)
    //                        infoQuery1.findObjectsInBackgroundWithBlock ({ (objects1:[PFObject]?, error:NSError?) -> Void in
    //                            if error == nil {
    //
    //                                // shown wrong user
    //                                if objects1!.isEmpty {
    //                                    // call alert
    //                                    let alert = UIAlertController(title: "\(guestname.last!.uppercaseString)", message: "is not existing", preferredStyle: UIAlertControllerStyle.Alert)
    //                                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
    //                                        self.navigationController?.popViewControllerAnimated(true)
    //                                    })
    //                                    alert.addAction(ok)
    //                                    self.presentViewController(alert, animated: true, completion: nil)
    //                                }
    //
    //                                // find related to user information
    //                                for object1 in objects1! {
    //                                    objc_sync_enter(self.nameArraySearch)
    //                                    // get users data with connections to columns of PFUser class
    //                                    let first = (object1.objectForKey("first_name") as? String)
    //                                    let last = (object1.objectForKey("last_name") as? String)
    //
    //                                    let fullname = first!+" "+last!
    //                                    self.nameArraySearch.append(fullname)
    //                                    objc_sync_exit(self.nameArraySearch)
    //
    //                                    dispatch_async(dispatch_get_main_queue(), {
    //                                        self.tableView.reloadData()
    //                                        self.collectionView.reloadData()
    //
    //                                        self.refresher.endRefreshing()
    //                                    });
    //
    //                                }
    //
    //
    //
    //
    //
    //                            } else {
    //                                print(error!.localizedDescription)
    //                            }
    //                        })
    //
    //
    //                        self.usernameArraySearch.append(object.objectForKey("username") as! String)
    //                        self.avaArraySearch.append(object.objectForKey("ava") as! PFFile)
    //                        self.dateArraySearch.append(object.createdAt)
    //                        self.picArraySearch.append(object.objectForKey("pic") as! PFFile)
    //                        //self.picArraySearch.append(object.objectForKey("pic") as! PFFile)
    //                        self.titleArraySearch.append(object.objectForKey("title") as! String)
    //                        self.uuidArraySearch.append(object.objectForKey("uuid") as! String)
    //
    //
    //                        //                            dispatch_async(dispatch_get_main_queue(), {
    //                        //                                self.tableView.reloadData()
    //                        //                                self.refresher.endRefreshing()
    //                        //                            });
    //
    //
    //
    //                    }
    //
    //                    //                    // found related objects
    //                    //                    for object in objects! {
    //                    //                        let desc = object.objectForKey("title") as! String
    //                    //                        print(desc)
    //                    //
    //                    //                        self.picArraySearch.append(object.objectForKey("pic") as! PFFile)
    //                    //                        self.uuidArraySearch.append(object.objectForKey("uuid") as! String)
    //                    //                        //self.usernameArraySearch.append(object.objectForKey("username") as! String)
    //                    //                        //self.avaArraySearch.append(object.objectForKey("picture_file") as! PFFile)
    //                    //                    }
    //                    //
    //                    //                    // reload
    //                    //                    self.collectionView.reloadData()
    //
    //                }
    //            })
    //        }
    //
    //        // return true
    //    }
    
    //    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
    //        self.searchBar.showsCancelButton = false
    //        return true
    //    }
    //
    //    override func resignFirstResponder() -> Bool {
    //        self.searchBar.showsCancelButton = false
    //        return super.resignFirstResponder()
    //    }
    //
    
    // tapped on the searchBar
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        if showColl == true {
            alreadyInColl = true
        }
        
        showColl = true
        showList = false
        tableView.isHidden = true
        collectionView.isHidden = false
        
        
        // show cancel button
        searchBar.showsCancelButton = true
        
        //SearchViewLaunch()
        //loadPostsforColl()
    }
    
    
    // clicked cancel button
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        //        // unhide collectionView when tapped cancel button
        //        collectionView.hidden = false
        shouldShowSearchResults = false
        //        if !changeviewwhilesearching {
        //            showColl = false
        //            showList = true
        //            collectionView.hidden = true
        //            tableView.hidden = false
        //            changeviewwhilesearching = false
        //        }
        if alreadyInColl == true {
            showColl = true
            showList = false
            collectionView.isHidden = false
            tableView.isHidden = true
            btn1.setImage(UIImage(named: "View Changer 2-2.png"), for: .normal)
            
            
        } else {
            showColl = false
            showList = true
            collectionView.isHidden = true
            tableView.isHidden = false
            btn1.setImage(UIImage(named: "View Changer 1-1.png"), for: .normal)
            
        }
        alreadyInColl = false
        // dismiss keyboard
        searchBar.resignFirstResponder()
        
        // hide cancel button
        searchBar.showsCancelButton = false
        
        // reset text
        searchBar.text = ""
        //tableView.hidden = false
        
        //collectionView.hidden = true
        
        // reset shown users
        //loadPostsforColl()
        tableView.reloadData()
        collectionView.reloadData()
        
        
    }
    
    
    
    //    // TABLEVIEW CODE
    //     //cell numb
    //        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //            return usernameArraySearch.count
    //        }
    
    //     //cell height
    //        func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //            if  (tableView == self.tableView){
    //                let cell = tableView.cellForRowAtIndexPath(indexPath) //as! postCell
    //             return cell!.frame.size.height
    //            } else {
    //               return ExpListFilters.rowHeight//tableView(tableView, heightForRowAtIndexPath:indexPath)
    //            }
    //            // return UITableViewAutomaticDimension
    //
    //        }
    
    //    // cell config
    //    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //
    //        // define cell
    //        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! followersCell
    //
    //        // hide follow button
    //        cell.followBtn.hidden = true
    //
    //        // connect cell's objects with received infromation from server
    //        cell.usernameLbl.text = usernameArraySearch[indexPath.row]
    //        avaArray[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
    //            if error == nil {
    //                cell.avaImg.image = UIImage(data: data!)
    //            }
    //        }
    //
    //        return cell
    //    }
    
    
    //    // selected tableView cell - selected user
    //    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //        if  (tableView == self.tableViewSearch){
    //            // calling cell again to call cell data
    //            let cell = tableView.cellForRowAtIndexPath(indexPath) as! followersCell
    //
    //            // if user tapped on his name go home, else go guest
    //            if cell.usernameLbl.text! == PFUser.currentUser()?.username {
    //                let home = self.storyboard?.instantiateViewControllerWithIdentifier("homeVC") as! homeVC
    //                self.navigationController?.pushViewController(home, animated: true)
    //            } else {
    //                guestname.append(cell.usernameLbl.text!)
    //                let guest = self.storyboard?.instantiateViewControllerWithIdentifier("guestVC") as! guestVC
    //                self.navigationController?.pushViewController(guest, animated: true)
    //            }
    //        }
    //    }
    
    
    
    
    
    // refreshign function after like to update degit
//    
//    func getLikesArrayW(){
//        let picturesGroup1 = dispatch_group_create()
//        
//        
//        firebase.child("Posts").queryOrderedByChild("date").observeEventType(.Value, withBlock: { snapshot in
//            
//            if snapshot.exists() {
//                self.likeArray.removeAll(keepCapacity: false)
//                for post in snapshot.children{
//                    dispatch_group_enter(picturesGroup1)
//                    // let k = post.key!
//                    //dispatch_group_enter(picturesGroup1)
//                    let uuid = post.key as String!
//                    
//                    firebase.child("Likes").child(uuid).observeSingleEventOfType(.Value, withBlock: { snapshot in
//                        if snapshot.exists() {
//                            //num = "\(snapshot.childrenCount)"
//                            //Lbl.setTitle("\(snapshot.childrenCount)", forState: UIControlState.Normal)
//                            //Lbl.text =  "\(snapshot.childrenCount)"
//                            //Lbl.setTitle(num, forState: .Normal)
//                            self.likeArray.append("\(snapshot.childrenCount)")
//                             dispatch_group_leave(picturesGroup1)
//                            
//                        } else {
//                            //num = "0"
//                            self.likeArray.append("0")
//                            //dispatch_group_leave(picturesGroup1)
//                            //Lbl.setTitle("0", forState: .Normal)
//                            //Lbl.setTitle(num, forState: .Normal)
//                             dispatch_group_leave(picturesGroup1)
//                        }
//                    }) { (error) in
//                        print(error.localizedDescription)
//                    }
//                   
//                }
//            }
//            dispatch_group_notify(picturesGroup1, dispatch_get_main_queue()) {
//                //self.likeArray = self.likeArray.reverse()
//                print(self.likeArray)
//                //self.tableView.reloadData()
//                self.collectionView.reloadData()
//            }
//            
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//        
//        
//        
//        
//    }
//    func getLikesArrayWO(){
//       
//        
//        
//        firebase.child("Posts").queryOrderedByChild("date").observeEventType(.Value, withBlock: { snapshot in
//            
//            if snapshot.exists() {
//                self.likeArray.removeAll(keepCapacity: false)
//                for post in snapshot.children{
//
//                    let uuid = post.key as String!
//                    
//                    firebase.child("Likes").child(uuid).observeSingleEventOfType(.Value, withBlock: { snapshot in
//                        if snapshot.exists() {
//                            //num = "\(snapshot.childrenCount)"
//                            //Lbl.setTitle("\(snapshot.childrenCount)", forState: UIControlState.Normal)
//                            //Lbl.text =  "\(snapshot.childrenCount)"
//                            //Lbl.setTitle(num, forState: .Normal)
//                            self.likeArray.append("\(snapshot.childrenCount)")
//                            
//                            
//                        } else {
//                            //num = "0"
//                            self.likeArray.append("0")
//                            //dispatch_group_leave(picturesGroup1)
//                            //Lbl.setTitle("0", forState: .Normal)
//                            //Lbl.setTitle(num, forState: .Normal)
//                            
//                        }
//                    }) { (error) in
//                        print(error.localizedDescription)
//                    }
//                   
//                }
//            }
//
//            
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//        
//        
//        
//        
//    }
    func refreshLikes(notification: NSNotification) {
        
        
        
            if let row = notification.object as? Int {

                
                let indexPath = NSIndexPath(row: row, section: 0)
                self.collectionView.reloadItems(at: [indexPath as IndexPath])
                self.tableView.reloadRows(at: [indexPath as IndexPath],with: .none)
            }
        
        
        //dispatch_group_leave(picturesGroup1)
        
        //let picturesGroup1 = dispatch_group_create()
        
       // self.getLikesArrayW()
        
        
        
        
        
        
    }
    
    
    //    override func viewWillAppear(animated: Bool) {
    //       loadPosts()
    //        tableView.reloadData()
    //       refresher.endRefreshing()
    //    }
    
    // reloading func with posts  after received notification
    func uploaded(notification:NSNotification) {
        loadPosts()
        
    }
    
    // load posts
    func loadPosts() {
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        let picturesGroup = DispatchGroup()
        let queue = DispatchQueue.global(qos: .default)
        
        //getLikesArrayWO()
        firebase.child("Posts").queryOrdered(byChild: "date").observe(.value, with: { snapshot in
            
            // clean up
            self.usernameArray.removeAll(keepingCapacity: false)
            self.nameArray.removeAll(keepingCapacity: false)
            self.avaArray.removeAll(keepingCapacity: false)
            self.dateArray.removeAll(keepingCapacity: false)
            self.picArrayURL.removeAll(keepingCapacity: false)
            self.picArray.removeAll(keepingCapacity: false)
            //self.picArraySearch.removeAll(keepCapacity: false)
            self.titleArray.removeAll(keepingCapacity: false)
            self.uuidArray.removeAll(keepingCapacity: false)
            
            if snapshot.exists() {
                
                //sorted = (snapshot.value!.allValues as NSArray).sortedArrayUsingDescriptors([NSSortDescriptor(key: "date", ascending: false)])
                
                
                var i = 0
                
                for post in snapshot.children{
                    // let k = post.key!F
                    //picturesGroup.enter()
                    
                    let userID = ((post as! FIRDataSnapshot).value as? [String:AnyObject])?["userID"] as! String
                    
                    
                    //                    self.storage.referenceForURL(post.value.objectForKey("photoUrl") as! String).dataWithMaxSize(25 * 1024 * 1024, completion: { (data, error) -> Void in
                    //                        let image = UIImage(data: data!)
                    //
                    //                        // objc_sync_enter(self.nameArray)
                    //                        // objc_sync_enter(self.nameArray)
                    //                        self.picArray.append(image! as! UIImage)
                    //
                    //                        //objc_sync_exit(self.nameArray)
                    //                        //self.tableView.reloadData()
                    //                        //self.scrollToBottom()
                    //
                    //                        // objc_sync_exit(self.nameArray)
                    //
                    //                    })
                    
                    //self.DLImages()
                    let url = ((post as! FIRDataSnapshot).value as? [String:AnyObject])?["photoUrl"] as! String
                    self.picArrayURL.append(url)
                    
                    self.myDictionaryURL.updateValue(url, forKey: i)
                    //d[i]=url
                    //print (self.myDictionaryURL)
                    i = i + 1
                    
                    let uuid = (post as AnyObject).key as String!
                    
//                    firebase.child("Likes").child(uuid).observeSingleEventOfType(.Value, withBlock: { snapshot in
//                        if snapshot.exists() {
//                            //num = "\(snapshot.childrenCount)"
//                            //Lbl.setTitle("\(snapshot.childrenCount)", forState: UIControlState.Normal)
//                            //Lbl.text =  "\(snapshot.childrenCount)"
//                            //Lbl.setTitle(num, forState: .Normal)
//                            self.likeArray.append("\(snapshot.childrenCount)")
//                            
//                            
//                        } else {
//                            //num = "0"
//                            self.likeArray.append("0")
//                            //dispatch_group_leave(picturesGroup1)
//                            //Lbl.setTitle("0", forState: .Normal)
//                            //Lbl.setTitle(num, forState: .Normal)
//                            
//                        }
//                    }) { (error) in
//                        print(error.localizedDescription)
//                    }
                    
                    
                    picturesGroup.enter()
                    queue.async(execute: {
                    firebase.child("Users").child(userID).observe(.value, with: { snapshot in
                        
                        let first = ((snapshot.value! as AnyObject)["first_name"] as? String)
                        let last = (snapshot.value! as AnyObject)["last_name"] as? String
                        
                        let fullname = first!+" "+last!
                        self.nameArray.append(fullname)
                        
                        //                        self.tableView.reloadData()
                        //                        self.collectionView.reloadData()
                        let avaURL = (snapshot.value! as AnyObject)["ProfilPicUrl"] as! String
                        let url = NSURL(string: avaURL)
                        if let data = NSData(contentsOf: url! as URL){ //make sure your image in this url does exist, otherwise unwrap in a if let check
                            self.avaArray.append(UIImage(data: data as Data) as UIImage!)
                            
                        }
                        
                        
                        picturesGroup.leave()
                        
                        //self.comments.append(snapshot)
                        //self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.comments.count-1, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Automatic)
                        }
                        
                        
                    ){ (error) in
                        print(error.localizedDescription)
                    }
                    })
                    
                    
                    //let datestring = post.value.objectForKey("date") as! String
                    if let datestring = ((post as! FIRDataSnapshot).value as? [String:AnyObject])?["date"]{
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                        let date = dateFormatter.date(from: datestring as! String)
                        self.dateArray.append((date as Date?)!)
                    }
                    self.usernameArray.append(userID )
                    
                    self.titleArray.append(((post as! FIRDataSnapshot).value as? [String:AnyObject])?["title"] as! String)
                    self.uuidArray.append((post as AnyObject).key! as String!)
                    
                    
                    
                    // dispatch_async(dispatch_get_main_queue(), {
                    //  self.tableView.reloadData()
                    //self.collectionView.reloadData()
                    self.refresher.endRefreshing()
                    // });
                    
                    
                    
                    
                }}
            
            //self.picArray = self.picArray.reverse()
            
            
            for (bookid, title) in self.myDictionaryURL {
                //println("Book ID: \(bookid) Title: \(title)")
                print(title)
                picturesGroup.enter()
                queue.async(execute: {
                self.storage.reference(forURL: title).data(withMaxSize: 25 * 1024 * 1024, completion: { (data, error) -> Void in
                    let image = UIImage(data: data!)
                    self.myDictionaryImage[bookid] = image!

                    //self.picArray.append(image! as! UIImage)
                    
                    picturesGroup.leave()
                })
                })
            }
            
            
            
            //            for url in self.picArrayURL{
            //                self.storage.referenceForURL(url).dataWithMaxSize(25 * 1024 * 1024, completion: { (data, error) -> Void in
            //                    let image = UIImage(data: data!)
            //
            //
            //                    self.picArray.append(image! as! UIImage)
            //
            //                    dispatch_group_leave(picturesGroup)
            //                })
            //            }
            
            
            //DispatchGroup.notify(picturesGroup)
            //DispatchQueue.main.async {
                picturesGroup.notify(queue: DispatchQueue.main, execute:{
            //picturesGroup.notify(qos: DispatchQoS.background, flags: DispatchWorkItemFlags.assignCurrentContext, queue: queue) {
                let imagesSorted = Array(self.myDictionaryImage.keys).sorted(by: >)
                //print(imagesSorted)
                // let y = sort(imagesSorted)  //{self.myDictionaryImage[$0] < self.myDictionaryImage[$1]}) //self.myDictionaryImage.sorted() { $0.0 < $1.0 }
                
                
                self.avaArray = self.avaArray.reversed()
                self.nameArray = self.nameArray.reversed()
                self.picArrayURL = self.picArrayURL.reversed()
                self.dateArray = self.dateArray.reversed()
                self.usernameArray = self.usernameArray.reversed()
                self.uuidArray = self.uuidArray.reversed()
                
                
                self.titleArray = self.titleArray.reversed()
                
                
                for a in imagesSorted {
                    self.picArray.append(self.myDictionaryImage[a]!)
                }
                //self.picArray.reverse()
                //DispatchQueue.main.async {
                
                if self.initialized == 0 {
                    self.tableViewLaunch()
                    //self.view.addSubview(self.tableView)
                    self.collectionViewLaunch()
                    self.initialized = 1
                }

                self.tableView.reloadData()
                self.collectionView.reloadData()
               // }
            })
            
            
            //self.comments.append(snapshot)
            //self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.comments.count-1, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Automatic)
        }){ (error) in
            print(error.localizedDescription)
        }
        


        
        
        
        UIApplication.shared.endIgnoringInteractionEvents()
        
        
    }
    
    func DLImages(){
        
        //        let picturesGroup = dispatch_group_create()
        
        self.picArray.removeAll(keepingCapacity: false)
        //objc_sync_enter(self.nameArray)
        for url in self.picArrayURL{
            //   dispatch_group_enter(picturesGroup)
            self.storage.reference(forURL: url).data(withMaxSize: 25 * 1024 * 1024, completion: { (data, error) -> Void in
                let image = UIImage(data: data!)
                
                // objc_sync_enter(self.nameArray)
                
                self.picArray.append(image! )
                //cell.picImg1.image = image
                //objc_sync_exit(self.nameArray)
                //self.tableView.reloadData()
                //self.scrollToBottom()
                
                
                // dispatch_group_leave(picturesGroup)
            })
        }
        
        //        dispatch_group_notify(picturesGroup, dispatch_get_main_queue()) {
        //            self.picArray//completion(true, attendees: attendees)
        //        }
        // objc_sync_exit(self)
    }
    //    // scrolled down
    //    override func scrollViewDidScroll(scrollView: UIScrollView) {
    //        if scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.size.height * 2 {
    //            loadMore()
    //        }
    //    }
    
    //    // pagination
    //    func loadMore() {
    //
    //        // if posts on the server are more than shown
    //        if page <= uuidArray.count {
    //
    //            // start animating indicator
    //            indicator.startAnimating()
    //
    //            // increase page size to load +10 posts
    //            page = page + 10
    //
    //            // STEP 1. Find posts realted to people who we are following
    //            let followQuery = PFQuery(className: "follow")
    //            followQuery.whereKey("follower", equalTo: PFUser.currentUser()!.username!)
    //            followQuery.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) -> Void in
    //                if error == nil {
    //
    //                    // clean up
    //                    self.followArray.removeAll(keepCapacity: false)
    //
    //                    // find related objects
    //                    for object in objects! {
    //                        self.followArray.append(object.objectForKey("following") as! String)
    //                    }
    //
    //                    // append current user to see own posts in feed
    //                    self.followArray.append(PFUser.currentUser()!.username!)
    //
    //                    // STEP 2. Find posts made by people appended to followArray
    //                    let query = PFQuery(className: "posts")
    //                    query.whereKey("username", containedIn: self.followArray)
    //                    query.limit = self.page
    //                    query.addDescendingOrder("createdAt")
    //                    query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
    //                        if error == nil {
    //
    //                            // clean up
    //                            self.usernameArray.removeAll(keepCapacity: false)
    //                            self.nameArray.removeAll(keepCapacity: false)
    //                            self.avaArray.removeAll(keepCapacity: false)
    //                            self.dateArray.removeAll(keepCapacity: false)
    //                            self.picArray.removeAll(keepCapacity: false)
    //                            self.titleArray.removeAll(keepCapacity: false)
    //                            self.uuidArray.removeAll(keepCapacity: false)
    //
    //                            // find related objects
    //                            for object in objects! {
    //                                self.usernameArray.append(object.objectForKey("username") as! String)
    //                                //self.avaArray.append(object.objectForKey("ava") as! PFFile)
    //                                self.dateArray.append(object.createdAt)
    //                                // self.picArray.append(object.objectForKey("pic") as! PFFile)
    //                                self.titleArray.append(object.objectForKey("title") as! String)
    //                                self.uuidArray.append(object.objectForKey("uuid") as! String)
    //
    //
    //                                let usernmae = object.valueForKey("username") as! String
    //                                let infoQuery = PFQuery(className: "_User")
    //                                infoQuery.whereKey("username", equalTo: usernmae)
    //                                infoQuery.findObjectsInBackgroundWithBlock ({ (objects1:[PFObject]?, error:NSError?) -> Void in
    //                                    if error == nil {
    //
    //                                        // shown wrong user
    //                                        if objects1!.isEmpty {
    //                                            // call alert
    //                                            let alert = UIAlertController(title: "\(guestname.last!.uppercaseString)", message: "is not existing", preferredStyle: UIAlertControllerStyle.Alert)
    //                                            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
    //                                                self.navigationController?.popViewControllerAnimated(true)
    //                                            })
    //                                            alert.addAction(ok)
    //                                            self.presentViewController(alert, animated: true, completion: nil)
    //                                        }
    //
    //                                        // find related to user information
    //                                        for object1 in objects1! {
    //
    //
    //
    //                                            // get users data with connections to columns of PFUser class
    //                                            let first = (object1.valueForKey("first_name") as? String)
    //                                            let last = (object1.valueForKey("last_name") as? String)
    //
    //                                            let fullname = first!+" "+last!
    //                                            self.nameArray.append(fullname)
    //                                            //self.tableView.reloadData()
    //                                            //self.refresher.endRefreshing()
    //
    //                                        }
    //
    //
    //                                    }
    //                                })
    //                            }
    //
    //                            //                            // reload tableView & end spinning of refresher
    //                            //                             self.tableView.reloadData()
    //                            //                            self.refresher.endRefreshing()
    //
    //                        } else {
    //                            print(error!.localizedDescription)
    //                        }
    //                    })
    //                } else {
    //                    print(error!.localizedDescription)
    //                }
    //            })
    //
    //        }
    //
    //    }
    
    // cell numb
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ExpListFilters {
            //print(visibleRows.count)
            return visibleRows.count
        } else {
            if shouldShowSearchResults {
                //objc_sync_enter(self)
                return uuidArraySearch.count
            }
            else {
                //objc_sync_enter(self.avaArray)
                print (nameArray.count)
                return nameArray.count
            }
        }
        //objc_sync_exit(self)
        //        }
    }
    
    //    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    //        objc_sync_enter(self)
    //        return uuidArray.count
    //        objc_sync_exit(self)
    //    }
    
    
    
    
    
    
    // cell config
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  (tableView == self.ExpListFilters){
            
            
            let currentCellDescriptor = getCellDescriptorForIndexPath(indexPath: indexPath as NSIndexPath)
            let cell = tableView.dequeueReusableCell(withIdentifier: currentCellDescriptor["cellIdentifier"] as! String, for: indexPath) as! CustomCell
            
            if currentCellDescriptor["cellIdentifier"] as! String == "idCellNormal" {
                if let primaryTitle = currentCellDescriptor["primaryTitle"] {
                    //cell.textLabel?.text = primaryTitle as? String
                }
                
                
                if let secondaryTitle = currentCellDescriptor["secondaryTitle"] {
                    //cell.detailTextLabel?.text = secondaryTitle as? String
                    cell.textLabel?.text = secondaryTitle as? String
                }
            }
            else if currentCellDescriptor["cellIdentifier"] as! String == "idChildCell" {
                //cell.textField.placeholder = currentCellDescriptor["primaryTitle"] as? String
                cell.TxtCell.text = currentCellDescriptor["primaryTitle"] as? String
            } else if currentCellDescriptor["cellIdentifier"] as! String == "idFilterButtonCell" {
                //cell.textField.placeholder = currentCellDescriptor["primaryTitle"] as? String
                cell.LastButton.setTitle(currentCellDescriptor["Title"] as? String, for: .normal) 
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width)
            }
            
            
            //cell.delegate = self
            
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "idPostFeedCell", for: indexPath) as! postCell
            cell.origin = "Feed"
            //cell.backgroundColor = UIColor.clearColor()
            
            cell.likeBtn.tag = indexPath.row
            
            cell.backgroundColor = UIColor(patternImage: UIImage(named: "Background_Blue_Joint.jpg")!)
            //let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! postCell
            let from = dateArray[indexPath.row]
            cell.segueDelegate = self
            // define cell
            if shouldShowSearchResults{
                
                //
                //                // connect objects with our information from arrays
                //                //objc_sync_enter(self.nameArray)
                //                cell.usernameBtn.setTitle(nameArraySearch[indexPath.row], forState: UIControlState.Normal)
                //                cell.usernameBtn.sizeToFit()
                //                //objc_sync_exit(self.nameArray)
                //                cell.uuidLbl.text = self.uuidArraySearch[indexPath.row]
                //                cell.titleLbl.text = self.titleArraySearch[indexPath.row]
                //                cell.titleLbl.sizeToFit()
                //                cell.usernameHidden.setTitle(usernameArraySearch[indexPath.row], forState: UIControlState.Normal)
                //
                //                // place profile picture
                //                avaArraySearch[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
                //                    cell.avaImg.image = UIImage(data: data!)
                //                }
                //
                //                // place post picture
                //                picArraySearch[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
                //                    cell.picImg.image = UIImage(data: data!)
                //                }
                //
                //                // calculate post date
                //                let from = dateArraySearch[indexPath.row]
            } else {
                let u = indexPath.row
                cell.usernameBtn.setTitle(nameArray[indexPath.row], for: UIControlState.normal)
                cell.usernameBtn.sizeToFit()
                //objc_sync_exit(self.nameArray)
                cell.uuidLbl.text = self.uuidArray[indexPath.row]
                cell.titleLbl.text = self.titleArray[indexPath.row]
                cell.titleLbl.sizeToFit()
                cell.usernameHidden.setTitle(usernameArray[indexPath.row], for: UIControlState.normal)
                
                //                // place profile picture
                //                avaArray[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
                //                    cell.avaImg.image = UIImage(data: data!)
                //                }
                //
                //                // place post picture
                //                picArray[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
                //                    cell.picImg.image = UIImage(data: data!)
                //                }
                cell.avaImg.image = avaArray[indexPath.row]
                cell.picImg.image = picArray[indexPath.row]
                
                //                self.storage.referenceForURL(picArray[indexPath.row]).dataWithMaxSize(25 * 1024 * 1024, completion: { (data, error) -> Void in
                //                    let image = UIImage(data: data!)
                //
                //                    // objc_sync_enter(self.nameArray)
                //                    // objc_sync_enter(self.nameArray)
                //                    //self.picArray.append(image! as! UIImage)
                //                    cell.picImg.image = image
                //                    //objc_sync_exit(self.nameArray)
                //                    //self.tableView.reloadData()
                //                    //self.scrollToBottom()
                //
                //                    // objc_sync_exit(self.nameArray)
                //
                //                })
                
                
                
                // calculate post date
                let from = dateArray[indexPath.row]
                
                
            }
            
            
            let now = Date()
            let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfMonth])
            let dayCalendarUnit: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfMonth]
            //let difference = NSCalendar.current.compare(from, to: now , toGranularity: .second)
            let difference = from.timeIntervalSinceNow
            //let difference1 = NSCalendar.current.dateComponents.dateComponents(dayCalendarUnit, from: from, to: now)
            cell.dateLbl.text = Date().offset(from: from)
            // logic what to show: seconds, minuts, hours, days or weeks
//            if difference.second! <= 0 {
//                cell.dateLbl.text = "now"
//            }
//            if difference.second > 0 && difference.minute == 0 {
//                cell.dateLbl.text = "\(difference.second)s"
//            }
//            if difference.minute > 0 && difference.hour == 0 {
//                cell.dateLbl.text = "\(difference.minute)m"
//            }
//            if difference.hour > 0 && difference.day == 0 {
//                cell.dateLbl.text = "\(difference.hour)h"
//            }
//            if difference.day > 0 && difference.weekOfMonth == 0 {
//                cell.dateLbl.text = "\(difference.day)d"
//            }
//            if difference.weekOfMonth > 0 {
//                cell.dateLbl.text = "\(difference.weekOfMonth)w"
//            }
            
            
            //            // manipulate like button depending on did user like it or not
            //            let didLike = PFQuery(className: "likes")
            //            didLike.whereKey("by", equalTo: PFUser.currentUser()!.username!)
            //            didLike.whereKey("to", equalTo: cell.uuidLbl.text!)
            //            didLike.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) -> Void in
            //                // if no any likes are found, else found likes
            //                if count == 0 {
            //                    cell.likeBtn.setTitle("unlike", forState: .Normal)
            //                    cell.likeBtn.setBackgroundImage(UIImage(named: "unlike.png"), forState: .Normal)
            //                } else {
            //                    cell.likeBtn.setTitle("like", forState: .Normal)
            //                    cell.likeBtn.setBackgroundImage(UIImage(named: "like.png"), forState: .Normal)
            //                }
            //            }
            //
            //            // count total likes of shown post
            //            let countLikes = PFQuery(className: "likes")
            //            countLikes.whereKey("to", equalTo: cell.uuidLbl.text!)
            //            countLikes.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) -> Void in
            //                cell.likeLbl.text = "\(count)"
            //            }
            
            
            //            firebase.child("Likes").child(cell.uuidLbl.text!).child((FIRAuth.auth()?.currentUser!.uid)!).observeEventType(.Value, withBlock: { snapshot in
            //                print(snapshot.value)
            //                if snapshot.exists() {
            //                    cell.likeBtn.setTitle("like", forState: .Normal)
            //                    cell.likeBtn.setBackgroundImage(UIImage(named: "like.png"), forState: .Normal)
            //                } else {
            //                    cell.likeBtn.setTitle("unlike", forState: .Normal)
            //                    cell.likeBtn.setBackgroundImage(UIImage(named: "unlike.png"), forState: .Normal)
            //                }
            //            })
            
            
            
            
            //            firebase.child("Likes").child(cell.uuidLbl.text!).observeEventType(.Value, withBlock: { snapshot in
            //                if snapshot.exists() {
            //
            //                    cell.likeLbl.text =  "\(snapshot.childrenCount)"
            //
            //                }
            //            })
            
            getLikeCount(string: cell.uuidLbl.text! , Lbl : cell.LikeLbl)
            getLikeState(string: cell.uuidLbl.text! , Btn: cell.likeBtn)
            
            
            // asign index
            cell.usernameBtn.layer.setValue(indexPath, forKey: "index")
            //cell.commentBtn.layer.setValue(indexPath, forKey: "index")
            //cell.moreBtn.layer.setValue(indexPath, forKey: "index")
            return cell
        }
        
        //   }
        
        
    }
    
    func usernameBtn_click(sender: AnyObject) {
        // call index of button
        let i = sender.layer.value(forKey: "index") as! NSIndexPath
        
        // call cell to call further cell data
        let cell = tableView.cellForRow(at: i as IndexPath) as! postCell
        
        // if user tapped on himself go home, else go guest
        
        
        if cell.usernameHidden.titleLabel?.text == (FIRAuth.auth()?.currentUser!.uid)! {
            let home = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as! homeVC1
            self.navigationController?.pushViewController(home, animated: true)
        } else {
            //            guestname.append(cell.usernameHidden.titleLabel!.text!)
            //            let guest = self.storyboard?.instantiateViewControllerWithIdentifier("guestVC") as! guestVC
            //            self.navigationController?.pushViewController(guest, animated: true)
        }
        
        
        
        
        
    }
    
    //    @IBAction func moreBtn_click(sender: AnyObject) {
    //
    //        // call index of button
    //        let i = sender.layer.valueForKey("index") as! NSIndexPath
    //
    //        // call cell to call further cell date
    //        let cell = tableView.cellForRowAtIndexPath(i) as! postCell
    //
    //
    //        // DELET ACTION
    //        let delete = UIAlertAction(title: "Delete", style: .Default) { (UIAlertAction) -> Void in
    //
    //            // STEP 1. Delete row from tableView
    //            self.usernameArray.removeAtIndex(i.row)
    //            self.avaArray.removeAtIndex(i.row)
    //            self.dateArray.removeAtIndex(i.row)
    //            self.picArray.removeAtIndex(i.row)
    //            self.titleArray.removeAtIndex(i.row)
    //            self.uuidArray.removeAtIndex(i.row)
    //
    //            // STEP 2. Delete post from server
    //            let postQuery = PFQuery(className: "posts")
    //            postQuery.whereKey("uuid", equalTo: cell.uuidLbl.text!)
    //            postQuery.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
    //                if error == nil {
    //                    for object in objects! {
    //                        object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
    //                            if success {
    //
    //                                // send notification to rootViewController to update shown posts
    //                                NSNotificationCenter.defaultCenter().postNotificationName("uploaded", object: nil)
    //
    //                                // push back
    //                                self.navigationController?.popViewControllerAnimated(true)
    //                            } else {
    //                                print(error!.localizedDescription)
    //                            }
    //                        })
    //                    }
    //                } else {
    //                    print(error?.localizedDescription)
    //                }
    //            })
    //
    //            // STEP 2. Delete likes of post from server
    //            let likeQuery = PFQuery(className: "likes")
    //            likeQuery.whereKey("to", equalTo: cell.uuidLbl.text!)
    //            likeQuery.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
    //                if error == nil {
    //                    for object in objects! {
    //                        object.deleteEventually()
    //                    }
    //                }
    //            })
    //
    //            // STEP 3. Delete comments of post from server
    //            let commentQuery = PFQuery(className: "comments")
    //            commentQuery.whereKey("to", equalTo: cell.uuidLbl.text!)
    //            commentQuery.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
    //                if error == nil {
    //                    for object in objects! {
    //                        object.deleteEventually()
    //                    }
    //                }
    //            })
    //
    //            // STEP 4. Delete hashtags of post from server
    //            let hashtagQuery = PFQuery(className: "hashtags")
    //            hashtagQuery.whereKey("to", equalTo: cell.uuidLbl.text!)
    //            hashtagQuery.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
    //                if error == nil {
    //                    for object in objects! {
    //                        object.deleteEventually()
    //                    }
    //                }
    //            })
    //        }
    //
    //
    //        // COMPLAIN ACTION
    //        let complain = UIAlertAction(title: "Complain", style: .Default) { (UIAlertAction) -> Void in
    //
    //            // send complain to server
    //            let complainObj = PFObject(className: "complain")
    //            complainObj["by"] = PFUser.currentUser()?.username
    //            complainObj["to"] = cell.uuidLbl.text
    //            complainObj["owner"] = cell.usernameBtn.titleLabel?.text
    //            complainObj.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
    //                if success {
    //                    self.alert("Complain has been made successfully", message: "Thank You! We will consider your complain")
    //                } else {
    //                    self.alert("ERROR", message: error!.localizedDescription)
    //                }
    //            })
    //        }
    //
    //        // CANCEL ACTION
    //        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    //
    //
    //        // create menu controller
    //        let menu = UIAlertController(title: "Menu", message: nil, preferredStyle: .ActionSheet)
    //
    //
    //        // if post belongs to user, he can delete post, else he can't
    //        if cell.usernameBtn.titleLabel?.text == PFUser.currentUser()?.username {
    //            menu.addAction(delete)
    //            menu.addAction(cancel)
    //        } else {
    //            menu.addAction(complain)
    //            menu.addAction(cancel)
    //        }
    //
    //        // show menu
    //        self.presentViewController(menu, animated: true, completion: nil)
    //    }
    
    // alert action
    func alert (title: String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    
    // COLLECTION VIEW CODE
    func collectionViewLaunch() {
        
        //                // layout of collectionView
        //                let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        //
        //                // item size
        //                layout.itemSize = CGSizeMake(self.view.frame.size.width / 2, self.view.frame.size.width / 3+25)
        //
        //                // direction of scrolling
        //                layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        //
        //                layout.minimumInteritemSpacing = 0
        //                layout.minimumLineSpacing = 0
        // define frame of collectionView
        //let frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+10000)
        //let frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.tabBarController!.tabBar.frame.size.height - self.navigationController!.navigationBar.frame.size.height - 20)
        
        // declare collectionView
        //collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        //  collectionView.setCollectionViewLayout(layout, animated: true)
        //collectionView.siz
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        //collectionView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - self.tabBarController!.tabBar.frame.size.height - self.navigationController!.navigationBar.frame.size.height - 20)
        //collectionView.la
        //collectionView.contentSize = CGSizeMake(self.view.frame.size.width / 2, self.view.frame.size.width / 2+25)
        //collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.tabBarController!.tabBar.frame.size.height - self.navigationController!.navigationBar.frame.size.height - 20)
        self.view.addSubview(collectionView)
        
        // define cell for collectionView
        //collectionView.registerClass(searchCollCell.self, forCellWithReuseIdentifier: "Cellsearch")
        
        // call function to load posts
        //loadPostsforColl()
    }
    
    
    // cell line spasing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // cell inter spasing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // cell numb
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            objc_sync_enter(self)
            return uuidArraySearch.count
        }
        else {
            objc_sync_enter(self)
            return nameArray.count
        }
    }
    
    //    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    //        return CGSizeMake(self.view.frame.width/2, self.view.frame.width/2 + 25)  // Header size
    //    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //print(UIScreen.mainScreen().bounds.width)
        //print (self.view.frame.width)
        return CGSize(width: UIScreen.main.bounds.width/2, height: self.view.frame.width/2 + 25);
        
    }
    //
    //    func collectionView(collectionView: UICollectionView, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
    //        return UIEdgeInsetsMake(0,0,0,0)
    //    }
    //
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath:IndexPath)->UICollectionViewCell{
        
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "idCollectionCell", for: indexPath) as! testsearchcell
        //cell.uuidLbl.text = self.uuidArray[indexPath.row]
        // cell.titleShop.text="cellText"
        cell.likeBtn.tag = indexPath.row
        cell.origin = "Feed"
        
        //cell.picImg1.frame = CGRectMake(0,0,cell.frame.width,cell.frame.width)
        
        // cell.backgroundColor = UIColor.whiteColor()
        cell.backgroundColor = UIColor(patternImage: UIImage(named: "Background_Blue_Joint.jpg")!)
        //cell.uuid.text = uuidArraySearch[indexPath.row]
        // cell.uuid.hidden = true
        
        if shouldShowSearchResults {
            //            cell.segueDelegate = self
            //            //print(indexPath.row)
            //            cell.uuidLbl.text = self.uuidArraySearch[indexPath.row]
            //
            //            // manipulate like button depending on did user like it or not
            //            let didLike = PFQuery(className: "likes")
            //            didLike.whereKey("by", equalTo: PFUser.currentUser()!.username!)
            //            didLike.whereKey("to", equalTo: uuidArraySearch[indexPath.row])
            //            didLike.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) -> Void in
            //                // if no any likes are found, else found likes
            //                if count == 0 {
            //                    cell.likeBtn.setTitle("unlike", forState: .Normal)
            //                    cell.likeBtn.setBackgroundImage(UIImage(named: "unlike.png"), forState: .Normal)
            //                } else {
            //                    cell.likeBtn.setTitle("like", forState: .Normal)
            //                    cell.likeBtn.setBackgroundImage(UIImage(named: "like.png"), forState: .Normal)
            //                }
            //            }
            //
            //            let countLikes = PFQuery(className: "likes")
            //            countLikes.whereKey("to", equalTo: uuidArraySearch[indexPath.row])
            //            countLikes.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) -> Void in
            //                cell.likeLbl.text = "\(count)"
            //            }
            //
            //            //cell.likeLbl.font.fontWithSize(13)
            //            //cell.likeButton.layer.setValue(indexPath, forKey: "index")
            //            //cell.nameLabel.text = "Two Little Bees"
            //            cell.titleLbl.text = "Two Little Bees" //self.titleArray[indexPath.row]
            //            //cell.titleLbl.sizeToFit()
            //            //cell.titleLbl.font.fontWithSize(13)
            //            //cell.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-35-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
            //            //cell.likeButton.addTarget(self, action: "likeTouchedColl:", forControlEvents:.TouchUpInside)
            //
            //
            //            // get loaded images from array
            //            picArraySearch[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
            //                if error == nil {
            //                    cell.picImg1.image = UIImage(data: data!)
            //                }
            //            }
            
        } else {
            cell.mySeg = self
            cell.uuidLbl.text = self.uuidArray[indexPath.row]
            
            //            // manipulate like button depending on did user like it or not
            //            let didLike = PFQuery(className: "likes")
            //            didLike.whereKey("by", equalTo: PFUser.currentUser()!.username!)
            //            didLike.whereKey("to", equalTo: uuidArray[indexPath.row])
            //            didLike.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) -> Void in
            //                // if no any likes are found, else found likes
            //                if count == 0 {
            //                    cell.likeBtn.setTitle("unlike", forState: .Normal)
            //                    cell.likeBtn.setBackgroundImage(UIImage(named: "unlike.png"), forState: .Normal)
            //                } else {
            //                    cell.likeBtn.setTitle("like", forState: .Normal)
            //                    cell.likeBtn.setBackgroundImage(UIImage(named: "like.png"), forState: .Normal)
            //                }
            //            }
            //
            //            let countLikes = PFQuery(className: "likes")
            //            countLikes.whereKey("to", equalTo: uuidArray[indexPath.row])
            //            countLikes.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) -> Void in
            //                cell.likeLbl.text = "\(count)"
            //            }
            
            
            
            //            firebase.child("Likes").child(cell.uuidLbl.text!).child((FIRAuth.auth()?.currentUser!.uid)!).observeEventType(.Value, withBlock: { snapshot in
            //                print(snapshot.value)
            //                if snapshot.exists() {
            //                    cell.likeBtn.setTitle("like", forState: .Normal)
            //                    cell.likeBtn.setBackgroundImage(UIImage(named: "like.png"), forState: .Normal)
            //                } else {
            //                    cell.likeBtn.setTitle("unlike", forState: .Normal)
            //                    cell.likeBtn.setBackgroundImage(UIImage(named: "unlike.png"), forState: .Normal)
            //                }
            //            })
            
            getLikeState(string: cell.uuidLbl.text! , Btn: cell.likeBtn)
            getLikeCount(string: cell.uuidLbl.text! , Lbl : cell.LikeLbl)
            
            //cell.LikeLbl.setTitle(self.likeArray[indexPath.row], forState: .Normal)
            
            
            //            firebase.child("Likes").child(cell.uuidLbl.text!).observeEventType(.Value, withBlock: { snapshot in
            //                if snapshot.exists() {
            //
            //                    cell.likeLbl.text =  "\(snapshot.childrenCount)"
            //
            //                }
            //            })
            
            
            
            
            //            self.storage.referenceForURL(picArray[indexPath.row]).dataWithMaxSize(25 * 1024 * 1024, completion: { (data, error) -> Void in
            //                let image = UIImage(data: data!)
            //
            //                // objc_sync_enter(self.nameArray)
            //                // objc_sync_enter(self.nameArray)
            //                //self.picArray.append(image! as! UIImage)
            //                cell.picImg1.image = image
            //                //objc_sync_exit(self.nameArray)
            //                //self.tableView.reloadData()
            //                //self.scrollToBottom()
            //
            //                // objc_sync_exit(self.nameArray)
            //
            //            })
            //objc_sync_enter(self.picArrayURL)
            // if picArray[indexPath.row] != nil {
            cell.picImg1.image = picArray[indexPath.row]
            // }
            //objc_sync_exit(self.picArrayURL)
            
            //cell.picImg1.image = picArray[indexPath.row]
            cell.titleLbl.text = "Two Little Bees"
            
            // get loaded images from array
            //            picArray[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
            //                if error == nil {
            //                    cell.picImg1.image = UIImage(data: data!)
            //                }
            
            
            //            }
            
        }
        
        
        
        
        
        
        
        
        
        
        //cell.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-4-[v0]-110-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": like]))
        
        //        cell.addSubview(nameLabel)
        //        cell.addSubview(like)
        //        cell.addSubview(likeLabel)
        //        cell.addSubview(picImg)
        //        cell.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-161-[v0(18)]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": like]))
        //        cell.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-2-[v1(18)]-1-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": likeLabel,"v1": like]))
        //        cell.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-50-[v2]-1-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v2": nameLabel]))
        //        cell.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-153-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": likeLabel]))
        //        cell.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-152-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        
        
        
        //let likeImg = UIImageView(frame: CGRectMake(0, 0, 10, 10))
        //cell.addSubview(likeImg)
        
        return cell
    }
    
    //    // cell config
    //    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    //
    //        // define cell
    //        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
    //
    //        // create picture imageView in cell to show loaded pictures
    //        let picImg = UIImageView(frame: CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height))
    //        cell.addSubview(picImg)
    //
    //        // get loaded images from array
    //        picArraySearch[indexPath.row].getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
    //            if error == nil {
    //                picImg.image = UIImage(data: data!)
    //            } else {
    //                print(error!.localizedDescription)
    //            }
    //        }
    //
    //        return cell
    //    }
    
    // cell's selected
    //    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    //
    //        // take relevant unique id of post to load post in postVC
    //        postuuid.append(uuidArraySearch[indexPath.row])
    //
    //        // present postVC programmaticaly
    //        let post = self.storyboard?.instantiateViewControllerWithIdentifier("postVC") as! postVC
    //        self.navigationController?.pushViewController(post, animated: true)
    //    }
    
    //    // load posts
    //    func loadPostsforColl() {
    //        let query = PFQuery(className: "posts")
    //        query.limit = page
    //        query.addDescendingOrder("createdAt")
    //        query.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error:NSError?) -> Void in
    //            if error == nil {
    //
    //                // clean up
    //                self.picArraySearch.removeAll(keepCapacity: false)
    //                self.uuidArraySearch.removeAll(keepCapacity: false)
    //
    //                // found related objects
    //                for object in objects! {
    //                    self.picArraySearch.append(object.objectForKey("pic") as! PFFile)
    //                    self.uuidArraySearch.append(object.objectForKey("uuid") as! String)
    //                }
    //
    //                // reload collectionView to present images
    //                self.collectionView.reloadData()
    //
    //            } else {
    //                print(error!.localizedDescription)
    //            }
    //        }
    //    }
    
    // scrolled down
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // scroll down for paging
        if scrollView.contentOffset.y >= scrollView.contentSize.height / 6 {
            // self.loadMore()
        }
    }
    
    //    // pagination
    //    func loadMoreColl() {
    //
    //        // if more posts are unloaded, we wanna load them
    //        if page <= picArray.count {
    //
    //            // increase page size
    //            page = page + 15
    //
    //            // load additional posts
    //            let query = PFQuery(className: "posts")
    //            query.limit = page
    //            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
    //                if error == nil {
    //
    //                    // clean up
    //                    self.picArray.removeAll(keepCapacity: false)
    //                    self.uuidArray.removeAll(keepCapacity: false)
    //
    //                    // find related objects
    //                    for object in objects! {
    //                        self.picArray.append(object.objectForKey("pic") as! PFFile)
    //                        self.uuidArray.append(object.objectForKey("uuid") as! String)
    //                    }
    //
    //                    // reload collectionView to present loaded images
    //                    self.collectionView.reloadData()
    //
    //                } else {
    //                    print(error!.localizedDescription)
    //                }
    //            })
    //
    //        }
    //
    //    }
    
    //    func unlikeTouchedColl(sender: AnyObject){
    //        let i = sender.layer.valueForKey("index") as! NSIndexPath
    //        // call cell to call further cell data
    //        let cell = collectionView.cellForItemAtIndexPath(i) as! searchCollCell
    //        print(cell.uuid.text)
    //
    //
    //        // request existing likes of current user to show post
    //        let query = PFQuery(className: "likes")
    //        query.whereKey("by", equalTo: PFUser.currentUser()!.username!)
    //        query.whereKey("to", equalTo: cell.uuid.text!)
    //        query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
    //
    //            // find objects - likes
    //            for object in objects! {
    //
    //                // delete found like(s)
    //                object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
    //                    if success {
    //                        print("disliked")
    //                        //self.likeBtn.setTitle("unlike", forState: .Normal)
    //                        cell.likeButton.setImage(UIImage(named: "unlike.png"), forState: .Normal)
    //
    //                        // send notification if we liked to refresh TableView
    //                        NSNotificationCenter.defaultCenter().postNotificationName("liked", object: nil)
    //
    //
    //                    }
    //                })
    //            }
    //        })
    //
    //
    //    }
    //
    //    func likeTouchedColl(sender: AnyObject){
    //
    //
    //        // call index of button
    //        let i = sender.layer.valueForKey("index") as! NSIndexPath
    //        // call cell to call further cell data
    //        let cell = collectionView.cellForItemAtIndexPath(i) as! searchCollCell
    //        print(cell.uuid.text)
    //
    //        // declare title of button
    //        let title = sender.titleForState(.Normal)
    //
    //
    //        // to like
    //        if title == "unlike" {
    //
    //            let object = PFObject(className: "likes")
    //            object["by"] = PFUser.currentUser()?.username
    //            object["to"] = cell.uuid.text!
    //            object.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
    //                if success {
    //                    print("liked")
    //                    //self.likeBtn.setTitle("like", forState: .Normal)
    //                    cell.likeButton.setImage(UIImage(named: "like.png"), forState: .Normal)
    //
    //                    // send notification if we liked to refresh TableView
    //                    NSNotificationCenter.defaultCenter().postNotificationName("liked", object: nil)
    //
    //
    //                }
    //            })
    //
    //        } else {
    //            // request existing likes of current user to show post
    //            let query = PFQuery(className: "likes")
    //            query.whereKey("by", equalTo: PFUser.currentUser()!.username!)
    //            query.whereKey("to", equalTo: cell.uuid.text!)
    //            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
    //
    //                // find objects - likes
    //                for object in objects! {
    //
    //                    // delete found like(s)
    //                    object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
    //                        if success {
    //                            print("disliked")
    //                            //self.likeBtn.setTitle("unlike", forState: .Normal)
    //                            cell.likeButton.setImage(UIImage(named: "unlike.png"), forState: .Normal)
    //
    //                            // send notification if we liked to refresh TableView
    //                            NSNotificationCenter.defaultCenter().postNotificationName("liked", object: nil)
    //
    //
    //                        }
    //                    })
    //                }
    //            })
    //
    //
    //        }
    //
    
    //    }
    
    
    
    
    
    // if user tapped on himself go home, else go guest
    
    
    //        if cell.usernameHidden.titleLabel?.text == PFUser.currentUser()?.username {
    //            let home = self.storyboard?.instantiateViewControllerWithIdentifier("homeVC") as! homeVC
    //            self.navigationController?.pushViewController(home, animated: true)
    //        } else {
    //            guestname.append(cell.usernameHidden.titleLabel!.text!)
    //            let guest = self.storyboard?.instantiateViewControllerWithIdentifier("guestVC") as! guestVC
    //            self.navigationController?.pushViewController(guest, animated: true)
    //        }
    //    }
    
    
    
    
    func tableViewLaunch() {
        
        // layout of collectionView
        //let layout : UITableViewLayout = UICollectionViewFlowLayout()
        //
        //        // item size
        //        layout.itemSize = CGSizeMake(self.view.frame.size.width / 3, self.view.frame.size.width / 3)
        //
        //        // direction of scrolling
        //        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        
        // define frame of collectionView
        //let frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.tabBarController!.tabBar.frame.size.height - self.navigationController!.navigationBar.frame.size.height - 20)
        
        // declare collectionView
        
        //tableViewSearch = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        //tableViewSearch = UITableView(frame: frame, collectionViewLayout: layout)
        //tableViewSearch = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = true
        tableView.backgroundColor = UIColor.white
        //tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UINib(nibName: "postFeed", bundle: nil), forCellReuseIdentifier: "idPostFeedCell")
        //tableView.frame = UIScreen.mainScreen().bounds
        self.view.addSubview(tableView)
        
        // define cell for collectionView
        //tableViewSearch.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        
        //tableView.registerClass(searchCell.self, forCellReuseIdentifier: "Cell")
        
        
        // call function to load posts
        //loadPosts()
        
        //loadUsers()
    }
    
    
    //    // SEARCHING CODE
    //    // load users function
    //    func loadUsers() {
    //
    //        let usersQuery = PFQuery(className: "_User")
    //        usersQuery.addDescendingOrder("createdAt")
    //        usersQuery.limit = 20
    //        usersQuery.findObjectsInBackgroundWithBlock ({ (objects:[PFObject]?, error:NSError?) -> Void in
    //            if error == nil {
    //
    //                // clean up
    //                self.usernameArraySearch.removeAll(keepCapacity: false)
    //                self.avaArraySearch.removeAll(keepCapacity: false)
    //
    //                // found related objects
    //                for object in objects! {
    //                    self.usernameArraySearch.append(object.valueForKey("username") as! String)
    //                    self.avaArraySearch.append(object.valueForKey("picture_file") as! PFFile)
    //                }
    //
    //                // reload
    //                self.tableViewSearch.reloadData()
    //
    //            } else {
    //                print(error!.localizedDescription)
    //            }
    //        })
    //        
    //    }
    
    
    
}
