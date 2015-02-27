//
//  ProfilePost.swift
//  SustainabilityAppV1
//
//  Created by Jake Quiring on 11/12/14.
//  Copyright (c) 2014 Jake Quiring. All rights reserved.
//

import Foundation
import UIKit

class ProfilePost {
    var title = "title"
    var imageName:NSData
    //var key_value = ""
    var id = ""
    var category = ""
    var refreshable = ""
    var date = ""
    //let date_time = ""
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
    init(title:String,imageName:NSData,id:String,cat:String, date:String){
        self.title = title
        self.imageName = imageName
        self.id = id
        self.category = cat
        self.date = date
        
    }
    init(title:String,id:String,cat:String, date:String){
        self.category = cat
        self.title = title
        self.id = id
        var image =  UIImage(named:"noImage")
        self.imageName = UIImageJPEGRepresentation(image, 1)
        self.date = date
    }
    func getID() -> String{
        return id
    }

    func upDateNSData(newer:Bool){
        if (NSUserDefaults.standardUserDefaults().objectForKey("user_posts") != nil) {
            var current_posts:[[AnyObject]] = NSUserDefaults.standardUserDefaults().objectForKey("user_posts") as [[AnyObject]]
            if(newer){
                current_posts.insert([id,title,imageName,category,date], atIndex: 0)
            }
            else {
                current_posts.append([id,title,imageName,category,date])
            }
            NSUserDefaults.standardUserDefaults().setObject(current_posts, forKey: "user_posts")
            
        }
        else {
            let dict:[[AnyObject!]] = [[id,title,imageName,category,date]]
            NSUserDefaults.standardUserDefaults().setObject(dict, forKey: "user_posts")
        }
    }
}