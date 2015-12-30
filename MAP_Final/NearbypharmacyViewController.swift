//
//  NearbypharmacyViewController.swift
//  MAP_Final
//  Created by RahulKumar Gaddam on 12/7/15.
//  Copyright © 2015 RahulKumar Gaddam. All rights reserved.
//  Under The Guidence of  Professor Robert J. Irwin
//  Team Name   : MedAssist Mobile Application
//  Team Members: Rahulkumar Gaddam (rgaddam@syr.edu)- Kusum Rudrayya (krudrayy@syr.edu) - Vemosh kumar (pkadavat@syr.edu)
//  Course Name : CIS/CSE 651 - Fall 2015 - Mobile Application Programming
//  Project Name: MedAssist - Never Forget your medicine again
//  Description :This page we are displaying the pharmacies that are located near to the current user location . We have implemented using Google Places API  (WEB Services) also we have written  customized annotation to display the name and address of the pharmacy. We have also parse the JSON file we got as a response from the Google places REST API request
import Foundation
import Parse


import UIKit

import MapKit
import CoreLocation

    



class NearbypharmacyViewController : UIViewController ,CLLocationManagerDelegate ,MKMapViewDelegate{
    
    @IBOutlet weak var Open: UIBarButtonItem!
    
    var currentCentre:CLLocationCoordinate2D=CLLocationCoordinate2D()
    var currenDist:Int = Int()
    
    let kBgQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    let METERS_PER_MILE = 1009.344
    var places=NSArray()
    let  mgr=CLLocationManager()
    let kGOOGLE_API_KEY = "AIzaSyAxycvWYEcYe7xSNvkB-tPxaXo3Vra1nQ8"
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        Open.target = self.revealViewController()
        Open.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        // Do any additional setup after loading the view, typically from a nib.
        
