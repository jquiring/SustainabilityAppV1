//
//  TwitterViewController.swift
//  SustainabilityAppV1
//
//  Created by Jake Quiring on 4/17/15.
//  Copyright (c) 2015 Jake Quiring. All rights reserved.
//

import UIKit
import Foundation

public class TwitterViewController: UIViewController {

    @IBOutlet var twitter: UIWebView!
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override public func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = UIBarStyle.Default
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.633, green: 0.855, blue: 0.620, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light",size: 24)!,NSForegroundColorAttributeName: UIColor.darkGrayColor()]
        let url = NSURL (string: "https://twitter.com/zagsgogreen");
        let requestObj = NSURLRequest(URL: url!);
        twitter.loadRequest(requestObj);
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
