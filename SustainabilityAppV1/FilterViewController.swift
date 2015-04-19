//
//  FilterViewController.swift
//  SustainabilityAppV1
//
//  Created by Jake Quiring on 2/27/15.
//  Copyright (c) 2015 Jake Quiring. All rights reserved.
//

import UIKit

@objc
protocol FilterViewControllerDelegate {
    func filterSelected()
}
class FilterViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet var barLabel: UIButton!
    @IBOutlet var keywordOutlet: UITextField!
    @IBOutlet var maxpriceOutlet: UITextField!
    @IBOutlet var minpriceOutlet: UITextField!
    @IBOutlet var booksOutlet: UIButton!
    @IBOutlet var electronicsOutlet: UIButton!
    @IBOutlet var householdOutlet: UIButton!
    @IBOutlet var rideshareOutlet: UIButton!
    @IBOutlet var servicesOutlet: UIButton!
    @IBOutlet var clothingOutlet: UIButton!
    @IBOutlet var recreationOutlet: UIButton!
    @IBOutlet var eventsOutlet: UIButton!
    @IBOutlet var freeOutlet: UIButton!
    
    var categoryString = ""
    var delegate:FilterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = UIBarStyle.Default
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.633, green: 0.855, blue: 0.620, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light",size: 24)!,NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        for string in NSUserDefaults.standardUserDefaults().objectForKey("categories") as! [String] {
            categoryString = categoryString + string
        }
        setUpButtons()
        barLabel.contentEdgeInsets = UIEdgeInsetsMake(0, 0, -23, 0)
    }
    func setUpButtons(){
        if(NSUserDefaults.standardUserDefaults().objectForKey("free") as! String == "1"){
            freeOutlet.setTitle("  ✓ Free ", forState: nil)
            freeOutlet.backgroundColor = UIColor.darkGrayColor()
        }
        else{
            freeOutlet.backgroundColor = UIColor.lightGrayColor()
            freeOutlet.setTitle("  ✗ Free ", forState: nil)
        }
        if(categoryString.rangeOfString("Books") != nil) {
            booksOutlet.backgroundColor = UIColor.darkGrayColor()
            booksOutlet.setTitle("  ✓ Books ", forState: nil)
        }
        else{
            booksOutlet.backgroundColor = UIColor.lightGrayColor()
            booksOutlet.setTitle("  ✗ Books ", forState: nil)
        }
        if(categoryString.rangeOfString("Electronics") != nil) {
            electronicsOutlet.backgroundColor = UIColor.darkGrayColor()
            electronicsOutlet.setTitle("  ✓ Electronics ", forState: nil)
        }
        else{
            electronicsOutlet.backgroundColor = UIColor.lightGrayColor()
            electronicsOutlet.setTitle("  ✗ Electronics ", forState: nil)
        }
        if(categoryString.rangeOfString("Household") != nil) {
            householdOutlet.backgroundColor = UIColor.darkGrayColor()
            householdOutlet.setTitle("  ✓ Household ", forState: nil)
        }
        else{
            householdOutlet.backgroundColor = UIColor.lightGrayColor()
            householdOutlet.setTitle("  ✗ Household ", forState: nil)
        }
        if(categoryString.rangeOfString("Rideshares") != nil) {
            rideshareOutlet.backgroundColor = UIColor.darkGrayColor()
            rideshareOutlet.setTitle("  ✓ Rideshares ", forState: nil)
        }
        else{
            rideshareOutlet.backgroundColor = UIColor.lightGrayColor()
            rideshareOutlet.setTitle("  ✗ Rideshares ", forState: nil)
        }
        if(categoryString.rangeOfString("Services") != nil) {
            servicesOutlet.backgroundColor = UIColor.darkGrayColor()
            servicesOutlet.setTitle("  ✓ Services ", forState: nil)
        }
        else{
            servicesOutlet.backgroundColor = UIColor.lightGrayColor()
            servicesOutlet.setTitle("  ✗ Services ", forState: nil)
        }
        if(categoryString.rangeOfString("Recreation") != nil) {
            recreationOutlet.backgroundColor = UIColor.darkGrayColor()
            recreationOutlet.setTitle("  ✓ Recreation ", forState: nil)
        }
        else{
            recreationOutlet.backgroundColor = UIColor.lightGrayColor()
            recreationOutlet.setTitle("  ✗ Recreation ", forState: nil)
        }
        if(categoryString.rangeOfString("Events") != nil) {
            eventsOutlet.backgroundColor = UIColor.darkGrayColor()
            eventsOutlet.setTitle("  ✓ Events ", forState: nil)
        }
        else{
            eventsOutlet.backgroundColor = UIColor.lightGrayColor()
            eventsOutlet.setTitle("  ✗ Events ", forState: nil)
        }
        if(categoryString.rangeOfString("Clothing") != nil) {
            clothingOutlet.backgroundColor = UIColor.darkGrayColor()
            clothingOutlet.setTitle("  ✓ Clothing ", forState: nil)
        }
        else{
            clothingOutlet.backgroundColor = UIColor.lightGrayColor()
            clothingOutlet.setTitle("  ✗ Clothing ", forState: nil)
        }
        minpriceOutlet.text = NSUserDefaults.standardUserDefaults().objectForKey("min_price") as! String
        maxpriceOutlet.text = NSUserDefaults.standardUserDefaults().objectForKey("max_price") as! String
        keywordOutlet.text = NSUserDefaults.standardUserDefaults().objectForKey("keyword") as! String
    }
    func resignKeyboard(){
        keywordOutlet.resignFirstResponder()
        minpriceOutlet.resignFirstResponder()
        maxpriceOutlet.resignFirstResponder()
    }
    @IBAction func submitAction(sender: AnyObject) {
        var message  = validatePrice(minpriceOutlet.text, max: maxpriceOutlet.text)
        if( message == "1"){
            var categories:[AnyObject] = []
            if(booksOutlet.backgroundColor == UIColor.darkGrayColor()){
                categories.append("Books")
            }
            if(electronicsOutlet.backgroundColor == UIColor.darkGrayColor()){
                categories.append("Electronics")
            }
            if(householdOutlet.backgroundColor == UIColor.darkGrayColor()){
                categories.append("Household")
            }
            if(rideshareOutlet.backgroundColor == UIColor.darkGrayColor()){
                categories.append("Rideshares")
            }
            if(servicesOutlet.backgroundColor == UIColor.darkGrayColor()){
                categories.append("Services")
            }
            if(eventsOutlet.backgroundColor == UIColor.darkGrayColor()){
                categories.append("Events")
            }
            if(recreationOutlet.backgroundColor == UIColor.darkGrayColor()){
                categories.append("Recreation")
            }
            if(clothingOutlet.backgroundColor == UIColor.darkGrayColor()){
                categories.append("Clothing")
            }
            if(freeOutlet.backgroundColor == UIColor.darkGrayColor()){
                NSUserDefaults.standardUserDefaults().setObject("1",forKey:"free")
            }
            else{
                NSUserDefaults.standardUserDefaults().setObject("0",forKey:"free")
            }
            NSUserDefaults.standardUserDefaults().setObject(keywordOutlet.text,forKey:"keyword")
            NSUserDefaults.standardUserDefaults().setObject(maxpriceOutlet.text,forKey:"max_price")
            NSUserDefaults.standardUserDefaults().setObject(minpriceOutlet.text,forKey:"min_price")
            NSUserDefaults.standardUserDefaults().setObject(categories,forKey:"categories")
            NSUserDefaults.standardUserDefaults().setObject(true,forKey:"newFilterPerameters")
            delegate?.filterSelected()
        }
        else{
            var alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            }))
        }
    }
    @IBAction func freeAction(sender: AnyObject) {
        resignKeyboard()
        if(freeOutlet.backgroundColor == UIColor.darkGrayColor()){
            freeOutlet.backgroundColor = UIColor.lightGrayColor()
            freeOutlet.setTitle("  ✗ Free ", forState: nil)
        }
        else{
            freeOutlet.backgroundColor = UIColor.darkGrayColor()
            freeOutlet.setTitle("  ✓ Free ", forState: nil)
        }
    }
    @IBAction func eventsAction(sender: AnyObject) {
        resignKeyboard()
        if(eventsOutlet.backgroundColor == UIColor.darkGrayColor()){
            eventsOutlet.backgroundColor = UIColor.lightGrayColor()
            eventsOutlet.setTitle("  ✗ Events ", forState: nil)
        }
        else{
            eventsOutlet.backgroundColor = UIColor.darkGrayColor()
            eventsOutlet.setTitle("  ✓ Events ", forState: nil)
        }
    }
    @IBAction func recreationAction(sender: AnyObject) {
        resignKeyboard()
        if(recreationOutlet.backgroundColor == UIColor.darkGrayColor()){
            recreationOutlet.backgroundColor = UIColor.lightGrayColor()
            recreationOutlet.setTitle("  ✗ Recreation ", forState: nil)
        }
        else{
            recreationOutlet.backgroundColor = UIColor.darkGrayColor()
            recreationOutlet.setTitle("  ✓ Recreation ", forState: nil)
        }
    }
    @IBAction func clothingAction(sender: AnyObject) {
        resignKeyboard()
        if(clothingOutlet.backgroundColor == UIColor.darkGrayColor()){
            clothingOutlet.backgroundColor = UIColor.lightGrayColor()
            clothingOutlet.setTitle("  ✗ Clothing ", forState: nil)
        }
        else{
            clothingOutlet.backgroundColor = UIColor.darkGrayColor()
            clothingOutlet.setTitle("  ✓ Clothing ", forState: nil)
        }
    }
    @IBAction func householdAction(sender: AnyObject) {
        resignKeyboard()
        if(householdOutlet.backgroundColor == UIColor.darkGrayColor()){
            householdOutlet.backgroundColor = UIColor.lightGrayColor()
            householdOutlet.setTitle("  ✗ Household ", forState: nil)
        }
        else{
            householdOutlet.backgroundColor = UIColor.darkGrayColor()
            householdOutlet.setTitle("  ✓ Household ", forState: nil)
        }
    }
    @IBAction func servicesAction(sender: AnyObject) {
        resignKeyboard()
        if(servicesOutlet.backgroundColor == UIColor.darkGrayColor()){
            servicesOutlet.backgroundColor = UIColor.lightGrayColor()
            servicesOutlet.setTitle("  ✗ Services ", forState: nil)
        }
        else{
            servicesOutlet.backgroundColor = UIColor.darkGrayColor()
            servicesOutlet.setTitle("  ✓ Services ", forState: nil)
        }
    }
    @IBAction func rideshareAction(sender: AnyObject) {
        resignKeyboard()
        if(rideshareOutlet.backgroundColor == UIColor.darkGrayColor()){
            rideshareOutlet.backgroundColor = UIColor.lightGrayColor()
            rideshareOutlet.setTitle("  ✗ Rideshares ", forState: nil)
        }
        else{
            rideshareOutlet.backgroundColor = UIColor.darkGrayColor()
            rideshareOutlet.setTitle("  ✓ Rideshares ", forState: nil)
        }
    }
    @IBAction func ElectronicsAction(sender: AnyObject) {
        resignKeyboard()
        if(electronicsOutlet.backgroundColor == UIColor.darkGrayColor()){
            electronicsOutlet.backgroundColor = UIColor.lightGrayColor()
            electronicsOutlet.setTitle("  ✗ Electronics ", forState: nil)
        }
        else{
            electronicsOutlet.backgroundColor = UIColor.darkGrayColor()
            electronicsOutlet.setTitle("  ✓ Electronics ", forState: nil)
        }
    }
    @IBAction func BooksAction(sender: AnyObject) {
        resignKeyboard()
        if(booksOutlet.backgroundColor == UIColor.darkGrayColor()){
            booksOutlet.backgroundColor = UIColor.lightGrayColor()
            booksOutlet.setTitle("  ✗ Books ", forState: nil)
        }
        else{
            booksOutlet.backgroundColor = UIColor.darkGrayColor()
            booksOutlet.setTitle("  ✓ Books ", forState: nil)
        }
    }
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func isNumeric(a: String) -> Bool {
        if let n = a.toDouble() {
            return true
        } else {
            return false
        }
    }
    func validatePrice(min:String,max:String) -> String{
        if(min == "" && max == ""){
            return "1"
        }
        if(!isNumeric(min) && min != ""){
            return "Please enter a valid minimum price"
        }
        if(!isNumeric(max) && max != ""){
            return "Please enter a valid maximum price"
        }
        if(min != "" && max != "" && min.toDouble() >= max.toDouble()){
            return "Please enter a minimum price lower than maximum"
        }
        return "1"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func touchesBegan(touches: Set<NSObject>,
        withEvent event: UIEvent) {
        resignKeyboard()
    }
}
