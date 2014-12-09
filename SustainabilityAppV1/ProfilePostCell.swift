//
//  ProfilePostCell.swift
//  SustainabilityAppV1
//
//  Created by Jake Quiring on 11/12/14.
//  Copyright (c) 2014 Jake Quiring. All rights reserved.
//

import UIKit

class ProfilePostCell: UITableViewCell {

    @IBOutlet var itemImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(title:String,imageName:String,id:String){
        self.title.text = title
        self.itemImage.image  = UIImage(named:imageName)
        self.restorationIdentifier = id
    }
}
