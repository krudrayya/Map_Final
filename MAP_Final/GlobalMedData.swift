//
//  GlobalMedData.swift
//  MAP_Final
// We are using singleton pattern for notificaitons 
//  Created by RahulKumar Gaddam on 12/10/15.
//  Copyright © 2015 RahulKumar Gaddam. All rights reserved.
//  Under The Guidence of  Professor Robert J. Irwin
//  Team Name   : MedAssist Mobile Application
//  Team Members: Rahulkumar Gaddam (rgaddam@syr.edu)- Kusum Rudrayya (krudrayy@syr.edu) - Vemosh kumar (pkadavat@syr.edu)
//  Course Name : CIS/CSE 651 - Fall 2015 - Mobile Application Programming
//  Project Name: MedAssist - Never Forget your medicine again
//  Description : This File we are using NSUserDefaults for storing the data to communicate between app delegate and other files . This serves as a local storage for the application maintaining persistance of the data . 

import Foundation

// class declaration 
class GlobalMedData {
    class var sharedInstance : GlobalMedData {
        struct Static {
            static let instance : GlobalMedData = GlobalMedData()
        }
        return Static.instance
    }
  
    func addItem(item: NSInteger) {
        //Creating the NSUserdefaults to use as local data storage
        NSUserDefaults.standardUserDefaults().setInteger(item, forKey: "MedCount")
        NSUserDefaults.standardUserDefaults().synchronize()
        
    }
}