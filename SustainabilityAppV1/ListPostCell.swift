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
    @IBOutlet var imageLoad: UIActivityIndicatorView!

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
        imageLoad.stopAnimating()
        itemImage.hidden = false
    }
    func setCell(title:String,keyValue:String,bounds:CGRect){
        self.title.text = title
        self.keyValue.text = keyValue
        self.itemImage.hidden = true
        self.imageLoad.startAnimating()
        var err: NSError?
        self.title.preferredMaxLayoutWidth = maxWidth() - 90
        self.keyValue.preferredMaxLayoutWidth = maxWidth() - 180
    }
    func setCell(title:String,keyValue:String,bounds:CGRect,hasError:Bool){
        self.title.text = title
        self.keyValue.text = keyValue
        var err: NSError?
        var image =  UIImage(named:"failedToLoad")
        itemImage.image = image
        self.title.preferredMaxLayoutWidth = maxWidth() - 90
        self.keyValue.preferredMaxLayoutWidth = maxWidth() - 180
        imageLoad.stopAnimating()
        itemImage.hidden = false
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.title.preferredMaxLayoutWidth = maxWidth() - 90
        self.keyValue.preferredMaxLayoutWidth = maxWidth() - 180
    }
}
