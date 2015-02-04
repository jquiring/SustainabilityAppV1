//
//  ViewPostController.swift
//  SustainabilityAppV1
//
//  Created by Jake Quiring on 12/1/14.
//  Copyright (c) 2014 Jake Quiring. All rights reserved.
//

import UIKit
import MessageUI
import Foundation

class ViewPostController: UITableViewController, UIScrollViewDelegate,MFMailComposeViewControllerDelegate{

    @IBOutlet var zagMailContact: UIButton!
    @IBOutlet var emailContact: UIButton!
    @IBOutlet var textContact: UIButton!
    @IBOutlet var callContact: UIButton!
    @IBOutlet var pages: UIPageControl!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControll: UIPageControl!
    var gonzaga_email_ = ""
    var pref_email_ = ""
    var call_ = ""
    var text_ = ""
    var scrollViewWidth:CGFloat = 0.0
    var pageImages: [UIImage] = []
    var frame: CGRect = CGRectMake(0, 0, 0, 0)
    let description1 = "description"
    let price = "price"             // |
    let title1 = "Post from Jake Quiring"            // |
    let category = "category"       // |
    var email_type = 0
    /*
    "gonzaga_email":gonzaga_email,  // |
    "pref_email":pref_email,        // |
    "call":phone,                   // |
    "text":text_bool,               // <
    */
    @IBOutlet var price_label: UILabel!
    @IBOutlet weak var description_label: UILabel!
    @IBOutlet weak var round_trip_label: UILabel!
    @IBOutlet weak var trip_location_label: UILabel!
    @IBOutlet var depature_date_label: UILabel!
    @IBOutlet var return_date_label: UILabel!
    @IBOutlet var isbn_label: UILabel!
    @IBOutlet weak var location_label: UILabel!
    @IBOutlet var date_time_label: UILabel!
    
    @IBOutlet weak var price_text: UILabel!
    @IBOutlet weak var description_text: UILabel!
    @IBOutlet weak var round_trip_text: UILabel!
    @IBOutlet weak var trip_location_text: UILabel!
    @IBOutlet weak var depature_date_text: UILabel!
    @IBOutlet weak var return_date_text: UILabel!
    @IBOutlet weak var isbn_text: UILabel!
    @IBOutlet weak var location_text: UILabel!
    @IBOutlet weak var date_text: UILabel!
    
    
    let messageComposer = MessageComposer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        scrollViewWidth = screenSize.width
        
       
        scrollView.delegate = self
        navigationController?.navigationBar.barStyle = UIBarStyle.Default
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.633, green: 0.855, blue: 0.620, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light",size: 24)!,NSForegroundColorAttributeName: UIColor.darkGrayColor()]

        
        self.tableView.reloadData()
        description_label.numberOfLines = 0
        trip_location_label.numberOfLines = 0
        depature_date_label.numberOfLines = 0
        return_date_label.numberOfLines = 0
        location_label.numberOfLines = 0
        date_time_label.numberOfLines = 0

