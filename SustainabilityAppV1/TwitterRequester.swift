//
//  TwitterRequester.swift
//  SustainabilityAppV1
//
//  Created by Lucas Orlita on 3/1/15.
//  Copyright (c) 2015 Jake Quiring. All rights reserved.
//

import Foundation
import UIKit
import Social
import Accounts

class TwitterRequester{
    
    var dataSource = [AnyObject]()
    
    func getTimeLine() {
        
        let account = ACAccountStore()
        let accountType = account.accountTypeWithAccountTypeIdentifier(
            ACAccountTypeIdentifierTwitter)
        
        account.requestAccessToAccountsWithType(accountType, options: nil,
            completion: {(success: Bool, error: NSError!) -> Void in
                
                if success {
                    let arrayOfAccounts =
                    account.accountsWithAccountType(accountType)
                    
                    if arrayOfAccounts.count > 0 {
                        let twitterAccount = arrayOfAccounts.last as ACAccount
                        
                        let requestURL = NSURL(string:
                            "https://api.twitter.com/1.1/statuses/user_timeline.json")
                        
                        let parameters = ["screen_name" : "@ZagsGoGreen",
                            "include_rts" : "0",
                            "trim_user" : "1",
                            "count" : "20"]
                        
                        let postRequest = SLRequest(forServiceType:
                            SLServiceTypeTwitter,
                            requestMethod: SLRequestMethod.GET,
                            URL: requestURL,
                            parameters: parameters)
                        
                        postRequest.account = twitterAccount
                        
                        postRequest.performRequestWithHandler(
                            {(responseData: NSData!,
                                urlResponse: NSHTTPURLResponse!,
                                error: NSError!) -> Void in
                                var err: NSError?
                                self.dataSource = NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableLeaves, error: &err) as [AnyObject]
                                
                                if self.dataSource.count != 0 {
                                    dispatch_async(dispatch_get_main_queue()) {
                                        println(self.dataSource)
                                    }
                                }
                        })
                    }
                } else {
                    println("Failed to access account")
                }
        })
    }
    
}