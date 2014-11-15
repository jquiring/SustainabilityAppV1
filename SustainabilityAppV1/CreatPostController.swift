//
//  CreatPostController.swift
//  SustainabilityAppV1
//
//  Created by Lucas Orlita on 11/14/14.
//  Copyright (c) 2014 Jake Quiring. All rights reserved.
//

import UIKit

class CreatePostController: UIViewController {

    @IBOutlet weak var cat_picker: UIPickerView!
    @IBOutlet weak var desc_field: UITextField!
    @IBOutlet weak var title_field: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
