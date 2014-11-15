//
//  EditUserController.swift
//  SustainabilityAppV1
//
//  Created by Jake Quiring on 11/3/14.
//  Copyright (c) 2014 Jake Quiring. All rights reserved.
//

import UIKit

class EditUserController: UIViewController {
    
    @IBOutlet weak var first_name: UITextField!
    @IBOutlet weak var last_name: UITextField!
    @IBOutlet weak var phone_number: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var error_label: UILabel!
    
    @IBAction func save(sender: AnyObject) {
    }
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        first_name.text = NSUserDefaults.standardUserDefaults().objectForKey("first_name") as String
        last_name.text = NSUserDefaults.standardUserDefaults().objectForKey("last_name") as String
        phone_number.text = NSUserDefaults.standardUserDefaults().objectForKey("phone") as String
        email.text = NSUserDefaults.standardUserDefaults().objectForKey("pref_email") as String
        error_label.hidden = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkFields() -> Bool {
        if(first_name.text.isEmpty || last_name.text.isEmpty) {
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
