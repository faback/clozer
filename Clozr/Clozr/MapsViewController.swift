//
//  MapsViewController.swift
//  Clozr
//
//  Created by Fateh Singh on 4/27/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let manager = CLLocationManager()
    let eventLocationAnnotation = MKPointAnnotation()
    var centerMap:Bool = false
    @IBOutlet weak var centerMapButton: UIButton!
    
    var event:Event! {
        didSet {
            let latitude = event.latitude ?? 37.3549144
            let longitude = event.longitude ?? -122.0035661
            
            // Center the map around the location of the event.
            let eventLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let mapSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: eventLocation, span: mapSpan)
            mapView.setRegion(region, animated: true)
            
            eventLocationAnnotation.coordinate = eventLocation
            eventLocationAnnotation.title      = "Event Location"
            mapView.addAnnotation(eventLocationAnnotation)
            mapView.showsUserLocation = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        manager.delegate = self
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ButtonClicked(_ sender: Any) {
        if centerMap == true {
            centerMap = false
            centerMapButton.setImage(UIImage(named: "location_grey.png"), for: UIControlState.normal)
        } else {
            centerMap = true
            centerMapButton.setImage(UIImage(named: "location_blue.png"), for: UIControlState.normal)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (centerMap) {
            let location = locations[0]
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let mylocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(mylocation, span)
            mapView.setRegion(region, animated: true)
            mapView.showsUserLocation = true
        }
    }
    

}
