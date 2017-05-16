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
import AFNetworking

class MyCustomPointAnnotation: MKPointAnnotation {
    var imageURL: String? = nil
}

class MapsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var centerMapButton: UIButton!
    
    weak var event:Event!
    let manager = CLLocationManager()
    var centerMap:Bool = false
    var timer:Timer?
    var eventLocation:CLLocationCoordinate2D?
    var updateOnce:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        manager.delegate = self
        
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.distanceFilter = 1.0
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        if event != nil {
            let latitude = event.latitude ?? 37.3549144
            let longitude = event.longitude ?? -122.0035661
            
            // Center the map around the location of the event.
            eventLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let mapSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: eventLocation!, span: mapSpan)
            mapView.setRegion(region, animated: false)
            
            let eventLocationAnnotation = MyCustomPointAnnotation()
            eventLocationAnnotation.coordinate = eventLocation!
            eventLocationAnnotation.title      = "Event Location"
            mapView.addAnnotation(eventLocationAnnotation)
            mapView.showsUserLocation = true
        }
            
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
        timer?.fire()
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
            let overlays = mapView.overlays
            mapView.removeOverlays(overlays)
            updateOnce = false
        } else {
            centerMap = true
            centerMapButton.setImage(UIImage(named: "location_blue.png"), for: UIControlState.normal)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let mylocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)

        if eventLocation != nil && updateOnce != true {
            showRouteOnMap(source: mylocation, destination: eventLocation!)
            updateOnce = true
        } else if (centerMap) {
            let span = MKCoordinateSpanMake(0.01, 0.01)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(mylocation, span)
            mapView.setRegion(region, animated: true)
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
                                    
                                    let friendLocationAnnotation = MyCustomPointAnnotation()
                                    friendLocationAnnotation.coordinate = friendLocation
                                    friendLocationAnnotation.title      = "\(usrF.name ?? "")"
                                    friendLocationAnnotation.imageURL   = usrF.profilePictureURLString
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MyCustomPointAnnotation) {
            return nil
        }
        let castAnnotation = annotation as? MyCustomPointAnnotation
        
        if castAnnotation == nil {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "destination")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: castAnnotation, reuseIdentifier: "destination")
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = castAnnotation
        }
        
        if castAnnotation?.imageURL == nil {
            annotationView?.image = UIImage(named: "destination")
        } else {
            let imageView:UIImageView = UIImageView()
            let url:URL = URL(string: (castAnnotation?.imageURL)!)!
            imageView.setImageWith(url)
            let newImageView:UIImageView = UIImageView(image: resizeImage(image: imageView.image!, targetSize: CGSize(width: 50, height: 50)))
            annotationView?.image = maskRoundedImage(image: newImageView.image!, radius: 20)
        }
        
        return annotationView
        
    }
    
    func showRouteOnMap(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { (resp: MKDirectionsResponse?, error: Error?) in
            guard let unwrappedResponse = resp else { return }
            
            if (unwrappedResponse.routes.count > 0) {
                self.mapView.add(unwrappedResponse.routes[0].polyline)
                if self.centerMap == false {
                    let mapRect:MKMapRect = unwrappedResponse.routes[0].polyline.boundingMapRect
                    self.mapView.setVisibleMapRect(mapRect, animated: true)
                } else {
                    let span = MKCoordinateSpanMake(0.01, 0.01)
                    let region:MKCoordinateRegion = MKCoordinateRegionMake(source, span)
                    self.mapView.setRegion(region, animated: true)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor(red: 57.0/255.0, green: 101.0/255.0, blue: 169.0/255.0, alpha:1)
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        return MKPolylineRenderer()
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func maskRoundedImage(image: UIImage, radius: Float) -> UIImage {
        let imageView: UIImageView = UIImageView(image: image)
        var layer: CALayer = CALayer()
        layer = imageView.layer
        
        layer.masksToBounds = true
        layer.cornerRadius = CGFloat(radius)
        
        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return roundedImage!
    }

}
