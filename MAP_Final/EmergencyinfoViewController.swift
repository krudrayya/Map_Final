//
//  EmergencyinfoViewController.swift
//  MAP_Final
//
//  Created by RahulKumar Gaddam on 12/7/15.
//  Copyright © 2015 RahulKumar Gaddam. All rights reserved.
//  Under The Guidence of  Professor Robert J. Irwin
//  Team Name   : MedAssist Mobile Application
//  Team Members: Rahulkumar Gaddam (rgaddam@syr.edu)- Kusum Rudrayya (krudrayy@syr.edu) - Vemosh kumar (pkadavat@syr.edu)
//  Course Name : CIS/CSE 651 - Fall 2015 - Mobile Application Programming
//  Project Name: MedAssist - Never Forget your medicine again
//  Description : We used basic personal information for display to the user . When in emergency user can directly call from the emergency info using "Phone Services" of the device used.

import Foundation
import Parse

class EmergencyinfoViewController : UIViewController {
    // outlet for scroll view
    @IBOutlet weak var SaveEmerInfor: UIBarButtonItem!
    @IBOutlet weak var ScrollViewEI: UIScrollView!
    @IBOutlet weak var FullName: UITextField!
    @IBOutlet weak var Address: UITextView!
    @IBOutlet weak var Age: UITextField!
    @IBOutlet weak var Bgroup: UITextField!
    @IBOutlet weak var PhoneNum: UITextField!
    @IBOutlet weak var InsuranceID: UITextField!
    @IBOutlet weak var ContactName: UITextField!
    @IBOutlet weak var ContactNumber: UITextField!
    @IBOutlet weak var UImage: UIImageView!
    @IBOutlet weak var InsuranceImage: UIImageView!
    @IBAction func SaveInfo(sender: AnyObject) {
        
        let MedicineData = PFObject(className: "EmergencyInfo")
        MedicineData["user"] = PFUser.currentUser()
        MedicineData["name"] = PFUser.currentUser()!.username
        MedicineData["FullName"] = self.FullName.text
        MedicineData["Address"] = self.Address.text

        MedicineData["Age"] = self.Age.text

        MedicineData["Bgroup"] = self.Bgroup.text

        MedicineData["PhoneNum"] = self.PhoneNum.text

        MedicineData["InsuranceID"] = self.InsuranceID.text

        MedicineData["ContactName"] = self.ContactName.text

        MedicineData["ContactNumber"] = self.ContactNumber.text

        
        print("Medicine Data saving...")
        MedicineData.saveInBackgroundWithBlock({
            (success: Bool , error: NSError?) -> Void in
            if error == nil
            {
                print("Data uplaod")
                
                let imgData = UIImageJPEGRepresentation(self.InsuranceImage.image! , 1.0)
                let parseImgFile = PFFile(name:"uploaded_img.jpg", data:imgData!)
                MedicineData["imageFile"] = parseImgFile
                //  print("istarting image check")
                MedicineData.ACL = PFACL(user: PFUser.currentUser()!)
                MedicineData.saveInBackground()
                
                
                
                
            }
            else
            {
                
                print (error)
            }
            
            
        })
        
        
        
    }
    @IBOutlet weak var Gender: UITextField!
    //outlet for slidemenu open
    @IBOutlet weak var Open: UIBarButtonItem!
   
    
    // function to call the phone number - phone service s
    @IBAction func CallEinfo(sender: AnyObject) {
        
        let phone = "tel://" + self.PhoneNum.text!
        let url:NSURL = NSURL(string:phone)!;
        UIApplication.sharedApplication().openURL(url);
        
        
    }
    override func viewDidLoad() {
        Open.target = self.revealViewController()
        Open.action = Selector("revealToggle:")
        ScrollViewEI.contentSize.height = 1000
        //touch gesture addtion
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        //querying database of parse
        if let MUserName = PFUser.currentUser()?["username"] as? String {
            let Mquery = PFQuery(className:"EmergencyInfo")
            Mquery.whereKey("name", equalTo: MUserName)
            Mquery.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) scores.")
                    // Do something with the found objects
                    if let objects = objects {
                        for object in objects {
                            print(object["FullName"])
                            
                            self.FullName.text = object["FullName"] as! NSString as String
                           self.Address.text =  object["Address"] as! NSString as String
                            
                            self.Age.text =  object["Age"] as! NSString as String
                            
                            self.Bgroup.text = object["Bgroup"] as! NSString as String
                            
                            self.PhoneNum.text =  object["PhoneNum"] as! NSString as String
                            
                            self.InsuranceID.text =  object["InsuranceID"] as! NSString as String
                            
                          self.ContactName.text =   object["ContactName"] as! NSString as String
                            
                            self.ContactNumber.text = object["ContactNumber"] as! NSString as String
                            
                            
                        }
                        
                    }
                    
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
            
        }
        
    }
    
    
}
