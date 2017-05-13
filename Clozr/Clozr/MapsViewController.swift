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
    @IBOutlet weak var centerMapButton: UIButton!
    
    weak var event:Event!
    let manager = CLLocationManager()
    var centerMap:Bool = false
    var timer:Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        manager.delegate = self
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        if event != nil {
            let latitude = event.latitude ?? 37.3549144
            let longitude = event.longitude ?? -122.0035661
            
            // Center the map around the location of the event.
            let eventLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let mapSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: eventLocation, span: mapSpan)
            mapView.setRegion(region, animated: true)
            
            let eventLocationAnnotation = MKPointAnnotation()
            eventLocationAnnotation.coordinate = eventLocation
            eventLocationAnnotation.title      = "Event Location"
            mapView.addAnnotation(eventLocationAnnotation)
            mapView.showsUserLocation = true
            
            if let invitedUsers = event.invitedUserIds as? [[String:Bool]] {
                for dict in invitedUsers {
                    let allKeys = dict.keys
                    for usr in allKeys {
                        User.getUserFromFirebase(usrId: usr, completion: { (usrF, error) in
                            if let usrF = usrF {
                                if usrF.latitude != nil && usrF.longitude != nil {
                                    let friendLocation = CLLocationCoordinate2D(latitude: usrF.latitude!, longitude: usrF.longitude!)
                                    
                                    let friendLocationAnnotation = MKPointAnnotation()
                                    friendLocationAnnotation.coordinate = friendLocation
                                    friendLocationAnnotation.title      = "\(usrF.firstName ?? "")"
                                    self.mapView.addAnnotation(friendLocationAnnotation)
                                    self.mapView.showsUserLocation = true
                                }
                            }
                        })
                    }
                }
            }
        }
            
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
        //scheduleTimer(timeInterval: 5, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
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
    
    func onTimer() {
        if event != nil {
            if let invitedUsers = event.invitedUserIds as? [[String:Bool]] {
                for dict in invitedUsers {
                    let allKeys = dict.keys
                    for usr in allKeys {
                        User.getUserFromFirebase(usrId: usr, completion: { (usrF, error) in
                            if let usrF = usrF {
                                if usrF.latitude != nil && usrF.longitude != nil && usrF.id != currentLoggedInUser?.id {
                                    let friendLocation = CLLocationCoordinate2D(latitude: usrF.latitude!, longitude: usrF.longitude!)
                                    
                                    let friendLocationAnnotation = MKPointAnnotation()
                                    friendLocationAnnotation.coordinate = friendLocation
                                    friendLocationAnnotation.title      = "\(usrF.firstName ?? "")"
                                    self.mapView.addAnnotation(friendLocationAnnotation)
                                    self.mapView.showsUserLocation = true
                                }
                            }
                        })
                    }
                    
                }
            }
            
        }
    }

}
