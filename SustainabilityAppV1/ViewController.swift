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
        var LDAPRequest = LDAPLogin()
        
        if(LDAPRequest.0 == 200){
            if(LDAPRequest.2 == "Yes"){
                var VC1 = self.storyboard?.instantiateViewControllerWithIdentifier("CenterViewController") as CenterViewController
                let navController = UINavigationController(rootViewController: VC1)
                self.presentViewController(navController, animated:true, completion: nil)
            }
            else if(LDAPRequest.2 == "No"){
                //need to pass email in to create user page to send to DB ***************************************************
                var VC1 = self.storyboard?.instantiateViewControllerWithIdentifier("newUser") as NewUserController
                let navController = UINavigationController(rootViewController: VC1)
                self.presentViewController(navController, animated:true, completion: nil)
            }
            else{
                incorrectLoginLabel.hidden = false
                incorrectLoginLabel.text = "Server Error: Please try again later"
            }
        }
        else if(LDAPRequest.0 == 400){
            incorrectLoginLabel.hidden = false
        }
        else if(LDAPRequest.0 == 500){
            incorrectLoginLabel.hidden = false
            incorrectLoginLabel.text = "Server Error: Please try again later"
        }
        else{
            incorrectLoginLabel.hidden = false
            incorrectLoginLabel.text = "Server Error: Server IP + Port has changed"
        }
    }
    func makeAlert(text:String){
    var alert = UIAlertController(title: nil, message: text, preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            }))

    }
    func LDAPLogin() -> (Int,String,String) {
        var request = NSMutableURLRequest(URL: NSURL(string: "http://147.222.165.133:2000/ldapauth/")!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        var infEmail = ""
        var existingUser = ""
        var params = ["username":email.text, "password":password.text] as Dictionary<String, String>
        var err: NSError?
        var returnVal = -1
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                var status_code = httpResponse.statusCode
                var jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &err) as? NSDictionary
                
                if(err != nil) {
                    println(err!.localizedDescription)
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: '\(jsonStr)'")
                }
                    
                else {
                    if let parseJSON = json as? Dictionary<String,AnyObject>{
                        // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                        //200 = OK, valid credentials
                        if(status_code == 200){
                            if let email = parseJSON["email"] as? String{
                                println("email: \(email)")
                                infEmail = email
                            }
                            //prints yes/no if user is in DB
                            if let exists = parseJSON["exists"] as? String{
                                println("exists: \(exists)")
                                existingUser = exists
                            }
                            if let message = parseJSON["message"] as? String{
                                println("message: \(message)")
                            }
                            println("Valid credentials! Carry on to main page...")
                            returnVal = 200
                            // The JSONObjectWithData constructor didn't return an error. But, we should still
                            // check and make sure that json has a value using optional binding.
                        }
                            //400 = BAD_REQUEST, invalid crentials
                        else if(status_code == 400){
                            if let message = parseJSON["message"] as? String{
                                println("message: \(message)")
                            }
                            returnVal = 400
                        }
                            //500 = INTERNAL_SERVER_ERROR. Oh snap *_*
                        else if(status_code == 500){
                            println("The server is down! Call the fire!")
                            returnVal = 500
                        }
                    }
                    else {
                        // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                        let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                        println("Error could not parse JSON: \(jsonStr)")
                    }
                }
            }
        })

        /*
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                var status_code = httpResponse.statusCode
                //200 = OK, valid credentials
                if(status_code == 200){
                    println("Valid credentials! Carry on to main page...")
                    returnVal = 200
                    
                    
                }
                    //400 = BAD_REQUEST, invalid crentials
                else if(status_code == 400){
                    println("Invalid credentials, you are not allowed in!")
                    returnVal = 400
                }
                    //500 = INTERNAL_SERVER_ERROR. Oh snap *_*
                else if(status_code == 500){
                    println("The server is down! Call the fire!")
                    returnVal = 500
                }
            } else {
                println("Error in casting response, data incomplete")
                returnVal = -1
            }
        })
*/
        task.resume()
        sleep(1)
        
        return (returnVal , infEmail , existingUser)
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

