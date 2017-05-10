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

class HomeViewController: UIViewController {

    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var control3: BetterSegmentedControl!
    @IBOutlet weak var categoriesCollection: UICollectionView!
    @IBOutlet weak var eventsTableView: UITableView!
    
    var mainCategory = Category()
    var isHeightCalculated: Bool = false
    var selectedSubCategory = Category()

    var sectionedEvents = [Int:[Event]]()
    var sectionTitles = [Int: String]()

    var selectedIndexPath:IndexPath!
    override func viewDidLoad() {
        super.viewDidLoad()
        User.getUserFromFirebase(mail: (User.currentLoginUserId())) { (usr, error) in
                currentLoggedInUser = usr
        }
        mainCategory = Category.getWatch()
        control3.titles = ["Watch","Play","Catchup"]
//        control3.titleFont = UIFont.appFont()
//        control3.selectedTitleFont = UIFont.appFont()
        control3.addTarget(self, action: #selector(navigationSegmentedControlValueChanged(_:)), for: .valueChanged)

        try! control3.setIndex(0, animated: false)
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        eventsTableView.rowHeight = UITableViewAutomaticDimension
        eventsTableView.estimatedRowHeight = 100
        categoriesCollection.delegate = self
        categoriesCollection.dataSource = self
        categoriesCollection.reloadData()
        
        self.categoriesCollection.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        
        selectedSubCategory = mainCategory.subCategories[0];
        changeButtonTitle()
        reloadEventsData()
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
        }
        else if sender.index == 1{
            mainCategory = Category.getPlay()
        }
        else {
            mainCategory = Category.getCatchup()
        }
        categoriesCollection.reloadData()
        eventsTableView.reloadData()
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
            let eventListController = segue.destination as! FriendEventsViewController
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
