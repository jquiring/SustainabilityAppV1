//
//  ViewController.swift
//  SustainabilityAppV1
//
//  Created by Jake Quiring on 10/20/14.
//  Copyright (c) 2014 Jake Quiring. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

  
    @IBOutlet weak var email: UITextField!

    @IBOutlet weak var password: UITextField!
   

    
    @IBAction func login(sender: AnyObject) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        email!.delegate = self
        password!.delegate = self

    
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // comment in did recieve
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        if(email .isFirstResponder()){
            email.resignFirstResponder()
            password.becomeFirstResponder()
        }
        else if(password.isFirstResponder()){
            password.resignFirstResponder()
        }
        return true
    }



}

