//
//  EventsListViewController.swift
//  Clozr
//
//  Created by CK on 5/5/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit

class EventsListViewController: UIViewController {

    @IBOutlet weak var eventsTable: UITableView!
    var searchBar: UISearchBar!

    @IBOutlet weak var titleLabel: UILabel!
    var category:Category?
    var subCategory:Category?
    var events:[Int:[Event]] = [Int:[Event]]()
    var sections:[Int:String] = [Int:String]()
    var locCell:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let sc = subCategory?.name {
            titleLabel.text = "Your choice for \(sc) "
        }
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
//        navigationItem.titleView = searchBar
        eventsTable.delegate = self
        eventsTable.dataSource = self
        eventsTable.rowHeight = UITableViewAutomaticDimension
        eventsTable.estimatedRowHeight = 100
        Styles.styleNav(controller: self)
        User.me?.getInvitedEvents();
        events[0] = User.me?.myCurrentEventInvites
        eventsTable.reloadData()
        loadEvents(searchTerm: nil)
        
    }

    func loadEvents(searchTerm:String? ) {
        if(category?.code == "watch" && (subCategory?.code == "movies" || subCategory?.code == "tvshows")) {
            locCell  = true
        }
        sections = [0:"You hosted", 1:"You are attending "]
        
        for (s , name ) in sections {
            if(s == 0) {
                //CK:TODO your filtered events.
                
            }else {
                //CK:TODO your attending events.
                
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK : Search Bar Delegates

extension EventsListViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        loadEvents(searchTerm: nil)
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadEvents(searchTerm: searchBar.text)
        searchBar.resignFirstResponder()
    }
}


extension EventsListViewController: UITableViewDelegate , UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //loceventcell
        //eventTableCell
        
        if(!locCell) {
            let  eventCell = tableView.dequeueReusableCell(withIdentifier: "eventTableCell") as! EventTableCell
            let section = indexPath.section
            let row = indexPath.row
            eventCell.event = events[section]?[row]
            return eventCell
        }else {
            let  locCell = tableView.dequeueReusableCell(withIdentifier: "loceventcell") as! LocEventCell
            let section = indexPath.section
            let row = indexPath.row
            locCell.event = events[section]?[row]
            return locCell
        }
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currentEvents = events[section] {
            return currentEvents.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionTitle = sections[section]
        return sectionTitle
    }
    
    
    
    
}
