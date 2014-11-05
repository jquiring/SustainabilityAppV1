//
//  ProfileController.swift
//  SustainabilityAppV1
//
//  Created by Jake Quiring on 11/2/14.
//  Copyright (c) 2014 Jake Quiring. All rights reserved.
//

import UIKit

class ProfileController: UIViewController{
    let slide:CGFloat = 60
    let buttonHeight:String = "25"
    
    @IBAction func edit(sender: AnyObject) {
        var VC1 = self.storyboard?.instantiateViewControllerWithIdentifier("editUser") as EditUserController
        let navController = UINavigationController(rootViewController: VC1)
        // Creating a navigation controller with VC1 at the root of the navigation stack.
        self.presentViewController(navController, animated:true, completion: nil)
        
    }
    @IBAction func helpAndFAQ(sender: AnyObject) {
        var VC1 = self.storyboard?.instantiateViewControllerWithIdentifier("helpAndFAQ") as HelpAndFAQController
        let navController = UINavigationController(rootViewController: VC1)
        // Creating a navigation controller with VC1 at the root of the navigation stack.
        self.presentViewController(navController, animated:true, completion: nil)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        makeLayout()
        println("view did load")
      
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        
    }
    @IBAction func newPost(sender: AnyObject) {
        //Code to bring up new post page
    }
    //why is it making the layout wrong the first time
    func makeLayout() {
        println("make Layout called")
        self.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.backgroundColor = UIColor.darkGrayColor()

        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width - slide;
        let screenHeight = screenSize.height
        let buttonHeight = 25
        let distanceFromTopVal  = 20
        let distanceBetweenButtonsVal = 13
        let bottomButtonPlacement = Int(screenHeight) - (buttonHeight*3) - distanceFromTopVal - distanceBetweenButtonsVal   // this might not work because we have to account for how long the list view is in this
        let view1 = UIButton.buttonWithType(UIButtonType.System) as UIButton
        let view2 = UIButton.buttonWithType(UIButtonType.System) as UIButton
        let view3 = UIButton.buttonWithType(UIButtonType.System) as UIButton
       // var tableView:UITableView
        let viewsDictionary = ["view1":view1,"view2":view2,"view3":view3]
        //here are the sizes used for the buttons - viewHeight is the button height, and the width is the entire screen - the 60 px layover
        let metricsDictionary = ["viewHeight": buttonHeight,"viewWidth":screenWidth, "screenHeight":screenHeight,"distanceFromTop": distanceFromTopVal,"distanceBetweenButtons":distanceBetweenButtonsVal,"bottomHeight": bottomButtonPlacement ]
    
        //edit profile
        view1.setTitle("Edit your Profile", forState: UIControlState.Normal)
        view1.setTranslatesAutoresizingMaskIntoConstraints(false)
        view1.backgroundColor = UIColor.darkGrayColor()
        //view1.setTitleColor(color:UIColor.whiteColor(), forState: UIControlState.Normal)
        view1.addTarget(self, action: "edit:", forControlEvents: UIControlEvents.TouchUpInside)
        //view1.titleLabel!.font = UIFont(name:"Helvetica Neue UltraLight",size: 12)
        let view1_constraint_H:Array = NSLayoutConstraint.constraintsWithVisualFormat("H:[view1(viewWidth)]", options: NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
        let view1_constraint_V:Array = NSLayoutConstraint.constraintsWithVisualFormat("V:[view1(viewHeight)]", options: NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
        view1.addConstraints(view1_constraint_H)
        view1.addConstraints(view1_constraint_V)
        //create a post
        view2.setTitle("Create a Post", forState: UIControlState.Normal)
        view2.setTranslatesAutoresizingMaskIntoConstraints(false)
        view2.backgroundColor = UIColor.lightGrayColor()
        view2.addTarget(self, action: "newPost:", forControlEvents: UIControlEvents.TouchUpInside)
        let view2_constraint_H:Array = NSLayoutConstraint.constraintsWithVisualFormat("H:[view2(viewWidth)]", options: NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
        let view2_constraint_V:Array = NSLayoutConstraint.constraintsWithVisualFormat("V:[view2(viewHeight)]", options:
            NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
        view2.addConstraints(view2_constraint_H)
        view2.addConstraints(view2_constraint_V)
        //Help & FAQ
        view3.setTitle("Help & FAQ", forState: UIControlState.Normal)
        view3.setTranslatesAutoresizingMaskIntoConstraints(false)
        view3.backgroundColor = UIColor.lightGrayColor()
        view3.addTarget(self, action: "helpAndFAQ:", forControlEvents: UIControlEvents.TouchUpInside)
        let view3_constraint_H:Array = NSLayoutConstraint.constraintsWithVisualFormat("H:[view3(viewWidth)]", options: NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
        let view3_constraint_V:Array = NSLayoutConstraint.constraintsWithVisualFormat("V:[view3(viewHeight)]", options:
            NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
        
        view3.addConstraints(view3_constraint_H)
        view3.addConstraints(view3_constraint_V)


        //casts width to a string then uses the width to set the width of the screen (denoted as H for some reason)
        
        
        
        

        view.addSubview(view1)
        view.addSubview(view2)
        view.addSubview(view3)

        //spaces it away from the top a little bit
        //this seems to be breaking the code right now
        let view_constraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-distanceFromTop-[view1]-distanceBetweenButtons-[view2]-bottomHeight-[view3]|", options: NSLayoutFormatOptions.AlignAllLeading, metrics: metricsDictionary, views: viewsDictionary)
        
        view.addConstraints(view_constraint_V)
        println("make layout finished")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        return nil
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
