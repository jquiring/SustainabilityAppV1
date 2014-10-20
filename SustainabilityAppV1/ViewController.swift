//
//  ViewController.swift
//  SustainabilityAppV1
//
//  Created by Jake Quiring on 10/20/14.
//  Copyright (c) 2014 Jake Quiring. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var switcher: UISegmentedControl!
    @IBOutlet var loginButtonLabel: UILabel!
    
    @IBAction func loginButtonAction(sender: UISegmentedControl) {
        switch(self.switcher.selectedSegmentIndex) {
        case 0:
            self.loginButtonLabel.text = "First Selected V2"
        case 1:
            self.loginButtonLabel.text = "Second Selected V2"
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

