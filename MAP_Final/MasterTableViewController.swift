//
//  MasterTableViewController.swift
//  MAP_Final
//  Created by RahulKumar Gaddam on 12/8/15.
//  Copyright © 2015 RahulKumar Gaddam. All rights reserved.
//  Under The Guidence of  Professor Robert J. Irwin
//  Team Name   : MedAssist Mobile Application
//  Team Members: Rahulkumar Gaddam (rgaddam@syr.edu)- Kusum Rudrayya (krudrayy@syr.edu) - Vemosh kumar (pkadavat@syr.edu)
//  Course Name : CIS/CSE 651 - Fall 2015 - Mobile Application Programming
//  Project Name: MedAssist - Never Forget your medicine again
//  Description : This is one of the important file of the Applicaiton where we loaded data from Parse and loaded in to the table view . We implemented pull to refresh feature to update the data . We also understood implementation of Observer pattern when adding feature Notifications in the applicaiton . Data is transfered using segue and and we get data back using unwind segue.
import UIKit
import Parse
class MasterTableViewController: UITableViewController {
    // arrays declaration to store the temporary data
    var MedicinceData:NSMutableArray = NSMutableArray()
    var MedicinceDoseData:NSMutableArray = NSMutableArray()
    var MedicinceDoseLeftData:NSMutableArray = NSMutableArray()
   var MedicinceReminderData:NSMutableArray = NSMutableArray()
    
    
    var dateFormatter = NSDateFormatter()
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    
    required init ( coder aDecoder: NSCoder) {

        super.init(coder : aDecoder)!
    }
    
