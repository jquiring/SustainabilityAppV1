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
        var post1 = ProfilePost(title: "Fresh Bike", imageName: "bike.jpg",id:"id1")
        var post2 = ProfilePost(title: "Cheap Tv for all you ladies out there and now the title is a litte bit bigger", imageName: "tv.png",id:"id2")
        var post3 = ProfilePost(title: "Hurt myself Skating -- Need to sell", imageName: "skateboard.jpg",id:"id3")
        arrayOfPosts.append(post1)
        arrayOfPosts.append(post2)
        arrayOfPosts.append(post3)
    }
    
    @IBAction func edit(sender: AnyObject) {
        var VC1 = self.storyboard?.instantiateViewControllerWithIdentifier("editUser") as EditUserController
        let navController = UINavigationController(rootViewController: VC1)
        self.presentViewController(navController, animated:true, completion: nil)
        
    }
    
    @IBAction func helpAndFAQ(sender: AnyObject) {
        var VC1 = self.storyboard?.instantiateViewControllerWithIdentifier("helpAndFAQ") as HelpAndFAQController
        let navController = UINavigationController(rootViewController: VC1)
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
        var VC1 = self.storyboard?.instantiateViewControllerWithIdentifier("viewPost") as ViewPostController
        let navController = UINavigationController(rootViewController: VC1)
        self.presentViewController(navController, animated:true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpPosts()
        makeLayout()
        self.table.registerClass(UITableViewCell.self,forCellReuseIdentifier:"cell")
        table.dataSource = self
        table.delegate = self
        self.table.tableFooterView = UIView()
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    @IBAction func newPost(sender: AnyObject) {
        var VC1 = self.storyboard?.instantiateViewControllerWithIdentifier("create") as CreatePostController
        let navController = UINavigationController(rootViewController: VC1)
        self.presentViewController(navController, animated:true, completion: nil)
    }
    
    func makeLayout() {
        self.view.backgroundColor = UIColor.lightGrayColor()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width - slide;
        let screenHeight = screenSize.height
        let buttonHeight = 35
        let labelHeight = 25
        let noPostsHeight = 42
        let editProfileHeight = 64
        let twitterFeedHeight = 20
        let distanceBetweenButtonsVal = 1
        var bottomButtonPlacement = 0
        if(arrayOfPosts.count == 0){
             bottomButtonPlacement = Int(screenHeight) - twitterFeedHeight - (buttonHeight*3) - labelHeight - noPostsHeight - editProfileHeight - distanceBetweenButtonsVal*7
        }
        else {
             bottomButtonPlacement = Int(screenHeight) - twitterFeedHeight - (buttonHeight*3) - labelHeight - editProfileHeight - distanceBetweenButtonsVal*6
        }
        let view1 = UIButton.buttonWithType(UIButtonType.System) as UIButton
        let view2 = UIButton.buttonWithType(UIButtonType.System) as UIButton
        let view3 = UIButton.buttonWithType(UIButtonType.System) as UIButton
        let logoutButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        let postsLabel = UIButton.buttonWithType(UIButtonType.System) as UIButton
        let noPosts = UIButton.buttonWithType(UIButtonType.System) as UIButton
        let filler = UIButton.buttonWithType(UIButtonType.System) as UIButton
        let twitterFeed = UIButton.buttonWithType(UIButtonType.System) as UIButton
        let viewsDictionary = ["view1":view1,"view2":view2,"view3":view3, "logoutButton":logoutButton, "postsLabel":postsLabel,"table":table,"noPosts":noPosts,"filler":filler,"twitterFeed":twitterFeed]
        
        //here are the sizes used for the buttons - viewHeight is the button height, and the width is the entire screen - the 60 px layover
        let metricsDictionary = ["viewHeight": buttonHeight,"viewWidth":screenWidth, "screenHeight":screenHeight,"distanceBetweenButtons":distanceBetweenButtonsVal,"bottomHeight": bottomButtonPlacement,"editProfileHeight":editProfileHeight,"labelHeight":labelHeight, "noPostsHeight":noPostsHeight,"twitterFeedHeight":twitterFeedHeight ]
        
        //edit profile
        view1.setTitle("⚙  John D.", forState: UIControlState.Normal)
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
        table.setTranslatesAutoresizingMaskIntoConstraints(false)
        let table_constraint_H:Array = NSLayoutConstraint.constraintsWithVisualFormat("H:[table(viewWidth)]", options: NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
        table.addConstraints(table_constraint_H)
        
        //twitterFeed
        twitterFeed.setTitle("@ZagsGoGreen", forState: UIControlState.Normal)
        twitterFeed.titleLabel!.font = UIFont(name: "HelveticaNeue-UltraLight",size: 15)
        twitterFeed.setTranslatesAutoresizingMaskIntoConstraints(false)
        twitterFeed.backgroundColor = backgroundColor
        twitterFeed.userInteractionEnabled = false
        twitterFeed.backgroundColor = UIColor.whiteColor()
        let twitterFeed_constraint_H:Array = NSLayoutConstraint.constraintsWithVisualFormat("H:[twitterFeed(viewWidth)]", options: NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
        let twitterFeed_constraint_V:Array = NSLayoutConstraint.constraintsWithVisualFormat("V:[twitterFeed(twitterFeedHeight)]", options:
            NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
        twitterFeed.addConstraints(twitterFeed_constraint_H)
        twitterFeed.addConstraints(twitterFeed_constraint_V)
            
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

        view.addSubview(view1)
        view.addSubview(view2)
        view.addSubview(view3)
        view.addSubview(postsLabel)
        view.addSubview(table)
        view.addSubview(logoutButton)
        view.addSubview(twitterFeed)
        if(arrayOfPosts.count == 0){
            //No posts
            table.removeFromSuperview()
            noPosts.setTitle("You currently have no posts", forState: UIControlState.Normal)
            noPosts.titleLabel!.font = labelFont
            noPosts.setTranslatesAutoresizingMaskIntoConstraints(false)
            noPosts.backgroundColor = backgroundColor
            noPosts.userInteractionEnabled = false
            let noPosts_constraint_H:Array = NSLayoutConstraint.constraintsWithVisualFormat("H:[noPosts(viewWidth)]", options: NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
            let noPosts_constraint_V:Array = NSLayoutConstraint.constraintsWithVisualFormat("V:[noPosts(noPostsHeight)]", options:
                NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
            noPosts.addConstraints(noPosts_constraint_H)
            noPosts.addConstraints(noPosts_constraint_V)
            view.addSubview(noPosts)
            self.table.hidden = true

            //Filler
            filler.setTranslatesAutoresizingMaskIntoConstraints(false)
            filler.setTitle("", forState: UIControlState.Normal)
            filler.userInteractionEnabled = false
            filler.backgroundColor = UIColor.whiteColor()
            let filler_constraint_H:Array = NSLayoutConstraint.constraintsWithVisualFormat("H:[filler(viewWidth)]", options: NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
            let filler_constraint_V:Array = NSLayoutConstraint.constraintsWithVisualFormat("V:[filler(bottomHeight)]", options:
                NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
            filler.addConstraints(filler_constraint_H)
            filler.addConstraints(filler_constraint_V)
            view.addSubview(filler)
            let view_constraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[view1]-distanceBetweenButtons-[view2]-distanceBetweenButtons-[postsLabel]-distanceBetweenButtons-[noPosts]-distanceBetweenButtons-[filler]-distanceBetweenButtons-[twitterFeed]-distanceBetweenButtons-[logoutButton]-distanceBetweenButtons-[view3]-|", options: NSLayoutFormatOptions.AlignAllLeading, metrics: metricsDictionary, views: viewsDictionary)
            view.addConstraints(view_constraint_V)
        }
        else {
        //spaces it away from the top a little bit
            let view_constraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[view1]-distanceBetweenButtons-[view2]-distanceBetweenButtons-[postsLabel]-distanceBetweenButtons-[table]-distanceBetweenButtons-[twitterFeed]-distanceBetweenButtons-[logoutButton]-distanceBetweenButtons-[view3]-|", options: NSLayoutFormatOptions.AlignAllLeading, metrics: metricsDictionary, views: viewsDictionary)
            view.addConstraints(view_constraint_V)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    //table view functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfPosts.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:ProfilePostCell = table.dequeueReusableCellWithIdentifier("Cell") as ProfilePostCell
        let postCell = arrayOfPosts[indexPath.row]
        cell.setCell(postCell.title, imageName: postCell.imageName,id:postCell.id)
        cell.setTranslatesAutoresizingMaskIntoConstraints(false)
        return cell
    }
}
