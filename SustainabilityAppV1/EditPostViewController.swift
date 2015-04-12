//
//  EditPostViewController.swift
//  SustainabilityAppV1
//
//  Created by Lucas Orlita on 1/30/15.
//  Copyright (c) 2015 Jake Quiring. All rights reserved.
//

import UIKit
import Foundation

class EditPostViewController: UITableViewController,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate, UITextFieldDelegate,UITextViewDelegate {
    
    @IBOutlet var image3Load: UIActivityIndicatorView!
    @IBOutlet var image2Load: UIActivityIndicatorView!
    @IBOutlet var image1Load: UIActivityIndicatorView!
    
    var orientation: UIImageOrientation = .Up
    var currentImage:UIImageView = UIImageView()
    var popover:UIPopoverController?=nil
    //Further Details Text Fields
    var currentText:UITextField = UITextField()
    var parseJSON:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
    @IBOutlet var descOutlet: UITextView!
    var category = ""
    
    @IBOutlet var editOutlet: UIBarButtonItem!
    @IBOutlet var title_field: UITextField!
    var picker:UIImagePickerController?=UIImagePickerController()
    weak var cat_picker: UIPickerView!
    //3 images for taking pics
    
    @IBOutlet var image1: UIImageView!
    @IBOutlet var image2: UIImageView!
    @IBOutlet var image3: UIImageView!
    
    @IBOutlet var round_trip_switch: UISwitch!
    var round_trip_flag = false
    
    @IBOutlet var from: UITextField!
    @IBOutlet var price: UITextField!
    //Ride Share
    
    @IBOutlet var to: UITextField!
    
    @IBOutlet var leaves: UITextField!
    @IBOutlet var comesBack: UITextField!
    
    //Textbooks
    @IBOutlet var ISBN: UITextField!
    
    //Events
    @IBOutlet var location: UITextField!
    
    @IBOutlet var date: UITextField!
    let date_picker:UIDatePicker = UIDatePicker()
    //contact options images
    
