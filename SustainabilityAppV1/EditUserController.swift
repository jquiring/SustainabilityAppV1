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
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
