//
//  HomeViewController.swift
//  MAP_Final
//
//  Created by RahulKumar Gaddam on 12/5/15.
//  Copyright © 2015 RahulKumar Gaddam. All rights reserved.
//  Under The Guidence of  Professor Robert J. Irwin
//  Team Name   : MedAssist Mobile Application
//  Team Members: Rahulkumar Gaddam (rgaddam@syr.edu)- Kusum Rudrayya (krudrayy@syr.edu) - Vemosh kumar (pkadavat@syr.edu)
//  Course Name : CIS/CSE 651 - Fall 2015 - Mobile Application Programming
//  Project Name: MedAssist - Never Forget your medicine again
//  Description : This File is Home of the Applications where the application starts after user logs in . This Page deals with Parse database and gets values from the cloud database. Multithreading is being implemented inside the parse function "getDataInBackgroundWithBlock()" inbuilt function. We used background thread for the view controller thus we can say this handles multi threading.

import Foundation
import Parse


class HomeViewController: UIViewController , UIViewControllerTransitioningDelegate {

   // Outlet for the menu open so that it reveals the slide menu
    @IBOutlet weak var Open: UIBarButtonItem!
    // Outlet for the the user name to be displayed
    @IBOutlet weak var userNameLabel: UILabel!
    // Outlet for the Profile pic of the user
    @IBOutlet weak var HomeImgView: UIImageView!
    
    // function to logout from the application
    @IBAction func MedLogOut(sender: AnyObject) {
        
        // Send a request to log out a user
        PFUser.logOut()
        // Sending the the view controller to background thread 
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login") 
            self.presentViewController(viewController, animated: true, completion: nil)
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Open.target = self.revealViewController()
        Open.action = Selector("revealToggle:")
       self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
   
        // Show the current visitor's username
        if let pUserName = PFUser.currentUser()?["username"] as? String {
            self.userNameLabel.text = " " + pUserName             
 //Query for the Parse database to retrieve details of the user
            let query = PFQuery(className:"imgProfile")
            query.whereKey("name", equalTo: pUserName)
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) scores.")
                    // Do something with the found objects
                    if let objects = objects {
                        for object in objects {
                            print(object.objectId)
                            let dispimg =  object["imageFile"] as! PFFile
                                dispimg.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                                    if (error == nil) {
                                        self.HomeImgView.image = UIImage(data:imageData!)
                                    }
                            }
                        }
                        
                        }
                    
                    
                  
                    
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }

         // Making the image view to the circular shape
            HomeImgView.layer.cornerRadius = HomeImgView.frame.size.width/2
            HomeImgView.clipsToBounds = true
            HomeImgView.layer.borderWidth = 4.0
            let white = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            HomeImgView.layer.borderColor = white.CGColor
            
        
            
        }
    }
    

    
    // Upadating the view whenever the  view appears
    override func viewWillAppear(animated: Bool) {
        if (PFUser.currentUser() == nil) {
            // View loading in the background thread 
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(viewController, animated: true, completion: nil)
            })
        }
    }
}