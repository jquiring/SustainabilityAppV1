//
//  ViewPostController.swift
//  SustainabilityAppV1
//
//  Created by Jake Quiring on 12/1/14.
//  Copyright (c) 2014 Jake Quiring. All rights reserved.
//

import UIKit
import MessageUI

class ViewPostController: UITableViewController, UIScrollViewDelegate,MFMailComposeViewControllerDelegate{

    @IBOutlet var pages: UIPageControl!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControll: UIPageControl!
    var scrollViewWidth:CGFloat = 0.0
    var pageImages: [UIImage] = []
    var pageViews: [UIImageView?] = []
    var images = ["bike.jpg", "tv.png","skateboard.jpg"]
    var colors:[UIColor] = [UIColor.redColor(), UIColor.blueColor(), UIColor.greenColor(), UIColor.yellowColor()]
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
    @IBOutlet var round_trip_label: UILabel!
    @IBOutlet var start_location_label: UILabel!
    @IBOutlet var end_location_label: UILabel!
    @IBOutlet var depature_date_label: UILabel!
    @IBOutlet var return_date_label: UILabel!
    @IBOutlet var isbn_label: UILabel!
    @IBOutlet var location_label: UILabel!
    @IBOutlet var date_time_label: UILabel!
    
    let messageComposer = MessageComposer()
    
    let departure_date = "departure_date_time" //rideshare specific
    let start_location = "start_location"           // |
    let end_location = "end_location start location begin stop end again"               // |
    let round_trip = true                           // |
    let return_date = "return_date_time"            // <
    let date_time = "date_time"         //datelocation specific
    let location = "location"           // <
    let isbn = "isbn"
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        scrollViewWidth = screenSize.width
        pages.numberOfPages = images.count
        if(images.count == 1) {
            pages.hidden  =  true
        }
        pages.currentPage = 0
        scrollView.delegate = self
        navigationController?.navigationBar.barStyle = UIBarStyle.Default
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.633, green: 0.855, blue: 0.620, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light",size: 24)!,NSForegroundColorAttributeName: UIColor.darkGrayColor()]

        createScroll()
        initializeLabels()
        
        self.tableView.reloadData()
        //setUpImageGestures()
    }
    func initializeLabels(){
        if(round_trip){
            round_trip_label.text = "Round trip"
        }
        else{
            round_trip_label.text = "One way"
        }
        price_label.text = price
        start_location_label.text = start_location
        end_location_label.text = end_location
        depature_date_label.text = departure_date
        return_date_label.text = return_date
        isbn_label.text = isbn
        location_label.text = location
        date_time_label.text = date_time
    }
    func createScroll(){
        for index in 0..<images.count {
            var image:UIImage  = UIImage(named: images[index])!
            var newImage = image.resizeToBoundingSquare(boundingSquareSideLength: scrollViewWidth)
            frame.origin.x = scrollViewWidth * CGFloat(index)
            frame.origin.y = 0
            frame.size = CGSize(width: scrollViewWidth, height: scrollViewWidth)
            self.scrollView.pagingEnabled = true
            
            var subView = UIImageView(frame: frame)
            subView.image = newImage
            self.scrollView.addSubview(subView)
        }
        
        self.scrollView.contentSize = CGSizeMake(scrollViewWidth * CGFloat(images.count), scrollView.contentSize.height)
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
            let messageComposeVC = messageComposer.configuredMessageComposeViewController()
            presentViewController(messageComposeVC, animated: true, completion: nil)
        }
        else {
            // Let the user know if his/her device isn't able to send text messages
            let errorAlert = UIAlertView(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", delegate: self, cancelButtonTitle: "OK")
            errorAlert.show()
        }
    }
    @IBAction func phoneIsTouched(sender: AnyObject) {
        let alertController = UIAlertController(title: "Would you like to call the seller right now?", message:
            nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default,handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction!) in
            var url:NSURL = NSURL(string: "tel://5033175476")!
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
        scrollView.contentSize = CGSize(width:scrollViewWidth * CGFloat(images.count), height: scrollView.contentSize.height)
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        //This needs to be only the picture cell
        if(indexPath.section == 0 && indexPath.row == 0 ){
            return scrollViewWidth + 20
        }
        if(indexPath.section == 1){
            return 77
        }
        return 30
    }
    
    override func tableView(tableView: (UITableView!), viewForHeaderInSection section: Int) -> (UIView!){
        print(section)
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
            mailComposerVC.setToRecipients(["someone@somewhere.com"]) //prefered email
        }
        else{
            mailComposerVC.setToRecipients(["someone@somewhere.com"]) //zagmail
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
    func configuredMessageComposeViewController() -> MFMessageComposeViewController {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self  //  Make sure to set this property to self, so that the controller can be dismissed!
        
        //these need to be fixed
        messageComposeVC.recipients = ["14087721993"]
        messageComposeVC.body = "Hey friend - Just sending a text message in-app using Swift!"
        return messageComposeVC
    }
    
    // MFMessageComposeViewControllerDelegate callback - dismisses the view controller when the user is finished with it
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

