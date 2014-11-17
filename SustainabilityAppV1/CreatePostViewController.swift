//
//  CreatePostViewController.swift
//  SustainabilityAppV1
//
//  Created by Lucas Orlita on 11/17/14.
//  Copyright (c) 2014 Jake Quiring. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var cat_picker: UIPickerView!
    
    @IBOutlet weak var title_field: UITextField!

    let pickerData = ["Cat1","Cat2","Cat3","Cat4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cat_picker.delegate = self
        cat_picker.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[row]
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
