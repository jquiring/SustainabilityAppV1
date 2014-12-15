//
//  ProfilePost.swift
//  SustainabilityAppV1
//
//  Created by Jake Quiring on 11/12/14.
//  Copyright (c) 2014 Jake Quiring. All rights reserved.
//

import Foundation

class ProfilePost {
    var title = "title"
    var imageName = "blank"
    var id = ""
    /*
    var cat = ""
    var pic1:NSData
    var pic2:NSData
    var pic3:NSData
    var price = ""
    var round_trip = ""
    var start_loc = ""
    var end_loc = ""
    var departs = ""
    var returns = ""
    var ISBN = ""
    var location = ""
    var date = ""
    var zagmail = ""
    var p_email = ""
    var text = ""
    var phone = "" 
*/
    init(title:String,imageName:String,id:String){
        self.title = title
        self.imageName = imageName
        self.id = id
    }
    init(arr: Array<Any>){

        
    }
}