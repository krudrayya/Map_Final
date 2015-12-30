//
//  AddMedicineViewController.swift
//  MAP_Final
//
//  Created by RahulKumar Gaddam on 12/8/15.
//  Copyright © 2015 RahulKumar Gaddam. All rights reserved.
//  Under The Guidence of  Professor Robert J. Irwin
//  Team Name   : MedAssist Mobile Application
//  Team Members: Rahulkumar Gaddam (rgaddam@syr.edu)- Kusum Rudrayya (krudrayy@syr.edu) - Vemosh kumar (pkadavat@syr.edu)
//  Course Name : CIS/CSE 651 - Fall 2015 - Mobile Application Programming
//  Project Name: MedAssist - Never Forget your medicine again
//  Description :The File inserts the data to the data base . we used camera services to load tha data to imageview .
//Important Note: Camera services will not work when used in simulator
import UIKit
import Parse
class AddMedicineViewController: UIViewController, UIViewControllerTransitioningDelegate ,  UINavigationControllerDelegate, UIImagePickerControllerDelegate {
// outlet for details of medicine name
    @IBOutlet weak var MedicineName: UITextField! = UITextField()
    // outlet for details of medicine dose
    @IBOutlet weak var Dose: UITextField! = UITextField()
    // outlet for details of medicine instrucitons
    @IBOutlet weak var Instruct: UITextView! = UITextView()
    // outlet for details of medicine image
    
    @IBOutlet weak var Mimage: UIImageView!
    // outlet for details of medicine reminder date
    
    @IBOutlet weak var MedReminder: UIDatePicker!

    var MimagePicker = UIImagePickerController()
    
    //funciton to uplaod the image
    @IBAction func UploadMedicineImg(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            print("Button capture")
            
            
            MimagePicker.delegate = self
            MimagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            MimagePicker.allowsEditing = true
            
            self.presentViewController(MimagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        MimagePicker .dismissViewControllerAnimated(true, completion: nil)
        Mimage.image=info[UIImagePickerControllerOriginalImage] as? UIImage
    }
   
    
    

    
    
    
    required init ( coder aDecoder: NSCoder) {
       
        
        super.init(coder : aDecoder)!
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// funciton to save tha data to cloud database
    @IBAction func MedicineSave(sender: AnyObject) {
        
    
        
        
        
        
        
        let MedicineData = PFObject(className: "MedicineData")
        MedicineData["user"] = PFUser.currentUser()
        MedicineData["name"] = PFUser.currentUser()!.username
         MedicineData["MedicineName"] = MedicineName.text
         MedicineData["Dose"] = Dose.text
         MedicineData["DoseLeft"] = "0"
          MedicineData["MedReminder"] = self.MedReminder.date
         MedicineData["Instruct"] = Instruct.text
        print("Medicine Data saving...")
        MedicineData.saveInBackgroundWithBlock({
            (success: Bool , error: NSError?) -> Void in
            if error == nil
            {
                print("Data uplaod")
                
                let imgData = UIImageJPEGRepresentation(self.Mimage.image! , 1.0)
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
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
