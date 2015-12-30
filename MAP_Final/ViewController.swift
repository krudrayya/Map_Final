//
//  ViewController.swift
//  MAP_Final
//
//  Created by RahulKumar Gaddam on 12/2/15.
//  Copyright © 2015 RahulKumar Gaddam. All rights reserved.
//  Under The Guidence of  Professor Robert J. Irwin
//  Team Name   : MedAssist Mobile Application
//  Team Members: Rahulkumar Gaddam (rgaddam@syr.edu)- Kusum Rudrayya (krudrayy@syr.edu) - Vemosh kumar (pkadavat@syr.edu)
//  Course Name : CIS/CSE 651 - Fall 2015 - Mobile Application Programming
//  Project Name: MedAssist - Never Forget your medicine again
//  Description : This page has main funcitonality of SMS service and Email Service where we integrate our Application with Twilio API (SMS Services) and Mailgun API (Mail Service ) both are being implemented using REST API request . We also implemented Animation while loading the application with Imageview "AssistLoader", where it loads set of images to perform animation . We also used third party framework "Alamofire" for REST API Requests making the application simple .
import UIKit
import Foundation
import QuartzCore
import Parse
import Alamofire



class ViewController: UIViewController , UIViewControllerTransitioningDelegate {

    // Outlet for the image loading animaiton
    @IBOutlet weak var AssistLoader: UIImageView!
    // outlet for the backgroundiamge
    @IBOutlet weak var BackGrnd: UIImageView!
    // outlet for the Username textfield
    @IBOutlet weak var MUser: UITextField!
    //outlet for the password text field
    @IBOutlet weak var MPwd: UITextField!
    // Outlet for the Forgot passowrd button
    @IBOutlet weak var FPwd: UIButton!
    //outlet for the Register user button
    @IBOutlet weak var Reg: UIButton!
   // outlet for the Logo
    @IBOutlet weak var MedLogoImg: UIImageView!
    //outlet for the label
    @IBOutlet weak var MedLogLabel: UILabel!
    // outlet for the Logo buton
    @IBOutlet weak var MedLogButton: StarButton!
    var EmailSwitch:Bool = Bool()
    var TextSwitch:Bool = Bool()
    // Function that validates user login credentials with database
    @IBAction func MedLogin(sender: StarButton) {
        sender.isFavorite = !sender.isFavorite
        
        let username = MUser.text
        let password = MPwd.text
        // touch gesture function  for the slide menu
        let tapGesture = UITapGestureRecognizer(target: self, action: "tap:")
        view.addGestureRecognizer(tapGesture)
        
        // Validate the text fields
        if username!.characters.count < 5 {
            
            
            //alert for the invalid user name
            let ac = UIAlertController(title: "Invalid", message: "Username must be greater than 5 characters", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(ac, animated: true, completion: nil)
            
            
            
        } else if password!.characters.count < 8 {
           
            
            //alert for invalid password
            let ac1 = UIAlertController(title: "Invalid", message: "Password must be greater than 8 characters", preferredStyle: .Alert)
            ac1.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(ac1, animated: true, completion: nil)
        } else {
            // Run a spinner to show a task in progress
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            
            // Send a request to login
            PFUser.logInWithUsernameInBackground(username!, password: password!, block: { (user, error) -> Void in
                
                // Stop the spinner
                spinner.stopAnimating()
                
                if ((user) != nil) {
                   
                    self.EmailSwitch = true
                    self.TextSwitch = true
                    
                    
                    //junk code starts here
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
                                            self.EmailSwitch = true
                                                                                    }
                                        else
                                        {
                                           self.EmailSwitch = false
                                            
                                        }
                                        
                                        if ((object["SMS"] as! NSString).boolValue ){
                                           self.TextSwitch = true
                                        }
                                        else
                                        {
                                           
                                            self.TextSwitch = false
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
                    
                    
                    
                    
                    if(self.TextSwitch){
                    let twilioSID = "AC617f8620747378d7a39c56ccba1a39f9"
                    
                    let twilioSecret = "dd5a53e7437fc232ce2959f31fd294dc"
                    
                    
                    
                    //Note replace + = %2B , for To and From phone number
                    
                    let fromNumber = "%2B13158832768"// actual number is +14803606445
                    
                    let toNumber = "%2B13213076775"// actual number is +919152346132
                    
                    let message = "Your account was recently logged in to from a new  device. Was this you? - Team MedAssist"
                    
                    
                    
                    // Build the request for twilio sms api
                    
                    let request = NSMutableURLRequest(URL: NSURL(string:"https://\(twilioSID):\(twilioSecret)@api.twilio.com/2010-04-01/Accounts/\(twilioSID)/SMS/Messages")!)
                    
                    request.HTTPMethod = "POST" //setting request as POST
                    
                    request.HTTPBody = "From=\(fromNumber)&To=\(toNumber)&Body=\(message)".dataUsingEncoding(NSUTF8StringEncoding)
                    
                    
                    
                    // Build the completion block and send the request
                    
                    NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
                        
                        print("Finished")
                        
                        if let data = data, responseDetails = NSString(data: data, encoding: NSUTF8StringEncoding) {
                            
                            // if repsonse is Success
                            
                            print("Response: \(responseDetails)")
                            
                        } else {
                            
                            // if response is Failure
                            
                            print("Error: \(error)")
                            
                        }
                        
                    }).resume()
                    
                    
                    
                    }
                    
                    
                    if(self.EmailSwitch){
                    
                    // code for the mailgun API starts here 
                    
                    // Key for Mail Gun API
                    let key = "key-c0a65caf960b1ac03d6549f6cfc9e96e"
                    
                    //parameters required to send the email
                    
                    let parameters = [
                        
                        "from": "rgaddam@syr.edu",
                        
                        "to": "Gaddam.rahul.kumar@gmail.com",
                        
                        "subject": "Login alert for your MedAssist Account",
                        
                        "text": " Hi User , Your Account was recently logged in to from a device . Was this you?  - Team MedAssist"
                        
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
                    
                }
                    //end of code for email
                    // background thread to load the another view
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Slide") 
                        self.presentViewController(viewController, animated: true, completion: nil)
                    })
                    
                } else {
                    // alert for invalid login credentials
                    
                    let ac1 = UIAlertController(title: "Error", message: "Invalid Login or Password Credentials", preferredStyle: .Alert)
                    ac1.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(ac1, animated: true, completion: nil)
                }
            })
        }

        
    }
   
    override func viewDidLoad() {
        BackGrnd.hidden = true;
        MUser.hidden = true;
        MPwd.hidden = true;
        FPwd.hidden = true;
        Reg.hidden = true;
        MedLogButton.hidden = true;
        MedLogoImg.hidden = true;
        MedLogLabel.hidden = true;
        //code for parse cloud database interaction
        let testObject = PFObject(className: "TestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("Object has been saved.")
        }
    //end of code for parse
        
        super.viewDidLoad()
        
        //code for  animation on the application loading
        AssistLoader.animationImages = [UIImage]()
        for var index = 1; index < 12; index++ {
            let frameName = String(format: "MedAssit%01d.jpg", index)
            AssistLoader.animationImages?.append(UIImage(named: frameName)!)
        }
        // Do any additional setup after loading the view, typically from a nib.
        AssistLoader.animationDuration = 2
        AssistLoader.startAnimating()
        _ = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "update", userInfo: nil, repeats: false)
        
        
    }
    // touch gesture function
    func tap(gesture: UITapGestureRecognizer) {
        self.MUser.resignFirstResponder()
          self.MPwd.resignFirstResponder()
    }
    
    
    
    func update() {
       AssistLoader.stopAnimating()
        NSLog("reached")
        AssistLoader.hidden = true;
        BackGrnd.hidden = false;
        MUser.hidden = false;
        MPwd.hidden = false;
        FPwd.hidden = false;
        Reg.hidden = false;
        MedLogButton.hidden = false ;
        MedLogoImg.hidden = false;
        MedLogLabel.hidden = false;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToLogInScreen(segue:UIStoryboardSegue) {
        
        
    }

}

