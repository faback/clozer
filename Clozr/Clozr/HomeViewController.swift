//
//  HomeViewController.swift
//  Clozr
//
//  Created by CK on 5/2/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit
import Firebase
//import HMSegmentedControl
import BetterSegmentedControl
import MapKit
import MBProgressHUD

class HomeViewController: UIViewController {
    var locationManager:CLLocationManager!

    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var control3: BetterSegmentedControl!
    @IBOutlet weak var categoriesCollection: UICollectionView!
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var categoriesHeight: NSLayoutConstraint!
    
    var locations = [CLLocation]()
    var coordinateList = [CLLocationCoordinate2D]()

    var mainCategory = Category()
    var isHeightCalculated: Bool = false
    var selectedSubCategory = Category()

    var sectionedEvents = [Int:[Event]]()
    var sectionTitles = [Int: String]()
    var userReady:Bool = false
    var selectedIndexPath:IndexPath!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MBProgressHUD.showAdded(to: self.view, animated: true)

        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]

        User.getUserFromFirebase(usrId: (User.currentLoginUserId())!) { (usr, error) in
                currentLoggedInUser = usr
                self.userReady = true
                self.determineMyCurrentLocation()
        }
        mainCategory = Category.getWatch()
        control3.titles = ["Watch","Play","Catchup"]
        control3.addTarget(self, action: #selector(navigationSegmentedControlValueChanged(_:)), for: .valueChanged)

        try! control3.setIndex(0, animated: false)
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        eventsTableView.rowHeight = UITableViewAutomaticDimension
        eventsTableView.estimatedRowHeight = 100
        categoriesCollection.delegate = self
        categoriesCollection.dataSource = self
        categoriesCollection.reloadData()
        categoriesHeight.constant = 100
        
        self.categoriesCollection.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        
        selectedSubCategory = mainCategory.subCategories[0];
        changeButtonTitle()
        reloadEventsData()
    }
    
    
    @IBAction func signout(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "loginController") as! LoginScreenViewController
        self.present(vc, animated: true, completion: nil)

    }
    
    
    @IBAction func showFriends(_ sender: Any) {
        
        self.performSegue(withIdentifier: "showFriends", sender: "showFriends")
        
    }

    func changeButtonTitle() {
        if let subcat = selectedSubCategory.name {
            moreButton.setTitle("More \(subcat)  ->", for: .normal)
        }
    }
    func reloadEventsData() {
        Event.getEvents(mainCategory: mainCategory.code!, subCategory: selectedSubCategory.code!) { (evts) in
            self.sectionedEvents[0] = evts
            self.sectionTitles[0] = "Suggested"
            self.eventsTableView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)


        }
    }
    @IBAction func moreEvents(_ sender: Any) {
        
        self.performSegue(withIdentifier: Clozer.Segues.moreBusinesses, sender: "moreBusinesses")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func navigationSegmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        
        if sender.index == 0 {
            mainCategory = Category.getWatch()
            categoriesHeight.constant = 100
            if let collectionViewFlowLayout = categoriesCollection?.collectionViewLayout as? UICollectionViewFlowLayout {
                 collectionViewFlowLayout.minimumInteritemSpacing = 30
            }
        }
        else if sender.index == 1{
            mainCategory = Category.getPlay()
            categoriesHeight.constant = 180
            if let collectionViewFlowLayout = categoriesCollection?.collectionViewLayout as? UICollectionViewFlowLayout {
                collectionViewFlowLayout.minimumInteritemSpacing = 10
            }

        }
        else {
            mainCategory = Category.getCatchup()
            categoriesHeight.constant = 100
            if let collectionViewFlowLayout = categoriesCollection?.collectionViewLayout as? UICollectionViewFlowLayout {
                collectionViewFlowLayout.minimumInteritemSpacing = 10
            }

        }
        selectedSubCategory = mainCategory.subCategories[0];
        categoriesCollection.reloadData()
        reloadEventsData()
        changeButtonTitle()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        Category.mainCategory = mainCategory
        Category.subCategory = selectedSubCategory
        let senderStr = sender as! String
        if(senderStr == "moreBusinesses") {
            //:BALAJI-NAV
            let eventListController = segue.destination as! BusinessViewController
            eventListController.category = mainCategory
            eventListController.subCategory = selectedSubCategory
        }
        if(senderStr == "showFriends") {
            _ = segue.destination as! FriendEventsViewController
        }
        
        if(senderStr == "movieDetail") {
            var indexPath  = selectedIndexPath
            let evt = sectionedEvents[(indexPath?.section)!]?[(indexPath?.row)!]
            let movieController = segue.destination as! SelectMovieViewController
            movieController.event = evt
        }
        if(senderStr == "createEventSegue") {
            
            var indexPath  = selectedIndexPath
            let evt = sectionedEvents[(indexPath?.section)!]?[(indexPath?.row)!]
            let createEventController = segue.destination as! CreateEventViewController
            createEventController.event = evt
        }
        
    }
 

}


