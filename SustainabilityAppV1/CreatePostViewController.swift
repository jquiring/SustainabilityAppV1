//
//  CreatePostViewController.swift
//  SustainabilityAppV1
//
//  Created by Lucas Orlita on 11/17/14.
//  Copyright (c) 2014 Jake Quiring. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate {
    var orientation: UIImageOrientation = .Up
    @IBOutlet weak var cat_picker: UIPickerView!
    
    @IBOutlet weak var title_field: UITextField!
    var currentImage:UIImageView = UIImageView()
    @IBOutlet var image1: UIImageView!
    var picker:UIImagePickerController?=UIImagePickerController()
    var popover:UIPopoverController?=nil
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    let pickerData = ["Books","Electronics","Furniture","Appliances & Kitchen","Ride Shares","Services","Events","Recreation"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cat_picker.delegate = self
        cat_picker.dataSource = self
        picker!.delegate=self
        //image1.
        // Do any additional setup after loading the view.
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
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        var touch = touches.anyObject()?.locationInView(self.view)
        if(CGRectContainsPoint(image1.frame, touch!)){
            currentImage = self.image1
            getImage()
        }
        /*
        else if(CGRectContainsPoint(image2.frame, touch!){
            currentImage = self.image2
            getImage()
        }
        else if(CGRectContainsPoint(image3.frame, touch!){
            currentImage = self.image3
            getImage()
        }
        */

    }
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
        let thumbNail = newImage.resizeToBoundingSquare(boundingSquareSideLength:400)
        picker.dismissViewControllerAnimated(true, completion: nil)
        currentImage.image=thumbNail    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController!)
    {
        println("picker cancel.")
        picker .dismissViewControllerAnimated(true, completion: nil)
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
