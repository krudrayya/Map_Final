//
//  AppDelegate.swift
//  MAP_Final
//  Created by RahulKumar Gaddam on 12/2/15.
//  Copyright © 2015 RahulKumar Gaddam. All rights reserved.
//  Under The Guidence of  Professor Robert J. Irwin
//  Team Name   : MedAssist Mobile Application
//  Team Members: Rahulkumar Gaddam (rgaddam@syr.edu)- Kusum Rudrayya (krudrayy@syr.edu) - Vemosh kumar (pkadavat@syr.edu)
//  Course Name : CIS/CSE 651 - Fall 2015 - Mobile Application Programming
//  Project Name: MedAssist - Never Forget your medicine again
//  Description : This File deals with Delegate Notifications and Notification Management


import UIKit
import Parse
import Bolts




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("ujECPYY4QLkC2PJcp22PKt5rRSZ6R3rkPlpqhmIn",
            clientKey: "ZVcY3IqpDZzugzyKebU1Pno0SFOsyiFqFW4FqBye")
        // parse analytics for application
          PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        //Notification settings that are reuired for user consent
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        //NSuserdefault for storing data on counter for badge - used as local data storage
         NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "MedCount")
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
    }
    //this funcition used to update the global variable in NSuserdefault to increment and redirection for the user when opened the notificaiton
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        NSNotificationCenter.defaultCenter().postNotificationName("MedDataShouldRefresh", object: self)
        let name:NSInteger = (NSUserDefaults.standardUserDefaults().objectForKey("MedCount")) as! NSInteger
        GlobalMedData.sharedInstance.addItem(name + 1) // incrementing the notification counter for badge
      
    }

    //  updating the badge number when application resigned from active state
    func applicationWillResignActive(application: UIApplication) {
         let name:NSInteger = (NSUserDefaults.standardUserDefaults().objectForKey("MedCount")) as! NSInteger
          UIApplication.sharedApplication().applicationIconBadgeNumber = name //updating the badge number
       // set our badge number to number of overdue items
        
    }

    func applicationDidEnterBackground(application: UIApplication) {
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        
    }

    // reinitializing the counter to zero when application is in foreground  again
    func applicationDidBecomeActive(application: UIApplication) {
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "MedCount")
        NSNotificationCenter.defaultCenter().postNotificationName("MedDataShouldRefresh", object: self)
    }

    func applicationWillTerminate(application: UIApplication) {
       
    }

    // fucntion to handle the keyboard event 
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    

}

