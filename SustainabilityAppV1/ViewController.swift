//
//  ViewController.swift
//  SustainabilityAppV1
//
//  Created by Jake Quiring on 10/20/14.
//  Copyright (c) 2014 Jake Quiring. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController,UITextFieldDelegate {

    //LDAP Variables
    let LDAPIP = "147.222.165.133:8000"
    
    
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var incorrectLoginLabel: UILabel!
    
    @IBAction func login(sender: AnyObject) {
        //if ldap confirmed && user in DB login 
        //if ladap confirmed -- new user
        //set the incorrectLoginLabel.hidden = false if the login has failed
        
        var VC1 = self.storyboard?.instantiateViewControllerWithIdentifier("newUser") as NewUserController
        let navController = UINavigationController(rootViewController: VC1)
        // Creating a navigation controller with VC1 at the root of the navigation stack.
        self.presentViewController(navController, animated:true, completion: nil)
        LDAPLogin()
        
    }
    
    func LDAPLogin(){
        var request = NSMutableURLRequest(URL: NSURL(string: "http://147.222.165.121:8000/ldapauth/")!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        var params = ["username":email.text, "password":password.text] as Dictionary<String, String>
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                var status_code = httpResponse.statusCode
                //200 = OK, valid credentials
                if(status_code == 200){
                    println("Valid credentials! Carry on to main page...")
                }
                    //400 = BAD_REQUEST, invalid crentials
                else if(status_code == 400){
                    println("Invalid credentials, you are not allowed in!")
                }
                    //500 = INTERNAL_SERVER_ERROR. Oh snap *_*
                else if(status_code == 500){
                    println("The server is down! Call the fire!")
                }
            } else {
                println("Error in casting response, data incomplete")
            }
        })
        task.resume()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        email!.delegate = self
        password!.delegate = self
        incorrectLoginLabel.hidden = true

        // Do any additional setup after loading the view, typically from a nib.
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        //do we need both?
        password.resignFirstResponder()
        email.resignFirstResponder()
        
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

