//
//  NewUserController.swift
//  SustainabilityAppV1
//
//  Created by Jake Quiring on 10/27/14.
//  Copyright (c) 2014 Jake Quiring. All rights reserved.
//

import UIKit

class NewUserController: UIViewController,UITextFieldDelegate {


    @IBOutlet weak var first: UITextField!
    
    @IBOutlet weak var last: UITextField!
    @IBOutlet weak var number: UITextField!
    @IBOutlet weak var email: UITextField!
    
    
    @IBAction func submit(sender: AnyObject) {
        var alert = UIAlertController(title: "Alert", message: "Please verifty your information is correct before submitting", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            var vc = self.storyboard?.instantiateViewControllerWithIdentifier("mainPage") as MainPageController
            self.presentViewController(vc, animated: true, completion: nil)
        }))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        first!.delegate = self
        last!.delegate = self
        number!.delegate = self
        email!.delegate = self

        // Do any additional setup after loading the view.
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
        first.resignFirstResponder()
        last.resignFirstResponder()
        number.resignFirstResponder()
        email.resignFirstResponder()

        
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
