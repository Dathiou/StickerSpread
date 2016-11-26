

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
    
    var UFGArray = [String]()
    var profPicURL = [String]()
    
    var postArray = [Post]()
    
    
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
        
        
        
        let adjustForTabbarInsets = UIEdgeInsetsMake(0, 0, self.tabBarController!.tabBar.frame.height + 3, 0);
        self.tableView.contentInset = adjustForTabbarInsets
        self.tableView.scrollIndicatorInsets = adjustForTabbarInsets
        self.collectionView.contentInset = adjustForTabbarInsets
        self.collectionView.scrollIndicatorInsets = adjustForTabbarInsets
        
        
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
        collectionView.addSubview(refresher)
        
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
        
        
    }
    
    func goToPost(thisPost : Post!){
        // take relevant unique id of post to load post in postVC
        
        //print (uuid)
        //postuuid.append(uuid)
        
        
        // present postVC programmaticaly
        let post = self.storyboard?.instantiateViewController(withIdentifier: "postVC") as! postVC
        post.myPost = thisPost
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
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: NSIndexPath) {
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
    
    func refreshLikes(_ notification: NSNotification) {
        
        if let row = notification.object as? Int {
            
            let indexPath = NSIndexPath(row: row, section: 0)
            self.collectionView.reloadItems(at: [indexPath as IndexPath])
            self.tableView.reloadRows(at: [indexPath as IndexPath],with: .none)
        }
        
    }
    
    // reloading func with posts  after received notification
    func uploaded(notification:NSNotification) {
        loadPosts()
        
    }
    
    // load posts
    func loadPosts() {
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        let picturesGroup = DispatchGroup()
        let queue = DispatchQueue.global(qos: .default)
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
            self.UFGArray.removeAll(keepingCapacity: false)
            self.profPicURL.removeAll(keepingCapacity: false)
            
            self.postArray.removeAll(keepingCapacity: false)
            
            if snapshot.exists() {
                
                var i = 0
                for post in snapshot.children{
                    
                    let userID = ((post as! FIRDataSnapshot).value as? [String:AnyObject])?["userID"] as! String
                    
                    //self.myDictionaryURL.updateValue(url, forKey: i)
                    
                    //i = i + 1
                    

                    picturesGroup.enter()
                    queue.async(execute: {
                        firebase.child("Users").child(userID).observe(.value, with: { snapshot in
                            
                            let uuid = (post as AnyObject).key as String!
                            let myPost = Post()
                            myPost.uuid = uuid
                            
                            myPost.UserID = userID
                            
                            let UFG = ((post as! FIRDataSnapshot).value as? [String:AnyObject])?["Grab"] as! String
                            self.UFGArray.append(UFG)
                            myPost.Grab = UFG
                            
                            let url = ((post as! FIRDataSnapshot).value as? [String:AnyObject])?["photoUrl"] as! String
                            self.picArrayURL.append(url)
                            myPost.photoURL = url
                            
                            
                            //let datestring = post.value.objectForKey("date") as! String
                            if let datestring = ((post as! FIRDataSnapshot).value as? [String:AnyObject])?["date"]{
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                                let date = dateFormatter.date(from: datestring as! String)
                                self.dateArray.append((date as Date?)!)
                                myPost.date = date
                            }
                            
                            self.usernameArray.append(userID )
                            
                            
                            self.titleArray.append(((post as! FIRDataSnapshot).value as? [String:AnyObject])?["title"] as! String)
                            myPost.title = ((post as! FIRDataSnapshot).value as? [String:AnyObject])?["title"] as! String
                            self.uuidArray.append((post as AnyObject).key! as String!)
                            
                            
                            
                            let first = ((snapshot.value! as AnyObject)["first_name"] as? String)
                            let last = (snapshot.value! as AnyObject)["last_name"] as? String
                            
                            let fullname = first!+" "+last!
                            self.nameArray.append(fullname)
                            myPost.NameAuthor = fullname
                            
                            let avaURL = (snapshot.value! as AnyObject)["ProfilPicUrl"] as! String
                            //let url = NSURL(string: avaURL)
                            self.profPicURL.append(avaURL)
                            myPost.profUrl = avaURL
                            self.postArray.append(myPost)
                            
                            picturesGroup.leave()
                            
                            //self.comments.append(snapshot)
                            //self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.comments.count-1, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Automatic)
                            }
                            
                            
                        ){ (error) in
                            print(error.localizedDescription)
                        }
                    })
                    

                    
                    self.refresher.endRefreshing()

                }}
            
            picturesGroup.notify(queue: DispatchQueue.main, execute:{
                
                self.avaArray = self.avaArray.reversed()
                self.nameArray = self.nameArray.reversed()
                self.picArrayURL = self.picArrayURL.reversed()
                self.profPicURL = self.profPicURL.reversed()
                self.dateArray = self.dateArray.reversed()
                self.usernameArray = self.usernameArray.reversed()
                self.uuidArray = self.uuidArray.reversed()
                self.UFGArray = self.UFGArray.reversed()
                
                self.postArray = self.postArray.reversed()
                self.titleArray = self.titleArray.reversed()
                
                self.tableView.reloadData()
                self.collectionView.reloadData()
                
            })
            
            
            //self.comments.append(snapshot)
            //self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.comments.count-1, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Automatic)
        }){ (error) in
            print(error.localizedDescription)
        }
        
        
        
        
        
        
        UIApplication.shared.endIgnoringInteractionEvents()
        
        
    }
    
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
                //print (nameArray.count)
                //return nameArray.count
                return postArray.count
            }
        }
        //objc_sync_exit(self)
        //        }
    }
    
    
    
    
    
    
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
             cell.backgroundColor = UIColor(patternImage: UIImage(named: "Background_Blue_Joint.jpg")!)
            cell.likeBtn.tag = indexPath.row
            cell.segueDelegate = self
            
            let thisPost = postArray[indexPath.row]
            cell.thisPost = thisPost
            
     
            let from = thisPost.date
            
            // define self
            
            //let u = indexPath.row
            cell.usernameBtn.setTitle(thisPost.NameAuthor, for: UIControlState.normal)
            cell.usernameBtn.sizeToFit()
            //objc_sync_exit(self.nameArray)
            cell.uuidLbl.text = thisPost.uuid//self.uuidArray[indexPath.row]
            cell.titleLbl.text = thisPost.title//self.titleArray[indexPath.row]
            cell.titleLbl.sizeToFit()
            cell.usernameHidden.setTitle(thisPost.UserID, for: UIControlState.normal)
            
            //self.avaImg.image = avaArray[indexPath.row]
            cell.avaImg.loadImageUsingCacheWithUrlString(urlString: thisPost.profUrl!)//profPicURL[indexPath.row])
            cell.picImg.loadImageUsingCacheWithUrlString(urlString: thisPost.photoURL!)//picArrayURL[indexPath.row]) //picArray[indexPath.row]
            
            if thisPost.Grab == "Not Available"{
                cell.flag.isHidden = true
                cell.UFG.isHidden = true
            } else {
                cell.flag.isHidden = false
                cell.UFG.isHidden = false
            }
            
            // calculate post date
            //let from = thisPost.date//dateArray[indexPath.row]
            
            
            
            
            let now = Date()
            let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfMonth])
            let dayCalendarUnit: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfMonth]
            //let difference = NSCalendar.current.compare(from, to: now , toGranularity: .second)
            let difference = from?.timeIntervalSinceNow
            //let difference1 = NSCalendar.current.dateComponents.dateComponents(dayCalendarUnit, from: from, to: now)
            cell.dateLbl.text = Date().offset(from: from!)

            
            getLikeCount(string: cell.uuidLbl.text! , Lbl : cell.LikeLbl)
            getLikeState(string: cell.uuidLbl.text! , Btn: cell.likeBtn)

            // asign index
            cell.usernameBtn.layer.setValue(indexPath, forKey: "index")
            //cell.commentBtn.layer.setValue(indexPath, forKey: "index")
            //cell.moreBtn.layer.setValue(indexPath, forKey: "index")
            return cell
        }

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
            
        }
    }

    // alert action
    func alert (title: String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    
    // COLLECTION VIEW CODE
    func collectionViewLaunch() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        self.view.addSubview(collectionView)
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
            
            
        } else {
            cell.mySeg = self
            let thisPost = postArray[indexPath.row]
            cell.thisPost = thisPost
cell.cellpos = indexPath.row
            cell.uuidLbl.text = thisPost.uuid//self.uuidArray[indexPath.row]
            cell.titleLbl.text = thisPost.title//self.titleArray[indexPath.row]
            cell.titleLbl.sizeToFit()
            //self.usernameHidden.setTitle(thisPost.UserID, for: UIControlState.normal)
            
            //self.avaImg.image = avaArray[indexPath.row]
            //self.avaImg.loadImageUsingCacheWithUrlString(urlString: thisPost.profUrl!)//profPicURL[indexPath.row])
            cell.picImg1.loadImageUsingCacheWithUrlString(urlString: thisPost.photoURL!)//picArrayURL[indexPath.row]) //picArray[indexPath.row]
            
            if thisPost.Grab == "Not Available"{
                cell.Flag.isHidden = true
                cell.UFG.isHidden = true
            } else {
                cell.Flag.isHidden = false
                cell.UFG.isHidden = false
            }
            

            getLikeState(string: cell.uuidLbl.text! , Btn: cell.likeBtn)
            getLikeCount(string: cell.uuidLbl.text! , Lbl : cell.LikeLbl)
            //cell.picImg1.loadImageUsingCacheWithUrlString(urlString: picArrayURL[indexPath.row]) //picArray[indexPath.row]
            //cell.titleLbl.text = titleArray[indexPath.row]
        }
        return cell
    }
    
    
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


    func tableViewLaunch() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = true
        tableView.backgroundColor = UIColor.white
        //tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UINib(nibName: "postFeed", bundle: nil), forCellReuseIdentifier: "idPostFeedCell")
        //tableView.frame = UIScreen.mainScreen().bounds
        self.view.addSubview(tableView)
    }
}
