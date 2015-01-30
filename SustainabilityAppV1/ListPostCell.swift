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

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        println("selected")
        // Configure the view for the selected state
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // MARK: Required for self-sizing cells.
        self.title.preferredMaxLayoutWidth = maxWidth() - 90
        self.keyValue.preferredMaxLayoutWidth = maxWidth() - 180
    }
    func maxWidth() -> CGFloat {
        
        var appMax = self.frame.width
        return appMax
    }
    func setCell(title:String,imageName:NSData,keyValue:String,bounds:CGRect){
        self.title.text = title
        self.keyValue.text = keyValue
        var err: NSError?
        itemImage.image = UIImage(data:imageName)
        self.title.preferredMaxLayoutWidth = maxWidth() - 90
        self.keyValue.preferredMaxLayoutWidth = maxWidth() - 180
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // MARK: Required for self-sizing cells
        self.title.preferredMaxLayoutWidth = maxWidth() - 90
        self.keyValue.preferredMaxLayoutWidth = maxWidth() - 180
    }


}
