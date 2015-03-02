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
    optional func toggleLeftPanel()
    optional func collapseSidePanels()
}

class CenterViewController: UIViewController,  UITableViewDataSource,UITableViewDelegate {
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
        self.table.addSubview(self.refreshControl)
        self.refreshControl.addTarget(self, action: "didRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.table.registerClass(UITableViewCell.self,forCellReuseIdentifier:"cell")
        self.table.tableFooterView = UIView()
        navigationController?.navigationBar.barStyle = UIBarStyle.Default
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.633, green: 0.855, blue: 0.620, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light",size: 24)!,NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        setUp("",older: "1",fromTop: "1")
        setupTable()
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
    }
    
    override func viewDidAppear(animated: Bool) {
        if(needsReloading){
            self.table.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(0, self.table.numberOfSections())), withRowAnimation: .None)
            needsReloading = false
        }
    }
    func didRefresh(){
        setUp("",older: "1",fromTop: "1")
        self.table.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(0, self.table.numberOfSections())), withRowAnimation: .None)
        
    }
    func upDatePosts(parseJSON:Dictionary<String,AnyObject>, date:String,older:String,fromTop:String){
        let posts: AnyObject = parseJSON["posts"]!
        if(fromTop == "1"){
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
                
                println(title)
                var new_post:ListPost
                let imageString = post["image"]! as String
                if !imageString.isEmpty {
                    let imageData = NSData(base64EncodedString: imageString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
                    new_post = ListPost(title: title as String, imageName: imageData, id: String(postID),keyValue:display_value,cat:category,date:date)
                    
                    //do stuff with the image here
                }
                else{
                    new_post = ListPost(title: title as String, id: String(postID),keyValue:display_value,cat:category,date:date)
                    
                }
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
    func setUp(date:String,older:String,fromTop:String){
       
        var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 25, 25)) as UIActivityIndicatorView
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        if(date == ""){
            if(first_time) {
                actInd.startAnimating()
                first_time = false
            }                                                                                                                    
        }
        self.navigationController?.view.addSubview(actInd)
        var api_requester: AgoraRequester = AgoraRequester()
        let categories:[String] = [] //empty string means all categories
        let keywordSearch:String = "" //empty string means no keyword search
        let min_price = "" //"" means no min_price
        let max_price = "" //"" means no max_price
        let free = "0" //false means not free only, true means is free only
        let params = ["categories":categories,
            "keywordSearch":keywordSearch,
            "min_price":min_price,
            "max_price":max_price,
            "free":free,
            "divider_date_time":date,
            "older":older]
            as Dictionary<String,AnyObject>
        
        api_requester.POST("postquery/", params: params,
            success: { parseJSON -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    self.upDatePosts(parseJSON, date:date,older:older,fromTop:fromTop)
                    self.actInd.stopAnimating()
                    actInd.stopAnimating()
                    self.refreshControl.endRefreshing()
                    self.postsLoaded = true})
            },
            failure: {code,message -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    self.actInd.stopAnimating()
                    var alert = UIAlertController(title: "Warning", message: "Unable to load posts, pull down to refresh", preferredStyle: UIAlertControllerStyle.Alert)
                    self.presentViewController(alert, animated: true, completion: nil)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                    }))
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
            d.toggleLeftPanel?()
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
        cell.setCell(postCell.title, imageName: postCell.imageName,keyValue:postCell.key_value,bounds:table.bounds)
 
        cell.setNeedsDisplay()
        cell.setNeedsLayout()
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        return cell
        
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return actInd
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Get the row data for the selected row
        println(arrayOfPosts[indexPath.row].id)
        NSUserDefaults.standardUserDefaults().setObject(arrayOfPosts[indexPath.row].id, forKey: "post_id")
        NSUserDefaults.standardUserDefaults().setObject(arrayOfPosts[indexPath.row].category, forKey: "cat")
        var VC1 = self.storyboard?.instantiateViewControllerWithIdentifier("viewPost") as ViewPostController
        let navController = UINavigationController(rootViewController: VC1)
        // Creating a navigation controller with VC1 at the root of the navigation stack.
        self.presentViewController(navController, animated:true, completion: nil)

    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(arrayOfPosts.count != 0 ){
            println("returning 1")
            self.table.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            self.table.backgroundView = UIView()
            return 1
        }
        else if(postsLoaded && arrayOfPosts.count == 0){
            println("creating empty tableview")
            var label:UILabel = UILabel()
            label.frame = CGRectMake(0,0,self.view.bounds.width,self.view.bounds.height)
            label.text = "No data is currently available. Please pull down to refresh or change search constraints"
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
            
            if(maximumOffset - currentOffset <= 15 && bottomNeedsMore){
                var oldLength = arrayOfPosts.count - 1
                bottomNeedsMore = false
                //println("Time to reload table")
                //println(arrayOfPosts[oldLength].date)
                //println(arrayOfPosts[oldLength - 1].date)
                //send request for more posts
                actInd.startAnimating()
                setUp(arrayOfPosts[oldLength].date,older:"1",fromTop : "0")
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
    
    var delegate: CenterViewControllerDelegate?
}
    

    