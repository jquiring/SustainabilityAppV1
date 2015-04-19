//
//  FieldValidator.swift
//  SustainabilityAppV1
//
//  Created by Jake Quiring on 2/9/15.
//  Copyright (c) 2015 Jake Quiring. All rights reserved.
//

import Foundation

class FieldValidator {
    init(){
    }
    func datesInOrder(date1:String,date2:String)->Bool{
        if(date1 != "" && date2 != ""){
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "M/d/yy, h:mm a"
            let date1:NSDate = dateFormatter.dateFromString(date1)!
            let date2:NSDate = dateFormatter.dateFromString(date2)!
            if(date1.compare(date2) == NSComparisonResult.OrderedDescending){
                return false
            }
        }
        return true
    }
    func checkLength(checkedString:String,lengthString:Int,empty:Bool)->Bool{
        if(empty){
            if(checkedString == ""){
                return false
            }
        }
        if(count(checkedString)<=lengthString){
            return true
        }
        return false
    }
    func checkPriceUnder1000(price:String)->Bool{
        if(price == ""){
            return true
        }
        if(price.toDouble() <= 10000){
                return true
        }
        return false
    }
    func checkFloat(price:String)->Bool{
        if let decimalAsDoubleUnwrapped = NSNumberFormatter().numberFromString(price) {
           return true
        }
        return false
    }
}