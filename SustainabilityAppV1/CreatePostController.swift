//
//  CreatePostController.swift
//  SustainabilityAppV1
//
//  Created by Jake Quiring on 11/19/14.
//  Copyright (c) 2014 Jake Quiring. All rights reserved.
//

import UIKit
import Foundation

class CreatePostController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate, UITextFieldDelegate,UITextViewDelegate {
    
    var orientation: UIImageOrientation = .Up
    var currentImage:UIImageView = UIImageView()
    var popover:UIPopoverController?=nil
    //Further Details Text Fields
    var currentText:UITextField = UITextField()
    
    
    var picker:UIImagePickerController?=UIImagePickerController()
    weak var cat_picker: UIPickerView!
    @IBOutlet var title_field: UITextField!
    @IBOutlet var descOutlet: UITextView!
    //3 images for taking pics
    @IBOutlet var image1: UIImageView!
    @IBOutlet var image2: UIImageView!
    @IBOutlet var image3: UIImageView!
    @IBOutlet var price: UITextField!
    //Ride Share
    @IBOutlet weak var round_trip_switch: UISwitch!
    @IBOutlet var from: UITextField!
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
    @IBOutlet var gmail: UIImageView!
    @IBOutlet var pEmail: UIImageView!
    @IBOutlet var text: UIImageView!
    @IBOutlet var phone: UIImageView!
    @IBOutlet var category: UITextField!
    var images_data:[NSData] = []
    var flag = false
    var id = 0
    let pickerData = ["Books","Electronics","Household","Ride Shares" ,"Services" ,"Events","Recreation","Clothing"]
    let categoryTitles = ["  Category","  Title","  Description","  Pictures","  Price","  Round Trip?","  From","  To","  Leaves","  Comes back","  ISBN","  Location","  Date","  How would you like to be contacted?"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker?.allowsEditing = true
        var indexPath1 = NSIndexPath(forRow: 1, inSection: 4)
        let SelectedCellHeight: CGFloat = 0
        var tblView =  UIView(frame: CGRectZero)
        tableView.tableFooterView = tblView
        tableView.backgroundColor = UIColor.clearColor()
        picker!.delegate=self
        intializeCatPicker()
        initializeDatePicker()
        navigationController?.navigationBar.barStyle = UIBarStyle.Default
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.633, green: 0.855, blue: 0.620, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light",size: 24)!,NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        self.tableView.reloadData()
        setUpImageGestures()
        assignDelegates()
        self.view.backgroundColor = UIColor.whiteColor()
    }
    func assignDelegates(){
        self.leaves.delegate = self
        self.date.delegate = self
        self.comesBack.delegate=self
        self.category.delegate=self
        self.to.delegate = self
        self.from.delegate = self
        self.ISBN.delegate = self
        self.price.delegate = self
        self.location.delegate = self
        self.descOutlet.delegate = self
        self.title_field.delegate = self
    }
    func doneCat() {
        if(category.text == ""){
            category.text = "Books"
        }
        currentText.resignFirstResponder()
        print("DoneCat")
    }
    func doneDate(){
        currentText.resignFirstResponder()
    }
    
