//
//  Extensions.swift
//  StickerSpread
//
//  Created by Student on 10/23/16.
//  Copyright © 2016 Student iMac. All rights reserved.
//

import UIKit
import JSQMessagesViewController
let imageCache = NSCache<AnyObject, AnyObject>()

//extension UIImageView {
//    
//    func loadImageUsingCacheWithUrlString(urlString: String) {
//        
//        self.image = nil
//        
//        //check cache for image first
//        if let cachedImage = imageCache.objectForKey(urlString) as? UIImage {
//            self.image = cachedImage
//            return
//        }
//        
//        //otherwise fire off a new download
//        let url = NSURL(string: urlString)
//        NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
//            
//            //download hit an error so lets return out
//            if error != nil {
//                print(error)
//                return
//            }
//            
//            dispatch_async(dispatch_get_main_queue(), {
//                
//                if let downloadedImage = UIImage(data: data!) {
//                    imageCache.setObject(downloadedImage, forKey: urlString)
//                    
//                    self.image = downloadedImage
//                }
//            })
//            
//        }).resume()
//    }
//    
//}


extension UIImageView {
    func loadImageUsingCacheWithUrlString(urlString: String) {
        
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey:urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    
                    self.image = downloadedImage
                }
            })
            
        }).resume()
    }
}


class Post: NSObject{
    var photoURL: String?
    var NameAuthor : String?
    var profUrl:String?
    //var profileURL: String?
    var uuid: String?
    var Grab: String?
    var UserID: String?
    var date: Date?
    var Color: [String] = []
    var Finish: String?
    var Layout: String?
    var Month: String?
    var title: String?
    
    
    
}

