//
//  TwitterTableViewController.swift
//  SustainabilityAppV1
//
//  Created by Lucas Orlita on 3/22/15.
//  Copyright (c) 2015 Jake Quiring. All rights reserved.
//

import UIKit
import TwitterKit


class TwitterTableViewController: UITableViewController , TWTRTweetViewDelegate {
    let tweetTableReuseIdentifier = "TweetCell"
    // Hold all the loaded Tweets
    var tweets: [TWTRTweet] = [] {
        didSet {
            tweetTable.reloadData()
        }
    }
    let tweetIDs = ["2011", // @jack's first Tweet
        "510908133917487104"] // our favorite bike Tweet
    
    @IBOutlet var tweetTable: UITableView!
    override func viewDidLoad() {
        // Setup the table view
        tweetTable.estimatedRowHeight = 150
        tweetTable.rowHeight = UITableViewAutomaticDimension // Explicitly set on iOS 8 if using automatic row height calculation
        tweetTable.allowsSelection = false
        tweetTable.registerClass(TWTRTweetTableViewCell.self, forCellReuseIdentifier: tweetTableReuseIdentifier)
        
        // Load Tweets
        Twitter.sharedInstance().logInGuestWithCompletion { guestSession, error in
            if (guestSession != nil) {
                Twitter.sharedInstance().APIClient.loadUserWithID("1601601674") { user, error in
                    if let userID = user as TWTRUser?{
                        println(user.description)
                        //self.tweetIDs = usersWithJSONArray(userID)
                        Twitter.sharedInstance().APIClient.loadTweetsWithIDs(self.tweetIDs) { tweets, error in
                            if let ts = tweets as? [TWTRTweet] {
                                self.tweets = ts
                            } else {
                                println("Failed to load tweets: \(error.localizedDescription)")
                            }
                        }}}
            } else {
                println("error: \(error.localizedDescription)");
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return tweets.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tweet = tweets[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(tweetTableReuseIdentifier, forIndexPath: indexPath) as TWTRTweetTableViewCell
        cell.tweetView.delegate = self
        cell.configureWithTweet(tweet)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let tweet = tweets[indexPath.row]
        return TWTRTweetTableViewCell.heightForTweet(tweet, width: CGRectGetWidth(self.view.bounds))
    }
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    Twitter.sharedInstance().logInGuestWithCompletion { (session: TWTRGuestSession!, error: NSError!) in
    Twitter.sharedInstance().APIClient.loadTweetWithID("20") { (tweet: TWTRTweet!, error: NSError!) in
    self.view.addSubview(TWTRTweetView(tweet: tweet))
    }
    }    */

}