extension HomeViewController : CLLocationManagerDelegate  {
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        let appDelegate = UIApplication.shared.delegate  as! AppDelegate
        appDelegate.locationManager = locationManager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let newLocation = locations.last!
        print("current position: \(newLocation.coordinate.longitude) , \(newLocation.coordinate.latitude)")
        self.locations.append(newLocation)
        self.coordinateList.append(newLocation.coordinate)
        if(userReady) {
            currentLoggedInUser?.latitude = newLocation.coordinate.latitude
            currentLoggedInUser?.longitude = newLocation.coordinate.longitude
            currentLatitude = newLocation.coordinate.latitude
            currentLongitude = newLocation.coordinate.longitude
            Clozer.savePreferenceDouble(name: Clozer.Preferences.lastLatitude, val: currentLatitude!)
            Clozer.savePreferenceDouble(name: Clozer.Preferences.lastLongitude, val: currentLongitude!)
            if let cuser = currentLoggedInUser {
                User.createOrUpdateUserInFirebase(user: cuser)
            }
        }
        let appDelegate = UIApplication.shared.delegate  as! AppDelegate
        

        
        if let bg =  appDelegate.isBackground , let df = appDelegate.deferringUpdates
        {
            if(bg && !df) {
                appDelegate.deferringUpdates = true;
                locationManager.allowDeferredLocationUpdates(untilTraveled: CLLocationDistanceMax, timeout: 1)
            }
        }
        // Building the kml file, building the message and pushing it
        let message = "{\"lat\":\(newLocation.coordinate.latitude),\"lng\":\(newLocation.coordinate.longitude), \"alt\": \(newLocation.altitude)}"
        print(message)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        YelpSettings.resetLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        let appDelegate = UIApplication.shared.delegate  as! AppDelegate
        appDelegate.deferringUpdates = false
    }
    
}


extension HomeViewController: UICollectionViewDelegate , UICollectionViewDataSource   {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainCategory.subCategories.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subcategorycell", for: indexPath) as! SubCategoryCell
        if(!mainCategory.subCategories.isEmpty) {
           let cat = mainCategory.subCategories[indexPath.row]
            cell.indexRow  = indexPath.row
            cell.category = cat
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSubCategory = mainCategory.subCategories[indexPath.row]
        if(indexPath.row != 0) {
          let firstIndexPath = IndexPath(item: 0, section: 0)
          let firstCell = collectionView.cellForItem(at: firstIndexPath) as! SubCategoryCell
          firstCell.unTintImage()
        }
         let cell = collectionView.cellForItem(at: indexPath) as! SubCategoryCell
         cell.tintImage()
        changeButtonTitle()
        reloadEventsData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SubCategoryCell
        cell.unTintImage()
    }
    
    
    
}


extension HomeViewController: UITableViewDelegate , UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  eventCell = tableView.dequeueReusableCell(withIdentifier: "homeEventsCell") as! HomeEventsCell
        let events = sectionedEvents[indexPath.section]
        let event = events?[indexPath.row]
        eventCell.event = event
        return eventCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        if(selectedSubCategory.code == "movies") {
        self.performSegue(withIdentifier: Clozer.Segues.movieDetail, sender: "movieDetail")
        }else{
         self.performSegue(withIdentifier: Clozer.Segues.createEventSegue, sender: "createEventSegue")
        }
        eventsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionedEvents.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currentEvents = sectionedEvents[section] {
            return currentEvents.count
        }
        return 0
    }
    

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionTitle = "Suggested Events"
        if let subcat = selectedSubCategory.name  {
            sectionTitle = "Suggestions for \(subcat) "
        }
        return sectionTitle
    }

    
    
    
}
