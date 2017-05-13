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

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var smallMapView: MKMapView!
    let eventLocation = MKPointAnnotation()
    
    weak var event: Event! {
        didSet {
            var latitude: Double = 37.3549144
            var longitude: Double = -122.0035661
            
            if event != nil {
                latitude = event.latitude ?? 37.3549144
                longitude = event.longitude ?? -122.0035661
                addressLabel.text = event.address ?? ""
            }
            
            let mapCenter = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let mapSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: mapCenter, span: mapSpan)
            smallMapView.setRegion(region, animated: true)
            
            eventLocation.coordinate = mapCenter
            eventLocation.title      = "Event Location"
            smallMapView.addAnnotation(eventLocation)
            smallMapView.showsUserLocation = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        smallMapView.delegate = self
        

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "destination")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "destination")
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "destination")
        return annotationView
    }

}
