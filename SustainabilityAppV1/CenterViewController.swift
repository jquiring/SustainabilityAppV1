//
//  MainPageController.swift
//  SustainabilityAppV1
//
//  Created by Jake Quiring on 10/30/14.
//  Copyright (c) 2014 Jake Quiring. All rights reserved.
//

import UIKit

@objc
protocol CenterViewControllerDelegate {
    optional  func toggleLeftPanel()
    optional func toggleRightPanel()
    optional func collapseSidePanels()
}

class CenterViewController: UIViewController,  UITableViewDataSource,UITableViewDelegate,FilterViewControllerDelegate {
    var delegate: CenterViewControllerDelegate?
    var cancelButton :UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
    var centerActInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 25, 25)) as UIActivityIndicatorView
    //TODO:MAKE SURE NO DUPLICATE REQUESTS 
    var refreshControl = UIRefreshControl()
    var needsReloading = true
    var bottomNeedsMore = true
    var no_more_posts = "1"
    var first_time = true
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 25, 25)) as UIActivityIndicatorView
    var postsLoaded = false
    @IBOutlet internal var table: UITableView!
    var arrayOfPosts: [ListPost] = []
    var cellHeights = Dictionary<String,Int>()
    override func viewDidLoad() {
        super.viewDidLoad()
        centerActInd.center = self.view.center
        centerActInd.hidesWhenStopped = true
        centerActInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.navigationController?.view.addSubview(centerActInd)
        var r = self.view.bounds
        var r2 = CGRect()
        r2.size.width = r.width
        r2.size.height = 30
        cancelButton.bounds = r2
        cancelButton.backgroundColor = UIColor.lightGrayColor()
        cancelButton.setTitle("Filtered Search     X", forState: UIControlState.Normal)
        cancelButton.addTarget(self, action: "cancelAction", forControlEvents: UIControlEvents.TouchUpInside)
        cancelButton.center = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height-15)
        cancelButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Light",size: 18)
        cancelButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        //self.view.addSubview(cancelButton)
        self.navigationController?.view.addSubview(cancelButton)
        if(!checkFilteredSearch()){
            println("isnt a filtered search")
            cancelButton.hidden = true
        }
        else {
            println("is a filtered search")
            cancelButton.hidden = false
        }
        self.table.addSubview(self.refreshControl)
        self.refreshControl.addTarget(self, action: "didRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.table.registerClass(UITableViewCell.self,forCellReuseIdentifier:"cell")
        self.table.tableFooterView = UIView()
        navigationController?.navigationBar.barStyle = UIBarStyle.Default
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.633, green: 0.855, blue: 0.620, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light",size: 24)!,NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        setUp("",older: "1",fromTop: "1",fromNewFilter:false)
        setupTable()
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
    }
    func cancelAction(){
        println("cancel clicked")
        NSUserDefaults.standardUserDefaults().setObject("0",forKey:"free")
        NSUserDefaults.standardUserDefaults().setObject("",forKey:"min_price")
        NSUserDefaults.standardUserDefaults().setObject("",forKey:"max_price")
        NSUserDefaults.standardUserDefaults().setObject("",forKey:"keyword")
    NSUserDefaults.standardUserDefaults().setObject(["Books","Electronics","Household","Rideshares" ,"Services" ,"Events","Recreation","Clothing"],forKey:"categories")
        setUp("",older: "1",fromTop: "1",fromNewFilter:true)
        self.table.reloadData()
        cancelButton.hidden = true
    }
    override func viewDidAppear(animated: Bool) {
        if(NSUserDefaults.standardUserDefaults().objectForKey("newFilterPerameters") as Bool){
            NSUserDefaults.standardUserDefaults().setObject(false,forKey:"newFilterPerameters")
            setUp("",older: "1",fromTop: "1",fromNewFilter:true)
            if(!checkFilteredSearch()){
                println("isnt a filtered search")
                cancelButton.hidden = true
            }
            else {
                cancelButton.hidden = false
            }
        }
        if(needsReloading){
            self.table.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(0, self.table.numberOfSections())), withRowAnimation: .None)
            needsReloading = false
        }
    }

    func checkFilteredSearch() -> Bool {
        
        var max_price : String = NSUserDefaults.standardUserDefaults().objectForKey("max_price") as String
        if(( max_price != "") ||
            (NSUserDefaults.standardUserDefaults().objectForKey("min_price") as String != "") ||
            (NSUserDefaults.standardUserDefaults().objectForKey("free") as String != "0") ||
            (NSUserDefaults.standardUserDefaults().objectForKey("keyword") as String != "") ||
        (NSUserDefaults.standardUserDefaults().objectForKey("categories") as [String] != ["Books","Electronics","Household","Rideshares" ,"Services" ,"Events","Recreation","Clothing"])){
    
            return true
        }
        else{
            return false
        }
    }

    func didRefresh(){
        if(!centerActInd.isAnimating() && !actInd.isAnimating()){
            setUp("",older: "1",fromTop: "1",fromNewFilter:false)
            self.table.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(0, self.table.numberOfSections())), withRowAnimation: .None)
        }
        else{
            refreshControl.endRefreshing()
        }
        
    }
    func upDatePosts(parseJSON:Dictionary<String,AnyObject>, date:String,older:String,fromTop:String,fromNewFilter:Bool){
        let posts: AnyObject = parseJSON["posts"]!
        if(fromTop == "1" || fromNewFilter){
            self.arrayOfPosts = []
        }
        let more_exists = parseJSON["more_exist"] as String
        if(more_exists == "1"){
            self.bottomNeedsMore = true
        }
        if(posts.count != 0){
            for i in 0...(posts.count - 1){
                let post: AnyObject! = posts[i] //just so we don't keep re-resolving this reference
                
                //get the easy ones, title and display_value
                //HERE ARE THE TEXTUAL INFORMATION PIECES FOR THE POST
                
                let title = post["title"] as String
                let display_value = post["display_value"]! as String
                let postID = post["id"]! as Int
                let category = post["category"] as String
                let date = post["post_date_time"] as String
                let image  = post["has_image"] as Bool
                var new_post:ListPost
                /*
                
                let imageString = post["image"]! as String
                if !imageString.isEmpty {
                    let imageData = NSData(base64EncodedString: imageString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
                    new_post = ListPost(title: title as String, imageName: imageData, id: String(postID),keyValue:display_value,cat:category,date:date)
                    
                    //do stuff with the image here
                }

                else{
                */

                new_post = ListPost(title: title as String, id: String(postID),keyValue:display_value,cat:category,date:date,has_image:image)
              
                if(older == "0"){
                    self.arrayOfPosts.insert(new_post, atIndex: 0)
                }
                else{
                    self.arrayOfPosts.append(new_post)
                }
            }
        }
        self.table.reloadData()
    }
    func setUp(date:String,older:String,fromTop:String,fromNewFilter:Bool){
       
        

        if(date == ""){
            if(first_time || fromNewFilter) {
                centerActInd.startAnimating()
                first_time = false
                cancelButton.enabled = false
            }                                                                                                                    
        }
        
        var api_requester: AgoraRequester = AgoraRequester()
        let categories = NSUserDefaults.standardUserDefaults().objectForKey("categories") as [String]
        let keywordSearch:String = NSUserDefaults.standardUserDefaults().objectForKey("keyword") as String
        let min_price = NSUserDefaults.standardUserDefaults().objectForKey("min_price") as String
        let max_price = NSUserDefaults.standardUserDefaults().objectForKey("max_price") as String
        let free = NSUserDefaults.standardUserDefaults().objectForKey("free") as String
        let params = ["categories":categories,
            "keywordSearch":keywordSearch,
            "min_price":min_price,
            "max_price":max_price,
            "free":free,
            "divider_date_time":date,
            "older":older]
            as Dictionary<String,AnyObject>
        
        api_requester.PostQuery(params,
            info: {parseJSON -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.upDatePosts(parseJSON, date:date,older:older,fromTop:fromTop,fromNewFilter:fromNewFilter)
                    self.actInd.stopAnimating()
                    self.centerActInd.stopAnimating()
                    self.refreshControl.endRefreshing()
                    self.postsLoaded = true
                    self.cancelButton.enabled = true
                })
            },
            imageReceived: {category,postID,imageData -> Void in
                //imageReceived function only called IF there is an image
                //no point in running this function just to determine there is no image...
                print("Received image for" + category + " ")
                println(postID)
                imageData.writeToFile("/Users/kylehandy/Desktop/" + category + String(postID) + ".png",atomically: false)
                var postCount = 0
                var hitCount:Int = 0
                for post in self.arrayOfPosts{
                    if(String(postID) == post.id && category == post.category){
                        post.imageName = imageData
                        post.image_loaded = true
                        hitCount = postCount
                    }
                    postCount++
                }
                dispatch_async(dispatch_get_main_queue(), {
                    var indexPath = NSIndexPath(forRow: hitCount, inSection: 0)
                    self.table.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                    //self.table.reloadData()
                    
                })
            },
            failure: {isImage,postID,category,code,message -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    if(isImage){
                        var postCount = 0
                        var hitCount = 0
                        for post in self.arrayOfPosts {
                            if((String(postID!) == post.id) && (category == post.category)){
                                post.image_error = true
                                hitCount = postCount;
                  
                            }
                            postCount++
                        }
                        dispatch_async(dispatch_get_main_queue(), {
                            var indexPath = NSIndexPath(forRow: postCount, inSection: 0)
                            self.table.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                        })
                    }
                    else{
                        var alert = UIAlertController(title: "Connection error", message: "Unable to load posts, pull down to refresh", preferredStyle: UIAlertControllerStyle.Alert)
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                            
                        }))
                        

                    }

                    
                    
                })
            }
            
        )
        
    }

    
    func setupTable(){
        table.delegate = self
        table.dataSource = self
    }
    @IBAction func profile(sender: AnyObject) {
        if let d = delegate {
            d.toggleLeftPanel!()
        }
    }
    
    @IBAction func filter(sender: AnyObject) {
        if let d = delegate {
            d.toggleRightPanel!()
        }
    }
    
    @IBAction func search(sender: AnyObject) {
        
        var VC1 = self.storyboard?.instantiateViewControllerWithIdentifier("searchPage") as FilterViewController
        let navController = UINavigationController(rootViewController: VC1)
        self.presentViewController(navController, animated:true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       
        return arrayOfPosts.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
 
        let cell:ListPostCell = table.dequeueReusableCellWithIdentifier("ListCell") as ListPostCell
     
        let postCell = arrayOfPosts[indexPath.row]
        if(postCell.image_error){
            //hide refresh show error image
            cell.setCell(postCell.title,keyValue:postCell.key_value,bounds:table.bounds,hasError:true)
        }
        else if(postCell.has_image && !postCell.image_loaded){
            //show refresh hide image
            cell.setCell(postCell.title,keyValue:postCell.key_value,bounds:table.bounds)
        }
        else {
            //show image hide refresh
            cell.setCell(postCell.title, imageName: postCell.imageName,keyValue:postCell.key_value,bounds:table.bounds)
        }

        cell.setNeedsDisplay()
        cell.setNeedsLayout()
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        return cell
        
    }
    func filterSelected(){
        println("filter selected")
        
        if(!checkFilteredSearch()){
            cancelButton.hidden = true
        }
        else{
            cancelButton.hidden = false
        }
        setUp("",older: "1",fromTop: "1",fromNewFilter:true)
        delegate?.collapseSidePanels?()
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return actInd
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Get the row data for the selected row
        NSUserDefaults.standardUserDefaults().setObject(arrayOfPosts[indexPath.row].id, forKey: "post_id")
        NSUserDefaults.standardUserDefaults().setObject(arrayOfPosts[indexPath.row].category, forKey: "cat")
        var VC1 = self.storyboard?.instantiateViewControllerWithIdentifier("viewPost") as ViewPostController
        let navController = UINavigationController(rootViewController: VC1)
        // Creating a navigation controller with VC1 at the root of the navigation stack.
        self.presentViewController(navController, animated:true, completion: nil)

    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(arrayOfPosts.count != 0 ){
            self.table.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            self.table.backgroundView = UIView()
            return 1
        }
        else if(postsLoaded && arrayOfPosts.count == 0){
            var label:UILabel = UILabel()
            label.frame = CGRectMake(0,0,self.view.bounds.width,self.view.bounds.height)
            label.text = "No posts available. Pull down to refresh or change search constraints"
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
    func scrollViewDidScroll(scrollView: UIScrollView){
        if(arrayOfPosts.count >= 10 ){
            
            var currentOffset = scrollView.contentOffset.y;
            var maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            
            if(maximumOffset - currentOffset <= 15 && bottomNeedsMore && !centerActInd.isAnimating() && !refreshControl.refreshing){
                var oldLength = arrayOfPosts.count - 1
                bottomNeedsMore = false
                //println("Time to reload table")
                //println(arrayOfPosts[oldLength].date)
                //println(arrayOfPosts[oldLength - 1].date)
                //send request for more posts
                actInd.startAnimating()
                setUp(arrayOfPosts[oldLength].date,older:"1",fromTop : "0",fromNewFilter:false)
                //print("DATE" + arrayOfPosts[oldLength].date)
                
                //var indexes = [oldLength...self.arrayOfPosts.count]
                //var indexPath = NSIndexPath(indexPathWithIndexes:indexes, length:indexes.count)
                var indexPaths : [Int] = []
                for i in oldLength...arrayOfPosts.count {
                    indexPaths.append(0)
                    indexPaths.append(i)
                }
                //need to reload twice for some damn reason
                
                table.reloadData()
                self.table.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(0, self.table.numberOfSections())), withRowAnimation: .None)

                self.table.scrollToRowAtIndexPath(NSIndexPath(forRow: (oldLength)   , inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
                
                
            }
            
        }

    }
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var creatorLabel: UILabel!
    
    
}
    

    