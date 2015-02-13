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
        //navigationController?.hidesBarsOnSwipe = true
        
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
        self.refreshControl.endRefreshing()
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
                    self.upDatePosts(parseJSON, date:date,older:older,fromTop:fromTop)})
                
            },
            failure: {code,message -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    var alert = UIAlertController(title: "Warning", message: "Unable to load posts, pull down to refresh", preferredStyle: UIAlertControllerStyle.Alert)
                    self.presentViewController(alert, animated: true, completion: nil)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                    }))
                })
              
                /*
                if code == 500 {
                //500: Server failure
                println("Server Failure!!!!!")
                }
                else if code == 58 {
                    //58: No Internet Connection
                    println("No Connection!!!!!")
                }
                else if code == 599 {
                    //599: Request Timeout
                    println("Timeout!!!!!")
                }
                */
            }
        )
    }

    
    func setupTable(){
        table.delegate = self
        table.dataSource = self
        //table.estimatedRowHeight = 160.0
        //table.rowHeight = UITableViewAutomaticDimension


    }
    @IBAction func profile(sender: AnyObject) {
        if let d = delegate {
            d.toggleLeftPanel?()
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       
        return arrayOfPosts.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
 
        let cell:ListPostCell = table.dequeueReusableCellWithIdentifier("ListCell") as ListPostCell
     
        let postCell = arrayOfPosts[indexPath.row]
        cell.setCell(postCell.title, imageName: postCell.imageName,keyValue:postCell.key_value,bounds:table.bounds)
        //cell.unwrappedLabel.preferredMaxLayoutWidth = CGRectGetWidth(tableView.bounds)
 
        cell.setNeedsDisplay()
        cell.setNeedsLayout()
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        return cell
        
    }
    /*
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.table.estimatedRowHeight = 160
    }
    func tableView(tableView: UITableView,
        estimatedHeightForRowAtIndexPath indexPath: NSIndexPath)
        -> CGFloat {
            println("getting index " + String(indexPath.row))
            return CGFloat(self.cellHeights[arrayOfPosts[indexPath.row].id + arrayOfPosts[indexPath.row].category]!)
    }
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height + 15
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
    }
*/
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
    func scrollViewDidScroll(scrollView: UIScrollView){
        if(arrayOfPosts.count >= 10 ){
            
            var currentOffset = scrollView.contentOffset.y;
            var maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            
            if(maximumOffset - currentOffset <= 15 && bottomNeedsMore){
                var oldLength = arrayOfPosts.count - 1
                bottomNeedsMore = false
                println("Time to reload table")
                println(arrayOfPosts[oldLength].date)
                println(arrayOfPosts[oldLength - 1].date)
                //send request for more posts
                setUp(arrayOfPosts[oldLength].date,older:"1",fromTop : "0")
                print("DATE" + arrayOfPosts[oldLength].date)
            
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
    
    // MARK: Button actions
    
    
    
    
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