        startRequest()
        createScroll()
        if(pageImages.count == 1) {
            pages.hidden  =  true
        }
        pages.currentPage = 0
        pages.numberOfPages = pageImages.count

    }
    
    func startRequest() {
        //create a mutable request with api view path /viewpost, set method to POST
        //kyle
        //var request = NSMutableURLRequest(URL: NSURL(string: "http://147.222.164.91:8000/viewpost")!)
        //trenton
        //var request = NSMutableURLRequest(URL: NSURL(string: "http://147.222.165.133:8000/viewpost/")!)
        //server
        var flag = true
        var request = NSMutableURLRequest(URL: NSURL(string: "http://147.222.165.3:8000/viewpost/")!)
        request.HTTPMethod = "POST"
        
        //open NSURLSession
        var session = NSURLSession.sharedSession()
        
        //parameter values
        //common post information ****
        var postid_ = NSUserDefaults.standardUserDefaults().objectForKey("post_id") as String
        var category_ = NSUserDefaults.standardUserDefaults().objectForKey("cat") as String
        
        //this is the parameters array that will be formulated as JSON.
        // We need both postid and category
        var params = ["post_id":postid_,          //post id so we find the post
            "category":category_]                 //category so we know what table to search
            as Dictionary<String,AnyObject>
        
        
        //Load body with JSON serialized parameters, set headers for JSON! (Star trek?)
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //_________________________________________________________________
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("In task")
            //read the message from the response
            var title_ = ""
            var description_ = ""
            var price_ = ""
            var departure_date_time_ = ""
            var return_date_time_ = ""
            var round_trip_ = false
            var trip_ = ""

            var isbn_ = ""
            var location_ = ""
            var date_time_ = ""
            var imageString: [String]=["","",""]
            var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &err) as? NSDictionary
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
            }
            
            else{
                if let parseJSON = json as? Dictionary<String,AnyObject>{
                    
                    title_ = parseJSON["title"] as String
                    description_ = parseJSON["description"] as String
                    price_ = parseJSON["price"] as String
                    self.gonzaga_email_ = parseJSON["gonzaga_email"] as String
                    self.pref_email_ = parseJSON["pref_email"] as String
                    self.call_ = parseJSON["call"] as String
                    self.text_ = parseJSON["text"] as String
                    
                    
                    if category_ == "Books"{
                        isbn_ = parseJSON["isbn"] as String
                    }
                    
                    if category_ == "Events" || category_ == "Services"{
                        println("We are in events/services")
                        location_ = parseJSON["location"] as String
                        date_time_ = parseJSON["date_time"] as String
                    }
                    
                    if category_ == "Ride Shares"{
                        departure_date_time_ = parseJSON["departure_date_time"] as String
                        round_trip_ = parseJSON["round_trip"] as Bool
                        trip_ = parseJSON["trip"] as String
                        if round_trip_{
                                return_date_time_ = parseJSON["return_date_time"] as String
                        }
                    }
                    
                    //The Three images are processed here
                    imageString[0] = parseJSON["image1"]! as String
                    imageString[1] = parseJSON["image2"]! as String
                    imageString[2] = parseJSON["image3"]! as String
                    if !imageString[0].isEmpty {
                        let imageData1 = NSData(base64EncodedString: imageString[0], options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
                        let image1 =  (UIImage(data: imageData1))
                        

                        self.pageImages.append(image1!)
                        
                        //do stuff with the image here
                    }
                    else{
                        //No image flag
                        let image1 = UIImage(named: "tv.png")
                        self.pageImages.append(image1!)
                        //CASE IN WHICH THE POST HAD NO IMAGE 1
                    }
                    if !imageString[1].isEmpty {
                        let imageData2 = NSData(base64EncodedString: imageString[1], options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
                        let image2 =  (UIImage(data: imageData2))
                        self.pageImages.append(image2!)
                        //do stuff with the image here
                    }
                    else{
                        //CASE IN WHICH THE POST HAD NO IMAGE 2
                    }
                    if !imageString[2].isEmpty {
                        let imageData3 = NSData(base64EncodedString: imageString[2], options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
                        let image3 =  (UIImage(data: imageData3))
                        self.pageImages.append(image3!)
                        //do stuff with the image here
                    }
                    else{
                        //CASE IN WHICH THE POST HAD NO IMAGE 3
                    }
                }
            }
           
            //downcast NSURLResponse object to NSHTTPURLResponse
            if let httpResponse = response as? NSHTTPURLResponse {
                
                //get the status code
                var status_code = httpResponse.statusCode
                
                //200 = OK: user created, carry on!
                if(status_code == 200){
                    
                    print("Title = ")
                    println(title_)
                    print("Description = ")
                    println(description_)
                    print("Category = ")
                    println(category_)
                    print("Price = ")
                    println(price_)
                    print("Gonzaga email = ")
                    if(self.gonzaga_email_ == ""){
                        self.zagMailContact.enabled = false
                        
                        self.zagMailContact.setImage(UIImage(named: "ZagMailOFF"), forState: UIControlState.Disabled)
                    }
                    println(self.gonzaga_email_)
                    print("Pref email = ")
                    if(self.pref_email_ == ""){
                        self.emailContact.enabled = false
                        
                        self.emailContact.setImage(UIImage(named: "eMailOFF.png"), forState: UIControlState.Disabled)

                    }
                    
                    println(self.pref_email_)
                    print("Call = ")
                    if(self.call_ == ""){
                        self.callContact.enabled = false
                        
                        self.callContact.setImage(UIImage(named: "CallOFF.png"), forState: UIControlState.Disabled)
                    }
                    println(self.call_)
                    print("Text = ")
                    if(self.text_ == ""){
                        self.textContact.enabled = false
                        
                        self.textContact.setImage(UIImage(named: "SMSOFF.png"), forState: UIControlState.Disabled)
                    }
                    println(self.text_)
                    
                    
                    self.price_label.text = price_
                    self.description_label.text = description_
                    
                    
                    //RideShares
                    self.round_trip_label.text = ""
                    if category_ != "Ride Shares"{
                        self.trip_location_label.text = ""
                        self.depature_date_label.text = ""
                        self.return_date_label.text = ""

                    }
                    if category_ == "Ride Shares"{
                        self.trip_location_label.text = trip_
                        self.depature_date_label.text = departure_date_time_
                        self.return_date_label.text = return_date_time_
                        
                        if round_trip_{
                            self.round_trip_label.text = "Round trip"
                        }
                        else{
                            self.round_trip_label.text = "One way"
                        }
                    }
                    //Events & Services
                    if category_ != "Events" && category_ != "Services"{
                        self.date_time_label.text = ""
                        self.location_label.text = ""
                    }
                    if category_ == "Events" || category_ == "Services"{
                        self.date_time_label.text = date_time_
                        self.location_label.text = location_
                    }
                    //Books
                    if category_ != "Books"{
                        self.isbn_label.text = ""
                    }
                    if category_ == "Books"{
                        self.isbn_label.text = isbn_
                    }
                    flag = false
                }
                //400 = BAD_REQUEST: error in creating user, display error!
                else if(status_code == 400){
                    println(title_)
                    flag = false
                }
                    //500 = INTERNAL_SERVER_ERROR. Oh snap *_*
                else if(status_code == 500){
                    println("The server is down! Call the fire department!")
                    
                    flag = false
                }
            } else {
                println("Error in casting response, data incomplete")
                
            }
        })
        task.resume()
        
        while(flag){
            
        }
    }
    
    func createScroll(){
        for index in 0..<pageImages.count {
            var image:UIImage  = pageImages[index]
            var newImage = image.resizeToBoundingSquare(boundingSquareSideLength: scrollViewWidth)
            frame.origin.x = scrollViewWidth * CGFloat(index)
            frame.origin.y = 0
            frame.size = CGSize(width: scrollViewWidth, height: scrollViewWidth)
            self.scrollView.pagingEnabled = true
            
            var subView = UIImageView(frame: frame)
            subView.image = newImage
            self.scrollView.addSubview(subView)
        }
        
        self.scrollView.contentSize = CGSizeMake(scrollViewWidth * CGFloat(pageImages.count), scrollView.contentSize.height)
    }

    @IBAction func done(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    //Actions for the contact buttons
    @IBAction func zagmailIsTouched(sender: AnyObject) {
        email_type = 0
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
       
    }
    @IBAction func prefEmailIsTouched(sender: AnyObject) {
        email_type = 1
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    @IBAction func textIsTouched(sender: AnyObject) {
        if (messageComposer.canSendText()) {
            let messageComposeVC = messageComposer.configuredMessageComposeViewController(title1,text_: self.text_)
            presentViewController(messageComposeVC, animated: true, completion: nil)
        }
        else {
            // Let the user know if his/her device isn't able to send text messages
            let errorAlert = UIAlertView(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", delegate: self, cancelButtonTitle: "OK")
            errorAlert.show()
        }
    }
    @IBAction func phoneIsTouched(sender: AnyObject) {
        let alertController = UIAlertController(title: "Call " + self.call_  + "?", message:
            nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default,handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction!) in
            var url:NSURL = NSURL(string: "tel://" + self.call_)!
            UIApplication.sharedApplication().openURL(url)}))
        presentViewController(alertController, animated: true, completion: nil)
   
    }
    
    
   override func scrollViewDidScroll(scrollView: UIScrollView) {
        var pageWidth = scrollViewWidth // you need to have a **iVar** with getter for scrollView
        var fractionalPage = self.scrollView.contentOffset.x / pageWidth;
        var page = lround(Double(fractionalPage))
        self.pages.currentPage = page;
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width:scrollViewWidth * CGFloat(pageImages.count), height: scrollView.contentSize.height)
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        var myFont = UIFont(name: "HelveticaNeue-Light",size: 17)
        
        //This needs to be only the picture cell
        if(indexPath.section == 0 && indexPath.row == 0 ){
            return scrollViewWidth + 20
        }
        //Contact options section
        if(indexPath.section == 1){
            return 77
        }
        //Description
        if(indexPath.section == 0 && indexPath.row == 2 && description_label.text == ""){
            self.description_text.hidden = true
            return 0
        }
        if(indexPath.section == 0 && indexPath.row == 2){
            var return_val = heightForView(description_label.text!, font: myFont!, width: (screenSize.width - 110))
            return return_val
        }
        //Hiding post specific information based upon category
        if(indexPath.section == 0 && indexPath.row == 3 && round_trip_label.text == ""){
            self.round_trip_text.hidden = true
            return 0
        }
        if(indexPath.section == 0 && indexPath.row == 4 && trip_location_label.text == ""){
            self.trip_location_text.hidden = true
            return 0
        }
        if(indexPath.section == 0 && indexPath.row == 4){
            var return_val = heightForView(trip_location_label.text!, font: myFont!, width: (screenSize.width - 110))
            return return_val
        }
        if(indexPath.section == 0 && indexPath.row == 5 && depature_date_label.text == ""){
            self.depature_date_text.hidden = true
            return 0
        }
        if(indexPath.section == 0 && indexPath.row == 5){
            var return_val = heightForView(depature_date_label.text!, font: myFont!, width: (screenSize.width - 110))
            return return_val
        }
        if(indexPath.section == 0 && indexPath.row == 6 && return_date_label.text == ""){
            self.return_date_text.hidden = true
            return 0
        }
        if(indexPath.section == 0 && indexPath.row == 6){
            var return_val = heightForView(return_date_label.text!, font: myFont!, width: (screenSize.width - 110))
            return return_val
        }
        if(indexPath.section == 0 && indexPath.row == 7 && isbn_label.text == ""){
            self.isbn_text.hidden = true
            return 0
        }
        if(indexPath.section == 0 && indexPath.row == 8 && location_label.text == ""){
            self.location_text.hidden = true
            return 0
        }
        if(indexPath.section == 0 && indexPath.row == 8){
            var return_val = heightForView(location_label.text!, font: myFont!, width: (screenSize.width - 110))
            return return_val
        }
        
        if(indexPath.section == 0 && indexPath.row == 9 && date_time_label.text == ""){
            self.date_text.hidden = true
            return 0
        }
        if(indexPath.section == 0 && indexPath.row == 9){
            var return_val = heightForView(date_time_label.text!, font: myFont!, width: (screenSize.width - 110))
            return return_val
        }
        return 30
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height + 15
    }
    
    override func tableView(tableView: (UITableView!), viewForHeaderInSection section: Int) -> (UIView!){
        var header : UILabel = UILabel()
        if(section == 0){
            header.text = " " + title1
        }
        else{
            header.text = " Contact the seller"
        }
        header.font = UIFont(name: "HelveticaNeue-Light",size: 18)
        header.backgroundColor = UIColor(red: 0.633, green: 0.855, blue: 0.620, alpha: 0.8)
        header.textColor = UIColor.darkGrayColor()
        
        return header
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{

        return 24
    }
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        if(email_type == 1){
            mailComposerVC.setToRecipients([pref_email_]) //prefered email
        }
        else{
            mailComposerVC.setToRecipients([gonzaga_email_]) //zagmail
        }
        mailComposerVC.setSubject("Inqury regarding " + title1)
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}

class MessageComposer: NSObject, MFMessageComposeViewControllerDelegate {
    
    // A wrapper function to indicate whether or not a text message can be sent from the user's device
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
    
    // Configures and returns a MFMessageComposeViewController instance
    func configuredMessageComposeViewController(title:String,text_:String) -> MFMessageComposeViewController {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self  //  Make sure to set this property to self, so that the controller can be dismissed!
        
        //these need to be fixed
        messageComposeVC.recipients = [text_]
        messageComposeVC.body = "inqury Regarding " + title
        return messageComposeVC
    }
    
    // MFMessageComposeViewControllerDelegate callback - dismisses the view controller when the user is finished with it
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
}


