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
    @IBOutlet weak var view1: UIButton!
    @IBOutlet weak var view2: UIButton!
    @IBOutlet weak var postsLabel: UIButton!
    @IBOutlet weak var twitterFeed: UIButton!
    @IBOutlet weak var helpnFAQ: UIButton!
    @IBOutlet weak var logoutBut: UIButton!
    
    var items = ["title 1","title 2","title 3"]
    var refreshControl = UIRefreshControl()
    var arrayOfPosts: [ProfilePost] = []
    var category :String?
    var id:String?
    var firstAppear = true
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 25, 25)) as UIActivityIndicatorView
    var centerLoad : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 25, 25)) as UIActivityIndicatorView
    var bottomNeedsMore = NSUserDefaults.standardUserDefaults().objectForKey("moreUserPosts") as! Bool
    var firstLoad = NSUserDefaults.standardUserDefaults().objectForKey("profileNeedsReloading") as! Bool
    
    let slide:CGFloat = 60
    //let buttonHeight:String = "25"
    let barColor:UIColor =  UIColor(red: 0.633, green: 0.855, blue: 0.620, alpha: 1)
    let backgroundColor:UIColor = UIColor(red: 0.847, green: 0.847, blue: 0.847, alpha: 1)
    let buttonFont:UIFont? = UIFont(name: "HelveticaNeue-Light",size: 20)
    let labelFont:UIFont? = UIFont(name: "HelveticaNeue-UltraLight",size: 18)
    
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
            table.reloadData()
        }
        setUpPosts(true)
        table.reloadData()
        self.table.tableFooterView = UIView()
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
    }
    override func viewDidAppear(animated: Bool) {
        if(NSUserDefaults.standardUserDefaults().objectForKey("profileNeedsReloading") as! Bool){
            setUpPosts(true)
            table.reloadData()
            NSUserDefaults.standardUserDefaults().setObject(false, forKey: "profileNeedsReloading")
            makeLayout()
        }
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
        let distanceBetweenButtonsVal = 1
        
        //edit profile
        if (NSUserDefaults.standardUserDefaults().objectForKey("username") != nil) {
            let user_first_name:String = NSUserDefaults.standardUserDefaults().objectForKey("first_name") as! String
            let user_last_name:String = NSUserDefaults.standardUserDefaults().objectForKey("last_name") as! String
            view1.setTitle("⚙ " + user_first_name + " " + user_last_name[0]+".", forState: UIControlState.Normal)
        }
        view1.setTitleColor(UIColor.darkGrayColor(), forState: nil)
        view1.titleLabel!.font = UIFont(name: "HelveticaNeue-Light",size: 24)
        view1.setTranslatesAutoresizingMaskIntoConstraints(false)
        view1.backgroundColor = barColor
        view1.contentEdgeInsets = UIEdgeInsetsMake(0, 10, -17, 0)
        view1.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        view1.addTarget(self, action: "edit:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //create a post
        view2.setTitle("Create a Post ➕", forState: UIControlState.Normal)
        view2.titleLabel!.font = buttonFont
        view2.setTranslatesAutoresizingMaskIntoConstraints(false)
        view2.backgroundColor = backgroundColor
        view2.addTarget(self, action: "newPost:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //Posts label
        postsLabel.setTitle("Your Posts", forState: UIControlState.Normal)
        postsLabel.titleLabel!.font = labelFont
        postsLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        postsLabel.backgroundColor = backgroundColor
        postsLabel.userInteractionEnabled = false
        postsLabel.backgroundColor = UIColor.whiteColor()
        
        twitterFeed.titleLabel!.font = buttonFont
        logoutBut.titleLabel!.font = buttonFont
        helpnFAQ.titleLabel!.font = buttonFont
        twitterFeed.backgroundColor = backgroundColor
        logoutBut.backgroundColor = backgroundColor
        helpnFAQ.backgroundColor = backgroundColor
        twitterFeed.addTarget(self, action: "twitterTouched", forControlEvents: UIControlEvents.TouchUpInside)
        logoutBut.addTarget(self, action: "logout:", forControlEvents: UIControlEvents.TouchUpInside)
        helpnFAQ.addTarget(self, action: "helpAndFAQ:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    func setUpPosts(fromAppear:Bool){
        if(fromAppear){
            arrayOfPosts = []
        }
        if (NSUserDefaults.standardUserDefaults().objectForKey("user_posts") != nil) {
            var current_posts:[[AnyObject]] = NSUserDefaults.standardUserDefaults().objectForKey("user_posts") as! [[AnyObject]]
            for post in current_posts {
                id = post[0] as? String
                var new_post = ProfilePost(title: post[1] as! String, imageName: post[2] as! NSData, id: id!,cat:post[3] as! String,date:post[4] as! String)
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
    func bumpUI(sender:Int,refreshed:String,date:String){
        if(refreshed == "1"){
            let bumped_post = self.arrayOfPosts[sender]
            self.arrayOfPosts.removeAtIndex(sender)
            self.arrayOfPosts.insert(bumped_post, atIndex: 0)
            self.arrayOfPosts[0].refreshing = false
            if (NSUserDefaults.standardUserDefaults().objectForKey("user_posts") != nil) {
                var current_posts:[[AnyObject]] = NSUserDefaults.standardUserDefaults().objectForKey("user_posts") as! [[AnyObject]]
                current_posts.removeAtIndex(sender)
                current_posts.insert([bumped_post.id,bumped_post.title,bumped_post.imageName,bumped_post.category,date], atIndex: 0)
                NSUserDefaults.standardUserDefaults().setObject(current_posts, forKey: "user_posts")
            }
            else {
                var current_posts = [bumped_post.id,bumped_post.title,bumped_post.imageName,bumped_post.category,date]
                NSUserDefaults.standardUserDefaults().setObject(current_posts, forKey: "user_posts")
            }
            self.table.reloadData()
        }
        else{
            let alertController = UIAlertController(title: "Your post was not bumped", message:
            "You can only bump posts once a day", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction!) in
                self.arrayOfPosts[sender].refreshing = false
                self.table.reloadData()
            }))
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    func bumpPost(category:String,post_id:String,tag:Int){
        var api_requester: AgoraRequester = AgoraRequester()
        let params = ["post_id":post_id, "category":category]
        self.arrayOfPosts[tag].refreshing = true
        var indexPath:NSIndexPath = NSIndexPath(forItem: tag, inSection: 0)
        self.table.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        api_requester.POST("refreshpost/", params: params,
            success: {parseJSON -> Void in
                
                dispatch_async(dispatch_get_main_queue(), {self.bumpUI(tag,refreshed:parseJSON["refreshed"] as! String,date:parseJSON["post_date_time"] as! String)
                    })
            },
            failure: {code,message -> Void in
                let alertController = UIAlertController(title: "Connection error", message:
                    "Your post was not bumped check connection and try again", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction!) in
                    self.arrayOfPosts[tag].deleting = false
                    dispatch_async(dispatch_get_main_queue(), {
                        self.table.reloadData()
                    })
                }))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        )
    }
    func deleteUI(sender:Int){
        var current_posts:[[AnyObject]] = NSUserDefaults.standardUserDefaults().objectForKey("user_posts") as! [[AnyObject]]
        current_posts.removeAtIndex(sender)
        NSUserDefaults.standardUserDefaults().setObject(current_posts, forKey: "user_posts")
        self.arrayOfPosts.removeAtIndex(sender)
        self.table.reloadData()
    }
    func deletePost(category:String, id:String,sender:Int){
        var api_requester: AgoraRequester = AgoraRequester()
        var indexPath:NSIndexPath = NSIndexPath(forItem: sender, inSection: 0)
        self.table.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        var not_ready = true
        let params = ["id":id, "category":category]
        api_requester.POST("deletepost/", params: params,
            success: {parseJSON -> Void in
                dispatch_async(dispatch_get_main_queue(), {self.deleteUI(sender) })
            },
            failure: {code,message -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    let alertController = UIAlertController(title: "Connection error", message:
                        "Your post was not deleted, check signal and try again", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction!) in
                        self.arrayOfPosts[sender].deleting = false
                        dispatch_async(dispatch_get_main_queue(), {
                            self.table.reloadData()
                        })
                    }))
                    self.presentViewController(alertController, animated: true, completion: nil)
                })
            }
        )
    }
    func twitterTouched(){
        var VC1 = self.storyboard?.instantiateViewControllerWithIdentifier("twitter") as! TwitterViewController
        let navController = UINavigationController(rootViewController: VC1)
        self.presentViewController(navController, animated:true, completion: nil)
    }
    @IBAction func deleteSelected(sender: AnyObject) {
        let cat:String = arrayOfPosts[sender.tag].category as String
        let id:String = arrayOfPosts[sender.tag].id as String
        let alertController = UIAlertController(title: nil, message:
            "Are you sure you wish to delete " + arrayOfPosts[sender.tag].title  + "?", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default,handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction!) in
            if (NSUserDefaults.standardUserDefaults().objectForKey("user_posts") != nil) {
                self.arrayOfPosts[sender.tag].deleting = true
                var index = NSIndexPath(forItem: sender.tag, inSection: 0)
                self.deletePost(cat, id:id,sender:sender.tag)
            }
        }))
        presentViewController(alertController, animated: true, completion: nil)
    }
    @IBAction func editSelected(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setObject(arrayOfPosts[sender.tag].id, forKey: "post_id")
        NSUserDefaults.standardUserDefaults().setObject(arrayOfPosts[sender.tag].category, forKey: "cat")
        var VC1 = self.storyboard?.instantiateViewControllerWithIdentifier("editPost") as! EditPostViewController
        let navController = UINavigationController(rootViewController: VC1)
        self.presentViewController(navController, animated:true, completion: nil)
    }
    @IBAction func bumpButton(sender: AnyObject) {
        self.bumpPost(arrayOfPosts[sender.tag].category,post_id: arrayOfPosts[sender.tag].id,tag:sender.tag)
    }
    @IBAction func edit(sender: AnyObject) {
        var VC1 = self.storyboard?.instantiateViewControllerWithIdentifier("editUser") as! EditUserController
        let navController = UINavigationController(rootViewController: VC1)
        self.presentViewController(navController, animated:true, completion: nil)
    }
    @IBAction func helpAndFAQ(sender: AnyObject) {
        var VC1 = self.storyboard?.instantiateViewControllerWithIdentifier("helpAndFAQ") as! HelpAndFAQController
        let navController = UINavigationController(rootViewController: VC1)
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
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "moreUserPosts")
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "profileNeedsReloading")
            var VC1 = self.storyboard?.instantiateViewControllerWithIdentifier("login") as! LoginController
            let navController = UINavigationController(rootViewController: VC1)
            self.presentViewController(navController, animated:true, completion: nil)
        }))
    }
    @IBAction func newPost(sender: AnyObject) {
        var VC1 = self.storyboard?.instantiateViewControllerWithIdentifier("create") as! CreatePostController
        let navController = UINavigationController(rootViewController: VC1)
        self.presentViewController(navController, animated:true, completion: nil)
    }
    func updateNSData(newDate:String,id:String,category:String){
        var current_posts:[[AnyObject]] = NSUserDefaults.standardUserDefaults().objectForKey("user_posts") as! [[AnyObject]]
        var new_post = []
        var the_index = 0
        for i in 0...current_posts.count - 1 {
            if current_posts[i][0] as! String == id && String(current_posts[i][3] as! String) == category {
                the_index = i
            }
        }
        current_posts[the_index][4] = newDate
        NSUserDefaults.standardUserDefaults().setObject(current_posts, forKey: "user_posts")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    //requests
    func addImage(id:Int, category:String, data:NSData?,failure:Bool){
        var hitCount = 0
        var foundPost = 0
        NSThread.sleepForTimeInterval(0.2)
        for post in arrayOfPosts {
            if(post.id.toInt() == id && category == post.category){
                if(failure){
                    var image =  UIImage(named:"failedToReload")
                    post.imageName = UIImageJPEGRepresentation(image, 1)
                }
                else{
                    post.imageName = data!
                }
                post.imageRefreshing = false
                foundPost = hitCount
                var current_posts:[[AnyObject]] = NSUserDefaults.standardUserDefaults().objectForKey("user_posts") as! [[AnyObject]]
                current_posts[hitCount][2] = data!
                NSUserDefaults.standardUserDefaults().setObject(current_posts, forKey: "user_posts")
            }
            hitCount += 1
        }
        dispatch_async(dispatch_get_main_queue(), {
            var indexPath = NSIndexPath(forRow: foundPost, inSection: 0)
            self.table.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
        })
    }
    func getMorePosts(date:String,older:String,fromTop:Bool,refresh:Bool){
        var api_requester: AgoraRequester = AgoraRequester()
        if(!fromTop){
            actInd.startAnimating()
        }
        let username = NSUserDefaults.standardUserDefaults().objectForKey("username") as! String
        let divider_date_time = date
        let params = ["username":username,
            "divider_date_time":divider_date_time,
            "older":older]
            as Dictionary<String,AnyObject>
        api_requester.UserPosts(params,
            info: {parseJSON -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    self.updatePosts(parseJSON, refresh:refresh)})
            },
            imageReceived: {category,postID,imageData -> Void in
                //imageReceived function only called IF there is an image
                //no point in running this function just to determine there is no image...
                self.addImage(postID, category:category, data:imageData,failure:false)
            },
            failure: {isImage,postID,category,code,message -> Void in
                if(!isImage){
                    dispatch_async(dispatch_get_main_queue(), {
                    self.refreshControl.endRefreshing()
                    self.actInd.stopAnimating()
                    self.centerLoad.stopAnimating()
                    var alert = UIAlertController(title: "Connection error", message: "Unable to load posts, pull down to refresh", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                    self.presentViewController(alert, animated: true, completion: nil)
                    }))})
                }
                else{
                    self.addImage(postID!, category:category!, data:nil,failure:true)
                }
            }
        )
    }
    func updatePosts(parseJSON:NSDictionary,refresh:Bool){
        if(refresh){
            arrayOfPosts = []
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "user_posts")
        }
        let posts: AnyObject = parseJSON["posts"]!
        let more = parseJSON["more_exist"] as! String //1 or zero
        let recent_del: String = parseJSON["recent_post_deletion"] as! String
        if(recent_del == "1"){
            let alertController = UIAlertController(title: "A post of yours over three weeks old has been deleted" , message:
                "Bump your posts before three weeks if you wish to avoid this in the future", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: {(alert: UIAlertAction!) in
            }))
            presentViewController(alertController, animated: true, completion: nil)
        }
        if posts.count > 0{
            for i in 0...(posts.count - 1 ){
                let post: AnyObject! = posts[i]
                var postID = post["id"]! as! Int
                let title = post["title"]! as! String
                let category = post["category"] as! String
                let post_date_time = post["post_date_time"]! as! String
                let display_value = post["display_value"]! as! String
                //THE THUMBNAIL IMAGE IS PROCESSED HERE
                var newPost:ProfilePost
                if(post["has_image"] as! Bool){
                    newPost = ProfilePost(title: title, id: String(postID), cat: category, date: post_date_time,imageComing:true)
                }
                else{
                    newPost = ProfilePost(title: title, id: String(postID), cat: category, date: post_date_time,imageComing:false)
                }
                newPost.upDateNSData(false)
                arrayOfPosts.append(newPost)
            }
        }
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
        self.table.reloadData()
    }
    //table view functions
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return actInd
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(arrayOfPosts.count == 0){
            makeLayout()
            self.reloadInputViews()
        }
        return arrayOfPosts.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ProfilePostCell = table.dequeueReusableCellWithIdentifier("Cell") as! ProfilePostCell
        cell.addSubview(UIView())
        let postCell = arrayOfPosts[indexPath.row]
        cell.edit.tag = indexPath.row
        cell.delete.tag = indexPath.row
        cell.bump.tag = indexPath.row
        cell.setCell(postCell.title, imageName: postCell.imageName,refreshing:postCell.refreshing,deleting:postCell.deleting)
        cell.setTranslatesAutoresizingMaskIntoConstraints(false)
        cell.id = postCell.id
        cell.category = postCell.category
        if(postCell.imageRefreshing){
            cell.imageRefresh.startAnimating()
            cell.itemImage.hidden = true
        }
        else {
            cell.imageRefresh.stopAnimating()
            cell.itemImage.hidden = false
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Get the row data for the selected row
        category = arrayOfPosts[indexPath.row].category
        id = arrayOfPosts[indexPath.row].id
        NSUserDefaults.standardUserDefaults().setObject(id, forKey: "post_id")
        NSUserDefaults.standardUserDefaults().setObject(arrayOfPosts[indexPath.row].category, forKey: "cat")
        var VC1 = self.storyboard?.instantiateViewControllerWithIdentifier("viewPost") as! ViewPostController
        let navController = UINavigationController(rootViewController: VC1)
        self.presentViewController(navController, animated:true, completion: nil)
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(arrayOfPosts.count != 0 ){
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
                label.text = " You currently have no posts, pull down to refresh"
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func scrollViewDidScroll(scrollView: UIScrollView){
        var currentOffset = scrollView.contentOffset.y;
        var maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if(maximumOffset - currentOffset <= 15 && bottomNeedsMore && !refreshControl.refreshing){
            self.actInd.startAnimating()
            var oldLength = arrayOfPosts.count - 1
            bottomNeedsMore = false
            //send request for more posts
            if(arrayOfPosts.count == 0){
                getMorePosts("",older:"1",fromTop:false,refresh:false)
            } else {
                getMorePosts(arrayOfPosts[oldLength].date,older:"1",fromTop:false,refresh:false)
            }
        }
    }
}
extension String {
    subscript (i: Int) -> String {
        return String(Array(self)[i])
    }
}

