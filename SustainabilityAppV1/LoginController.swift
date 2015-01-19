//
//  LoginController.swift
//  SustainabilityAppV1
//
//  Created by Jake Quiring on 10/20/14.
//  Copyright (c) 2014 Jake Quiring. All rights reserved.
//

import UIKit
import Foundation

class LoginController: UIViewController,UITextFieldDelegate {

    //LDAP Variables
    let LDAPIP = "147.222.164.91:8000/ldapauth/"
    var flag = false
    //Made a change
    var window: UIWindow?
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var incorrectLoginLabel: UILabel!
    
    @IBAction func login(sender: AnyObject) {
        //if ldap confirmed && user in DB login 
        //if ladap confirmed -- new user
        //set the incorrectLoginLabel.hidden = false if the login has failed
        var LDAPRequest = LDAPLogin()
        password.resignFirstResponder()
        email.resignFirstResponder()

        if(LDAPRequest.0 == 200){
            print(LDAPRequest.1)
           if(LDAPRequest.1 == "yes"){
                self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
                self.window!.backgroundColor = UIColor.whiteColor()
                let customVC = ContainerViewController()
                self.window!.rootViewController = customVC
                self.window!.makeKeyAndVisible()
            }
            //else if (true){
            else if(LDAPRequest.1 == "no"){
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
            incorrectLoginLabel.text = "Server Error2: Please try again later"
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
    func LDAPLogin() -> (Int,String) {
        var request = NSMutableURLRequest(URL: NSURL(string: "http://147.222.164.91:8000/ldapauth/")!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        var username = ""
        var first_name = ""
        var last_name = ""
        var g_email = ""
        var p_email = ""
        var phone = ""
        var existingUser = ""
        var params = ["username":email.text, "password":password.text] as Dictionary<String, String>
        var err: NSError?
        var returnVal = -1
        var flag_Val = false
        flag = false
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
                            if let _username = parseJSON["username"] as? String{
                                username = _username
                            }
                            if let first = parseJSON["first_name"] as? String{
                                first_name = first
                            }
                            if let last = parseJSON["last_name"] as? String{
                                last_name = last
                            }
                            if let _g_email = parseJSON["g_email"] as? String{
                                g_email = _g_email
                            }
                            if let _p_email = parseJSON["p_email"] as? String{
                                p_email = _p_email
                            }
                            if let _phone = parseJSON["phone"] as? String{
                                phone = _phone
                            }
                            if let _exists = parseJSON["exists"] as? String{
                                existingUser = _exists
                            }
                            println("Valid credentials! Carry on to main page...")
                            returnVal = 200
                            if let posts: AnyObject = parseJSON["posts"]{
                                
                                //iterate through each post
                                for i in 0...(posts.count - 1){
                                    let post: AnyObject! = posts[i] //just so we don't keep re-resolving this reference
                                    
                                    //get the easy ones, title, display_value and post ID
                                    let title = post["title"] as String
                                    let postID = post["id"]! as Int
                                    let category = post["category"] as String 
                                    
                                    //read imageString, base64 encoded
                                    let imageString = post["image"]! as String
                                    
                                    //make sure there is an image...
                                    var new_post:ProfilePost
                                    if !imageString.isEmpty {
                                        let imageData = NSData(base64EncodedString: imageString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
                                         new_post = ProfilePost(title: title, imageName: imageData, id: String(postID))
                                        //THIS IS WHERE IMAGES ARE HANDLED, if there are any...
                                    }
                                   
                                        //no image included...
                                    else{
                                        new_post = ProfilePost(title: title, id: String(postID))
                                        //NO IMAGE WITH POST
                                    }
                                    new_post.upDateNSData()
                                }
                            }

                            NSUserDefaults.standardUserDefaults().setObject(username, forKey: "username")
                            NSUserDefaults.standardUserDefaults().setObject(first_name, forKey: "first_name")
                            NSUserDefaults.standardUserDefaults().setObject(last_name, forKey: "last_name")
                            NSUserDefaults.standardUserDefaults().setObject(g_email, forKey: "gonzaga_email")
                            NSUserDefaults.standardUserDefaults().setObject(p_email, forKey: "pref_email")
                            NSUserDefaults.standardUserDefaults().setObject(phone, forKey: "phone")
                            flag_Val = true
                        }
                            //400 = BAD_REQUEST, invalid crentials
                        else if(status_code == 400){
                            if let message = parseJSON["message"] as? String{
                                println("message: \(message)")
                            }
                            returnVal = 400
                            flag_Val = true
                        }
                            //500 = INTERNAL_SERVER_ERROR. Oh snap *_*
                        else if(status_code == 500){
                            println("The server is down! Call the fire!")
                            returnVal = 500
                            flag_Val = true
                        }
                    }
                    else {
                        // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                        let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                        println("Error could not parse JSON: \(jsonStr)")
                        flag_Val = true
                    }
                }
            }
        })
        task.resume()
        while(flag == false){
            flag = flag_Val
        }
        return (returnVal, existingUser)
        
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

