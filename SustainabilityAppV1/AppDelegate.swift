 //
//  AppDelegate.swift
//  SustainabilityAppV1
//
//  Created by Jake Quiring on 10/20/14.
//  Copyright (c) 2014 Jake Quiring. All rights reserved.
//

import UIKit
import Fabric
import TwitterKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var flag = false
    var userDefaults = NSUserDefaults.standardUserDefaults()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Fabric.with([Twitter()])
        
        if((userDefaults.objectForKey("username")) != nil) {
            window = UIWindow(frame: UIScreen.mainScreen().bounds)
            let containerViewController = ContainerViewController()
            window!.rootViewController = containerViewController
            window!.makeKeyAndVisible()
        }
       
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //refreshUserPosts()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func refreshUserPosts(){
        /*
        if(userDefaults.objectForKey("username") != nil) {
            if(userDefaults.objectForKey("user_posts") != nil) {
                println("GOT TO THIS LINE OF CODE")
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "user_posts")
                
                var request = NSMutableURLRequest(URL: NSURL(string: "http://147.222.165.3:8000/userposts/")!)
                //trenton
                //var request = NSMutableURLRequest(URL: NSURL(string: "http://147.222.165.133:8000/userposts/")!)
                request.HTTPMethod = "POST"
                
                //open NSURLSession
                var session = NSURLSession.sharedSession()
                
                //set username
                let username = userDefaults.objectForKey("username") as String
                
                let params = ["username":username] //format for as Dictionary for JSON
                    as Dictionary<String,AnyObject>
                
                //Load body with JSON serialized parameters, set headers for JSON! (Star trek?)
                var err: NSError?
                request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                
                
                //define NSURLSession data task with completionHandler call back function
                var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                    
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
                            
                            //attempt to parse JSON
                            if let parseJSON = json as? Dictionary<String,AnyObject> {
                                
                                let message = parseJSON["message"] as String
                                
                                //200 = OK: carry on!
                                if(status_code == 200){
                                    println(message)
                                    
                                    //response code is OK, continue with parsing JSON and reading response data
                                    //THIS IS WHERE RESPONSE HANDLING CODE SHOULD GO
                                    
                                    //get all of the posts from response
                                    let posts: AnyObject = parseJSON["posts"]!
                                    
                                    //iterate through each post
                                    
                                    if(posts.count != 0){
                                        for i in 0...(posts.count - 1){
                                            let post: AnyObject! = posts[i] //just so we don't keep re-resolving this reference
                                            
                                            //get the easy ones, title, display_value and post ID
                                            let title = post["title"] as String
                                            let postID = post["id"]! as Int
                                            let category = post["category"] as String
                                            
                                            
                                            let imageString = post["image"]! as String
                                            
                                            //make sure there is an image...
                                            var new_post:ProfilePost
                                            if !imageString.isEmpty {
                                                let imageData = NSData(base64EncodedString: imageString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
                                                new_post = ProfilePost(title: title, imageName: imageData, id: String(postID),cat:category,date:)
                                                
                                            }
                                                
                                                
                                            else{
                                                new_post = ProfilePost(title: title, id: String(postID),cat:category)
                                                
                                            }
                                            new_post.upDateNSData(false)
                                        }
                                    }
                                }
                                    
                                    //400 = BAD_REQUEST: error in creating user, display error!
                                else if(status_code == 400){
                                    
                                    println()
                                    println(message)
                                }
                                    
                                    //500 = INTERNAL_SERVER_ERROR. Oh snap *_*
                                else if(status_code == 500){
                                    println("The server is down! I blame Schnagl")
                                }
                            }
                        }
                        else {
                            println("Error in casting response, data incomplete")
                        }
                    }
                    
                })
                
                task.resume()
                println("GOT PAST TASK RESUME")
                while(flag){
                }
            }
        }
 */
    }
 }
 

