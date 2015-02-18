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
 
        //start spinning icon
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
            let rts = parseJSON["round_trip"] as Int
            if(rts == 1){
                round_trip_flag = true
                self.round_trip_switch.setOn(true, animated: false)
            }
            //self.round_trip_switch.selected = parseJSON["round_trip"] as Bool
            let trip_ = parseJSON["trip"] as String
            let trip_array = trip_.componentsSeparatedByString(" To ")
            let to_ = trip_array[0].componentsSeparatedByString("From ")
            self.from.text = to_[1]
            self.to.text = trip_array[1]
            if parseJSON["round_trip"] as Bool{
                self.comesBack.text = parseJSON["return_date_time"] as String
            }
        tableView.reloadData()
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
            self.image1.image = UIImage(named: "PlusDark.png")
            //CASE IN WHICH THE POST HAD NO IMAGE 1
        }
        if !imageString[1].isEmpty {
            let imageData2 = NSData(base64EncodedString: imageString[1], options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
            self.image2.image =  (UIImage(data: imageData2))
        }
        else{
            self.image2.image = UIImage(named: "PlusDark.png")
        }
        if !imageString[2].isEmpty {
            let imageData3 = NSData(base64EncodedString: imageString[2], options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
            self.image3.image =  (UIImage(data: imageData3))
            //do stuff with the image here
        }
        else{
            self.image3.image = UIImage(named: "PlusDark.png")
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

        
        let gestureRecogniserPEmail = UITapGestureRecognizer(target: self, action: Selector("pEmailToutched"))
        self.pEmail.addGestureRecognizer(gestureRecogniserPEmail)

        
        let gestureRecogniserText = UITapGestureRecognizer(target: self, action: Selector("textToutched"))
        self.text.addGestureRecognizer(gestureRecogniserText)

        
        let gestureRecogniserPhone = UITapGestureRecognizer(target: self, action: Selector("phoneToutched"))
        self.phone.addGestureRecognizer(gestureRecogniserPhone)

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
        //print(section)
        var header : UILabel = UILabel()
        header.text = categoryTitles[section]
        header.font = UIFont(name: "HelveticaNeue-Light",size: 18)
        header.textColor = UIColor.darkGrayColor()
        header.backgroundColor = UIColor(red: 0.633, green: 0.855, blue: 0.620, alpha: 0.8)
        
        return header
    }
    
    //sets the category header height to 0 if it is not being used
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        //println(category)
        let rideShareOneWaySections = [4,5,6,7]
        let rideShareBothWaysSections = [4,5,6,7,8]
        let eventSections = [10,11]
        if(section == 8 && category != "Ride Shares"){
            return 0
        }
        if(section == 8 && round_trip_flag == false && category == "Ride Shares"){
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
    func pullPostInfoRequest(){
        //basically modified view post
    }
    
    func submitEditedPost(){
        // modified submit post
    }
    func createAlert(message:String){
        var alert = UIAlertController(title: "Warning", message: message, preferredStyle: UIAlertControllerStyle.Alert)
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
          self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func editPostSubmit(sender: AnyObject) {
        if(validateFields()){
            editPostRequest()
        }
    }
    func getPostRequest(postid_:String, category_:String){
        var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.navigationController?.view.addSubview(actInd)

        actInd.startAnimating()
        var api_requester: AgoraRequester = AgoraRequester()
        var params = ["post_id":postid_,          //post id so we find the post
            "category":category_]                 //category so we know what table to search
            as Dictionary<String,AnyObject>
    
        api_requester.POST("viewpost/", params: params,
            success: {parseJSON -> Void in
                dispatch_async(dispatch_get_main_queue(), {self.updateUI(parseJSON)
                actInd.stopAnimating()})
           
            },
            failure: {code,message -> Void in
                if code == 500 {
                    //500: Server failure
                    println("Server Failure!!!!!")
                }
                else if code == 400 {
                    //400: Bad Client Request
                    println("Bad Request!!!!!")
                }
                else if code == 58 {
                    //58: No Internet Connection
                    println("No Connection!!!!!")
                }
                else if code == 599 {
                    //599: Request Timeout
                    println("Timeout!!!!!")
                }
            }
        )
    }
    func updateNSData(defaultImage:NSData){
        var current_posts:[[AnyObject]] = NSUserDefaults.standardUserDefaults().objectForKey("user_posts") as [[AnyObject]]
        var new_post = []
        var the_index = 0
        for i in 0...current_posts.count - 1 {
            if current_posts[i][0] as String == postid_ && String(current_posts[i][3] as String) == category {
                new_post = [String(self.postid_),title_field.text,defaultImage,category]
                the_index = i
            }
        }
        current_posts.removeAtIndex(the_index)
        current_posts.insert(new_post, atIndex: the_index)
        NSUserDefaults.standardUserDefaults().setObject(current_posts, forKey: "user_posts")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func editPostRequest() {
        var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 25, 25)) as UIActivityIndicatorView
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.navigationController?.view.addSubview(actInd)
        
        actInd.startAnimating()
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
            }
            else if(imageDifferences[i] == ""){
                imagesBase64.append("")
                if(notChoseDefault && UIImageList[i] != UIImage(named: "PlusDark.png")){
                    defaultImage = UIImageJPEGRepresentation(UIImageList[i],1)
                    notChoseDefault = false
                }
            }
            else{
                imageData = UIImageJPEGRepresentation(UIImageList[i],1)
                imageBase64 = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(0))
                imagesBase64.append(imageBase64)
                if(notChoseDefault && UIImageList[i] != UIImage(named: "PlusDark.png")){
                    defaultImage = imageData
                    notChoseDefault = false
                }
            }
        }
        if(defaultImage == nil){
            defaultImage = UIImageJPEGRepresentation(UIImage(named:"no_image.jpg"),1)
        }
        let username = NSUserDefaults.standardUserDefaults().objectForKey("username") as String
        var gonzaga_email = "0"
        if(gmail.image == UIImage(named: "ZagMail.png")){
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
        var round_trip = "0" // not sure
        if(round_trip_switch.on){
            round_trip = "1"
        }
        let params = ["username":username,          //common post information
            "description":descOutlet.text,
            "price":price.text,                   // |
            "title":title_field.text,
            "post_id" : self.postid_, // |
            "category" : self.category,
            "gonzaga_email":gonzaga_email,  // |
            "pref_email":pref_email,        // |
            "call":phone_bool,                   // |
            "text":text_bool,               // <
            "departure_date_time":leaves.text,  //rideshare specific
            "start_location":from.text,            // |
            "end_location":to.text,                // |
            "round_trip":round_trip,                    // |
            "return_date_time":comesBack.text,        // <
            "date_time":date.text,          //datelocation specific
            "location":location.text,           // <
            "isbn":ISBN.text,                    //book specific
            "images":imagesBase64]          //images array
            as Dictionary<String,AnyObject>
        var not_ready = true
        api_requester.POST("editpost/", params: params,
            success: {parseJSON -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    self.updateNSData(defaultImage!)
                    println("stopped spinning")
                    actInd.stopAnimating()
                })
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
        }
        
       //
       
    }
}




    