    override func viewDidAppear(animated: Bool) {
        
      
      
        
        
      
  
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // adding notificaiton observer
          NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshList", name: "MedDataShouldRefresh", object: nil)
        
        //querying database of parse
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
                            print(object["MedicineName"])
                            self.MedicinceData.addObject(object["MedicineName"])
                            self.MedicinceDoseData.addObject(object["Dose"])
                             self.MedicinceDoseLeftData.addObject(object["DoseLeft"])
                              self.MedicinceReminderData.addObject(object["MedReminder"])
                        }
                        
                    }
                    
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
            
        }
        

       
        self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        self.dateFormatter.timeStyle = NSDateFormatterStyle.LongStyle
        let attr = [NSForegroundColorAttributeName:UIColor.greenColor()]
        // Adding funcitonality to pull to refresh funciton
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh" , attributes:attr)
        self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
         self.refreshControl!.backgroundColor = UIColor.grayColor()
         self.refreshControl!.tintColor = UIColor.greenColor()
        
        
        
        
    }

  
    // fucntion to carried out when pulled
    
    func handleRefresh(refreshControl: UIRefreshControl) {
           NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshList", name: "MedDataShouldRefresh", object: nil)
        
        // clearing all the notifications previously created
        
        let app:UIApplication = UIApplication.sharedApplication()
        for oneEvent in app.scheduledLocalNotifications! {
            let notification = oneEvent as UILocalNotification
            if(notification.userInfo != nil){
            if let userInfoCurrent = notification.userInfo! as? [String:AnyObject] {
            let uid = userInfoCurrent["UUID"] as! String
                print(uid)
            if uid == "MedNotify" {
                //Cancelling local notification
                app.cancelLocalNotification(notification)
                break;
            }
            }
            }
        }
        
        
        
        
        // background thread process to refresh the data
        dispatch_async(dispatch_get_main_queue(), {
            
            if (self.refreshControl!.refreshing) {
                self.refreshControl!.endRefreshing()
            }
            
            self.tableView.reloadData()
        })
        let now = NSDate()
        let updateString = "Last Updated at " + self.dateFormatter.stringFromDate(now)
        
        
        let attr = [NSForegroundColorAttributeName:UIColor.greenColor()]
        
        
        
        self.refreshControl!.attributedTitle = NSAttributedString(string: updateString , attributes:attr)
        
        
   
     // querying the parse database to get the data of user medicine
        
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
                            print(object["MedicineName"])
                            if( !self.MedicinceData.containsObject(object["MedicineName"])){
                            self.MedicinceData.addObject(object["MedicineName"])
                            self.MedicinceDoseData.addObject(object["Dose"])
                            self.MedicinceDoseLeftData.addObject(object["DoseLeft"])
                            self.MedicinceReminderData.addObject(object["MedReminder"])
                            }
                            
                            if( self.MedicinceData.containsObject(object["MedicineName"])){
                                 let tempIndex = self.MedicinceData.indexOfObject(object["MedicineName"])
                                let x = self.MedicinceDoseLeftData.objectAtIndex(tempIndex)  as! String
                                let y = object["DoseLeft"] as! String
                                
                                if (!(x==y))
                                {
                                self.MedicinceDoseLeftData.replaceObjectAtIndex(tempIndex, withObject: object["DoseLeft"])
                                
                                
                                
                                }
                          
                                
                                
                                self.MedicinceReminderData.replaceObjectAtIndex(tempIndex, withObject: object["MedReminder"])
                                
                                let currentDateTime = NSDate()
                                let userRemindDate = object["MedReminder"] as! NSDate
                                if currentDateTime.compare(userRemindDate) == NSComparisonResult.OrderedDescending
                                {
                                    NSLog("date1 after date2");
                                } else if currentDateTime.compare(userRemindDate) == NSComparisonResult.OrderedAscending
                                {
                                    let notification = UILocalNotification()
                                    notification.alertBody = "Time for  \"\(self.MedicinceData.objectAtIndex(tempIndex))\" dose intake" // text that will be displayed in the notification
                                    notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
                                    notification.fireDate = (object["MedReminder"] as! NSDate) // todo item due date (when notification will be fired)
                                    print(notification.fireDate)
                                    notification.soundName = UILocalNotificationDefaultSoundName // play default sound
                                    notification.userInfo = ["UUID": "MedNotify" ] // assign a unique identifier to the notification so that we can retrieve it later
                                    
                                    notification.category = "MED_ASSIST"
                                    UIApplication.sharedApplication().scheduleLocalNotification(notification)
                                    
                                    
                                   
                                } else
                                {
                                    NSLog("dates are equal");
                                }
                                
                                // set the reminder only for future dates 
                              
                              
                                
                                
                                
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
    
    
    func refreshList() {
        
        tableView.reloadData()
    }
    
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath ) -> Bool
    {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.MedicinceData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MedicineCell", forIndexPath: indexPath) as! HomeTableViewCell
        
   
        
      
        
         cell.MedTitle!.text =  MedicinceData.objectAtIndex(indexPath.row) as? String
        let DL:Float
        let DNL:Float
        DL = (MedicinceDoseData.objectAtIndex(indexPath.row) as! NSString).floatValue
        DNL = (MedicinceDoseLeftData.objectAtIndex(indexPath.row) as! NSString).floatValue
        
            cell.MedStatus!.text = String(DL-DNL)  + " Doses left today"
       
        if (DL-DNL == 0){
        cell.MedStatus!.text =  " Completed!"}
        dateFormatter.dateFormat = "'Due' MMM dd 'at' h:mm a"
        cell.MedReminder!.text =  dateFormatter.stringFromDate(MedicinceReminderData.objectAtIndex(indexPath.row)  as! NSDate)
        
        
        cell.MedStatusBar.progress = DNL/DL
        // Configure the cell...

        return cell
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "DetailMed"){
            let selectedIP:NSIndexPath = self.tableView.indexPathForSelectedRow!
            let DetailMViewController:DetailMedicineViewController = segue.destinationViewController as! DetailMedicineViewController
            DetailMViewController.getData = MedicinceData.objectAtIndex(selectedIP.row) as! NSString
            
        }
        
    }
    
// segue to get the data from detail view so that we can handle the update data to parse
    @IBAction func unwindToMasterScreen(segue:UIStoryboardSegue) {
        if ( segue.identifier == "UnwindMaster"){
        
       let DetailMViewControllerUnwind:DetailMedicineViewController = segue.sourceViewController as! DetailMedicineViewController
        // query to parse data base to delete the object
            
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
                                
                                if( String(object["MedicineName"]) == DetailMViewControllerUnwind.getData){
                                    
                                    object.deleteInBackground()
                                    
                                    print("Object Deleted")
                                    
                                    
                                    
                                }
                                
                                
                                
                            }
                            
                        }
                        
                    } else {
                        // Log details of the failure
                        print("Error: \(error!) \(error!.userInfo)")
                    }
                }
                
            }
   // removing data from local array data we created
            let Remindex = MedicinceData.indexOfObject(DetailMViewControllerUnwind.getData)
            MedicinceData.removeObject(DetailMViewControllerUnwind.getData)
             MedicinceDoseData.removeObjectAtIndex(Remindex)
             MedicinceDoseLeftData.removeObjectAtIndex(Remindex)
            
            
            
            
        }
        
    }

}
