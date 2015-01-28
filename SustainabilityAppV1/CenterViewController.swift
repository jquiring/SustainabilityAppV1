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
    @IBOutlet var table: UITableView!
    var arrayOfPosts: [ListPost] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        self.table.addSubview(self.refreshControl)
        println("something is not working")
        
        self.refreshControl.addTarget(self, action: "didRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.table.registerClass(UITableViewCell.self,forCellReuseIdentifier:"cell")
        self.table.tableFooterView = UIView()
        navigationController?.navigationBar.barStyle = UIBarStyle.Default
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.633, green: 0.855, blue: 0.620, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light",size: 24)!,NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        setUpPosts()
        setupTable()
        navigationController?.hidesBarsOnSwipe = true
        
    }
    override func viewDidAppear(animated: Bool) {
        if(needsReloading){
            self.table.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(0, self.table.numberOfSections())), withRowAnimation: .None)
            needsReloading = false
        }
        
    }
    func didRefresh(){
        
        setUpPosts()
        self.table.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(0, self.table.numberOfSections())), withRowAnimation: .None)
        self.refreshControl.endRefreshing()
    }
    func setUpPosts(){
        arrayOfPosts = []

        var request = NSMutableURLRequest(URL: NSURL(string: "http://147.222.165.3:8000/postquery/")!)
        //trenton
        //var request = NSMutableURLRequest(URL: NSURL(string: "http://147.222.165.133:8000/postquery/")!)
        request.HTTPMethod = "POST"
        
        //open NSURLSession
        var session = NSURLSession.sharedSession()
        
        //set filter parameters
        let category:String = "" //empty string means all categories
        let keywordSearch:String = "" //empty string means no keyword search
        let min_price = "" //"" means no min_price
        let max_price = "" //"" means no max_price
        let free = "0" //false means not free only, true means is free only
        
        let params = ["category":category,
            "keywordSearch":keywordSearch,
            "min_price":min_price,
            "max_price":max_price,
            "free":free,]  //images array
            as Dictionary<String,AnyObject>
        
        //Load body with JSON serialized parameters, set headers for JSON! (Star trek?)
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var not_ready = true

        //define NSURLSession data task with completionHandler call back function
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            //read the message from the response
            var message = ""
            var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &err) as? NSDictionary
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
            }
            else{
                
                //downcast NSURLResponse object to NSHTTPURLResponse
                if let httpResponse = response as? NSHTTPURLResponse {
                    
                    //get the status code
                    var status_code = httpResponse.statusCode
                    
                    //200 = OK: carry on!
                    if(status_code == 200){
                        println(message)
                        
                        //response code is OK, continue with parsing JSON and reading response data
                        //THIS IS WHERE RESPONSE HANDLING CODE SHOULD GO
                        if let parseJSON = json as? Dictionary<String,AnyObject>{
                            message = parseJSON["message"] as String
                            
                            let posts: AnyObject = parseJSON["posts"]!
                            if(posts.count != 0){
                                for i in 0...(posts.count - 1){
                                    let post: AnyObject! = posts[i] //just so we don't keep re-resolving this reference
                                
                                //get the easy ones, title and display_value
                                //HERE ARE THE TEXTUAL INFORMATION PIECES FOR THE POST
                                    let title = post["title"] as String
                                    let display_value = post["display_value"]! as String
                                    let postID = post["id"]! as Int
                                    let category = post["category"] as String
                                    println(title)
                                    var new_post:ListPost
                                
                                
                                
                                //THE THUMBNAIL IMAGE IS PROCESSED HERE
                                    let imageString = post["image"]! as String
                                    if !imageString.isEmpty {
                                        let imageData = NSData(base64EncodedString: imageString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
                                        new_post = ListPost(title: title as String, imageName: imageData, id: String(postID),keyValue:display_value,cat:category)
                                    //do stuff with the image here
                                    }
                                    else{
                                        new_post = ListPost(title: title as String, id: String(postID),keyValue:display_value,cat:category)
                                    }
                                    self.arrayOfPosts.append(new_post)
                                }
                            }
                            not_ready = false
                        }
                    }
                        
                        //400 = BAD_REQUEST: error in creating user, display error!
                    else if(status_code == 400){
                        println(message + "another part of the message")
                        var alert = UIAlertController(title: "Warning", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                        self.presentViewController(alert, animated: true, completion: nil)
                        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                        }))
                        not_ready = false
                    }
                        
                        //500 = INTERNAL_SERVER_ERROR. Oh snap *_*
                    else if(status_code == 500){
                        println("The server is down! I blame Schnagl")
                        not_ready = false
                    }
                    
                    
                }
                else {
                    println("Error in casting response, data incomplete")
                    not_ready = false
                }
            }
            
        })
        
        task.resume()
        
        println("something is not working")
        while(not_ready){
            
        }

        
    }
    func setupTable(){
        table.delegate = self
        table.dataSource = self
        table.estimatedRowHeight = 120.0
        table.rowHeight = UITableViewAutomaticDimension


    }
    @IBAction func profile(sender: AnyObject) {
        if let d = delegate {
            d.toggleLeftPanel?()
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(arrayOfPosts.count)
        return arrayOfPosts.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("not broken")
        let cell:ListPostCell = table.dequeueReusableCellWithIdentifier("ListCell") as ListPostCell
        println("still working")
        let postCell = arrayOfPosts[indexPath.row]
        cell.setCell(postCell.title, imageName: postCell.imageName,keyValue:postCell.key_value)

        return cell
        
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
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var currentOffset = scrollView.contentOffset.y;
        var maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
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