    @IBOutlet var text: UIImageView!
    @IBOutlet var pEmail: UIImageView!
    @IBOutlet var gmail: UIImageView!
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 25, 25)) as UIActivityIndicatorView
    
    
    @IBOutlet var phone: UIImageView!
    var status_code = 0
    var images_data:[NSData] = []
    var flag = false
    var postid_ = ""
    let categoryTitles = ["  Title","  Description","  Pictures","  Price","  Round Trip?","  From","  To","  Leaves","  Comes back","  ISBN","  Location","  Date","  How would you like to be contacted?"]
    var imageDifferences = ["","",""]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        postid_ = NSUserDefaults.standardUserDefaults().objectForKey("post_id") as String
        category = NSUserDefaults.standardUserDefaults().objectForKey("cat") as String
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.navigationController?.view.addSubview(actInd)
        self.round_trip_switch.hidden = true
        
        getPostRequest(postid_, category_:category)
        //end spinning icon
        picker?.allowsEditing = true
        var indexPath1 = NSIndexPath(forRow: 1, inSection: 4)
        let SelectedCellHeight: CGFloat = 0
        var tblView =  UIView(frame: CGRectZero)
        tableView.tableFooterView = tblView
        tableView.backgroundColor = UIColor.clearColor()
        picker!.delegate=self
        initializeDatePicker()
        navigationController?.navigationBar.barStyle = UIBarStyle.Default
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.633, green: 0.855, blue: 0.620, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light",size: 24)!,NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        self.tableView.reloadData()
        setUpImageGestures()
        assignDelegates()
        self.view.backgroundColor = UIColor.whiteColor()
        tableView.reloadData()
    }
    
    @IBAction func rount_trip_switch_changed(sender: AnyObject) {
        self.tableView.reloadData()
        if(!round_trip_switch.on){
            round_trip_flag = false
            comesBack.hidden = true
        }
        else{
            round_trip_flag = true
            comesBack.hidden = false
        }
    }
    
    func updateUI(parseJSON:NSDictionary){
        self.title_field.text = parseJSON["title"] as String
        self.descOutlet.text = parseJSON["description"] as String
        let newPrice = parseJSON["price"] as String
        if(newPrice == "Free"){
            self.price.text = "0.00"
        }
        else if newPrice == "" {
            self.price.text = ""
        }
        else {
            var new_price = parseJSON["price"] as NSString
            new_price = new_price.substringFromIndex(1)
            price.text = new_price
        }
        
        if(parseJSON["gonzaga_email"] as String == ""){
            self.gmail.image = UIImage(named: "ZagMailOFF")
        }
        else{
            self.gmail.image = UIImage(named: "ZagMail")
        }
        if(parseJSON["pref_email"] as String == ""){
            self.pEmail.image = UIImage(named: "eMailOFF")
        }
        else{
            self.pEmail.image = UIImage(named: "eMail")
        }
        if(parseJSON["call"] as String == ""){
            self.phone.image = UIImage(named: "CallOFF")
        }
        else{
            self.phone.image = UIImage(named: "Call")
        }
        if(parseJSON["text"] as String == ""){
            self.text.image = UIImage(named: "SMSOFF")
        }
        else{
            self.text.image = UIImage(named: "SMS")
        }
        
        
        if self.category == "Books"{
            self.ISBN.text = parseJSON["isbn"] as String
        }
        
        if self.category == "Events" || self.category == "Services"{
            println("We are in events/services")
            self.location.text = parseJSON["location"] as String
            self.date.text = parseJSON["date_time"] as String
        }
        
        if self.category == "Ride Shares"{
            self.round_trip_switch.hidden = false
            self.leaves.text = parseJSON["departure_date_time"] as String
            let rts = parseJSON["round_trip"] as Int
            if(rts == 1){
                round_trip_flag = true
                self.round_trip_switch.setOn(true, animated: false)
            }
            //self.round_trip_switch.selected = parseJSON["round_trip"] as Bool
            /*
            
            if(trip.substringWithRange(NSRange(location: 0, length: 2){
            
            }
            else if(trip.substringWithRange(NSRange(location: 0, length: 4)) == "From"){
            
            }
            
            */
            
            
            
            let trip_ = parseJSON["trip"] as String
            var range = NSRange(location:0,length:2)
            if(trip_ == ""){
                println ("empty")
                self.from.text = ""
                self.to.text = ""
            }
            else if(trip_[0...1] == "To"){
                println("To")
                self.from.text = ""
                var end = countElements(trip_) - 1
                self.to.text = trip_[3...end]
            }
            else if(trip_.rangeOfString("To*&") != nil){
                
                println("From")
                trip_.stringByReplacingOccurrencesOfString("To*&", withString: "To", options: NSStringCompareOptions.LiteralSearch, range: nil)
                println(trip_)
                let trip_array = trip_.componentsSeparatedByString(" To*& ")
                let to_ = trip_array[0].componentsSeparatedByString("From ")
                self.from.text = to_[1]
                self.to.text = trip_array[1]
            }
            else{
                println("both")
                self.from.text = trip_[5...(countElements(trip_) - 1)]
                self.to.text = ""
            }
            if parseJSON["round_trip"] as Bool{
                self.comesBack.text = parseJSON["return_date_time"] as String
                
            }
        }
        tableView.reloadData()
        var image_count: Int = parseJSON["image_count"] as Int
        if(image_count < 3){
            image3.image = UIImage(named: "PlusDark.png")
            image3.hidden = false
            image3Load.stopAnimating()
        }
        if(image_count < 2){
            image2.image = UIImage(named: "PlusDark.png")
            image2.hidden = false
            image2Load.stopAnimating()
        }
        if(image_count < 1){
            image1.image = UIImage(named: "PlusDark.png")
            image1.hidden = false
            image1Load.stopAnimating()
        }
    }
    func assignDelegates(){
        self.leaves.delegate = self
        self.date.delegate = self
        self.comesBack.delegate=self
        self.to.delegate = self
        self.from.delegate = self
        self.ISBN.delegate = self
        self.price.delegate = self
        self.location.delegate = self
        self.descOutlet.delegate = self
        self.title_field.delegate = self
    }
    
    func doneDate(){
        currentText.resignFirstResponder()
    }
    
    @IBAction func switch_changed(sender: AnyObject) {
        tableView.reloadData()
        
    }
    //initializes date pickers for the 3 necessary fields
    func initializeDatePicker(){
        var item = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done,target: self, action: "doneDate")
        var toolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.bounds.size.width, 44))
        toolbar.setItems([item], animated: true)
        self.leaves.inputAccessoryView = toolbar
        self.comesBack.inputAccessoryView = toolbar
        self.date.inputAccessoryView = toolbar
        let currentDate = NSDate()  //5 -  get the current date
        date_picker.minimumDate = currentDate
        self.comesBack.inputView = date_picker
        self.leaves.inputView = date_picker
        self.date.inputView = date_picker
        date_picker.addTarget(self, action: Selector("dataPickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    func dataPickerChanged(date_picker:UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        var strDate = dateFormatter.stringFromDate(date_picker.date)
        print (strDate)
        currentText.text = strDate
    }
    func setUpImageGestures(){
        //image1
        let gestureRecogniser1 = UITapGestureRecognizer(target: self, action: Selector("image1Toutched"))
        self.image1.addGestureRecognizer(gestureRecogniser1)
        let tap = UITapGestureRecognizer(target: self, action: Selector("tableToutched"))
        self.view.addGestureRecognizer(tap)
        self.image1.image = UIImage(named:"PlusDark.png")
        
        //image 2
        let gestureRecogniser2 = UITapGestureRecognizer(target: self, action: Selector("image2Toutched"))
        self.image2.addGestureRecognizer(gestureRecogniser2)
        self.image2.image = UIImage(named:"PlusDark.png")
        
        //image 3
        let gestureRecogniser3 = UITapGestureRecognizer(target: self, action: Selector("image3Toutched"))
        self.image3.addGestureRecognizer(gestureRecogniser3)
        self.image3.image = UIImage(named:"PlusDark.png")
        
        //TODO:images will be changed to image specifics
        let gestureRecogniserGmail = UITapGestureRecognizer(target: self, action: Selector("gMailToutched"))
        self.gmail.addGestureRecognizer(gestureRecogniserGmail)
        self.gmail.image = UIImage(named:"ZagMail")
        
        
        let gestureRecogniserPEmail = UITapGestureRecognizer(target: self, action: Selector("pEmailToutched"))
        self.pEmail.addGestureRecognizer(gestureRecogniserPEmail)
        self.pEmail.image = UIImage(named:"eMailOFF")
        
        
        let gestureRecogniserText = UITapGestureRecognizer(target: self, action: Selector("textToutched"))
        self.text.addGestureRecognizer(gestureRecogniserText)
        self.text.image = UIImage(named:"SMSOFF")
        
        
        let gestureRecogniserPhone = UITapGestureRecognizer(target: self, action: Selector("phoneToutched"))
        self.phone.addGestureRecognizer(gestureRecogniserPhone)
        self.phone.image = UIImage(named:"CallOFF")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func image1Toutched(){ //touched
        currentImage = self.image1
        getImage()
    }
    func image2Toutched(){
        currentImage = self.image2
        getImage()
    }
    func image3Toutched(){
        currentImage = self.image3
        getImage()
    }
    func tableToutched(){
        currentText.resignFirstResponder()
        descOutlet.resignFirstResponder()
    }
    func gMailToutched(){
        if(self.gmail.image!.isEqual(UIImage(named:"ZagMailOFF"))){
            self.gmail.image = UIImage(named:"ZagMail")
        }
        else {
            self.gmail.image = UIImage(named:"ZagMailOFF")
        }
    }
    func pEmailToutched(){
        if(self.pEmail.image!.isEqual(UIImage(named:"eMailOFF")) && NSUserDefaults.standardUserDefaults().objectForKey("pref_email") != nil){
            self.pEmail.image = UIImage(named:"eMail")
        }
        else{
            self.pEmail.image = UIImage(named:"eMailOFF")
        }
    }
    func textToutched(){
        if(self.text.image!.isEqual(UIImage(named:"SMSOFF")) && NSUserDefaults.standardUserDefaults().objectForKey("phone") != nil){
            self.text.image = UIImage(named:"SMS")
        }
        else{
            self.text.image = UIImage(named:"SMSOFF")
        }
    }
    func phoneToutched(){
        println("phone touched")
        if((self.phone.image!.isEqual(UIImage(named:"CallOFF"))) && NSUserDefaults.standardUserDefaults().objectForKey("phone") != nil){
            self.phone.image = UIImage(named:"Call")
        }
        else{
            self.phone.image = UIImage(named:"CallOFF")
        }
    }
    
    func getImage(){
        //Create the alert action that comes up when the images are selected
        currentText.resignFirstResponder()
        var alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        var cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default){
            UIAlertAction in
            self.openCamera()
        }
        var gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.Default){
            UIAlertAction in
            self.openGallary()
        }
        var deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default){
            UIAlertAction in
            self.currentImage.image = UIImage(named:"PlusDark.png")
            if(self.currentImage == self.image1){
                self.imageDifferences[0] = "deleted"
            }
            else if(self.currentImage == self.image2){
                self.imageDifferences[1] = "deleted"
            }
            else{
                self.imageDifferences[2] = "deleted"
            }
        }
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel){
            UIAlertAction in
        }
        // Add the actions
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        if(currentImage.image != UIImage(named:"PlusDark.png") ){
            alert.addAction(deleteAction)
        }
        // Present the controller
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone{
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else{
            popover=UIPopoverController(contentViewController: alert)
            popover!.presentPopoverFromRect(image1.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    func openCamera(){
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            picker!.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(picker!, animated: true, completion: nil)
        }
        else{
            openGallary()
        }
    }
    func openGallary(){ //gallery
        picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone{
            self.presentViewController(picker!, animated: true, completion: nil)
        }
        else{
            popover=UIPopoverController(contentViewController: picker!)
            popover!.presentPopoverFromRect(currentImage.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: NSDictionary!){
        let newImage = info[UIImagePickerControllerEditedImage] as UIImage
        let thumbNail = newImage.resizeToBoundingSquare(boundingSquareSideLength:800)
        picker.dismissViewControllerAnimated(true, completion: nil)
        currentImage.image=newImage
        if(currentImage == image1){
            self.imageDifferences[0] = "edited"
        }
        else if(currentImage == image2){
            self.imageDifferences[1] = "edited"
        }
        else{
            self.imageDifferences[2] = "edited"
        }
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController!){
        println("picker cancel.")
        picker .dismissViewControllerAnimated(true, completion: nil)
    }
    //gets the current text field that is selected
    func textFieldDidBeginEditing(textField: UITextField!){    //delegate method
        currentText = textField
    }
    func textFieldShouldEndEditing(textField: UITextField!) -> Bool{  //delegate method
        return true
    }
    func textFieldShouldReturn(textField: UITextField!) -> Bool{   //delegate method
        return true
    }
    //creates the custom view headers
    override func tableView(tableView: (UITableView!), viewForHeaderInSection section: Int) -> (UIView!){
        var header : UILabel = UILabel()
        header.text = categoryTitles[section]
        header.font = UIFont(name: "HelveticaNeue-Light",size: 18)
        header.textColor = UIColor.darkGrayColor()
        header.backgroundColor = UIColor(red: 0.633, green: 0.855, blue: 0.620, alpha: 0.8)
        
        return header
    }
    
    //sets the category header height to 0 if it is not being used
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        let rideShareOneWaySections = [4,5,6,7]
        let rideShareBothWaysSections = [4,5,6,7,8]
        let eventSections = [10,11]
        if(section == 8 && category != "Ride Shares"){
            return 0
        }
        if(section == 8 && round_trip_switch.on == false && category == "Ride Shares"){
            return 0
        }
        if(contains(rideShareOneWaySections,section) && category != "Ride Shares"){
            return 0
        }
        
        if(section == 9 && category != "Books"){
            return 0
        }
        if(contains(eventSections,section) && category !=  "Services" && category != "Events"){
            return 0
        }
        return 24
    }
    func createAlert(message:String){
        var alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
        }))
        
    }
    func validateFields() -> Bool{
        var validator:FieldValidator = FieldValidator()
        if(!validator.checkLength(title_field.text, lengthString: 100, empty:true)){
            createAlert("Please enter a title under 100 characters")
            return false
        }
        
        
        if(!validator.checkFloat(price.text) && price.text != ""){
            createAlert("Please enter a valid price")
            return false
        }
        if(!validator.checkPriceUnder1000(price.text) && price != ""){
            createAlert("Prices over $10,000 are not allowed on Zig Zag")
            return false
        }
        if(!validator.checkLength(descOutlet.text, lengthString: 1000, empty:false)){
            createAlert("Please enter a description under 1000 characters")
            return false
        }
        if(category == "Ride Shares"){
            if(round_trip_switch.on){
                println("is roundtrip shares")
                if(!validator.datesInOrder(leaves.text, date2: comesBack.text)){
                    
                    createAlert("Your ride share is planned to come back before it leaves")
                    return false
                }
            }
            if(!validator.checkLength(to.text, lengthString: 70, empty:false)){
                createAlert("Please enter a location under 70 characters")
                return false
            }
            if(!validator.checkLength(from.text, lengthString: 70, empty:false)){
                createAlert("Please enter a location under 70 characters")
                return false
            }
            
        }
        if(category == "Books"){
            if(!validator.checkLength(ISBN.text, lengthString: 13, empty:false)){
                createAlert("Please enter an ISBN under 13 characters")
                return false
            }
        }
        if(category == "Events" || category == "Services" ){
            if(!validator.checkLength(location.text, lengthString: 70 , empty:false)){
                createAlert("Please enter a location under 70 characters")
                return false
            }
        }
        return true
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.section == 0 || indexPath.section == 3){
            return 30
        }
        if(indexPath.section == 1){
            return 128
        }
        if(indexPath.section == 2){
            return 150
        }
        if(indexPath.section == 4 && category == "Ride Shares"){
            return 50
        }
        if((indexPath.section == 5 || indexPath.section == 6 || indexPath.section == 7) && category == "Ride Shares"){
            return 30
        }
        if(indexPath.section == 8 && category == "Ride Shares" && round_trip_switch.on){
            return 30
        }
        if(indexPath.section == 9 && category == "Books"){
            return 30
        }
        if((indexPath.section == 10 || indexPath.section == 11 ) && (category == "Services" || category == "Events")){
            return 30
        }
        if(indexPath.section == 12){
            return 100
        }
        return 0
    }
    
    @IBAction func cancel(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setObject(false, forKey: "fromEdit")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func editPostSubmit(sender: AnyObject) {
        if(validateFields()){
            actInd.startAnimating()
            self.editOutlet.enabled = false
            editPostRequest()
            
        }
    }
    func failedImage(imageNumber:Int){
        if(imageNumber == 1){
            image1.image = UIImage(named: "leaf.png")
            image1.hidden = false
            image1Load.stopAnimating()
        }
        else if(imageNumber == 2){
            image2.image = UIImage(named: "leaf.png")
            image2.hidden = false
            image2Load.stopAnimating()
        }
        else if(imageNumber == 3){
            image2.image = UIImage(named: "leaf.png")
            image2.hidden = false
            image2Load.stopAnimating()
        }
    }
    func getPostRequest(postid_:String, category_:String){
        var api_requester: AgoraRequester = AgoraRequester()
        api_requester.ViewPost(category_, id: postid_.toInt()!,
            info: {parseJSON -> Void in
                dispatch_async(dispatch_get_main_queue(), {self.updateUI(parseJSON)})
            },
            image1: {imageData -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    self.image1.image = UIImage(data:imageData!)
                    self.image1.hidden = false
                    self.image1Load.stopAnimating()
                })
            },
            image2: {imageData -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    self.image2.image = UIImage(data:imageData!)
                    self.image2.hidden = false
                    self.image2Load.stopAnimating()
                })
                
            },
            image3: {imageData -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    self.image3.image =  UIImage(data:imageData!)
                    self.image3.hidden = false
                    self.image3Load.stopAnimating()
                })
            },
            failure: {isImage,imageNumber,code,message -> Void in
                if !isImage{
                    self.failedImage(imageNumber!)
                }
                else{
                    if(code == 400){
                        var alert = UIAlertController(title: "This post no longer exists", message: "Pull down to refresh", preferredStyle: UIAlertControllerStyle.Alert)
                        self.presentViewController(alert, animated: true, completion: nil)
                        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }))
                        
                    }
                    else {
                        dispatch_async(dispatch_get_main_queue(), {
                            var alert = UIAlertController(title: "Connection error", message: "Check signal and try", preferredStyle: UIAlertControllerStyle.Alert)
                            self.presentViewController(alert, animated: true, completion: nil)
                            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }))
                        })
                    }
                    
                }
            }
        )
    }
    func updateNSData(defaultImage:NSData,date:String){
        var current_posts:[[AnyObject]] = NSUserDefaults.standardUserDefaults().objectForKey("user_posts") as [[AnyObject]]
        var new_post = []
        var the_index = 0
        for i in 0...current_posts.count - 1 {
            if current_posts[i][0] as String == postid_ && String(current_posts[i][3] as String) == category {
                new_post = [String(self.postid_),title_field.text,defaultImage,category,date]
                the_index = i
            }
        }
        current_posts.removeAtIndex(the_index)
        current_posts.insert(new_post, atIndex: the_index)
        NSUserDefaults.standardUserDefaults().setObject(current_posts, forKey: "user_posts")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func editPostRequest() {
        actInd.startAnimating()
        self.tableView.userInteractionEnabled = false
        
        var api_requester: AgoraRequester = AgoraRequester()
        var UIImageList = [image1.image,image2.image,image3.image]
        var imagesBase64:[String] = []
        var imageData:NSData
        var imageBase64:String
        var notChoseDefault = true
        var defaultImage:NSData? = nil
        for i in 0...2 {
            if(imageDifferences[i] == "deleted"){
                imagesBase64.append("deleted")
                println("image was a deleted one")
            }
            else if(imageDifferences[i] == ""){
                imagesBase64.append("")
                if(notChoseDefault && UIImageList[i] != UIImage(named: "PlusDark.png")){
                    defaultImage = UIImageJPEGRepresentation(UIImageList[i],1)
                    notChoseDefault = false
                    println("image was the same")
                    
                }
            }
            else{
                imageData = UIImageJPEGRepresentation(UIImageList[i],1)
                imageBase64 = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(0))
                imagesBase64.append(imageBase64)
                println("was a new image")
                if(notChoseDefault && UIImageList[i] != UIImage(named: "PlusDark.png")){
                    defaultImage = imageData
                    notChoseDefault = false
                    
                }
            }
        }
        if(defaultImage == nil){
            defaultImage = UIImageJPEGRepresentation(UIImage(named:"noImage"),1)
        }
        let username = NSUserDefaults.standardUserDefaults().objectForKey("username") as String
        var gonzaga_email = "0"
        if(gmail.image == UIImage(named: "ZagMail")){
            gonzaga_email = "1" //boolean contact option
        }
        var pref_email = "0" //boolean contact option
        if(pEmail.image == UIImage(named: "eMail")){
            pref_email = "1"
        }
        var text_bool = "0"
        if(text.image == UIImage(named: "SMS")){
            text_bool = "1" //boolean contact option
        }
        var phone_bool = "0"
        if(phone.image == UIImage(named: "Call")){
            phone_bool = "1"
        }
        var round_trip = "0" // not sure
        if(round_trip_switch.on){
            round_trip = "1"
        }
        if(gonzaga_email == "0" && pref_email == "0" && text_bool == "0" && phone_bool == "0"){
            //self.createAlert("Please select at least one contact option")
            //do something in here to stop the function
        }
        let params = ["username":username,
            "description":descOutlet.text,
            "price":price.text,
            "title":title_field.text,
            "post_id" : self.postid_,
            "category" : self.category,
            "gonzaga_email":gonzaga_email,
            "pref_email":pref_email,
            "call":phone_bool,
            "text":text_bool,
            "departure_date_time":leaves.text,
            "start_location":from.text,
            "end_location":to.text,
            "round_trip":round_trip,
            "return_date_time":comesBack.text,
            "date_time":date.text,
            "location":location.text,
            "isbn":ISBN.text,
            "images":imagesBase64]
            as Dictionary<String,AnyObject>
        var not_ready = true
        api_requester.POST("editpost/", params: params,
            success: {parseJSON -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    //TODO: found null while unwrapping
                    var post_date = parseJSON["post_date_time"] as String
                    self.updateNSData(defaultImage!,date:parseJSON["post_date_time"] as String)
                    NSUserDefaults.standardUserDefaults().setObject(true, forKey: "profileNeedsReloading")
                    self.actInd.stopAnimating()
                })
                not_ready = false
            },
            failure: {code,message -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    var alert = UIAlertController(title: "Connection Error", message: "Check signal and try again", preferredStyle: UIAlertControllerStyle.Alert)
                    self.presentViewController(alert, animated: true, completion: nil)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                    }))
                    self.actInd.stopAnimating()
                    self.editOutlet.enabled = true
                    self.tableView.userInteractionEnabled = true
                })
            }
        )
        
    }
    
}







