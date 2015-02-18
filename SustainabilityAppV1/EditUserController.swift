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
            error_label.hidden = false
            error_label.text = "Please enter a first and a last name"
        }
        else if(!phone_number.text.isEmpty && (!isNumeric(phone_number.text) || !(countElements(phone_number.text) == 10 || countElements(phone_number.text) == 11))) {
            error_label.hidden = false
            error_label.text = "Please enter a valid phone number"
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
        var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 300, 300)) as UIActivityIndicatorView
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        actInd.startAnimating()
        self.navigationController?.view.addSubview(actInd)
        var username = NSUserDefaults.standardUserDefaults().objectForKey("username") as String
        var params = ["username":username, "first_name":first_name_field.text, "last_name":last_name_field.text, "pref_email":email.text, "phone":phone_number.text] as Dictionary<String, String>
        var api_requester: AgoraRequester = AgoraRequester()
        var not_ready = true
        api_requester.POST("edituser/", params: params,
            success: {parseJSON -> Void in
                dispatch_async(dispatch_get_main_queue(), {self.updateUI()})
                not_ready = false
            },
            failure: {code,message -> Void in
                if code == 500 {
                    //500: Server failure
                    not_ready = false
                    println("Server Failure!!!!!")
                }
                else if code == 400 {
                    if(message == "Enter a valid email address.") {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.error_label.text = "Please enter a valide email address"
                            self.error_label.hidden = false
                            actInd.stopAnimating()
                        })
                    }
                    
                    not_ready = false
                    
                }
                else if code == 58 {
                    not_ready = false
                    println("No Connection!!!!!")
                }
                else if code == 599 {
                    not_ready = false
                    println("Timeout!!!!!")
                }
            }
        )
        while(not_ready){
        }
    }
    func updateUI(){
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
