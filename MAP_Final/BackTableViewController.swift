//
//  BackTableViewController.swift
//  MAP_Final
//
//  Created by RahulKumar Gaddam on 12/7/15.
//  Copyright © 2015 RahulKumar Gaddam. All rights reserved.
//  Under The Guidence of  Professor Robert J. Irwin
//  Team Name   : MedAssist Mobile Application
//  Team Members: Rahulkumar Gaddam (rgaddam@syr.edu)- Kusum Rudrayya (krudrayy@syr.edu) - Vemosh kumar (pkadavat@syr.edu)
//  Course Name : CIS/CSE 651 - Fall 2015 - Mobile Application Programming
//  Project Name: MedAssist - Never Forget your medicine again
//  Description :This file loads data in to table view that is revealed when user swipes on the main screen (Slide menu bar on the left )
import Foundation


class BackTableViewController : UITableViewController {
// static data that is being used for loading in to table view
var TableArray = [String]()
    var TableArrayimg  = [String]()
    override func viewDidLoad() {
       //names of the different views
        TableArray = ["Home" , "MyStatus" ,"NearBy-Pharmacy" ,"Send-Report ","Settings" , "Emergency-Info"]
        TableArrayimg = ["Home" , "Mystatus" ,"Nearbypharmacy" ,"Sendreport ","Settings" , "Emergencyinfo"]
    }


    override func tableView(tableView : UITableView , numberOfRowsInSection section: Int ) -> Int {
    
    return TableArray.count
    
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableArray[indexPath.row], forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = TableArray[indexPath.row]
        
        cell.textLabel!.font = UIFont (name: "American Typewriter", size: 18)
        cell.textLabel!.textColor = UIColor.whiteColor()
    
        return cell
    }
    
    
}