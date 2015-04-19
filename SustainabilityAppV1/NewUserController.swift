//
//  NewUserController.swift
//  SustainabilityAppV1
//
//  Created by Jake Quiring on 10/27/14.
//  Copyright (c) 2014 Jake Quiring. All rights reserved.
//

import UIKit

class NewUserController: UIViewController,UITextFieldDelegate {
    @IBOutlet var submitButton: UIButton!
    @IBOutlet weak var first: UITextField!
    @IBOutlet var warningLabel: UILabel!
    @IBOutlet weak var last: UITextField!
    @IBOutlet weak var number: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var TaA: UILabel!
    @IBOutlet weak var terms: UIButton!
    
    var window: UIWindow?
    var flag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        first!.delegate = self
        last!.delegate = self
        number!.delegate = self
        email!.delegate = self
        self.warningLabel.hidden = true
        let gestureRecogniser3 = UITapGestureRecognizer(target: self, action: Selector("TaATouched"))
        self.TaA.addGestureRecognizer(gestureRecogniser3)
        TaA.userInteractionEnabled = true
        navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
        navigationController?.navigationBar.barStyle = UIBarStyle.Default
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light",size: 24)!,NSForegroundColorAttributeName: UIColor.darkGrayColor()]
    }
    override func viewWillDisappear(animated: Bool) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func updateUI(){
        self.resignKeyboard()
        NSUserDefaults.standardUserDefaults().setObject(self.first.text, forKey: "first_name")
        NSUserDefaults.standardUserDefaults().setObject(self.last.text, forKey: "last_name")
        NSUserDefaults.standardUserDefaults().setObject(self.email.text, forKey: "pref_email")
        NSUserDefaults.standardUserDefaults().setObject(self.number.text, forKey: "phone")
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.backgroundColor = UIColor.whiteColor()
        let customVC = ContainerViewController()
        self.window!.rootViewController = customVC
        self.window!.makeKeyAndVisible()
    }
    func checkFields() -> Bool {
        if(TaA.text == "☐" ) {
            self.warningLabel.hidden = false
            self.warningLabel.text = "Please agree to the terms and agreements"
            return false
        }
        else if(first.text.isEmpty || last.text.isEmpty) {
            self.warningLabel.hidden = false
            self.warningLabel.text = "Please enter a first and last name"
            return false
        }
        else if(!number.text.isEmpty && (!isNumeric(number.text) || !(count(number.text) == 10 || count(number.text) == 11))) {
            self.warningLabel.hidden = false
            self.warningLabel.text = "Please enter a valid phone number"
            return false
        }
        else {
            return true
        }
    }
    func isNumeric(a: String) -> Bool {
        if let n = a.toDouble() {
            if(a.rangeOfString(".") != nil){
                return false
            }
            else{
                return true
            }
        } else {
            return false
        }
    }
    func formattedPhoneNumber(length:NSInteger,text:NSString) -> NSString {
        switch(length) {
        case 3: return NSString(format:"(%@)",text)
        default: return "yes"
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(first.isFirstResponder()){
            first.resignFirstResponder()
            last.becomeFirstResponder()
        }
        else if(last.isFirstResponder()){
            last.resignFirstResponder()
            number.becomeFirstResponder()
        }
        else if(number.isFirstResponder()){
            number.resignFirstResponder()
            email.becomeFirstResponder()
        }
        else if(email.isFirstResponder()){
            email.resignFirstResponder()
        }
        return true
    }
    func resignKeyboard(){
        first.resignFirstResponder()
        last.resignFirstResponder()
        number.resignFirstResponder()
        email.resignFirstResponder()
    }
    func toggleTaAStatus(){
        let unchecked = "☐"
        let checked = "☑"
        if(TaA.text == checked){
            TaA.text = unchecked
        }
        else{
            TaA.text = checked
        }
    }
    func TaATouched(){
        println("TOA touched")
        toggleTaAStatus()
    }
    @IBAction func submit(sender: AnyObject) {
        if(checkFields()) {
            submitData()
        }
    }
    @IBAction func terms(sender: AnyObject) {
        var VC1 = self.storyboard?.instantiateViewControllerWithIdentifier("termsConditions") as! TermsAndConditionsConroller
        let navController = UINavigationController(rootViewController: VC1)
        self.presentViewController(navController, animated:true, completion: nil)
    }
    @IBAction func formattingNumber(sender: AnyObject) {
        var length = count(number.text)
    }
    func submitData(){
        self.view.userInteractionEnabled = false
        var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.navigationController?.view.addSubview(actInd)
        submitButton.enabled = false
        actInd.startAnimating()
        var username = NSUserDefaults.standardUserDefaults().objectForKey("username") as! String
        var g_email = NSUserDefaults.standardUserDefaults().objectForKey("gonzaga_email") as! String
        var params = ["username":username, "first_name":first.text, "last_name":last.text, "gonzaga_email":g_email, "pref_email":email.text, "phone":number.text] as Dictionary<String, String>
        var api_requester: AgoraRequester = AgoraRequester()
        api_requester.POST("createuser/", params: params,
            success: {parseJSON -> Void in
                dispatch_async(dispatch_get_main_queue(), {self.updateUI()
                    actInd.stopAnimating()
                })
            },
            failure: {code,message -> Void in
                self.submitButton.enabled = true
                if code == 400 {
                    dispatch_async(dispatch_get_main_queue(), {self.updateUI()
                        actInd.stopAnimating()
                        self.warningLabel.hidden = true
                        self.warningLabel.text = "Please Enter a valid Email address"
                        self.view.userInteractionEnabled = true
                    })
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), {self.updateUI()
                        actInd.stopAnimating()
                        self.warningLabel.hidden = false
                        self.view.userInteractionEnabled = true
                        self.warningLabel.text = "Connection error, check signal and try again"

                    })
                }
            }
        )
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func touchesBegan(touches: Set<NSObject>,
        withEvent event: UIEvent) {
        resignKeyboard()
    }
}
