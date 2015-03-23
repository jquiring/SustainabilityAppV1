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
    var flag = false
    //Made a change
    var window: UIWindow?
    @IBOutlet var loginOutlet: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var incorrectLoginLabel: UILabel!
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 25, 25)) as UIActivityIndicatorView
    @IBAction func login(sender: AnyObject) {
        self.actInd.startAnimating()
        println("should be animating")
        //self.view.userInteractionEnabled = false
        loginOutlet.enabled = false
        password.resignFirstResponder()
        email.resignFirstResponder()
        LDAPLogin()
    }
    func updateUI(parseJSON:Dictionary<String,AnyObject>){
        self.actInd.stopAnimating()
        if let _username = parseJSON["username"] as? String{
            NSUserDefaults.standardUserDefaults().setObject(_username, forKey: "username")
        }
        if let first = parseJSON["first_name"] as? String{
            NSUserDefaults.standardUserDefaults().setObject(first, forKey: "first_name")
        }
        if let last = parseJSON["last_name"] as? String{
            NSUserDefaults.standardUserDefaults().setObject(last, forKey: "last_name")
        }
        if let _g_email = parseJSON["g_email"] as? String{
            NSUserDefaults.standardUserDefaults().setObject(_g_email, forKey: "gonzaga_email")
        }
        if let _p_email = parseJSON["p_email"] as? String{
            if(_p_email != ""){
                NSUserDefaults.standardUserDefaults().setObject(parseJSON["p_email"] as? String, forKey: "pref_email")
            }
        }
        if let _phone = parseJSON["phone"] as? String{
            if( _phone) != "" {
                NSUserDefaults.standardUserDefaults().setObject(parseJSON["phone"] as? String, forKey: "phone")
            }
        }
        //TODO:should we set any of these differently in the newuser controller?
        NSUserDefaults.standardUserDefaults().setObject(true,forKey:"newFilterPerameters")
        NSUserDefaults.standardUserDefaults().setObject(true, forKey: "moreUserPosts")
        NSUserDefaults.standardUserDefaults().setObject(true, forKey: "profileNeedsReloading")
        NSUserDefaults.standardUserDefaults().setObject("0",forKey:"free")
        NSUserDefaults.standardUserDefaults().setObject("",forKey:"min_price")
        NSUserDefaults.standardUserDefaults().setObject("",forKey:"max_price")
        NSUserDefaults.standardUserDefaults().setObject("",forKey:"keyword")
    NSUserDefaults.standardUserDefaults().setObject(["Books","Electronics","Household","Rideshares" ,"Services" ,"Events","Recreation","Clothing"],forKey:"categories")
        if(parseJSON["exists"] as String == "yes"){
            
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            self.window!.backgroundColor = UIColor.whiteColor()
            let customVC = ContainerViewController()
            self.window!.rootViewController = customVC
            self.window!.makeKeyAndVisible()
        }
        else{
            //need to pass email in to create user page to send to DB ***************************************************
            var VC1 = self.storyboard?.instantiateViewControllerWithIdentifier("newUser") as NewUserController
            let navController = UINavigationController(rootViewController: VC1)
            self.presentViewController(navController, animated:true, completion: nil)
        }
    
    }
    func LDAPLogin(){
        var api_requester: AgoraRequester = AgoraRequester()
        api_requester.LdapAuth(email.text, password: password.text,
            success: { parseJSON -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    self.updateUI(parseJSON)})
            },
            failure: {code,message -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    self.incorrectLoginLabel.hidden = false
                    self.incorrectLoginLabel.text = "Connection error, check signal and try again"
                    self.password.text = ""
                    self.loginOutlet.enabled = true
                    self.actInd.stopAnimating()
                    self.view.userInteractionEnabled = true
                })
            },
            badCreds: { () -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    self.incorrectLoginLabel.hidden = false
                    self.incorrectLoginLabel.text = "Incorrect username or password"
                    self.password.text = ""
                    self.loginOutlet.enabled = true
                    self.view.userInteractionEnabled = true

                    self.actInd.stopAnimating()
                })
            })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        email!.delegate = self
        password!.delegate = self
        incorrectLoginLabel.hidden = true
        
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.navigationController?.view.addSubview(actInd)
        println("view did load")
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

