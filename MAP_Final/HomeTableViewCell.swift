//
//  HomeTableViewCell.swift
//  MAP_Final
//
//  Created by RahulKumar Gaddam on 12/8/15.
//  Copyright © 2015 RahulKumar Gaddam. All rights reserved.
//  Under The Guidence of  Professor Robert J. Irwin
//  Team Name   : MedAssist Mobile Application
//  Team Members: Rahulkumar Gaddam (rgaddam@syr.edu)- Kusum Rudrayya (krudrayy@syr.edu) - Vemosh kumar (pkadavat@syr.edu)
//  Course Name : CIS/CSE 651 - Fall 2015 - Mobile Application Programming
//  Project Name: MedAssist - Never Forget your medicine again
//  Description : This is a controller for the view of the table cell of the main home view . Using this file we formatted the table view of the hOmeview controller . 

import UIKit

class HomeTableViewCell: UITableViewCell {
// outlet for the title of the medicine
    @IBOutlet weak var MedTitle: UILabel!
    //outlet for progress display
    @IBOutlet weak var MedStatusBar: UIProgressView!
    // outlet for the dose 
    @IBOutlet weak var MedStatus: UILabel!
    // outlet that dispalys the due date
    @IBOutlet weak var MedReminder: UILabel!
    override func awakeFromNib() {
      
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
