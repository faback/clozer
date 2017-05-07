//
//  EventDetailsMapCell.swift
//  Clozr
//
//  Created by Fateh Singh on 5/6/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit
import MapKit

class EventDetailsMapCell: UITableViewCell, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var smallMapView: MKMapView!
    let manager = CLLocationManager()
    let eventLocation = MKPointAnnotation()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        smallMapView.delegate = self
        manager.delegate = self
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        let mapCenter = CLLocationCoordinate2D(latitude: 37.3549144, longitude: -122.0035661)
        let mapSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: mapCenter, span: mapSpan)
        // Set animated property to true to animate the transition to the region
        smallMapView.setRegion(region, animated: false)
        
        eventLocation.coordinate = mapCenter
        eventLocation.title      = "Event Location"
        smallMapView.addAnnotation(eventLocation)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let mylocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(mylocation, span)
        smallMapView.setRegion(region, animated: false)
        smallMapView.showsUserLocation = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
