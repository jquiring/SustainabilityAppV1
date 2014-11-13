//
//  ProfileController.swift
//  SustainabilityAppV1
//
//  Created by Jake Quiring on 11/2/14.
//  Copyright (c) 2014 Jake Quiring. All rights reserved.
//

import UIKit

class ProfileController: UIViewController, UITableViewDataSource,UITableViewDelegate{
    @IBOutlet weak var table: UITableView!
    var items = ["title 1","title 2","title 3"]
    let slide:CGFloat = 60
    let buttonHeight:String = "25"
    let barColor:UIColor =  UIColor(red: 0.633, green: 0.855, blue: 0.620, alpha: 1)
    let backgroundColor:UIColor = UIColor(red: 0.847, green: 0.847, blue: 0.847, alpha: 1)
    let buttonFont:UIFont? = UIFont(name: "HelveticaNeue-Light",size: 20)
    let labelFont:UIFont? = UIFont(name: "HelveticaNeue-UltraLight",size: 18)
    var arrayOfPosts: [ProfilePost] = [ProfilePost]()
    
    func setUpPosts(){
        var post1 = ProfilePost(title: "Fresh Ass Bike", imageName: "bike.jpg")
        var post2 = ProfilePost(title: "Cheap Tv for all you ladies out there", imageName: "tv.png")
        var post3 = ProfilePost(title: "Hurt myself Skating -- Need to sell", imageName: "skateboard.jpg")
        arrayOfPosts.append(post1)
        arrayOfPosts.append(post2)
        arrayOfPosts.append(post3)
    }
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
    @IBAction func logout(sender: AnyObject) {
        /*
        var alert = UIAlertController(title:nil, message: "Are you sure you wish to logout?", preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            var VC1 = self.storyboard?.instantiateViewControllerWithIdentifier("login") as ViewController
            let navController = UINavigationController(rootViewController: VC1)
            // Creating a navigation controller with VC1 at the root of the navigation stack.
            self.presentViewController(navController, animated:true, completion: nil)

            
        }))
    */

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        makeLayout()
        self.table.registerClass(UITableViewCell.self,forCellReuseIdentifier:"cell")
        self.setUpPosts()
      
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        
    }
    @IBAction func newPost(sender: AnyObject) {
        //Code to bring up new post page
    }
    //why is it making the layout wrong the first time
    func makeLayout() {
        //self.view.backgroundColor = UIColor(red: 0.847, green: 0.847, blue: 0.847, alpha: 1)
        self.view.backgroundColor = UIColor.lightGrayColor()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width - slide;
        let screenHeight = screenSize.height
        let buttonHeight = 35
        let labelHeight = 25
        let editProfileHeight = 64  
        let distanceFromTopVal  = 20
        let distanceBetweenButtonsVal = 1
        let bottomButtonPlacement = Int(screenHeight) - (buttonHeight*3) - labelHeight - editProfileHeight - distanceBetweenButtonsVal*5   // this might not work because we have to account for how long the list view is in this
        let view1 = UIButton.buttonWithType(UIButtonType.System) as UIButton
        let view2 = UIButton.buttonWithType(UIButtonType.System) as UIButton
        let view3 = UIButton.buttonWithType(UIButtonType.System) as UIButton
        let logoutButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        let postsLabel = UIButton.buttonWithType(UIButtonType.System) as UIButton
        
       // let yourPosts = UILabel as UILabel
       // var tableView:UITableView
        let viewsDictionary = ["view1":view1,"view2":view2,"view3":view3, "logoutButton":logoutButton, "postsLabel":postsLabel,"table":table]
        //here are the sizes used for the buttons - viewHeight is the button height, and the width is the entire screen - the 60 px layover
        let metricsDictionary = ["viewHeight": buttonHeight,"viewWidth":screenWidth, "screenHeight":screenHeight,"distanceFromTop": distanceFromTopVal,"distanceBetweenButtons":distanceBetweenButtonsVal,"bottomHeight": bottomButtonPlacement,"editProfileHeight":editProfileHeight,"labelHeight":labelHeight ]
    
        //edit profile
        view1.setTitle("⚙  Jake Q.", forState: UIControlState.Normal)
        view1.setTitleColor(UIColor.darkGrayColor(), forState: nil)
        view1.titleLabel!.font = UIFont(name: "HelveticaNeue-Light",size: 24)
        view1.setTranslatesAutoresizingMaskIntoConstraints(false)
        view1.backgroundColor = barColor
        view1.contentEdgeInsets = UIEdgeInsetsMake(0, 10, -22, 0)
        view1.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        //view1.setTitleColor(color:UIColor.whiteColor(), forState: UIControlState.Normal)
        view1.addTarget(self, action: "edit:", forControlEvents: UIControlEvents.TouchUpInside)
        let view1_constraint_H:Array = NSLayoutConstraint.constraintsWithVisualFormat("H:[view1(viewWidth)]", options: NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
        let view1_constraint_V:Array = NSLayoutConstraint.constraintsWithVisualFormat("V:[view1(editProfileHeight)]", options: NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
        view1.addConstraints(view1_constraint_H)
        view1.addConstraints(view1_constraint_V)
        //create a post
        view2.setTitle("Create a Post ➕", forState: UIControlState.Normal)
        view2.titleLabel!.font = buttonFont
        view2.setTranslatesAutoresizingMaskIntoConstraints(false)
        view2.backgroundColor = backgroundColor
        view2.addTarget(self, action: "newPost:", forControlEvents: UIControlEvents.TouchUpInside)
        let view2_constraint_H:Array = NSLayoutConstraint.constraintsWithVisualFormat("H:[view2(viewWidth)]", options: NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
        let view2_constraint_V:Array = NSLayoutConstraint.constraintsWithVisualFormat("V:[view2(viewHeight)]", options:
            NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
        view2.addConstraints(view2_constraint_H)
        view2.addConstraints(view2_constraint_V)

        //Posts label
        postsLabel.setTitle("Your Posts", forState: UIControlState.Normal)
        postsLabel.titleLabel!.font = labelFont
        postsLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        postsLabel.backgroundColor = backgroundColor
        postsLabel.userInteractionEnabled = false
        postsLabel.backgroundColor = UIColor.whiteColor()
        let postsLabel_constraint_H:Array = NSLayoutConstraint.constraintsWithVisualFormat("H:[postsLabel(viewWidth)]", options: NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
        let postsLabel_constraint_V:Array = NSLayoutConstraint.constraintsWithVisualFormat("V:[postsLabel(labelHeight)]", options:
            NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
        postsLabel.addConstraints(postsLabel_constraint_H)
        postsLabel.addConstraints(postsLabel_constraint_V)
       
        //table
        println("table created")
        table.setTranslatesAutoresizingMaskIntoConstraints(false)
        let table_constraint_H:Array = NSLayoutConstraint.constraintsWithVisualFormat("H:[table(viewWidth)]", options: NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
        let table_constraint_V:Array = NSLayoutConstraint.constraintsWithVisualFormat("V:[table(bottomHeight)]", options:
            NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
        table.addConstraints(table_constraint_H)
        table.addConstraints(table_constraint_V)

        //Logout
        logoutButton.setTitle("Logout", forState: UIControlState.Normal)
        logoutButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        logoutButton.backgroundColor = backgroundColor
        logoutButton.addTarget(self, action: "logout:", forControlEvents: UIControlEvents.TouchUpInside)
        let logout_constraint_H:Array = NSLayoutConstraint.constraintsWithVisualFormat("H:[logoutButton(viewWidth)]", options: NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
        let logout_constraint_V:Array = NSLayoutConstraint.constraintsWithVisualFormat("V:[logoutButton(viewHeight)]", options:
            NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
        logoutButton.titleLabel!.font = buttonFont
        logoutButton.addConstraints(logout_constraint_H)
        logoutButton.addConstraints(logout_constraint_V)

        //Help & FAQ
        view3.setTitle("Help & FAQ", forState: UIControlState.Normal)
        view3.setTranslatesAutoresizingMaskIntoConstraints(false)
        view3.backgroundColor = backgroundColor
        view3.addTarget(self, action: "helpAndFAQ:", forControlEvents: UIControlEvents.TouchUpInside)
        let view3_constraint_H:Array = NSLayoutConstraint.constraintsWithVisualFormat("H:[view3(viewWidth)]", options: NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
        let view3_constraint_V:Array = NSLayoutConstraint.constraintsWithVisualFormat("V:[view3(viewHeight)]", options:
            NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
        view3.titleLabel!.font = buttonFont
        view3.addConstraints(view3_constraint_H)
        view3.addConstraints(view3_constraint_V)


        //casts width to a string then uses the width to set the width of the screen (denoted as H for some reason)
        
        
        
        

        view.addSubview(view1)
        view.addSubview(view2)
        view.addSubview(view3)
        view.addSubview(postsLabel)
        view.addSubview(table)
        view.addSubview(logoutButton)

        //spaces it away from the top a little bit
        //this seems to be breaking the code right now
        let view_constraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[view1]-distanceBetweenButtons-[view2]-distanceBetweenButtons-[postsLabel]-distanceBetweenButtons-[table]-distanceBetweenButtons-[logoutButton]-distanceBetweenButtons-[view3]-|", options: NSLayoutFormatOptions.AlignAllLeading, metrics: metricsDictionary, views: viewsDictionary)
        
        view.addConstraints(view_constraint_V)
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
    //table view functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfPosts.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:ProfilePostCell = table.dequeueReusableCellWithIdentifier("Cell") as ProfilePostCell
        let person = arrayOfPosts[indexPath.row]
        cell.setCell(person.title, imageName: person.imageName)
        
        
        
        return cell
    
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
