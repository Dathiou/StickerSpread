//
//  searchCollCell.swift
//  StickerSpread
//
//  Created by Student iMac on 6/16/16.
//  Copyright © 2016 Student iMac. All rights reserved.
//

import UIKit
import Parse

class searchCollCell: UICollectionViewCell {
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //cell.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-2-[v1(20)]-1-[v0]-5-[v2]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": likeLbl,"v1": like,"v2": titleShop]))
        // round ava
        //avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        //avaImg.clipsToBounds = true
        
        

        
    }

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
     
        setupViews(frame)
    }
    
//    let uuidLbl: UILabel = {
//        let label = UILabel()
//        //label.text = "My Custom CollectionView"
//        //label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        //label.text = "My Custom CollectionView"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.fontWithSize(13)
        return label
    }()
    
    let likeLabel: UILabel = {
        let label = UILabel()
        // count total likes of shown post
        
        //
        
        //label.frame = CGRectMake(21, 140, 10, 10)
        //label.text = "9"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.fontWithSize(9)
        return label
    }()
    
    let likeButton: UIButton = {
        
        let image = UIImage(named: "unlike.png")
//        let likeImg = UIImageView(image: image!)
//        //likeImg.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
//        likeImg.translatesAutoresizingMaskIntoConstraints = false
        
        let button   = UIButton(type: UIButtonType.Custom) as UIButton
        //button.frame = CGRectMake(100, 100, 100, 100)
        //button.setImage(image, forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.addTarget(self, action: "btnTouched:", forControlEvents:.TouchUpInside)
        
        return button
    }()
    
    let uuid = UILabel()
    
    let picImg = UIImageView()
    
//    let image = UIImage(named: "name") as UIImage?
//    let button   = UIButton(type: UIButtonType.Custom) as UIButton
//    //button.frame = CGRectMake(100, 100, 100, 100)
//    button.setImage(image, forState: .Normal)
//    button.addTarget(self, action: "btnTouched:", forControlEvents:.TouchUpInside)
//    self.view.addSubview(button)
    
    
//    let likeLabel: UILabel = {
//        let label = UILabel()
//        // count total likes of shown post
//        let countLikes = PFQuery(className: "likes")
//        countLikes.whereKey("to", equalTo: uuidArrayColl[indexPath.row])
//        countLikes.countObjectsInBackgroundWithBlock { (count:Int32, error:NSError?) -> Void in
//            label.text = String(count) //"\(count)"
//        }
//    }()
    
    func setupViews(frame: CGRect) {
//        backgroundColor = UIColor.redColor()
//        
//        addSubview(nameLabel)
//        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-12-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
//        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
       
        
        var lineView = UIView(frame: CGRectMake(25,self.frame.size.height - 2,self.frame.size.width - 50,0.5))
        lineView.layer.borderWidth = 0.5
        lineView.layer.borderColor = UIColor.blackColor().CGColor
        self.addSubview(lineView)
        self.addSubview(likeButton)
        self.addSubview(nameLabel)
        //self.addSubview(like)
        self.addSubview(likeLabel)
        picImg.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)
        self.addSubview(picImg)
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-161-[v0(18)]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": likeButton]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-2-[v1(18)]-1-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": likeLabel,"v1": likeButton]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-50-[v2]-1-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v2": nameLabel]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-153-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": likeLabel]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-152-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
