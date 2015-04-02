//
//  ListPost.swift
//  SustainabilityAppV1
//
//  Created by Jake Quiring on 1/16/15.
//  Copyright (c) 2015 Jake Quiring. All rights reserved.
//

import Foundation
import UIKit

class ListPost: ProfilePost  {
    var key_value = ""
    var has_image:Bool
    var image_loaded:Bool = false
    var image_error:Bool = false
    init(title:String,imageName:NSData,id:String,keyValue:String,cat:String,date:String,has_image:Bool){
        self.has_image = has_image
        self.key_value = keyValue
        self.image_loaded = false
        super.init(title:title,imageName:imageName,id:id,cat:cat,date:date)
    }
    init(title:String,id:String,keyValue:String,cat:String,date:String,has_image:Bool){
        self.has_image = has_image
        self.key_value = keyValue
        self.image_loaded = false
        super.init(title:title,id:id,cat:cat,date:date)
    }
}
