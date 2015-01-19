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
    
    @IBOutlet var table: UITableView!
    var arrayOfPosts: [ListPost] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.registerClass(UITableViewCell.self,forCellReuseIdentifier:"cell")
        self.table.tableFooterView = UIView()

        navigationController?.navigationBar.barStyle = UIBarStyle.Default
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.633, green: 0.855, blue: 0.620, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light",size: 24)!,NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        setUpPosts()
        setupTable()
        table.reloadData()
    }
    override func viewDidAppear(animated: Bool) {
        table.reloadData()
    }
    func setUpPosts(){
        arrayOfPosts = []
        if (NSUserDefaults.standardUserDefaults().objectForKey("user_posts") != nil) {
            var current_posts:Dictionary<String,AnyObject> = NSUserDefaults.standardUserDefaults().objectForKey("user_posts") as Dictionary<String,AnyObject>
            for (id,post) in current_posts {
                println("new_post)")
                var new_post:ListPost
                new_post = ListPost(title: post[0] as String, imageName: post[1] as NSData, id: id,keyValue:"This is the key")
                
                arrayOfPosts.append(new_post)
            }
        }
    }
    func setupTable(){
        table.delegate = self
        table.dataSource = self
        table.estimatedRowHeight = 80.0
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