    @IBAction func switch_changed(sender: AnyObject) {
        tableView.reloadData()
        
    }
    //TODO: title field changed to cat_field.
    func intializeCatPicker(){
        var item = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done,target: self, action: "doneCat")
        var toolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.bounds.size.width, 44))
        toolbar.setItems([item], animated: true)
        self.category.inputAccessoryView = toolbar
        var tempPicker = UIPickerView()
        tempPicker.delegate = self
        tempPicker.dataSource = self
        self.cat_picker = tempPicker
        self.category.inputView = cat_picker
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
        self.gmail.image = UIImage(named:"ZagMail.png")

        let gestureRecogniserPEmail = UITapGestureRecognizer(target: self, action: Selector("pEmailToutched"))
        self.pEmail.addGestureRecognizer(gestureRecogniserPEmail)
        self.pEmail.image = UIImage(named:"eMailOFF.png")

        let gestureRecogniserText = UITapGestureRecognizer(target: self, action: Selector("textToutched"))
        self.text.addGestureRecognizer(gestureRecogniserText)
        self.text.image = UIImage(named:"SMSOFF.png")

        let gestureRecogniserPhone = UITapGestureRecognizer(target: self, action: Selector("phoneToutched"))
        self.phone.addGestureRecognizer(gestureRecogniserPhone)
        self.phone.image = UIImage(named:"CallOFF.png")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[row]
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
    //TODO:
    func gMailToutched(){
        if(self.gmail.image!.isEqual(UIImage(named:"ZagMailOFF.png"))){
            self.gmail.image = UIImage(named:"ZagMail.png")
        }
        else {
            self.gmail.image = UIImage(named:"ZagMailOFF.png")
        }
    }
    func pEmailToutched(){
        if(self.pEmail.image!.isEqual(UIImage(named:"eMailOFF.png")) && NSUserDefaults.standardUserDefaults().objectForKey("pref_email") != nil){
            self.pEmail.image = UIImage(named:"eMail.png")
        }
        else{
            self.pEmail.image = UIImage(named:"eMailOFF.png")
        }
    }
    func textToutched(){
        if(self.text.image!.isEqual(UIImage(named:"SMSOFF.png")) && NSUserDefaults.standardUserDefaults().objectForKey("phone") != nil){
            self.text.image = UIImage(named:"SMS.png")
        }
        else{
            self.text.image = UIImage(named:"SMSOFF.png")
        }
    }
    func phoneToutched(){
        println("phone touched")
        if((self.phone.image!.isEqual(UIImage(named:"CallOFF.png"))) && NSUserDefaults.standardUserDefaults().objectForKey("phone") != nil){
            self.phone.image = UIImage(named:"Call.png")
        }
        else{
            self.phone.image = UIImage(named:"CallOFF.png")
        }
    }
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int) {
        category.text = "\(pickerData[row])"
        tableView.reloadData()
        category.becomeFirstResponder()
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
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController!){
        println("picker cancel.")
        picker .dismissViewControllerAnimated(true, completion: nil)
    }
    //gets the current text field that is selected
    func textFieldDidBeginEditing(textField: UITextField!){    //delegate method
        currentText = textField
    }
    //TODO: do we need these next two functions
    func textFieldShouldEndEditing(textField: UITextField!) -> Bool{  //delegate method
        return true
    }
    func textFieldShouldReturn(textField: UITextField!) -> Bool{   //delegate method
        //textField.resignFirstResponder()
        return true
    }
    //creates the custom view headers
    override func tableView(tableView: (UITableView!), viewForHeaderInSection section: Int) -> (UIView!){
        print(section)
        var header : UILabel = UILabel()
        header.text = categoryTitles[section]
        header.font = UIFont(name: "HelveticaNeue-Light",size: 18)
        header.textColor = UIColor.darkGrayColor()
        header.backgroundColor = UIColor(red: 0.633, green: 0.855, blue: 0.620, alpha: 0.8)
        
        return header
    }
    //sets the row heights within the table view
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 4){
            return 30
        }
        if(indexPath.section == 2){
            return 128
        }
        if(indexPath.section == 3){
            return 150
        }
        if(indexPath.section == 5 && category.text == "Ride Shares"){
            return 50
        }
        if((indexPath.section == 6 || indexPath.section == 7 || indexPath.section == 8) && category.text == "Ride Shares"){
            return 30
        }
        if(indexPath.section == 9 && category.text == "Ride Shares" && round_trip_switch.on){
            return 30
        }
        if(indexPath.section == 10 && category.text == "Books"){
            return 30
        }
        if((indexPath.section == 11 || indexPath.section == 12 ) && (category.text == "Services" || category.text == "Events")){
            return 30
        }
        if(indexPath.section == 13){
            return 100
        }
        return 0
    }
    //sets the category header height to 0 if it is not being used
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        let rideShareOneWaySections = [5,6,7,8]
        let rideShareBothWaysSections = [5,6,7,8,9]
        let eventSections = [11,12]
        if(section == 9 && (!round_trip_switch.on || category.text != "Ride Shares")){
            return 0
        }
        if(contains(rideShareOneWaySections,section) && category.text != "Ride Shares"){
            return 0
        }
        
        if(section == 10 && category.text != "Books"){
            return 0
        }
        if(contains(eventSections,section) && category.text !=  "Services" && category.text != "Events"){
            return 0
        }
        return 24
    }
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func validateFields() -> Bool{
        var validator:FieldValidator = FieldValidator()
        if(category.text == ""){
            createAlert("Please select a category")
            return false
        }
        if(!validator.checkLength(title_field.text, lengthString: 100, empty:true)){
            createAlert("Please enter a title under 100 characters")
            return false
        }
            
        if(!validator.checkFloat(price.text) && price.text != ""){
            createAlert("Please enter a valid price")
            return false
        }
        if(!validator.checkPriceUnder1000(price.text) && price.text != ""){
            createAlert("Prices over $10,000 are not allowed on ZigZaga")
            return false
        }
        if(!validator.checkLength(descOutlet.text, lengthString: 1000, empty:false)){
            createAlert("Please enter a description under 1000 characters")
            return false
        }
        if(category.text == "Ride Shares"){
            println("is ride shares")
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
        if(category.text == "Books"){
            if(!validator.checkLength(ISBN.text, lengthString: 13, empty:false)){
                createAlert("Please enter an ISBN under 13 characters")
                return false
            }
        }
        if(category.text == "Events" || category.text == "Services" ){
            if(!validator.checkLength(location.text, lengthString: 70 , empty:false)){
                createAlert("Please enter a location under 70 characters")
                return false
            }
        }
        return true

    }
    @IBAction func createPostSubmit(sender: AnyObject) {
        if(validateFields()){
            createPostRequest()
        }
        
    }

    func createPostRequest() {
        var not_ready = true
        var api_requester: AgoraRequester = AgoraRequester()
        var UIImageList = [image1.image,image2.image,image3.image]
        var imagesBase64:[String] = []
        var imageData:NSData
        var imageBase64:String
        for images in UIImageList{
            if(images != UIImage(named:"PlusDark.png")){
                imageData = UIImageJPEGRepresentation(images, 1)
                images_data.append(imageData)
                imageBase64 = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(0))
                imagesBase64.append(imageBase64)
            }
        }
        // if statements that only create the necesarry vriables? or always create them all
        let username = NSUserDefaults.standardUserDefaults().objectForKey("username") as String
        let description_ = descOutlet.text
        let cost = price.text
        let title = title_field.text
        let category_ = category.text // not sure
        var gonzaga_email = "0"
        if(gmail.image == UIImage(named: "ZagMail.png")){
            println("USing zagmail")
            gonzaga_email = "1" //boolean contact option
        }
        var pref_email = "0" //boolean contact option
        if(pEmail.image == UIImage(named: "eMail.png")){
            pref_email = "1"
        }
        var text_bool = "0"
        if(text.image == UIImage(named: "SMS.png")){
            text_bool = "1" //boolean contact option
        }
        var phone_bool = "0"
        if(phone.image == UIImage(named: "Call.png")){
            phone_bool = "1"
        }
        var departure_date_time = leaves.text
        var start_location = from.text
        var end_location = to.text
        var round_trip = "0" // not sure
        if(round_trip_switch.on){
            round_trip = "1"
        }
        var return_date_time = comesBack.text
        var date_time = date.text
        var location_ = location.text
        var isbn = ISBN.text
        let params = ["username":username,          //common post information
            "description":description_,
            "price":cost,                   // |
            "title":title,                  // |
            "category":category_,           // |
            "gonzaga_email":gonzaga_email,  // |
            "pref_email":pref_email,        // |
            "call":phone_bool,                   // |
            "text":text_bool,               // <
            "departure_date_time":departure_date_time,  //rideshare specific
            "start_location":start_location,            // |
            "end_location":end_location,                // |
            "round_trip":round_trip,                    // |
            "return_date_time":return_date_time,        // <
            "date_time":date_time,          //datelocation specific
            "location":location_,           // <
            "isbn":isbn,                    //book specific
            "images":imagesBase64]          //images array
            as Dictionary<String,AnyObject>
        api_requester.POST("createpost/", params: params,
            success: {parseJSON -> Void in
                println(self.id)
                var default_image : NSData? = nil
                var new_post:ProfilePost
                var id = parseJSON["id"] as Int

                var stringid = String(id)
                if(self.images_data != []) {
                    default_image = self.images_data[0]
                    new_post = ProfilePost(title: title, imageName: default_image!, id:stringid , cat:category_)
                }
                else{
                    new_post = ProfilePost(title: title, id: stringid,cat:category_)
                }
                println(title)
                
                println("got past here")
                new_post.upDateNSData(true)
                dispatch_async(dispatch_get_main_queue(), {self.dismissViewControllerAnimated(true, completion: nil)})
                not_ready = false
                
            },
            failure: {code,message -> Void in
                if code == 500 {
                    //500: Server failure
                    not_ready = false
                    println("Server Failure!!!!!")
                }
                else if code == 400 {
                    
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
            
        }    }
    func createUI(){
        
    }
    func createAlert(message:String){
        var alert = UIAlertController(title: "Warning", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
        }))

    }
}
extension String {
    func toDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
}
extension UIImage{
    func resizeToBoundingSquare(#boundingSquareSideLength : CGFloat) -> UIImage{
        let imgScale = self.size.width > self.size.height ? boundingSquareSideLength / self.size.width : boundingSquareSideLength / self.size.height
        let newWidth = self.size.width * imgScale
        let newHeight = self.size.height * imgScale
        let newSize = CGSize(width: newWidth, height: newHeight)
        UIGraphicsBeginImageContext(newSize)
        self.drawInRect(CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return resizedImage
    }
}