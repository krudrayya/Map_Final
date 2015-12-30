//
//  SignUpViewController.swift
//  MAP_Final
//
//  Created by RahulKumar Gaddam on 12/5/15.
//  Copyright © 2015 RahulKumar Gaddam. All rights reserved.
//  Under The Guidence of  Professor Robert J. Irwin
//  Team Name   : MedAssist Mobile Application
//  Team Members: Rahulkumar Gaddam (rgaddam@syr.edu)- Kusum Rudrayya (krudrayy@syr.edu) - Vemosh kumar (pkadavat@syr.edu)
//  Course Name : CIS/CSE 651 - Fall 2015 - Mobile Application Programming
//  Project Name: MedAssist - Never Forget your medicine again
//  Description : This is a Controller for the registration page for the User where we can upload the user profile image and other user info 
import Foundation
import Parse

class SignUpViewController: UIViewController , UIViewControllerTransitioningDelegate ,  UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//outlet for the registration email 
    
    @IBOutlet weak var RegEmail: UITextField!
  //outlet for the username field
    @IBOutlet weak var RegUserName: UITextField!
   //outlet for the registration ped field
    @IBOutlet weak var RegPwd: UITextField!
    // outlet for the uploading profile picture button
    @IBOutlet weak var RegUploadImg: UIButton!
    
 // outlet fot the imageview that loads image of uploaded image
    @IBOutlet weak var RegImgView: UIImageView!
// initialising the imagepicker controller
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var UploadLabel: UILabel!
    @IBAction func Rego(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            print("Button capture")
            
            
          imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }

        
    }
   // Image picker controller for loading the image from the camera and loading it on to the image view
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        print("Saving")
        RegImgView.image = image
        RegImgView.layer.cornerRadius = RegImgView.frame.size.width/2
        RegImgView.clipsToBounds = true
        RegImgView.layer.borderWidth = 3.0
        let white = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        RegImgView.layer.borderColor = white.CGColor
        UploadLabel.text = "Change Picture"
    }
    
    
    // fucntion that handles signup funcitonality and updaitng database in parse
    
    @IBAction func RegisterSignUp(sender: AnyObject) {
        
        let username = RegUserName.text
        let password = RegPwd.text
        let email =  RegEmail.text
        let finalEmail = email!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        // Validate the text fields
        if username!.characters.count < 5 {
           
            //alert for invalid user name
            let alertController = UIAlertController(title: "Invalid", message: "Username must be greater than 5 characters", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
            
            
        } else if password!.characters.count < 8 {
               //alert for invalid password
            let alertController = UIAlertController(title: "Invalid", message: "Password Must be greater than 8 characters", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
            
        } else if email!.characters.count < 8 {
               //alert for invalid emai ID
            let alertController = UIAlertController(title: "Invalid", message: "Email must be greater than 8 characters", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
            
        } else {
            // Run a spinner to show a task in progress
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            // creation of new user in the parse
            let newUser = PFUser()
            
            newUser.username = username
            newUser.password = password
            newUser.email = finalEmail
            
            // Sign up the user asynchronously
            newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
                
                
                if self.RegImgView.image == nil {
                // image is not attached to the image view 
                    print("image not uploaded ")
                
                } else {
                
                    let imgProfile = PFObject(className: "imgProfile")
                     imgProfile["user"] = PFUser.currentUser()
                     imgProfile["name"] = PFUser.currentUser()!.username
                    print("imgprofile saving...")
                    imgProfile.saveInBackgroundWithBlock({
                        (success: Bool , error: NSError?) -> Void in
                        if error == nil
                        {
                        print("istarting image uplaod")
                            // uploading the image to database
                            let imgData = UIImageJPEGRepresentation(self.RegImgView.image! , 1.0)
                            let parseImgFile = PFFile(name:"uploaded_img.jpg", data:imgData!)
                            imgProfile["imageFile"] = parseImgFile
                              print("istarting image check")
                             imgProfile.ACL = PFACL(user: PFUser.currentUser()!)
                            imgProfile.saveInBackground() // background process for image upload
                            
                            
                            
                            
                            
                            
                        }
                        else
                        {
                        
                            print (error)
                        }
                        
                        
                    })
                
                }
                
                
                
                // Stop the spinner
                spinner.stopAnimating()
                if ((error) != nil) {
                    print(error)
                    
                } else {
                    print(error)
                    //background process to load the view 
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Slide") 
                        self.presentViewController(viewController, animated: true, completion: nil)
                    })
                }
            })
        }
    }
    
   
    
}