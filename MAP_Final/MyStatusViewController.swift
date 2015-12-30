//
//  MyStatusViewController.swift
//  MAP_Final
//
//  Created by RahulKumar Gaddam on 12/7/15.
//  Copyright © 2015 RahulKumar Gaddam. All rights reserved.
//  Under The Guidence of  Professor Robert J. Irwin
//  Team Name   : MedAssist Mobile Application
//  Team Members: Rahulkumar Gaddam (rgaddam@syr.edu)- Kusum Rudrayya (krudrayy@syr.edu) - Vemosh kumar (pkadavat@syr.edu)
//  Course Name : CIS/CSE 651 - Fall 2015 - Mobile Application Programming
//  Project Name: MedAssist - Never Forget your medicine again
//  Description : This page has information to the user about his medication status of the day . We implemented animation and UIView to display the status visually appealing. We also used touch gesture to reveal the slide menu . KDcircularprogress is class of third party framework 

import Foundation
import Parse

class MyStatusViewController : UIViewController {
//outlet for the bar button to open the menu - slide menu
    @IBOutlet weak var Open: UIBarButtonItem!
 // outlet for the percentage display of status
    @IBOutlet weak var StatusLabel: UILabel!
    // outlet used for circular status animation
    @IBOutlet weak var CircularStatus: KDCircularProgress!
    @IBOutlet weak var percen: UILabel!
    var DoseLeft: Int32 = 0
    
    var Dose:Int32 = 0
    override func viewDidLoad() {
        Open.target = self.revealViewController()
        Open.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
    }
    
  
    
    override func viewDidAppear(animated: Bool) {
        if let MUserName = PFUser.currentUser()?["username"] as? String {
            let Mquery = PFQuery(className:"MedicineData")
            Mquery.whereKey("name", equalTo: MUserName)
            // Parse background querying
            Mquery.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) scores.")
                    // Do something with the found objects
                    if let objects = objects {
                        for object in objects {
                            
                            self.Dose = self.Dose + (object["Dose"]   as! NSString).intValue
                            
                            
                            
                            
                            self.DoseLeft = self.DoseLeft +  (object["DoseLeft"]   as! NSString).intValue
                        }
                        
                    }
                    print(self.Dose)
                    print(self.DoseLeft)
                    let result:Double = ((Double(self.DoseLeft)/Double(self.Dose)));
                    self.CircularStatus.animateToAngle( Int(result * 360) , duration: 3, completion: nil)
                    
                    
                    self.percen.text = String(round((result)*100))

                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
            
        }
        
        

        
        
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        
   //animating circular view created 
        CircularStatus.animateToAngle(0, duration: 3, completion: nil)
    }
    
    
    
    
}


