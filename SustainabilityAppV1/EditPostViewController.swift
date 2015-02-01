//
//  EditPostViewController.swift
//  SustainabilityAppV1
//
//  Created by Lucas Orlita on 1/30/15.
//  Copyright (c) 2015 Jake Quiring. All rights reserved.
//

import UIKit

class EditPostViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func pullPostInfoRequest(){
        //basically modified view post
    }
    
    func submitEditedPost(){
        // modified submit post
    }
    
    func splitFromAndToFields(location: String) -> String{
        // this function will be called to split the location into 2 strings, a 'From" and a "To"
        return ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.section == 0 || indexPath.section == 3){
            return 30
        }
        if(indexPath.section == 1){
            return 128
        }
        if(indexPath.section == 2){
            return 150
        }
        if(indexPath.section == 4 /*&& category.text == "Ride Shares"*/){
            return 50
        }
        if((indexPath.section == 5 || indexPath.section == 6 || indexPath.section == 7) /*&& category.text == "Ride Shares"*/){
            return 30
        }
        if(indexPath.section == 8 /*&& category.text == "Ride Shares" && round_trip_switch.on*/){
            return 30
        }
        if(indexPath.section == 9 /*&& category.text == "Books"*/){
            return 30
        }
        if((indexPath.section == 10 || indexPath.section == 11 ) /* && (category.text == "Services" || category.text == "Events")*/){
            return 30
        }
        if(indexPath.section == 12){
            return 100
        }
        return 0
    }

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
