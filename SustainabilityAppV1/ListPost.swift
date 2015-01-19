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
    
    init(title:String,imageName:NSData,id:String,keyValue:String){
        super.init(title:title,imageName:imageName,id:id)
        self.key_value = keyValue
    }
    init(title:String,id:String,keyValue:String){
        super.init(title:title,id:id)
        self.key_value = keyValue
    }
    
}
