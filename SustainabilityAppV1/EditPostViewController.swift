//
//  EditPostViewController.swift
//  SustainabilityAppV1
//
//  Created by Lucas Orlita on 1/30/15.
//  Copyright (c) 2015 Jake Quiring. All rights reserved.
//

import UIKit

class EditPostViewController: UITableViewController,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate, UITextFieldDelegate,UITextViewDelegate {
    
    var orientation: UIImageOrientation = .Up
    var currentImage:UIImageView = UIImageView()
    var popover:UIPopoverController?=nil
    //Further Details Text Fields
    var currentText:UITextField = UITextField()
    var parseJSON:Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
    @IBOutlet var descOutlet: UITextView!
    var category = ""
    
    @IBOutlet var title_field: UITextField!
    var picker:UIImagePickerController?=UIImagePickerController()
    weak var cat_picker: UIPickerView!
    //3 images for taking pics

    @IBOutlet var image1: UIImageView!
    @IBOutlet var image2: UIImageView!
    @IBOutlet var image3: UIImageView!
    
    @IBOutlet var round_trip_switch: UISwitch!

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

    @IBOutlet var phone: UIImageView!
    var status_code = 0
    var images_data:[NSData] = []
    var flag = false
    var id = 0
    let categoryTitles = ["  Title","  Description","  Pictures","  Price","  Round Trip?","  From","  To","  Leaves","  Comes back","  ISBN","  Location","  Date","  How would you like to be contacted?"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        var postid_ = NSUserDefaults.standardUserDefaults().objectForKey("post_id") as String
        var category_ = NSUserDefaults.standardUserDefaults().objectForKey("cat") as String
        //start spinning icon
        getPostRequest(postid_, category_:category_)
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
    }
    func updateUI(parseJSON:NSDictionary){
        self.title_field.text = parseJSON["title"] as String
        self.descOutlet.text = parseJSON["description"] as String
        self.price.text = parseJSON["price"] as String
        if(parseJSON["gonzaga_email"] as String == ""){
            self.gmail.image = UIImage(named: "ZagMailOFF.png")
        }
        else{
            self.gmail.image = UIImage(named: "ZagMail.png")
        }
        if(parseJSON["pref_email"] as String == ""){
            self.pEmail.image = UIImage(named: "eMailOFF.png")
        }
        else{
            self.pEmail.image = UIImage(named: "eMail.png")
        }
        if(parseJSON["call"] as String == ""){
            self.phone.image = UIImage(named: "CallOFF.png")
        }
        else{
            self.phone.image = UIImage(named: "Call.png")
        }
        if(parseJSON["text"] as String == ""){
            self.text.image = UIImage(named: "SMSOFF.png")
        }
        else{
            self.text.image = UIImage(named: "SMS.png")
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
            self.leaves.text = parseJSON["departure_date_time"] as String
            self.round_trip_switch.selected = parseJSON["round_trip"] as Bool
            let trip_ = parseJSON["trip"] as String
            let trip_array = trip_.componentsSeparatedByString(" From ")
            let to_ = trip_array[0].componentsSeparatedByString("To ")
            self.to.text = to_[1]
            self.from.text = trip_array[1]
            if parseJSON["round_trip"] as Bool{
                self.comesBack.text = parseJSON["return_date_time"] as String
            }
        }
        
        //The Three images are processed here
        var imageString: [String]=["","",""]
        imageString[0] = parseJSON["image1"]! as String
        imageString[1] = parseJSON["image2"]! as String
        imageString[2] = parseJSON["image3"]! as String
        if !imageString[0].isEmpty {
            let imageData1 = NSData(base64EncodedString: imageString[0], options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
            self.image1.image =  (UIImage(data: imageData1))
            
            
            //do stuff with the image here
        }
        else{
            //No image flag
            self.image1.image = UIImage(named: "tv.png")
            //CASE IN WHICH THE POST HAD NO IMAGE 1
        }
        if !imageString[1].isEmpty {
            let imageData2 = NSData(base64EncodedString: imageString[1], options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
            self.image2.image =  (UIImage(data: imageData2))
        }
        else{
            self.image2.image = UIImage(named: "tv.png")
        }
        if !imageString[2].isEmpty {
            let imageData3 = NSData(base64EncodedString: imageString[2], options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
            self.image3.image =  (UIImage(data: imageData3))
            //do stuff with the image here
        }
        else{
            self.image3.image = UIImage(named: "tv.png")
        }
        println("still happy")
        
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
        self.image1.image = UIImage(named:"tv.png")
        
        //image 2
        let gestureRecogniser2 = UITapGestureRecognizer(target: self, action: Selector("image2Toutched"))
        self.image2.addGestureRecognizer(gestureRecogniser2)
        self.image2.image = UIImage(named:"tv.png")
        
        //image 3
        let gestureRecogniser3 = UITapGestureRecognizer(target: self, action: Selector("image3Toutched"))
        self.image3.addGestureRecognizer(gestureRecogniser3)
        self.image3.image = UIImage(named:"tv.png")
        
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
            self.currentImage.image = UIImage(named:"tv.png")
        }
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel){
            UIAlertAction in
        }
        // Add the actions
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        if(currentImage.image != UIImage(named:"tv.png") ){
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
    
    //sets the category header height to 0 if it is not being used
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        let rideShareOneWaySections = [5,6,7,8]
        let rideShareBothWaysSections = [5,6,7,8,9]
        let eventSections = [11,12]
        if(section == 9 && (!round_trip_switch.on || category != "Ride Shares")){
            return 0
        }
        if(contains(rideShareOneWaySections,section) && category != "Ride Shares"){
            return 0
        }
        
        if(section == 10 && category != "Books"){
            return 0
        }
        if(contains(eventSections,section) && category !=  "Services" && category != "Events"){
            return 0
        }
        return 24
    }
    func pullPostInfoRequest(){
        //basically modified view post
    }
    
    func submitEditedPost(){
        // modified submit post
    }
    
    func splitFromAndToFields(location: String) -> String{
        // this function will be called to split the location into 2 strings, a 'From" and a "To"
        return ""
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
        if(indexPath.section == 4 /*&& category.text == "Ride Shares"*/){
            return 50
        }
        if((indexPath.section == 5 || indexPath.section == 6 || indexPath.section == 7) /*&& category.text == "Ride Shares"*/){
            return 30
        }
        if(indexPath.section == 8 /*&& category.text == "Ride Shares" && round_trip_switch.on*/){
            return 30
        }
        if(indexPath.section == 9 /*&& category.text == "Books"*/){
            return 30
        }
        if((indexPath.section == 10 || indexPath.section == 11 ) /* && (category.text == "Services" || category.text == "Events")*/){
            return 30
        }
        if(indexPath.section == 12){
            return 100
        }
        return 0
    }

    @IBAction func cancel(sender: AnyObject) {
          self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func editPostSubmit(sender: AnyObject) {
        //LoadingOverlay.shared.showOverlay(tableView)

        if(title_field.text  == "" ){
            var alert = UIAlertController(title: "Warning", message: "Please enter a title", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            }))
        }
        else if let n = price.text.toDouble() {
            createPostRequest()
        }
        else {
            var alert = UIAlertController(title: "Warning", message: "Please enter a correct price", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            }))
        }
        
    }
    func getPostRequest(postid_:String, category_:String){
   
        var flag = true
        var request = NSMutableURLRequest(URL: NSURL(string: "http://147.222.165.3:8000/viewpost/")!)
        request.HTTPMethod = "POST"
        //open NSURLSession
        var session = NSURLSession.sharedSession()
        //this is the parameters array that will be formulated as JSON.
        // We need both postid and category
        var params = ["post_id":postid_,          //post id so we find the post
            "category":category_]                 //category so we know what table to search
            as Dictionary<String,AnyObject>
        
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
     
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                //get the status code
                var status_code = httpResponse.statusCode
                self.status_code = status_code
                //200 = OK: user created, carry on!
                if(status_code == 200){
                    var parseJSON = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &err) as? NSDictionary
                    print(parseJSON!["image1"])
                    if(err != nil) {
                        println(err!.localizedDescription)
                        let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                        println("Error could not parse JSON: '\(jsonStr)'")
                    }
                    else{
                        dispatch_async(dispatch_get_main_queue(), {self.updateUI(parseJSON!)})
                        
                    }
                    flag = false
                }
                //400 = BAD_REQUEST: error in creating user, display error!
                else if(status_code == 400){
                    var parseJSON = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &err) as? Dictionary<String,AnyObject>
                    if(err != nil) {
                        println(err!.localizedDescription)
                        let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                        println("Error could not parse JSON: '\(jsonStr)'")
                    }
                    else{
                        
                        //println(parseJSON["message"] as String)
                    }
                    flag = false
                }
                //500 = INTERNAL_SERVER_ERROR. Oh snap *_*
                else if(status_code == 500){
                    println("The server is down! Call the fire department!")
                    flag = false
                }
            }
            else {
                flag = false
                println("Error in casting response, data incomplete")
            }
        })
        task.resume()
        //start a timer
        while(flag){
          //if(timer = 10 seconds) 
            //make flag false
            //set status code to 600
        }
    }
    func createPostRequest() {
        flag = false
        // check all fields first
        
        // create a post code
        var request = NSMutableURLRequest(URL: NSURL(string: "http://147.222.165.3:8000/createpost/")!)
        request.HTTPMethod = "POST"
        var session = NSURLSession.sharedSession()
        
        // need to do images
        //image urls
        var imageUrls:[NSURL] = [NSURL(fileURLWithPath: "/Users/kylehandy/Desktop/thisguy.png")!,NSURL(fileURLWithPath: "/Users/kylehandy/Desktop/thisotherguy.png")!]
        var UIImageList = [image1.image,image2.image,image3.image]
        
        //formulate imageBase64 array
        var imagesBase64:[String] = []
        var imageData:NSData
        var imageBase64:String
        /*
        for url in imageUrls{
        imageData = NSData(contentsOfURL:url)! //load contents of url into NSData type
        imageBase64 = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(0))
        imagesBase64.append(imageBase64)
        }*/
        for images in UIImageList{
            if(images != UIImage(named:"tv.png")){
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
        // need text message boolean too
        //rideshare specific
        var departure_date_time = leaves.text
        var start_location = from.text
        var end_location = to.text
        var round_trip = "0" // not sure
        if(round_trip_switch.on){
            round_trip = "1"
        }
        var return_date_time = comesBack.text
        //datelocation specific
        var date_time = date.text
        var location_ = location.text
        //textbook specific
        var isbn = ISBN.text
        //this is the parameters array that will be formulated as JSON.
        //it has space for EVERY attribute of EVERY category.
        //only fill attributes that pertain to the category
        let params = ["username":username,          //common post information
            "description":description_,
            "price":cost,                   // |
            "title":title,                  // |
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
        
        //Load body with JSON serialized parameters, set headers for JSON! (Star trek?)
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        var status_code = 0
        //define NSURLSession data task with completionHandler call back function
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
                    self.id = parseJSON["id"] as Int
                }
            }
            
            //downcast NSURLResponse object to NSHTTPURLResponse
            if let httpResponse = response as? NSHTTPURLResponse {
                //get the status code
                status_code = httpResponse.statusCode
                //200 = OK: user created, carry on!
                if(status_code == 200){
                    
                    println(message)
                    self.flag = true
                }
                    //400 = BAD_REQUEST: error in creating user, display error!
                else if(status_code == 400){
                    println(message)
                    self.flag = true
                }
                    //500 = INTERNAL_SERVER_ERROR. Oh snap *_*
                else if(status_code == 500){
                    println("The server is down! Call the fire!")
                    self.flag = true
                }
            } else {
                println("Error in casting response, data incomplete")
                self.flag = true
            }
        })
        task.resume()
        while(self.flag == false){
        }
        if(status_code == 200){
                   self.dismissViewControllerAnimated(true, completion: nil)
        
        }
    }
}




    

