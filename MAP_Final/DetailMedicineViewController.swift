//
//  DetailMedicineViewController.swift
//  MAP_Final
//
//  Created by RahulKumar Gaddam on 12/8/15.
//  Copyright © 2015 RahulKumar Gaddam. All rights reserved.
//  Under The Guidence of  Professor Robert J. Irwin
//  Team Name   : MedAssist Mobile Application
//  Team Members: Rahulkumar Gaddam (rgaddam@syr.edu)- Kusum Rudrayya (krudrayy@syr.edu) - Vemosh kumar (pkadavat@syr.edu)
//  Course Name : CIS/CSE 651 - Fall 2015 - Mobile Application Programming
//  Project Name: MedAssist - Never Forget your medicine again
//  Description : This file is the controler for the detail view . Data from parse database is being loaded to the view and user can update the data to the cloud .  
import UIKit
import Parse
class DetailMedicineViewController: UIViewController {
// outlet for details of medicine
    @IBOutlet weak var DetailMed: UITextField!
 // outlet for details of medicine dose
    @IBOutlet weak var DetailValueDose: UILabel!
    // outlet for details of medicine count presntly
    @IBOutlet weak var DetailStepper: UIStepper!
    // outlet for details of medicine image
    @IBOutlet weak var DetailImg: UIImageView!
    // outlet for details of medicine dose prescribed
    @IBOutlet weak var DetailDose: UITextField!
    // outlet for details of medicine instrucitons
    @IBOutlet weak var DetailInstruct: UITextView!
    // outlet for details of medicine reminder
    @IBOutlet weak var DetailMedReminder: UIDatePicker!
    
    
    var getData:NSString = NSString()
    required init ( coder aDecoder: NSCoder) {
        
        super.init(coder : aDecoder)!
    }
    
    @IBAction func DateChanged(sender: UIDatePicker) {
        // parse querying to get the details
        if let MUserName = PFUser.currentUser()?["username"] as? String {
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
                            
                            if( String(object["MedicineName"]) == self.DetailMed.text!){
                                
                                
                                
                                object["MedReminder"] = self.DetailMedReminder.date
                                object.saveInBackground()
                                
                            }
                            
                            
                            
                        }
                        
                    }
                    
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
            
        }
        
        
    }
    
    //fucniton that gets executed when stepper value changes
    @IBAction func DetailValueChanged(sender: UIStepper) {
        
        DetailValueDose.text =  sender.value.description
        
        
        // updates parse database with the values
        if let MUserName = PFUser.currentUser()?["username"] as? String {
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
                            
                            if( String(object["MedicineName"]) == self.DetailMed.text!){
                                
                                
                            
                             object["DoseLeft"] = self.DetailValueDose.text
                                object.saveInBackground()
                                
                            }
                            
                            
                            
                        }
                        
                    }
                    
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = NSDateFormatter()
        let timeZone = NSTimeZone(name: "UTC")
        dateFormatter.timeZone = timeZone
        
        DetailDose.userInteractionEnabled = false
        DetailMed.userInteractionEnabled = false
        
        DetailMed.text = getData as String
        // query to display user data from parse
        
        if let MUserName = PFUser.currentUser()?["username"] as? String {
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
                          
                            if( String(object["MedicineName"]) == self.DetailMed.text!){
                               
                                self.DetailDose.text = object["Dose"] as? String
                                self.DetailInstruct.text = object["Instruct"] as? String
                                self.DetailValueDose.text  = object["DoseLeft"] as? String
                                self.DetailStepper.wraps = true
                                self.DetailStepper.autorepeat = true
                                self.DetailStepper.maximumValue = ((object["Dose"] as? NSString))!.doubleValue
                                self.DetailStepper.minimumValue = 0
                                self.DetailMedReminder.date  = (object["MedReminder"] as? NSDate)!
                                
                                // getting the image data from parse 
                                let dispimg =  object["imageFile"] as! PFFile
                                dispimg.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                                    if (error == nil) {
                                        self.DetailImg.image = UIImage(data:imageData!)
                                    }
                                }
                                
                                
                                
                            }
                            
                            
                          
                        }
                        
                    }
                    
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
            
        }
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func RemoveMed(sender: AnyObject) {
        
        
        
        
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
   
   

}
