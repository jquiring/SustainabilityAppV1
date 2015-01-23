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
            var submitRequest = submitData()
            if(submitRequest == 200){
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
            else if(submitRequest == 400){
                //email error
            }
            else if(submitRequest == 500){
                //server is down
            }
            else{
                //death
            }
        }
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
    
    func submitData() -> Int{
        var request = NSMutableURLRequest(URL: NSURL(string: "http://147.222.165.3:8000/createuser/")!)
        request.HTTPMethod = "POST"
        var session = NSURLSession.sharedSession()
        var flag_Val = false
        var return_Val = -1
        
        var username = NSUserDefaults.standardUserDefaults().objectForKey("username") as String
        var g_email = NSUserDefaults.standardUserDefaults().objectForKey("gonzaga_email") as String
        var first_name = first.text
        var last_name = last.text
        var p_email = email.text
        var phone = number.text
        
        var params = ["username":username, "first_name":first_name, "last_name":last_name, "gonzaga_email":g_email, "pref_email":p_email, "phone":phone] as Dictionary<String, String>
        
        //Load body with JSON serialized parameters, set headers for JSON! (Star trek?)
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            //read the message from the response
            var message = ""
            var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &err) as? NSDictionary
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
            }
            else{
                if let parseJSON = json as? Dictionary<String,AnyObject>{
                    message = parseJSON["message"] as String
                }
            }
            
            //downcast NSURLResponse object to NSHTTPURLResponse
            if let httpResponse = response as? NSHTTPURLResponse {
                
                //get the status code
                var status_code = httpResponse.statusCode
                
                //200 = OK: user created, carry on!
                if(status_code == 200){
                    println(message)
                    return_Val = 200
                    flag_Val = true
                }
                    //400 = BAD_REQUEST: error in creating user, display error!
                else if(status_code == 400){
                    println(message)
                    if(message == "Enter a valid email address.") {
                        var alert = UIAlertController(title: "Warning", message: "Please read and agree to the Terms and Conditions for Zig Zag", preferredStyle: UIAlertControllerStyle.Alert)
                        self.presentViewController(alert, animated: true, completion: nil)
                        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                        }))
                    }
                    return_Val = 400
                    flag_Val = true
                }
                    //500 = INTERNAL_SERVER_ERROR. Oh snap *_*
                else if(status_code == 500){
                    println("The server is down! Call the fire department!")
                    return_Val = 500
                    flag_Val = true
                }
            } else {
                println("Error in casting response, data incomplete")
            }
        })
        task.resume()
        while(flag == false){
            flag = flag_Val
        }
        return return_Val
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