        self.mgr.delegate=self
        self.mgr.desiredAccuracy=kCLLocationAccuracyBest
        self.mgr.requestWhenInUseAuthorization()
        self.mgr.startUpdatingLocation()
        self.mapView.delegate=self;
        self.mapView.showsUserLocation=true
        //  centerMapOnLocation(initialLocation)

    }
    
    //location deleagte methods
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location=locations.last;
        print("did update location called" + (location?.description)!)
        
        let zoomLocation=CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        
        let viewRegion:MKCoordinateRegion  = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.3*METERS_PER_MILE, 0.3*METERS_PER_MILE);
        
        self.mapView.setRegion(viewRegion, animated: true)
        
        self.mgr.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("errors" + error.localizedDescription)
    }
    
    
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        //Get the east and west points on the map so you can calculate the distance (zoom level) of the current map view.
        var  mRect=MKMapRect()
        var eastMapPoint=MKMapPoint()
        var westMapPoint=MKMapPoint()
        mRect = self.mapView.visibleMapRect
        eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect))
        westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect))
        
        //Set your current distance instance variable.
        currenDist = Int(MKMetersBetweenMapPoints(eastMapPoint, westMapPoint));
        
        //Set your current center point on the map instance variable.
        
        currentCentre = self.mapView.centerCoordinate;
    }
    
    
    
    
    func queryGooglePlaces(googleType:NSString )  {
        // Build the url string to send to Google. NOTE: The kGOOGLE_API_KEY is a constant that should contain your own API key that you obtain from Google. See this link for more info:
        // https://developers.google.com/maps/documentation/places/#Authentication
        
        let url:String = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(currentCentre.latitude), \(currentCentre.longitude)&radius=\(currenDist)&types=pharmacy&sensor=true&key=\(kGOOGLE_API_KEY)"
        
        //Formulate the string as a URL object.
        // let googleRequestURL:NSURL=NSURL(string: url)!
        
        let urlStr = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        let url1 = NSURL(string: urlStr!)
        
        let googleRequestURL = url1
        
        
        
        
        // var request = NSMutableURLRequest(URL: googleRequestURL)
        //  request.HTTPMethod = "POST"
        
        // Retrieve the results of the URL.
        dispatch_async(kBgQueue) {
            let data:NSData = NSData(contentsOfURL: googleRequestURL!)!;
            
            self.fetchedData(data)
            
        };
        
        print("url \(url)");
    }
    
    func fetchedData(responseData:NSData)
    {
        
        do {
            if let jsonResult = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? NSDictionary {
                print(jsonResult)
                let place:NSArray=jsonResult.objectForKey("results") as! NSArray
                places=place
                //The results from Google will be an array obtained from the NSDictionary object with the key "results".
                self.plotPostions(place)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
            
        }
        
        
    }
    
  
    
    
    //Use this title text to build the URL query and get the data from Google.

    
    @IBAction func ToolBarButtonPress(sender: AnyObject) {
    self.queryGooglePlaces("pharmacy")
    }
    
    
    // in order to plot points on the map this function is written
    
    
    func plotPostions(data:NSArray)
    {
        //Removing  any existing custom annotations but not the user location blue dot.
        for annotation in mapView.annotations as [MKAnnotation]
        {
            if let annotation = annotation as?MapObject
            {
                mapView.removeAnnotation(annotation)
            }
        }
        
        // 2 - Loop through the array of places returned from the Google API.
        
        for(var i=0;i<data.count;i++)
        {
            //Retrieve the NSDictionary object in each index of the array.
            
            let PharmaPlace:NSDictionary=data.objectAtIndex(i) as! NSDictionary
            // 3 - There is a specific NSDictionary object that gives us the location info.
            let geo:NSDictionary = PharmaPlace.objectForKey("geometry") as! NSDictionary
            
            //gives the latitude and longitude coordinates of the places
            let latlon:NSDictionary = geo.objectForKey("location") as! NSDictionary
            
            //stores the name of the place
            let name:NSString  = PharmaPlace.objectForKey("name") as! NSString
            
            //stores the address of the place
            let vicinity:NSString = PharmaPlace.objectForKey("vicinity") as! NSString
            
            var coord=CLLocationCoordinate2D()
            
            coord.latitude = latlon.objectForKey("lat")  as! Double
            coord.longitude = latlon.objectForKey("lng") as! Double
            
            
            // Create a new annotation.
            let finalPlaces = MapObject(title: name as String,coordinate: coord,info: vicinity as String)
            
            finalPlaces.title=name as String
            finalPlaces.info=vicinity as String
            
            
            mapView.addAnnotation(finalPlaces);
            
        }
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        // 1
        let identifier = "MapObject"
        
        // 2
        if annotation.isKindOfClass(MapObject.self) {
            // 3
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            
            if annotationView == nil {
                //4
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
                
                // 5
                let btn = UIButton(type: .DetailDisclosure)
                annotationView!.rightCalloutAccessoryView = btn
            } else {
                // 6
                annotationView!.annotation = annotation
            }
            
            return annotationView
        }
        
        // 7
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        for annotation in mapView.annotations as [MKAnnotation]
        {
            if let annotation = annotation as?MapObject
            {
                mapView.removeAnnotation(annotation)
            }
        }
        
        // 2 - Loop through the array of places returned from the Google API.
        
        for(var i=0;i<places.count;i++)
        {
            //Retrieve the NSDictionary object in each index of the array.
            
            let PharmaPlace:NSDictionary=places.objectAtIndex(i) as! NSDictionary
            // 3 - There is a specific NSDictionary object that gives us the location info.
            let geo:NSDictionary = PharmaPlace.objectForKey("geometry") as! NSDictionary
            
            //gives the latitude and longitude coordinates of the places
            let latlon:NSDictionary = geo.objectForKey("location") as! NSDictionary
            
            //stores the name of the place
            let name:NSString  = PharmaPlace.objectForKey("name") as! NSString
            
            //stores the address of the place
            let vicinity:NSString = PharmaPlace.objectForKey("vicinity") as! NSString
            
            var coord=CLLocationCoordinate2D()
            
            coord.latitude = latlon.objectForKey("lat")  as! Double
            coord.longitude = latlon.objectForKey("lng") as! Double
            
            
            // Create a new annotation.
            let finalPlaces = MapObject(title: name as String,coordinate: coord,info: vicinity as String)
            
            finalPlaces.title=name as String
            finalPlaces.info=vicinity as String
            
            
            mapView.addAnnotation(finalPlaces);
            
       
       
            let ac = UIAlertController(title: finalPlaces.info, message: finalPlaces.info, preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            let subview = ac.view.subviews.first! as UIView
            let alertContentView = subview.subviews.first! as UIView
            let image : UIImage = UIImage(named:"Plain-Green-Color-Background-HD-Wallpaper.jpg")!
            
            alertContentView.backgroundColor = UIColor(patternImage: image)
            presentViewController(ac, animated: true, completion: nil)
            //ac.setValue(imvImage, forKey: "image")
            
            }
            
            
        
        }
        
        
        
        
        
    }
    
    
 


