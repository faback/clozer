//
//  BusinessViewController.swift
//  Clozr
//
//  Created by Tummala, Balaji on 5/3/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit
import MapKit

class BusinessViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, MKMapViewDelegate, ListBusinessViewDelegate  {

    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    var category:Category?
    var subCategory:Category?
    var event: Event!
    var events: [Event]!
    var searchBar: UISearchBar!
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollView?
    var isTableViewShowing: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
       // contentView.delegate = self
        
//        let picker = DateTimePicker.show(view: contentView)
//        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
//        picker.completionHandler = { date in
//            // do something after tapping done
//            
//        }
        
        searchBar = UISearchBar()
        searchBar.delegate = self as! UISearchBarDelegate
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        mapView.delegate = self
        
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollView.defaultHeight)
        loadingMoreView = InfiniteScrollView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollView.defaultHeight
        tableView.contentInset = insets
        
        
        //        let location = CLLocationCoordinate2DMake(37.361893,-122.024229)
        //        businessMapView.setRegion(MKCoordinateRegionMakeWithDistance(location, 2000, 2000), animated: true)
        //        let pin = PinAnnotation(title: "Test Restuarant", coordinate: location)
        //        businessMapView.addAnnotation(pin)
        reloadEventsData()
        
       


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadEventsData(offset:Int=0) {
        self.loadingMoreView!.startAnimating()
        Event.getEvents(mainCategory: Category.mainCategory.code!, subCategory: Category.subCategory.code!, offset: offset) { (evts) in
            
            if offset == 0 {
                self.events = evts
            } else {
                for oneEvent in evts {
                    self.events.append(oneEvent)
                }
            }
            //self.events = evts
            self.tableView.reloadData()
            self.isMoreDataLoading = false
            self.loadingMoreView!.stopAnimating()
            var pinArray=[MKAnnotation]()
            var doOnce:Bool = false
            
            var takeAroundCoordinates:CLLocationCoordinate2D?
            
            for event in evts {
                if let latitude = event.latitude , let longitude = event.longitude {
                    let pinLocation = CLLocationCoordinate2DMake(latitude,longitude)
                    if(!doOnce){
                        takeAroundCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    }
                    doOnce = true
                    
                    // self.businessMapView.setRegion(MKCoordinateRegionMakeWithDistance(pinLocation, 2000, 2000), animated: true)
                    let pin = PinAnnotation(title: event.name!, coordinate: pinLocation)
                    pinArray.append(pin)
                }
            }
            let zoomLevel:Int = 10
            let clLocationCordinate = takeAroundCoordinates
            
            let span = MKCoordinateSpanMake(0, 360 / pow(2, Double(zoomLevel)) * Double(self.mapView.frame.size.width) / 256)
            self.mapView.setRegion(MKCoordinateRegionMake(clLocationCordinate!, span), animated: true)
            self.mapView.addAnnotations(pinArray)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! BusinessTableCell
        cell.event = events[indexPath.row]
        return cell
    }
    
    /*  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     businessCellNib.instantiate(withOwner: self, options: nil)
     }*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let events = events {
            return events.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSeguetoCreateEvent(event: events[indexPath.row])
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func performSeguetoCreateEvent(event: Event) {
        self.event = event
        performSegue(withIdentifier: "BusinessToCreateEvent", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let createEventViewController = segue.destination as! CreateEventViewController
        createEventViewController.event = self.event
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if (!isMoreDataLoading) {
                // Calculate the position of one screen length before the bottom of the results
                let scrollViewContentHeight = tableView.contentSize.height
                let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
                
                // When the user has scrolled past the threshold, start requesting
                if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                    isMoreDataLoading = true
                    
                    // Update position of loadingMoreView, and start loading indicator
                    let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollView.defaultHeight)
                    loadingMoreView?.frame = frame
                    
                    // Code to load more results
                    reloadEventsData(offset: events.count)
                }
            }
        }

    @IBAction func switchView(_ sender: Any) {
        
        var option: UIViewAnimationOptions = .transitionFlipFromLeft
        isTableViewShowing = !isTableViewShowing
        let button = sender as! UIBarButtonItem
        if isTableViewShowing {
            button.title = "Map"
            mapView.isHidden = true
            tableView.isHidden = false
            UIView.transition(with: self.tableView, duration: 0.4, options: option, animations: nil, completion: nil)
        } else {
            button.title = "List"
            tableView.isHidden = true
            mapView.isHidden = false
            option = .transitionFlipFromRight
            UIView.transition(with: self.mapView, duration: 0.4, options: option, animations: nil, completion: nil)
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isTableViewShowing {
            mapView.isHidden = true
        } else {
            tableView.isHidden = true
        }
    }
}


extension BusinessViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
       
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
       
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            searchBar.resignFirstResponder()
        }
    }
}
