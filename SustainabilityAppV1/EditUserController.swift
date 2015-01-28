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
        if(first_name_field.text == "" || last_name_field.text == ""){
            error_label.text = "Please enter a first and a last name"
        }
        else if(!phone_number.text.isEmpty && (!isNumeric(phone_number.text) || !(countElements(phone_number.text) == 10 || countElements(phone_number.text) == 11))) {
            error_label.text = "Please enter a valide phone number"
        }
        else if(false){
        }
        else {
            updateUserRequest()
        }
    }
    /*
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex)?.evaluateWithObject(candidate)
    }
*/
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        first_name_field.text = NSUserDefaults.standardUserDefaults().objectForKey("first_name") as String
        last_name_field.text = NSUserDefaults.standardUserDefaults().objectForKey("last_name") as String
        if(NSUserDefaults.standardUserDefaults().objectForKey("phone") != nil) {
            phone_number.text = NSUserDefaults.standardUserDefaults().objectForKey("phone") as String
        }
        if(NSUserDefaults.standardUserDefaults().objectForKey("pref_email") != nil) {
            email.text = NSUserDefaults.standardUserDefaults().objectForKey("pref_email") as String
        }
        error_label.hidden = true

    }
    func updateUserRequest() {
        var flag_Val = false
        var return_Val = -1
        var request = NSMutableURLRequest(URL: NSURL(string: "http://147.222.165.3:8000/edituser/")!)
        
        request.HTTPMethod = "PUT"
        
        var session = NSURLSession.sharedSession()
        
        //parameter values cahnge these
        var username = NSUserDefaults.standardUserDefaults().objectForKey("username") as String
        var first_name = first_name_field.text
        var last_name = last_name_field.text
        var p_email = email.text            //editable field
        var phone = phone_number.text       //editable field
        
        var params = ["username":username, "first_name":first_name, "last_name":last_name, "pref_email":p_email, "phone":phone] as Dictionary<String, String>
        
        //Load body with JSON serialized parameters, set headers for JSON! (Star trek?)
        var err: NSError?
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
            //downcast NSURLResponse object to NSHTTPURLResponse
            if let httpResponse = response as? NSHTTPURLResponse {
                //get the status code
                var status_code = httpResponse.statusCode
                
                //200 = OK: user created, carry on!
                if(status_code == 200){
                    
                    println(message)
                    return_Val = 200
                    flag_Val = true
                }
                    //400 = BAD_REQUEST: error in creating user, display error!
                else if(status_code == 400){
                    println(message)
                    if(message == "Invalid email"){
                        self.error_label.text = "Please enter a valide email address"
                        self.error_label.hidden = false
                    }
                    return_Val = 400
                    flag_Val = true
                }
                    //500 = INTERNAL_SERVER_ERROR. Oh snap *_*
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
            NSUserDefaults.standardUserDefaults().setObject(first_name_field.text, forKey: "first_name")
            NSUserDefaults.standardUserDefaults().setObject(last_name_field.text, forKey: "last_name")
            if(email.text != "") {
                
                NSUserDefaults.standardUserDefaults().setObject(email.text, forKey: "pref_email")
            }
            else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "pref_email")
                
            }
            if(phone_number.text != "") {
                NSUserDefaults.standardUserDefaults().setObject(phone_number.text, forKey: "phone")
            }
            else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "phone")
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkFields() -> Bool {
        if(first_name_field.text.isEmpty || last_name_field.text.isEmpty) {
            //var alert = UIAlertController(title: "Warning", message: "Please include a last and first name", preferredStyle: UIAlertControllerStyle.Alert)
            //self.presentViewController(alert, animated: true, completion: nil)
            //alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in }))
            error_label.hidden = false
            error_label.text = "Please enter a valid phone number"
            return false
        }
        else if(!phone_number.text.isEmpty && (!isNumeric(phone_number.text) || !(countElements(phone_number.text) == 10 || countElements(phone_number.text) == 11))) {
            //var alert = UIAlertController(title: "Warning", message: "Please enter a valid Phone number of all numbers", preferredStyle: UIAlertControllerStyle.Alert)
            //self.presentViewController(alert, animated: true, completion: nil)
            //alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in }))
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
