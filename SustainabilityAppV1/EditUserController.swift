//
//  EditUserController.swift
//  SustainabilityAppV1
//
//  Created by Jake Quiring on 11/3/14.
//  Copyright (c) 2014 Jake Quiring. All rights reserved.
//

import UIKit
import Foundation

class EditUserController: UIViewController {
    var flag = false
 
    @IBOutlet weak var error_label: UILabel!
    @IBOutlet weak var first_name_field: UITextField!
    @IBOutlet weak var last_name_field: UITextField!
    @IBOutlet weak var phone_number: UITextField!
    @IBOutlet weak var email: UITextField!
    
    
    @IBAction func save(sender: AnyObject){
        var flag_Val = false
        var return_Val = -1
        var request = NSMutableURLRequest(URL: NSURL(string: "http://147.222.165.121:8000/edituser/")!)
        var session = NSURLSession.sharedSession()
        var username = NSUserDefaults.standardUserDefaults().objectForKey("username") as String
        var first_name = first_name_field.text
        var last_name = last_name_field.text
        var p_email = email.text
        var phone = phone_number.text
        var params = ["username":username, "first_name":first_name, "last_name":last_name, "pref_email":p_email, "phone":phone] as Dictionary<String, String>
        var err: NSError?
        request.HTTPMethod = "PUT"
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var message = ""
            var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &err) as? NSDictionary
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
            }
            else{
                if let parseJSON = json as? Dictionary<String,AnyObject>{
                    message = parseJSON["message"] as String
                }
            }
            if let httpResponse = response as? NSHTTPURLResponse {
                var status_code = httpResponse.statusCode
                if(status_code == 200){
                    println(message)
                    return_Val = 200
                    flag_Val = true
                }
                else if(status_code == 400){
                    println(message)
                    return_Val = 400
                    flag_Val = true
                }
                else if(status_code == 500){
                    println(message)
                    return_Val = 500
                    flag_Val = true
                }
            } else {
                println("Error in casting response, data incomplete")
            }
        })
        task.resume()
        while(flag == false){
            flag = flag_Val
        }
        if(return_Val == 200){
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        first_name_field.text = NSUserDefaults.standardUserDefaults().objectForKey("first_name") as String
        last_name_field.text = NSUserDefaults.standardUserDefaults().objectForKey("last_name") as String
        phone_number.text = NSUserDefaults.standardUserDefaults().objectForKey("phone") as String
        email.text = NSUserDefaults.standardUserDefaults().objectForKey("pref_email") as String
        error_label.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func checkFields() -> Bool {
        if(first_name_field.text.isEmpty || last_name_field.text.isEmpty) {
            error_label.hidden = false
            error_label.text = "Please enter a valid phone number"
            return false
        }
        else if(!phone_number.text.isEmpty && (!isNumeric(phone_number.text) || !(countElements(phone_number.text) == 10 || countElements(phone_number.text) == 11))) {
            error_label.hidden = false
            error_label.text = "Please enter a valid phone number"
            return false
        }
        else {
            return true
        }
    }
    
    func isNumeric(a: String) -> Bool {
        if let n = a.toInt() {
            return true
        } else {
            return false
        }
    }
}
