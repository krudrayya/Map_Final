//
//  ResetPasswordViewController.swift
//  MAP_Final
//
//  Created by RahulKumar Gaddam on 12/5/15.
//  Copyright © 2015 RahulKumar Gaddam. All rights reserved.
//  Under The Guidence of  Professor Robert J. Irwin
//  Team Name   : MedAssist Mobile Application
//  Team Members: Rahulkumar Gaddam (rgaddam@syr.edu)- Kusum Rudrayya (krudrayy@syr.edu) - Vemosh kumar (pkadavat@syr.edu)
//  Course Name : CIS/CSE 651 - Fall 2015 - Mobile Application Programming
//  Project Name: MedAssist - Never Forget your medicine again
//  Description : This File deals with the reset password functionality where user can send email to his registered account and reset his password 

import Foundation
import Parse

class ResetPasswordViewController: UIViewController , UIViewControllerTransitioningDelegate {


// Outlet for the Textfield of Email 
    @IBOutlet weak var ResetEmail: UITextField!
    // This is action of the reset button when clicked sends the email to the user registered email
    @IBAction func ResetButton(sender: AnyObject) {
        let email = ResetEmail.text
        let finalEmail = email!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        // Send a request to reset a password
        PFUser.requestPasswordResetForEmailInBackground(finalEmail)
        // Display alert for confirmation to the user
        let alert = UIAlertController (title: "Password Reset", message: "An email containing information on how to reset your password has been sent to " + finalEmail + ".", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }



}