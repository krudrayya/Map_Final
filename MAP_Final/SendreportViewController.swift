//
//  SendreportViewController.swift
//  MAP_Final
//
//  Created by RahulKumar Gaddam on 12/7/15.
//  Copyright © 2015 RahulKumar Gaddam. All rights reserved.
//  Under The Guidence of  Professor Robert J. Irwin
//  Team Name   : MedAssist Mobile Application
//  Team Members: Rahulkumar Gaddam (rgaddam@syr.edu)- Kusum Rudrayya (krudrayy@syr.edu) - Vemosh kumar (pkadavat@syr.edu)
//  Course Name : CIS/CSE 651 - Fall 2015 - Mobile Application Programming
//  Project Name: MedAssist - Never Forget your medicine again
//  Description :This page is used to send Email to the preferred emailIDs about the current status of the medication . This feature makes user easy to share his medication summary to his caretakers or consulting doctors 

import Foundation
import Parse
import Alamofire
class SendreportViewController : UIViewController {
    // outlet for the bar button - side menu
    @IBOutlet weak var Open: UIBarButtonItem!
    // function to send email to the particular email ID
    @IBOutlet weak var PMail: UITextField!
    @IBOutlet weak var SMail: UITextField!
    var bodytext:String = String()
   
    @IBAction func SendEmail(sender: AnyObject) {
         print("NButton check")
        
       
        var username1:String
        username1 = ""
        if let MUserName = PFUser.currentUser()?["username"] as? String {
            username1 = MUserName
            let Mquery = PFQuery(className:"MedicineData")
            Mquery.whereKey("name", equalTo: MUserName)
            Mquery.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) scores.")
                    // Do something with the found objects
                    if let objects = objects {
                        for object in objects {
                            print(object["MedicineName"])
                           self.bodytext = self.bodytext + "Medicine Name:" + ((((object["MedicineName"]) as! NSString) ) as String) as String + "\r\n"
                            self.bodytext = self.bodytext + "Dose to be taken:" + (((object["Dose"]) as! NSString) as String) as String + "\r\n"
                            self.bodytext = self.bodytext + "Dose Left Still" + (((object["DoseLeft"]) as! NSString) as String) as String + "\r\n" + "\r\n"
                            
                        }
                        
                    }
                    print(self.bodytext)
                    
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
            
        }
        
        
        let tempM = self.PMail.text! + ";" + self.SMail.text!
        // code for the mailgun API starts here
        
        // Key for Mail Gun API
        let key = "key-c0a65caf960b1ac03d6549f6cfc9e96e"
        
        //parameters required to send the email
        print("check")
           print(bodytext)
        let parameters = [
            
            "from": "rgaddam@syr.edu",
            
            "to": "Gaddam.rahul.kumar@gmail.com;" + tempM,
            
            "subject": "Important! Report from Med Assist Account : " + username1,
            
            "text": "Dear Recipient ," + self.bodytext + " This is a Report from the MedAssist - Team MedAssist"
            
        ]
        
        //third party request - alamofire for rest api request mail gun
        
        let r = Alamofire.request(.POST, "https://api.mailgun.net/v3/sandboxe0031c8cf9ce4b32b982e951306915ed.mailgun.org/messages", parameters:parameters)
            
            .authenticate(user: "api", password: key)
            
            .response { (request, response, data, error) in
                
                print(request)
                
                print(response)
                
                print(error)
                
        }
        
        
        print(r)
        //end of code for email
    }
    
    
    
    
    

    
    override func viewDidLoad() {
        Open.target = self.revealViewController()
        Open.action = Selector("revealToggle:")
        //touch gesture for the slide menu reveal
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    
}
