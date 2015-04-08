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
    var refreshControl = UIRefreshControl()
    let slide:CGFloat = 60
    let buttonHeight:String = "25"
    let barColor:UIColor =  UIColor(red: 0.633, green: 0.855, blue: 0.620, alpha: 1)
    let backgroundColor:UIColor = UIColor(red: 0.847, green: 0.847, blue: 0.847, alpha: 1)
    let buttonFont:UIFont? = UIFont(name: "HelveticaNeue-Light",size: 20)
    let labelFont:UIFont? = UIFont(name: "HelveticaNeue-UltraLight",size: 18)
    var arrayOfPosts: [ProfilePost] = []
    var arrayofCells: [ProfilePostCell] = []
    var category :String?
    var id:String?
    var firstAppear = true
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 25, 25)) as UIActivityIndicatorView
    var centerLoad : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 25, 25)) as UIActivityIndicatorView
    //NSUserDefaults.standardUserDefaults().setObject(true, forKey: "moreUserPosts")
    var bottomNeedsMore = NSUserDefaults.standardUserDefaults().objectForKey("moreUserPosts") as Bool
    var firstLoad = NSUserDefaults.standardUserDefaults().objectForKey("profileNeedsReloading") as Bool
    func setUpPosts(fromAppear:Bool){
        if(fromAppear){
            arrayOfPosts = []
            arrayofCells = []
        }
        if (NSUserDefaults.standardUserDefaults().objectForKey("user_posts") != nil) {
            var current_posts:[[AnyObject]] = NSUserDefaults.standardUserDefaults().objectForKey("user_posts") as [[AnyObject]]
            for post in current_posts {
                id = post[0] as? String
                var new_post = ProfilePost(title: post[1] as String, imageName: post[2] as NSData, id: id!,cat:post[3] as String,date:post[4] as String)
                arrayOfPosts.append(new_post)
            }
        }
    }
    func didRefresh(){
        if(!actInd.isAnimating() && !centerLoad.isAnimating()){
            getMorePosts("",older:"1",fromTop:true,refresh:true)
        }
        else{
            refreshControl.endRefreshing()
        }
    }

    @IBAction func deleteSelected(sender: AnyObject) {
        let cat:String = arrayOfPosts[sender.tag].category as String
        let id:String = arrayOfPosts[sender.tag].id as String

        let alertController = UIAlertController(title: nil, message:
            "Are you sure you wish to delete " + arrayOfPosts[sender.tag].title  + "?", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default,handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction!) in
            if (NSUserDefaults.standardUserDefaults().objectForKey("user_posts") != nil) {
                self.arrayofCells[sender.tag].delete.hidden = true
                self.arrayofCells[sender.tag].deleteRefresh.startAnimating()
                self.deletePost(cat, id:id,sender:sender.tag)
            }

        }))
        presentViewController(alertController, animated: true, completion: nil)
       
        
    }
    func bumpUI(sender:Int,refreshed:String,date:String){
        if(refreshed == "1"){
            let alertController = UIAlertController(title: nil , message:
                "Your post has been bumped", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction!) in
                self.arrayofCells[sender].bump.hidden = false
                self.arrayofCells[sender].bumpRefresh.stopAnimating()
                let bumped_post = self.arrayOfPosts[sender]
                self.arrayOfPosts.removeAtIndex(sender)
                self.arrayOfPosts.insert(bumped_post, atIndex: 0)
                if (NSUserDefaults.standardUserDefaults().objectForKey("user_posts") != nil) {
                    var current_posts:[[AnyObject]] = NSUserDefaults.standardUserDefaults().objectForKey("user_posts") as [[AnyObject]]
                    current_posts.removeAtIndex(sender)
                    current_posts.insert([bumped_post.id,bumped_post.title,bumped_post.imageName,bumped_post.category,date], atIndex: 0)
                    NSUserDefaults.standardUserDefaults().setObject(current_posts, forKey: "user_posts")
                    
                }
               // self.arrayofCells = []
                self.table.reloadData()
            }))
            presentViewController(alertController, animated: true, completion: nil)
        }
        else{
            let alertController = UIAlertController(title: "Your post was not bumped", message:
            "You can only bump posts once a day", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction!) in
                self.arrayofCells[sender].bump.hidden = false
                self.arrayofCells[sender].bumpRefresh.stopAnimating()
            }))
            presentViewController(alertController, animated: true, completion: nil)

        }
    }
    func bumpPost(category:String,post_id:String,tag:Int){
        var api_requester: AgoraRequester = AgoraRequester()
        let params = ["post_id":post_id, "category":category]
        api_requester.POST("refreshpost/", params: params,
            success: {parseJSON -> Void in
                
                dispatch_async(dispatch_get_main_queue(), {self.bumpUI(tag,refreshed:parseJSON["refreshed"] as String,date:parseJSON["post_date_time"] as String)
                    
                    })
            },
            failure: {code,message -> Void in
                let alertController = UIAlertController(title: "Connection error", message:
                    "Your post was not bumped check connection and try again", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction!) in
                    self.arrayofCells[tag].bump.hidden = false
                    self.arrayofCells[tag].bumpRefresh.stopAnimating()
                }))
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
        )

    }
    func deleteUI(sender:Int){
        var current_posts:[[AnyObject]] = NSUserDefaults.standardUserDefaults().objectForKey("user_posts") as [[AnyObject]]
        current_posts.removeAtIndex(sender)
        NSUserDefaults.standardUserDefaults().setObject(current_posts, forKey: "user_posts")
        self.arrayOfPosts.removeAtIndex(sender)
        self.arrayofCells.removeAtIndex(sender)
        
        let alertController = UIAlertController(title: nil, message:
            "Your post has been deleted", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction!) in
            self.table.reloadData()
            
        }))
        presentViewController(alertController, animated: true, completion: nil)

        
    }
    func deletePost(category:String, id:String,sender:Int){
        var api_requester: AgoraRequester = AgoraRequester()
        
        var not_ready = true
        let params = ["id":id, "category":category]
        api_requester.POST("deletepost/", params: params,
            success: {parseJSON -> Void in
                
                dispatch_async(dispatch_get_main_queue(), {self.deleteUI(sender) })
            },
            failure: {code,message -> Void in
                println("failure")
                dispatch_async(dispatch_get_main_queue(), {
                    let alertController = UIAlertController(title: "Connection error", message:
                        "Your post was not deleted, check signal and try again", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction!) in
                        self.arrayofCells[sender].delete.hidden = false
                        self.arrayofCells[sender].deleteRefresh.stopAnimating()
                    }))
                   self.presentViewController(alertController, animated: true, completion: nil)
                    
                })
            }
        )
    }
    @IBAction func editSelected(sender: AnyObject) {
        println(sender.tag)
        NSUserDefaults.standardUserDefaults().setObject(arrayOfPosts[sender.tag].id, forKey: "post_id")
        NSUserDefaults.standardUserDefaults().setObject(arrayOfPosts[sender.tag].category, forKey: "cat")
        var VC1 = self.storyboard?.instantiateViewControllerWithIdentifier("editPost") as EditPostViewController
        let navController = UINavigationController(rootViewController: VC1)
        // Creating a navigation controller with VC1 at the root of the navigation stack.
        
        self.presentViewController(navController, animated:true, completion: nil)

    }
    
    @IBAction func bumpButton(sender: AnyObject) {
        arrayofCells[sender.tag].bumpRefresh.startAnimating()
        arrayofCells[sender.tag].bump.hidden = true
        self.bumpPost(arrayOfPosts[sender.tag].category,post_id: arrayOfPosts[sender.tag].id,tag:sender.tag)
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
    
    @IBAction func tweets(sender: AnyObject) {
        /*
        var VC1 = self.storyboard?.instantiateViewControllerWithIdentifier("twttr") as TwitterTableViewController
        let navController = UINavigationController(rootViewController: VC1)
        // Creating a navigation controller with VC1 at the root of the navigation stack.
        self.presentViewController(navController, animated:true, completion: nil)
        */
        
    }

    
    @IBAction func logout(sender: AnyObject) {
        
        var alert = UIAlertController(title:nil, message: "Are you sure you wish to logout?", preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Logout", style: .Default, handler: { (action: UIAlertAction!) in
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "username")
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "first_name")
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "last_name")
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "user_posts")
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "pref_email")
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "phone")
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "moreUserPosts")
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "profileNeedsReloading")
            //set the rest of the user defaults to nil?
            var VC1 = self.storyboard?.instantiateViewControllerWithIdentifier("login") as LoginController
            let navController = UINavigationController(rootViewController: VC1)
            // Creating a navigation controller with VC1 at the root of the navigation stack.
            self.presentViewController(navController, animated:true, completion: nil)

            
        }))


    }/*
    override func viewWillAppear(animated: Bool) {
        println("view will appear")
        
        self.setUpPosts()
        makeLayout()
        
        table.reloadData()
        self.view.setNeedsDisplay()
    }*/

    override func viewDidAppear(animated: Bool) {
        if(NSUserDefaults.standardUserDefaults().objectForKey("profileNeedsReloading") as Bool){
            setUpPosts(true)
            println("view did appear");
            self.arrayofCells = []
            table.reloadData()
            NSUserDefaults.standardUserDefaults().setObject(false, forKey: "profileNeedsReloading")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.registerClass(UITableViewCell.self,forCellReuseIdentifier:"cell")
        table.dataSource = self
        table.delegate = self
        centerLoad.center = CGPoint(x:self.view.center.x - 30 , y:self.view.center.y)
        centerLoad.hidesWhenStopped = true
        centerLoad.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.table.addSubview(centerLoad)
        makeLayout()
        self.table.addSubview(self.refreshControl)
        self.refreshControl.addTarget(self, action: "didRefresh", forControlEvents: UIControlEvents.ValueChanged)
        if(firstLoad){
            centerLoad.startAnimating()
            arrayOfPosts = []
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "user_posts")
            getMorePosts("", older: "1", fromTop: true,refresh:false)
            NSUserDefaults.standardUserDefaults().setObject(false, forKey: "profileNeedsReloading")
            self.setUpPosts(false)
            self.arrayofCells = []
            table.reloadData()

        }
        setUpPosts(true)
        table.reloadData()
        //view.setTranslatesAutoresizingMaskIntoConstraints(false)

        //table.preformSeg
        self.table.tableFooterView = UIView()

        println("view did load")
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray

        // Do any additional setup after loading the view.
    }


    @IBAction func newPost(sender: AnyObject) {
        var VC1 = self.storyboard?.instantiateViewControllerWithIdentifier("create") as CreatePostController
        let navController = UINavigationController(rootViewController: VC1)
        // Creating a navigation controller with VC1 at the root of the navigation stack.
        self.presentViewController(navController, animated:true, completion: nil)
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
        let noPostsHeight = 42
        let editProfileHeight = 64
        let twitterFeedHeight = 20
        //let distanceFromTopVal  = 20
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
        let twitterFeed = MarqueeLabel()
        //let twitterFeed = UIButton.buttonWithType(UIButtonType.System) as UIButton
        //let yourPosts = UILabel as UILabel
        //var tableView:UITableView
        let viewsDictionary = ["view1":view1,"view2":view2,"view3":view3, "logoutButton":logoutButton, "postsLabel":postsLabel,"table":table,"noPosts":noPosts,"filler":filler,"twitterFeed":twitterFeed]
        //here are the sizes used for the buttons - viewHeight is the button height, and the width is the entire screen - the 60 px layover
        let metricsDictionary = ["viewHeight": buttonHeight,"viewWidth":screenWidth, "screenHeight":screenHeight,"distanceBetweenButtons":distanceBetweenButtonsVal,"bottomHeight": bottomButtonPlacement,"editProfileHeight":editProfileHeight,"labelHeight":labelHeight, "noPostsHeight":noPostsHeight,"twitterFeedHeight":twitterFeedHeight ]
        
        //edit profile
        if (NSUserDefaults.standardUserDefaults().objectForKey("username") != nil) {
            let user_first_name:String = NSUserDefaults.standardUserDefaults().objectForKey("first_name") as String
            let user_last_name:String = NSUserDefaults.standardUserDefaults().objectForKey("last_name") as String
            view1.setTitle("⚙ " + user_first_name + " " + user_last_name[0]+".", forState: UIControlState.Normal)
        }
        view1.setTitleColor(UIColor.darkGrayColor(), forState: nil)
        view1.titleLabel!.font = UIFont(name: "HelveticaNeue-Light",size: 24)
        view1.setTranslatesAutoresizingMaskIntoConstraints(false)
        view1.backgroundColor = barColor
        view1.contentEdgeInsets = UIEdgeInsetsMake(0, 10, -17, 0)
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
        //let table_constraint_V:Array = NSLayoutConstraint.constraintsWithVisualFormat("V:[table(bottomHeight)]", options:
            //NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
        table.addConstraints(table_constraint_H)
        //table.addConstraints(table_constraint_V)
        
        //twitterFeed
        //twitterFeed.setTitle("@ZagsGoGreen", forState: UIControlState.Normal)
        //twitterFeed.titleLabel!.font = UIFont(name: "HelveticaNeue-UltraLight",size: 16)
        twitterFeed.marqueeType = .MLLeftRight
        twitterFeed.scrollDuration = 15.0
        twitterFeed.fadeLength = 10.0
        twitterFeed.continuousMarqueeExtraBuffer = 10.0
        twitterFeed.text = "This is a test of MarqueeLabel - the text is long enough that it needs to scroll to see the whole thing."
        twitterFeed.tag = 101

        twitterFeed.setTranslatesAutoresizingMaskIntoConstraints(false)
        twitterFeed.backgroundColor = backgroundColor
        //twitterFeed.addTarget(self, action: "tweets:", forControlEvents: UIControlEvents.TouchUpInside)
        //twitterFeed.userInteractionEnabled = false
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
        let view_constraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[view1]-distanceBetweenButtons-[view2]-distanceBetweenButtons-[postsLabel]-distanceBetweenButtons-[table]-distanceBetweenButtons-[twitterFeed]-distanceBetweenButtons-[logoutButton]-distanceBetweenButtons-[view3]-|", options: NSLayoutFormatOptions.AlignAllLeading, metrics: metricsDictionary, views: viewsDictionary)
        view.addConstraints(view_constraint_V)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //table view functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println(arrayOfPosts.count)
        if(arrayOfPosts.count == 0){
            makeLayout()
            self.reloadInputViews()
        }
        return arrayOfPosts.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:ProfilePostCell = table.dequeueReusableCellWithIdentifier("Cell") as ProfilePostCell
        cell.addSubview(UIView())
        let postCell = arrayOfPosts[indexPath.row]
        cell.edit.tag = indexPath.row
        cell.delete.tag = indexPath.row
        cell.bump.tag = indexPath.row
        cell.setCell(postCell.title, imageName: postCell.imageName)
        cell.setTranslatesAutoresizingMaskIntoConstraints(false)
        cell.bumpRefresh.stopAnimating()
        cell.deleteRefresh.stopAnimating()
        cell.delete.hidden = false
        if(!contains(arrayofCells,cell)){
            arrayofCells.append(cell)
        }
        else{
            println("already contained")
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Get the row data for the selected row
        println(arrayOfPosts[indexPath.row].id)
        category = arrayOfPosts[indexPath.row].category
        println(category)
        id = arrayOfPosts[indexPath.row].id
        println(id)
        NSUserDefaults.standardUserDefaults().setObject(id, forKey: "post_id")
        NSUserDefaults.standardUserDefaults().setObject(arrayOfPosts[indexPath.row].category, forKey: "cat")
        var VC1 = self.storyboard?.instantiateViewControllerWithIdentifier("viewPost") as ViewPostController
        let navController = UINavigationController(rootViewController: VC1)
        // Creating a navigation controller with VC1 at the root of the navigation stack.
        
        self.presentViewController(navController, animated:true, completion: nil)

    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(arrayOfPosts.count != 0 ){
            println("f")
            self.table.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            self.table.backgroundView = UIView()
            return 1
        }
        else if(arrayOfPosts.count == 0){
            var label:UILabel = UILabel()
            label.frame = CGRectMake(0,0,self.view.bounds.width,self.view.bounds.height)
            if(self.centerLoad.isAnimating()){
                label.text = "Loading your posts"
            }
            else{
                label.text = "No posts currently loaded"
            }
            label.textColor = UIColor.blackColor()
            label.textAlignment = NSTextAlignment.Center
            label.numberOfLines = 0
            label.font = UIFont(name: "HelveticaNeue-UltraLight",size: 24)
            label.sizeToFit()
            self.table.backgroundView = label
            self.table.separatorStyle = UITableViewCellSeparatorStyle.None
        }
        return 0
    }
    func updateNSData(newDate:String,id:String,category:String){
        var current_posts:[[AnyObject]] = NSUserDefaults.standardUserDefaults().objectForKey("user_posts") as [[AnyObject]]
        var new_post = []
        var the_index = 0
        for i in 0...current_posts.count - 1 {
            if current_posts[i][0] as String == id && String(current_posts[i][3] as String) == category {
                the_index = i
            }
        }
        current_posts[the_index][4] = newDate
        NSUserDefaults.standardUserDefaults().setObject(current_posts, forKey: "user_posts")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func getMorePosts(date:String,older:String,fromTop:Bool,refresh:Bool){
        var api_requester: AgoraRequester = AgoraRequester()
        if(!fromTop){
            actInd.startAnimating()
        }
        let username = NSUserDefaults.standardUserDefaults().objectForKey("username") as String
        //let divider_date_time = ""
        let divider_date_time = date
        
        let params = ["username":username,
            "divider_date_time":divider_date_time,
            "older":older]
            as Dictionary<String,AnyObject>
        
        api_requester.POST("userposts/",params:params,
            success: {parseJSON -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    self.updatePosts(parseJSON, refresh:refresh)})
            },
            failure: {code,message -> Void in
                self.refreshControl.endRefreshing()
                self.actInd.stopAnimating()
                self.centerLoad.stopAnimating()
                var alert = UIAlertController(title: "Connection error", message: "Unable to load posts, pull down to refresh", preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(alert, animated: true, completion: nil)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                    
                }))
                if(code == 500){
                    //server error
                }
                else if (code == 599){
                    //timeout
                }
                else if (code == 58){
                    //no internet connection
                }
            }
        )
    }
    /*
    func didRefresh(){
        if(arrayOfPosts.count == 0){
            getMorePosts("", older: "0",fromTop:true)
        }
        else{
            getMorePosts(arrayOfPosts[0].date,older:"",fromTop:true)
        }
        table.reloadData()
    }
    */
    func updatePosts(parseJSON:NSDictionary,refresh:Bool){
        if(refresh){
            arrayOfPosts = []
            arrayofCells = []
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "user_posts")
                
        }
        let posts: AnyObject = parseJSON["posts"]!
        let more = parseJSON["more_exist"] as String //1 or zero

        let recent_del: String = parseJSON["recent_post_deletion"] as String
        if(recent_del == "1"){
            let alertController = UIAlertController(title: "A post of yours over three weeks old has been deleted" , message:
                "Bump your posts before three weeks if you wish to avoid this in the future", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction!) in
            }))
            presentViewController(alertController, animated: true, completion: nil)
        }
        if posts.count > 0{
            for i in 0...(posts.count - 1){
                let post: AnyObject! = posts[i]
                var postID = post["id"]! as Int
                let title = post["title"]! as String
                let category = post["category"] as String
                let post_date_time = post["post_date_time"]! as String
                let display_value = post["display_value"]! as String
                //THE THUMBNAIL IMAGE IS PROCESSED HERE
                let imageString = post["image"]! as String
                var newPost:ProfilePost
                if !imageString.isEmpty {
                    let imageData = NSData(base64EncodedString: imageString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
                    newPost = ProfilePost(title: title, imageName: imageData, id: String(postID), cat: category, date: post_date_time)
                }
                else{
                    newPost = ProfilePost(title: title, id: String(postID), cat: category, date: post_date_time)
                }
                newPost.upDateNSData(false)
                arrayOfPosts.append(newPost)
            }
        }
        println("reloading data")
        self.arrayofCells = []
        self.table.reloadData()
        refreshControl.endRefreshing()
        self.actInd.stopAnimating()
        centerLoad.stopAnimating()
        if(more == "1"){
            NSUserDefaults.standardUserDefaults().setObject(true, forKey: "moreUserPosts")
            bottomNeedsMore = true
        }
        else{
            NSUserDefaults.standardUserDefaults().setObject(false, forKey: "moreUserPosts")
            bottomNeedsMore = false
        }
        table.needsUpdateConstraints()
        self.arrayofCells = []
        table.reloadData()

    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return actInd
    }
    func scrollViewDidScroll(scrollView: UIScrollView){
        if(arrayOfPosts.count >= 10 ){
            var currentOffset = scrollView.contentOffset.y;
            var maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            
            if(maximumOffset - currentOffset <= 15 && bottomNeedsMore && !refreshControl.refreshing){
                self.actInd.startAnimating()
                var oldLength = arrayOfPosts.count - 1
                bottomNeedsMore = false
                println("Time to reload table")
                println(arrayOfPosts[oldLength].date)
                println(arrayOfPosts[oldLength - 1].date)
                //send request for more posts
                //actInd.startAnimating()
                getMorePosts(arrayOfPosts[oldLength].date,older:"1",fromTop:false,refresh:false)
                
                //var indexes = [oldLength...self.arrayOfPosts.count]
                //var indexPath = NSIndexPath(indexPathWithIndexes:indexes, length:indexes.count)
                var indexPaths : [Int] = []
                for i in oldLength...arrayOfPosts.count {
                    indexPaths.append(0)
                    indexPaths.append(i)
                }
                //need to reload twice for some damn reason
                self.arrayofCells = []
                table.reloadData()
                self.table.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(0, self.table.numberOfSections())), withRowAnimation: .None)
                
                self.table.scrollToRowAtIndexPath(NSIndexPath(forRow: (oldLength)   , inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
                
                
            }
            
        }
    }
}
extension String {
    subscript (i: Int) -> String {
        return String(Array(self)[i])

    }
}

