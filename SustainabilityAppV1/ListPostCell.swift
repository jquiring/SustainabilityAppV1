//
//  ListPostCell.swift
//  SustainabilityAppV1
//
//  Created by Jake Quiring on 1/16/15.
//  Copyright (c) 2015 Jake Quiring. All rights reserved.
//

import UIKit

class ListPostCell: UITableViewCell {
    @IBOutlet var title: UILabel!
    @IBOutlet var keyValue: UILabel!
    @IBOutlet var itemImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        println("selected")
        // Configure the view for the selected state
    }
    func setCell(title:String,imageName:NSData,keyValue:String){
        self.title.text = title
        self.keyValue.text = keyValue
        var err: NSError?
        itemImage.image = UIImage(data:imageName)
    }


}
