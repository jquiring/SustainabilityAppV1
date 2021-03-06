//
//  ProfilePostCell.swift
//  SustainabilityAppV1
//
//  Created by Jake Quiring on 11/12/14.
//  Copyright (c) 2014 Jake Quiring. All rights reserved.
//

import UIKit

class ProfilePostCell: UITableViewCell {
    
    @IBOutlet var imageRefresh: UIActivityIndicatorView!
    @IBOutlet var deleteRefresh: UIActivityIndicatorView!
    @IBOutlet var bumpRefresh: UIActivityIndicatorView!
    @IBOutlet var itemImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet var edit: UIButton!
    @IBOutlet var delete: UIButton!
    @IBOutlet var bump: UIButton!
    
    var id = "0"
    var category = "0"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setCell(title:String,imageName:NSData){
        self.title.text = title
        var err: NSError?
        itemImage.image = UIImage(data:imageName)
    }
    func setCell(title:String,imageName:NSData,refreshing:Bool,deleting:Bool){
        self.title.text = title
        var err: NSError?
        itemImage.image = UIImage(data:imageName)
        if(refreshing){
            bump.hidden = true
            bumpRefresh.startAnimating()
        }
        else{
            bump.hidden = false
            bumpRefresh.stopAnimating()
        }
        if(deleting){
            delete.hidden = true
            deleteRefresh.startAnimating()
        }
        else{
            delete.hidden = false
            deleteRefresh.stopAnimating()
        }
    }
}
