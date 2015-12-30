//
//  SettingsViewCOntroller.swift
//  MAP_Final
//
//  Created by RahulKumar Gaddam on 12/7/15.
//  Copyright © 2015 RahulKumar Gaddam. All rights reserved.
//  Under The Guidence of  Professor Robert J. Irwin
//  Team Name   : MedAssist Mobile Application
//  Team Members: Rahulkumar Gaddam (rgaddam@syr.edu)- Kusum Rudrayya (krudrayy@syr.edu) - Vemosh kumar (pkadavat@syr.edu)
//  Course Name : CIS/CSE 651 - Fall 2015 - Mobile Application Programming
//  Project Name: MedAssist - Never Forget your medicine again
//  Description :This is a controller for the settings of the application . We used the settings to control the SMS and Email Services as per the wish of the end user 

import Foundation
import Parse

class SettingsViewController : UIViewController {
    @IBOutlet weak var ENotify: UISwitch!
    @IBOutlet weak var TNotify: UISwitch!
    
    
    @IBAction func SaveInfoSettings(sender: AnyObject) {
        
        
        let MedicineData = PFObject(className: "SettingsInfo")
        MedicineData["user"] = PFUser.currentUser()
        MedicineData["name"] = PFUser.currentUser()!.username
        if self.ENotify.on {
         MedicineData["Email"] = "True"
        
        }
        else
        {
          MedicineData["Email"] = "False"
        
        }
        if self.TNotify.on {
            MedicineData["SMS"] = "True"
            
        }
        else
        {
            MedicineData["SMS"] = "False"
            
        }
        
       
        
        
        print("Medicine Settings saving...")
        MedicineData.saveInBackgroundWithBlock({
            (success: Bool , error: NSError?) -> Void in
            if error == nil
            {
                
                
                
                
            }
            else
            {
                
                print (error)
            }
            
            
        })
        
        
      
        
    }
    @IBOutlet weak var Open: UIBarButtonItem!
    
    
    override func viewDidLoad() {
     
        
        
        
        //querying database of parse
        if let MUserName = PFUser.currentUser()?["username"] as? String {
            let Mquery = PFQuery(className:"SettingsInfo")
            Mquery.whereKey("name", equalTo: MUserName)
            Mquery.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) scores.")
                    // Do something with the found objects
                    if let objects = objects {
                        for object in objects {
                            if ((object["Email"] as! NSString).boolValue){
                             self.ENotify.setOn(true, animated:true)
                            }
                            else
                            {
                           self.ENotify.setOn(false, animated:true)
                            
                            }
                            
                            if ((object["SMS"] as! NSString).boolValue ){
                                self.TNotify.setOn(true, animated:true)
                            }
                            else
                            {
                                self.TNotify.setOn(false, animated:true)
                                
                            }
                            
                            //self.ENotify. = object["FullName"] as! NSString as String
                            //self.Address.text =  object["Address"] as! NSString as String
                            
                            
                            
                            
                        }
                        
                    }
                    
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
            
        }
        Open.target = self.revealViewController()
        Open.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    
}
