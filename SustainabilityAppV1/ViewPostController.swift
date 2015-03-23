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
    let price = "Price"
    var title1 = "Post"
    var email_type = 0
   
    @IBOutlet var price_label: UILabel!
    @IBOutlet weak var description_label: UILabel!
    @IBOutlet weak var round_trip_label: UILabel!
    @IBOutlet weak var trip_location_label: UILabel!
    @IBOutlet var depature_date_label: UILabel!
    @IBOutlet var return_date_label: UILabel!
    @IBOutlet var isbn_label: UILabel!
    @IBOutlet weak var location_label: UILabel!
    @IBOutlet var date_time_label: UILabel!
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 25, 25)) as UIActivityIndicatorView
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
        self.tableView.tableFooterView = UIView()
        startRequest()
    }
    
    func startRequest() {
        self.tableView.userInteractionEnabled = false
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        actInd.startAnimating()
        self.navigationController?.view.addSubview(actInd)
        var api_requester: AgoraRequester = AgoraRequester()
        var post_id = NSUserDefaults.standardUserDefaults().objectForKey("post_id") as String
        var category = NSUserDefaults.standardUserDefaults().objectForKey("cat") as String
        let params = ["post_id": post_id, "category":category]
        var not_ready = true
        
        api_requester.POST("viewpost/", params: params,
            success: {parseJSON -> Void in
                dispatch_async(dispatch_get_main_queue(), {self.updateUI(parseJSON)
                        self.actInd.stopAnimating()
                        self.tableView.userInteractionEnabled = true

                })
            },
            failure: {code,message -> Void in
                self.actInd.stopAnimating()
                if(code == 400){
                    self.actInd.stopAnimating()
                    var alert = UIAlertController(title: "This post no longer exists", message: "Pull down to refresh", preferredStyle: UIAlertControllerStyle.Alert)
                    self.presentViewController(alert, animated: true, completion: nil)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }))

                }
                else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.actInd.stopAnimating()
                        var alert = UIAlertController(title: "Connection error", message: "Check signal and try", preferredStyle: UIAlertControllerStyle.Alert)
                        self.presentViewController(alert, animated: true, completion: nil)
                        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }))
                    })
                }
            }
        )
    }
    func createAlert(message:String, title:String?){
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
        }))
        
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
    func updateUI(parseJSON:NSDictionary){
        var category = NSUserDefaults.standardUserDefaults().objectForKey("cat") as String
        self.title1 = parseJSON["title"] as String
        gonzaga_email_ = parseJSON["gonzaga_email"] as String
        pref_email_ = parseJSON["gonzaga_email"] as String
        text_ = parseJSON["call"] as String
        call_ = parseJSON["text"] as String
        if(parseJSON["gonzaga_email"] as String == ""){
            self.zagMailContact.enabled = false
            self.zagMailContact.setImage(UIImage(named: "ZagMailOFF"), forState: UIControlState.Disabled)
            gonzaga_email_ = parseJSON["gonzaga_email"] as String
        }
        if(parseJSON["pref_email"] as String == ""){
            self.emailContact.enabled = false
            self.emailContact.setImage(UIImage(named: "eMailOFF"), forState: UIControlState.Disabled)
        }
        if(parseJSON["call"] as String == ""){
            self.callContact.enabled = false
            self.callContact.setImage(UIImage(named: "CallOFF"), forState: UIControlState.Disabled)
        }
        if(parseJSON["text"] as String == ""){
            self.textContact.enabled = false
            self.textContact.setImage(UIImage(named: "SMSOFF"), forState: UIControlState.Disabled)
        }
        self.price_label.text = parseJSON["price"] as? String
        self.description_label.text = parseJSON["description"] as? String
        self.round_trip_label.text = ""
        if category != "Ride Shares"{
            self.trip_location_label.text = ""
            self.depature_date_label.text = ""
            self.return_date_label.text = ""
        }
        if category == "Ride Shares"{
            self.trip_location_label.text = parseJSON["trip"] as? String
            self.depature_date_label.text = parseJSON["departure_date_time"] as? String
            if parseJSON["round_trip"] as Bool {
                self.round_trip_label.text = "Round trip"
                self.return_date_label.text = parseJSON["return_date_time"] as? String
            }
            else{
                self.return_date_label.text = ""
                self.round_trip_label.text = "One way"
            }
        }
        if category != "Events" && category != "Services"{
            self.date_time_label.text = ""
            self.location_label.text = ""
        }
        if category == "Events" || category == "Services"{
            self.date_time_label.text = parseJSON["date_time"] as? String
            self.location_label.text = parseJSON["location"] as? String
        }
        //Books
        if category != "Books"{
            self.isbn_label.text = ""
        }
        if category == "Books"{
            self.isbn_label.text = parseJSON["isbn"] as? String
        }
        var imageString: [String]=["","",""]
        imageString[0] = parseJSON["image1"]! as String
        imageString[1] = parseJSON["image2"]! as String
        imageString[2] = parseJSON["image3"]! as String
        if !imageString[0].isEmpty {
            let imageData1 = NSData(base64EncodedString: imageString[0], options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
            let image1 =  (UIImage(data: imageData1))
            self.pageImages.append(image1!)
        }
        else{
            let image1 = UIImage(named: "noImage")
            self.pageImages.append(image1!)
        }
        if !imageString[1].isEmpty {
            let imageData2 = NSData(base64EncodedString: imageString[1], options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
            let image2 =  (UIImage(data: imageData2))
            self.pageImages.append(image2!)
        }
        if !imageString[2].isEmpty {
            let imageData3 = NSData(base64EncodedString: imageString[2], options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
            let image3 =  (UIImage(data: imageData3))
            self.pageImages.append(image3!)
        }
        createScroll()
        if(pageImages.count == 1) {
            pages.hidden  =  true
        }
        pages.currentPage = 0
        pages.numberOfPages = pageImages.count
        self.tableView.reloadData()
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
    func reportPostRequest(){
        var post_id = NSUserDefaults.standardUserDefaults().objectForKey("post_id") as String
        var category = NSUserDefaults.standardUserDefaults().objectForKey("cat") as String
        var username =  NSUserDefaults.standardUserDefaults().objectForKey("username") as String
        var api_requester: AgoraRequester = AgoraRequester()
        
        let params = ["post_id":post_id,
            "category":category,
            "reporter": username]          //images array
            as Dictionary<String,AnyObject>
        api_requester.POST("reportpost/", params: params,
            success: {parseJSON -> Void in
                if(parseJSON["reported"] as String == "1"){
                    dispatch_async(dispatch_get_main_queue(), {
                        self.createAlert("Thank you for helping keep ZigZaga appropriate",title:"The post has been reported")
                    })
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), {
                        self.createAlert("You have already reported this post",title:nil)
                    })
                }
                
            },
            failure: {code,message -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    self.createAlert("Check signal and try again",title:"Connection error" )
                })
        })
    }
    @IBAction func reportPost(sender: AnyObject){
        let alertController = UIAlertController(title: nil, message:
             "Are you sure you wish to report this post for inappropriate content?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default,handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction!) in
                self.reportPostRequest()
        }))
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
        if(indexPath.section == 0 && indexPath.row == 1 && (price_label.text == "")){
            self.price_text.hidden = true
            return 0
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
        header.numberOfLines = 0
        header.font = UIFont(name: "HelveticaNeue-Light",size: 18)
        header.backgroundColor = UIColor(red: 0.633, green: 0.855, blue: 0.620, alpha: 0.8)
        header.textColor = UIColor.darkGrayColor()
        header.lineBreakMode = NSLineBreakMode.ByWordWrapping
        header.sizeToFit()
        
        return header
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        if(section == 0){
            return heightForView(title1, font: UIFont(name: "HelveticaNeue-Light",size: 18)!, width: UIScreen.mainScreen().bounds.width)-5
        }
        return 25
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
        mailComposerVC.setSubject("Inquiry regarding " + title1 + "\n")
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
        messageComposeVC.body = "Inquiry Regarding " + title + "\n"
        return messageComposeVC
    }
    
    // MFMessageComposeViewControllerDelegate callback - dismisses the view controller when the user is finished with it
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
}


