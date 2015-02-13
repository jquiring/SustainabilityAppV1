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
    var arrayOfPosts: [ProfilePost] = []
    var category :String?
    var id:String?
    var firstAppear = true
    func setUpPosts(){
        /*
        var post1 = ProfilePost(title: "Fresh Bike", imageName: "bike.jpg",id:"id1")
        var post2 = ProfilePost(title: "Cheap Tv for all you ladies out there and now the title is a litte bit bigger", imageName: "tv.png",id:"id2")
        var post3 = ProfilePost(title: "Hurt myself Skating -- Need to sell", imageName: "skateboard.jpg",id:"id3")
        arrayOfPosts.append(post1)
        arrayOfPosts.append(post2)
        arrayOfPosts.append(post3)
        */
        arrayOfPosts = []
        if (NSUserDefaults.standardUserDefaults().objectForKey("user_posts") != nil) {
            var current_posts:[[AnyObject]] = NSUserDefaults.standardUserDefaults().objectForKey("user_posts") as [[AnyObject]]
            for post in current_posts {
                id = post[0] as? String
                var new_post = ProfilePost(title: post[1] as String, imageName: post[2] as NSData, id: id!,cat:post[3] as String)
                arrayOfPosts.append(new_post)
            }
        }
    }
    @IBAction func deleteSelected(sender: AnyObject) {
        let cat:String = arrayOfPosts[sender.tag].category as String
        let id:String = arrayOfPosts[sender.tag].id as String
        
        let alertController = UIAlertController(title: "Are you sure you wish to delete " + arrayOfPosts[sender.tag].title  + "?", message:
            nil, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default,handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction!) in
            if (NSUserDefaults.standardUserDefaults().objectForKey("user_posts") != nil) {
                self.deletePost(cat, id:id,sender:sender.tag)
            }

        }))
        presentViewController(alertController, animated: true, completion: nil)
       
        
    }
    func bumpUI(sender:Int,refreshed:String){
        if(refreshed == "1"){
            let alertController = UIAlertController(title: "Your post has been bumped", message:
                nil, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction!) in
               
                let bumped_post = self.arrayOfPosts[sender]
                self.arrayOfPosts.removeAtIndex(sender)
                self.arrayOfPosts.insert(bumped_post, atIndex: 0)
                if (NSUserDefaults.standardUserDefaults().objectForKey("user_posts") != nil) {
                    var current_posts:[[AnyObject]] = NSUserDefaults.standardUserDefaults().objectForKey("user_posts") as [[AnyObject]]
                    current_posts.removeAtIndex(sender)
                    current_posts.insert([bumped_post.id,bumped_post.title,bumped_post.imageName,bumped_post.category], atIndex: 0)
                    NSUserDefaults.standardUserDefaults().setObject(current_posts, forKey: "user_posts")
                    
                }
                self.table.reloadData()
            }))
            presentViewController(alertController, animated: true, completion: nil)
        }
        else{
            let alertController = UIAlertController(title: "Your post has was not bumped you have already done that today, try again tomorrow", message:
            nil, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction!) in
            
            let bumped_post = self.arrayOfPosts[sender]
            self.arrayOfPosts.removeAtIndex(sender)
            self.arrayOfPosts.insert(bumped_post, atIndex: 0)
            if (NSUserDefaults.standardUserDefaults().objectForKey("user_posts") != nil) {
            var current_posts:[[AnyObject]] = NSUserDefaults.standardUserDefaults().objectForKey("user_posts") as [[AnyObject]]
            current_posts.removeAtIndex(sender)
            current_posts.insert([bumped_post.id,bumped_post.title,bumped_post.imageName,bumped_post.category], atIndex: 0)
            NSUserDefaults.standardUserDefaults().setObject(current_posts, forKey: "user_posts")
            
            }
            self.table.reloadData()
            }))
            presentViewController(alertController, animated: true, completion: nil)

        }
    }
    func bumpPost(category:String,post_id:String,tag:Int){
        var api_requester: AgoraRequester = AgoraRequester()
        var not_ready = true
        let params = ["post_id":post_id, "category":category]
        api_requester.POST("refreshpost/", params: params,
            success: {parseJSON -> Void in
                dispatch_async(dispatch_get_main_queue(), {self.bumpUI(tag,refreshed:parseJSON["refreshed"] as String)})
                println("success")
                not_ready = false
            },
            failure: {code,message -> Void in
                if code == 500 {
                    //500: Server failure
                    not_ready = false
                    println("Server Failure!!!!!")
                }
                else if code == 400 {
                    
                }
                else if code == 58 {
                    not_ready = false
                    println("No Connection!!!!!")
                }
                else if code == 599 {
                    not_ready = false
                    println("Timeout!!!!!")
                }
            }
        )

    }
    func deleteUI(sender:Int){
        var current_posts:[[AnyObject]] = NSUserDefaults.standardUserDefaults().objectForKey("user_posts") as [[AnyObject]]
        current_posts.removeAtIndex(sender)
        NSUserDefaults.standardUserDefaults().setObject(current_posts, forKey: "user_posts")
        self.arrayOfPosts.removeAtIndex(sender)
        
        
        let alertController = UIAlertController(title: "Your post has been deleted", message:
            nil, preferredStyle: UIAlertControllerStyle.Alert)
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
                if code == 500 {
                    //500: Server failure
                    not_ready = false
                    println("Server Failure!!!!!")
                }
                else if code == 400 {
                    
                }
                else if code == 58 {
                    not_ready = false
                    println("No Connection!!!!!")
                }
                else if code == 599 {
                    not_ready = false
                    println("Timeout!!!!!")
                }
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
        self.bumpPost(arrayOfPosts[sender.tag].category,post_id: arrayOfPosts[sender.tag].id,tag:sender.tag)
       
        println("post bumped")
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
            //set the rest of the user defaults to nil?
            var VC1 = self.storyboard?.instantiateViewControllerWithIdentifier("login") as LoginController
            let navController = UINavigationController(rootViewController: VC1)
            // Creating a navigation controller with VC1 at the root of the navigation stack.
            self.presentViewController(navController, animated:true, completion: nil)

            
        }))


    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpPosts()
        makeLayout()
        self.table.registerClass(UITableViewCell.self,forCellReuseIdentifier:"cell")
        //view.setTranslatesAutoresizingMaskIntoConstraints(false)
        table.dataSource = self
        table.delegate = self
        //table.preformSeg
        self.table.tableFooterView = UIView()
        table.reloadData()
        println("view did load")
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        
        setUpPosts()
        makeLayout()
        self.table.reloadData()
        println("view did appear")
        firstAppear = false
       

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
        let twitterFeed = UIButton.buttonWithType(UIButtonType.System) as UIButton
       // let yourPosts = UILabel as UILabel
       // var tableView:UITableView
        let viewsDictionary = ["view1":view1,"view2":view2,"view3":view3, "logoutButton":logoutButton, "postsLabel":postsLabel,"table":table,"noPosts":noPosts,"filler":filler,"twitterFeed":twitterFeed]
        //here are the sizes used for the buttons - viewHeight is the button height, and the width is the entire screen - the 60 px layover
        let metricsDictionary = ["viewHeight": buttonHeight,"viewWidth":screenWidth, "screenHeight":screenHeight,"distanceBetweenButtons":distanceBetweenButtonsVal,"bottomHeight": bottomButtonPlacement,"editProfileHeight":editProfileHeight,"labelHeight":labelHeight, "noPostsHeight":noPostsHeight,"twitterFeedHeight":twitterFeedHeight ]
        
        //edit profile
        if (NSUserDefaults.standardUserDefaults().objectForKey("username") != nil) {
            let user_first_name:String = NSUserDefaults.standardUserDefaults().objectForKey("first_name") as String
            let user_last_name:String = NSUserDefaults.standardUserDefaults().objectForKey("last_name") as String
            view1.setTitle("⚙ " + user_first_name + " "+user_last_name[0]+".", forState: UIControlState.Normal)
        }
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
        //let table_constraint_V:Array = NSLayoutConstraint.constraintsWithVisualFormat("V:[table(bottomHeight)]", options:
            //NSLayoutFormatOptions(0), metrics: metricsDictionary, views: viewsDictionary)
        table.addConstraints(table_constraint_H)
        //table.addConstraints(table_constraint_V)
        
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


        //casts width to a string then uses the width to set the width of the screen (denoted as H for some reason)
        
        
        
        

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

            //filler
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
        //this seems to be breaking the code right now
            let view_constraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[view1]-distanceBetweenButtons-[view2]-distanceBetweenButtons-[postsLabel]-distanceBetweenButtons-[table]-distanceBetweenButtons-[twitterFeed]-distanceBetweenButtons-[logoutButton]-distanceBetweenButtons-[view3]-|", options: NSLayoutFormatOptions.AlignAllLeading, metrics: metricsDictionary, views: viewsDictionary)
        
            view.addConstraints(view_constraint_V)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //table view functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfPosts.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:ProfilePostCell = table.dequeueReusableCellWithIdentifier("Cell") as ProfilePostCell
        let postCell = arrayOfPosts[indexPath.row]
        cell.edit.tag = indexPath.row
        cell.delete.tag = indexPath.row
        cell.bump.tag = indexPath.row
        cell.setCell(postCell.title, imageName: postCell.imageName)
        cell.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        
        
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

        
  
}



extension String {
    subscript (i: Int) -> String {
        return String(Array(self)[i])

    }


}
