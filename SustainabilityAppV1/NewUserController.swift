//
//  NewUserController.swift
//  SustainabilityAppV1
//
//  Created by Jake Quiring on 10/27/14.
//  Copyright (c) 2014 Jake Quiring. All rights reserved.
//

import UIKit

class NewUserController: UIViewController,UITextFieldDelegate {

    var flag = false
    @IBOutlet weak var first: UITextField!
    @IBOutlet weak var last: UITextField!
    @IBOutlet weak var number: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var TaA: UILabel!
    @IBAction func terms(sender: AnyObject) {
        var VC1 = self.storyboard?.instantiateViewControllerWithIdentifier("termsConditions") as TermsAndConditionsConroller
        let navController = UINavigationController(rootViewController: VC1)
        // Creating a navigation controller with VC1 at the root of the navigation stack.
        self.presentViewController(navController, animated:true, completion: nil)
    }
    var window: UIWindow?
    @IBAction func submit(sender: AnyObject) {
        if(checkFields()) {
            submitData()
        }
    }
    func updateUI(){
        resignKeyboard()
        NSUserDefaults.standardUserDefaults().setObject(first.text, forKey: "first_name")
        NSUserDefaults.standardUserDefaults().setObject(last.text, forKey: "last_name")
        NSUserDefaults.standardUserDefaults().setObject(email.text, forKey: "pref_email")
        NSUserDefaults.standardUserDefaults().setObject(number.text, forKey: "phone")
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.backgroundColor = UIColor.whiteColor()
        let customVC = ContainerViewController()
        self.window!.rootViewController = customVC
        self.window!.makeKeyAndVisible()
    }
    @IBOutlet weak var terms: UIButton!
    func checkFields() -> Bool {
        if(TaA.text == "☐" ) {
            var alert = UIAlertController(title: "Warning", message: "Please read and agree to the Terms and Conditions for Zig Zag", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            }))
            return false
        }
        else if(first.text.isEmpty || last.text.isEmpty) {
            var alert = UIAlertController(title: "Warning", message: "Please include a last and first name", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            }))
            return false
        }
        else if(!number.text.isEmpty && (!isNumeric(number.text) || !(countElements(number.text) == 10 || countElements(number.text) == 11))) {
            var alert = UIAlertController(title: "Warning", message: "Please enter a valid Phone number of all numbers", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            }))
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
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        first!.delegate = self
        last!.delegate = self
        number!.delegate = self
        email!.delegate = self

        // Do any additional setup after loading the view.
    }
    
    func submitData(){
        var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.navigationController?.view.addSubview(actInd)
        actInd.startAnimating()
        var username = NSUserDefaults.standardUserDefaults().objectForKey("username") as String
        var g_email = NSUserDefaults.standardUserDefaults().objectForKey("gonzaga_email") as String
        var params = ["username":username, "first_name":first.text, "last_name":last.text, "gonzaga_email":g_email, "pref_email":email.text, "phone":number.text] as Dictionary<String, String>
        var api_requester: AgoraRequester = AgoraRequester()
        var not_ready = true
        api_requester.POST("createuser/", params: params,
            success: {parseJSON -> Void in
                dispatch_async(dispatch_get_main_queue(), {self.updateUI()
                    actInd.stopAnimating()
                })
                not_ready = false
            },
            failure: {code,message -> Void in
                if code == 500 {
                    not_ready = false
                    println("Server Failure!!!!!")
                }
                else if code == 400 {
                    print(message)
                    if(message == "Enter a valid email address.") {
                            dispatch_async(dispatch_get_main_queue(), {
                            var alert = UIAlertController(title: "Warning", message: "Please Enter a valid Email address", preferredStyle: UIAlertControllerStyle.Alert)
                            self.presentViewController(alert, animated: true, completion: nil)
                            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                        }))
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

    @IBAction func formattingNumber(sender: AnyObject) {
         var length = countElements(number.text)
       
    }

    func formattedPhoneNumber(length:NSInteger,text:NSString) -> NSString {
        switch(length) {
        case 3: return NSString(format:"(%@)",text)
            //case 6: return NSString(format: "%@ - %@",text.substringWithRange(NSRange(location:0,length:5)),text[-1])
            
        default: return "yes"
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
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
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        //do we need both?
        resignKeyboard()
        var touch = touches.anyObject()?.locationInView(self.view)
        if(CGRectContainsPoint(TaA.frame, touch!)){
            toggleTaAStatus()
        }
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
