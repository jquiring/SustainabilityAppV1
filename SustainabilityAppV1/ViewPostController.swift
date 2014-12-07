//
//  ViewPostController.swift
//  SustainabilityAppV1
//
//  Created by Jake Quiring on 12/1/14.
//  Copyright (c) 2014 Jake Quiring. All rights reserved.
//

import UIKit

class ViewPostController: UITableViewController, UIScrollViewDelegate{

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
    let price = "price"                // |
    let title1 = "title"                  // |
    let category = "category"           // |
    /*
    "gonzaga_email":gonzaga_email,  // |
    "pref_email":pref_email,        // |
    "call":phone,                   // |
    "text":text_bool,
    // <
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
    @IBOutlet var gmail: UIImageView!
    @IBOutlet var pEmail: UIImageView!
    @IBOutlet var text: UIImageView!
    @IBOutlet var phone: UIImageView!
    
    let departure_date = "departure_date_time" //rideshare specific
    let start_location = "start_location"            // |
    let end_location = "end_location"               // |
    let round_trip = true                   // |
    let return_date = "return_date_time"// <
    let date_time = "date_time"         //datelocation specific
    let location = "location"           // <
    let isbn = "isbn"
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        scrollViewWidth = screenSize.width
       //self.scrollView.setContentSize(CGSize(width: scrollViewWidth, height: 0))
        pages.numberOfPages = images.count
        if(images.count == 1) {
            pages.hidden  =  true
        }
        pages.currentPage = 0
        scrollView.delegate = self
        navigationController?.navigationBar.barStyle = UIBarStyle.Default
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.633, green: 0.855, blue: 0.620, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light",size: 24)!,NSForegroundColorAttributeName: UIColor.whiteColor()]
        createScroll()
        initializeLabels()
        
        self.tableView.reloadData()
        setUpImageGestures()
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
    func setUpImageGestures(){
        
        //TODO:images will be changed to image specifics
        let gestureRecogniserGmail = UITapGestureRecognizer(target: self, action: Selector("gMailToutched"))
        self.gmail.addGestureRecognizer(gestureRecogniserGmail)
        self.gmail.image = UIImage(named:"bike.jpg")
        
        let gestureRecogniserPEmail = UITapGestureRecognizer(target: self, action: Selector("pEmailToutched"))
        self.pEmail.addGestureRecognizer(gestureRecogniserPEmail)
        self.pEmail.image = UIImage(named:"bike.jpg")
        
        let gestureRecogniserText = UITapGestureRecognizer(target: self, action: Selector("textToutched"))
        self.text.addGestureRecognizer(gestureRecogniserText)
        self.text.image = UIImage(named:"bike.jpg")
        
        let gestureRecogniserPhone = UITapGestureRecognizer(target: self, action: Selector("phoneToutched"))
        self.phone.addGestureRecognizer(gestureRecogniserPhone)
        self.phone.image = UIImage(named:"bike.jpg")
    }
   override func scrollViewDidScroll(scrollView: UIScrollView) {
        var pageWidth = scrollViewWidth // you need to have a **iVar** with getter for scrollView
        var fractionalPage = self.scrollView.contentOffset.x / pageWidth;
        var page = lround(Double(fractionalPage))
        self.pages.currentPage = page;
    }
    func gMailToutched(){
        if(self.gmail.image!.isEqual(UIImage(named:"bike.jpg"))){
            println("in here")
            self.gmail.image = UIImage(named:"tv.png")
        }
        else {
            self.gmail.image = UIImage(named:"bike.jpg")
        }
        println("touched")
    }
    func pEmailToutched(){
        if(self.pEmail.image!.isEqual(UIImage(named:"bike.jpg"))){
            self.pEmail.image = UIImage(named:"tv.png")
        }
        else{
            self.pEmail.image = UIImage(named:"bike.jpg")
        }
    }
    func textToutched(){
        if(self.text.image!.isEqual(UIImage(named:"bike.jpg"))){
            self.text.image = UIImage(named:"tv.png")
        }
        else{
            self.text.image = UIImage(named:"bike.jpg")
        }
    }
    func phoneToutched(){
        println("phone touched")
        if((self.phone.image!.isEqual(UIImage(named:"bike.jpg")))){
            self.phone.image = UIImage(named:"tv.png")
        }
        else{
            self.phone.image = UIImage(named:"bike.jpg")
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width:scrollViewWidth * CGFloat(images.count), height: scrollView.contentSize.height)
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        println("hello")
        //This needs to be only the picture cell
        if(indexPath.section == 0 && indexPath.row == 0 ){
            return scrollViewWidth + 20
        }
        if(indexPath.section == 1){
            return 45
        }
        return 20
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
        header.backgroundColor = UIColor.lightGrayColor()
        
        return header
    }
    

}


