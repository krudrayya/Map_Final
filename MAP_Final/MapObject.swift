//
//  MapObject.swift
//  MapSwift
//
//  Created by Kusum Rudrayya on 12/9/15.
//  Copyright © 2015 Kusum Rudrayya. All rights reserved.
//  Under The Guidence of  Professor Robert J. Irwin
//  Team Name   : MedAssist Mobile Application
//  Team Members: Rahulkumar Gaddam (rgaddam@syr.edu)- Kusum Rudrayya (krudrayy@syr.edu) - Vemosh kumar (pkadavat@syr.edu)
//  Course Name : CIS/CSE 651 - Fall 2015 - Mobile Application Programming
//  Project Name: MedAssist - Never Forget your medicine again
//  Description : This class stores information for the nearby pharmacy places to be used for Mapview  annotations.

import Foundation

import MapKit
import UIKit
// calss for the mapobject - Annotation
class MapObject: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}