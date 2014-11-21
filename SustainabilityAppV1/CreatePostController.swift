//
//  CreatePostController.swift
//  SustainabilityAppV1
//
//  Created by Jake Quiring on 11/19/14.
//  Copyright (c) 2014 Jake Quiring. All rights reserved.
//

import UIKit


class CreatePostController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate {
    
   
    var orientation: UIImageOrientation = .Up
        var currentImage:UIImageView = UIImageView()
  
    var picker:UIImagePickerController?=UIImagePickerController()
    var popover:UIPopoverController?=nil
   
    @IBOutlet var gmail: UIImageView!
    @IBOutlet var pEmail: UIImageView!
    @IBOutlet var text: UIImageView!
    @IBOutlet var phone: UIImageView!
 
    @IBOutlet var image1: UIImageView!
    @IBOutlet var image2: UIImageView!
    @IBOutlet var image3: UIImageView!
    let date_picker:UIDatePicker = UIDatePicker()
   // @IBOutlet var rideDetials: UITableViewSection!
    @IBOutlet var descOutlet: UITextView!
    @IBOutlet var title_field: UITextField!
    weak var cat_picker: UIPickerView!
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
   
    let pickerData = ["Books","Electronics","Furniture","Appliances & Kitchen","Ride Shares","Services","Events","Recreation","Clothing"]
    let categoryTitles = ["  Category","  Title","  Description","  Pictures","  Price","  Ride Details","  How would you like to be contacted?"]
    override func viewDidLoad() {
        super.viewDidLoad()

        picker!.delegate=self
        //intializeCatPicker()
        initializeDatePicker()
        navigationController?.navigationBar.barStyle = UIBarStyle.Default
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.633, green: 0.855, blue: 0.620, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light",size: 24)!,NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        
        setUpImageGestures()

        //image1.
        // Do any additional setup after loading the view.
    }
    func doneAction() {
 
        self.title_field.resignFirstResponder()
    }
    //TODO: title field changed to cat_field.
    func intializeCatPicker(){
        var item = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done,
            target: self, action: "doneAction")
        var toolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.bounds.size.width, 44))
        toolbar.setItems([item], animated: true)
        self.title_field.inputAccessoryView = toolbar
        var tempPicker = UIPickerView()
        tempPicker.delegate = self
        tempPicker.dataSource = self
        self.cat_picker = tempPicker
        self.title_field.inputView = cat_picker
    }
    func initializeDatePicker(){
        var item = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done,
            target: self, action: "doneAction")
        var toolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.bounds.size.width, 44))
        toolbar.setItems([item], animated: true)
        self.title_field.inputAccessoryView = toolbar
        
        let currentDate = NSDate()  //5 -  get the current date
        date_picker.minimumDate = currentDate
        self.title_field.inputView = date_picker
        date_picker.addTarget(self, action: Selector("dataPickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    func dataPickerChanged(date_picker:UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        var strDate = dateFormatter.stringFromDate(date_picker.date)
        title_field.text = strDate
    }
    func setUpImageGestures(){
        
        let gestureRecogniser1 = UITapGestureRecognizer(target: self, action: Selector("image1Toutched"))
        self.image1.addGestureRecognizer(gestureRecogniser1)
        let tap = UITapGestureRecognizer(target: self, action: Selector("tableToutched"))
        //let scroll = UIPanGestureRecognizer(target: self, action: Selector("tableToutched"))
        //self.view.addGestureRecognizer(scroll)
        self.view.addGestureRecognizer(tap)
        let gestureRecogniser2 = UITapGestureRecognizer(target: self, action: Selector("image2Toutched"))
        self.image2.addGestureRecognizer(gestureRecogniser2)
        
        let gestureRecogniser3 = UITapGestureRecognizer(target: self, action: Selector("image3Toutched"))
        self.image3.addGestureRecognizer(gestureRecogniser3)
        
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
    func image1Toutched(){
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
        title_field.resignFirstResponder()
        descOutlet.resignFirstResponder()
        println("table touched")
    }
    //TODO: change these to gray/colored images of contact options
    func gMailToutched(){
        if((self.gmail.image!.isEqual(UIImage(named:"bike.jpg")))){
            println("in here")
            self.gmail.image = UIImage(named:"tv.png")
        }
        else{
            self.gmail.image = UIImage(named:"bike.jpg")
        }
    }
    func pEmailToutched(){
        if((self.pEmail.image!.isEqual(UIImage(named:"bike.jpg")))){
            self.pEmail.image = UIImage(named:"tv.png")
        }
        else{
            self.pEmail.image = UIImage(named:"bike.jpg")
        }
    }
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        title_field.text = "\(pickerData[row])"
    }
    func textToutched(){
        var oldImage:UIImage = self.text.image!
        var bikeImage:UIImage = UIImage(named:"bike.jpg")!
        if(oldImage == UIImage(named:"tv.png")){
            println("this printed")
        }
        if(oldImage != bikeImage){
            self.text.image = UIImage(named:"bike.jpg")
        }
        else{
            self.text.image = UIImage(named:"tv.png")
        }
    }
    func phoneToutched(){
        println("phone touched")
        if((self.phone.image!.isEqual(UIImage(named:"bike.jpg")))){
            self.phone.image = UIImage(named:"tv.png")
        }
        else{
            self.phone.image = UIImage(named:"bike.jpg")
        }    }
    func getImage() {
        var alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        var cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openCamera()
                
        }
        var gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openGallary()
        }
        var deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.currentImage.image = UIImage(named:"tv.png")
        }
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
            {
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
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: alert)
            popover!.presentPopoverFromRect(image1.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            picker!.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(picker!, animated: true, completion: nil)
        }
        else
        {
            openGallary()
        }
    }
    func openGallary()
    {
        picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(picker!, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: picker!)
            popover!.presentPopoverFromRect(currentImage.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: NSDictionary!)
    {
        let newImage = info[UIImagePickerControllerOriginalImage] as UIImage
        let thumbNail = newImage.resizeToBoundingSquare(boundingSquareSideLength:800)
        picker.dismissViewControllerAnimated(true, completion: nil)
        currentImage.image=newImage
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController!)
    {
        println("picker cancel.")
        picker .dismissViewControllerAnimated(true, completion: nil)
    }
    override func tableView(tableView: (UITableView!), viewForHeaderInSection section: Int) -> (UIView!) {
        print(section)
        var header : UILabel = UILabel()
        header.text = categoryTitles[section]
        header.font = UIFont(name: "HelveticaNeue-Light",size: 18)
        header.backgroundColor = UIColor(red: 0.633, green: 0.855, blue: 0.620, alpha: 1)

        return header
    }

}
extension UIImage
{
    func resizeToBoundingSquare(#boundingSquareSideLength : CGFloat) -> UIImage
    {
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