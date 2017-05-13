//
//  EventsListViewController.swift
//  Clozr
//
//  Created by CK on 5/5/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit
import MBProgressHUD

class EventsListViewController: UIViewController,UserChangesProtocol {

    @IBOutlet weak var eventsTable: UITableView!
    var searchBar: UISearchBar!

    @IBOutlet weak var titleLabel: UILabel!
    var category:Category?
    var subCategory:Category?
    var comingFromCreateEvent: Bool = false
    var newEventFromCreateEventView: Event!
    var events:[Int:Any] = [Int:Any]()
    var sections:[Int:String] = [Int:String]()
    var locCell:Bool = false
    var currentUser :User?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]

        category = Category.mainCategory
        subCategory = Category.subCategory
        events[0] = [Event]()
        events[1] = [Event]()
        
        if let me = currentLoggedInUser   {
            reloadData(user: me)
        }else {
            User.getUserFromFirebase(usrId: User.currentLoginUserId()) { (loggedInUser, error) in
                currentLoggedInUser = loggedInUser
                self.currentUser = loggedInUser
                self.reloadData(user: self.currentUser)
            }
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
        
        loadEvents(searchTerm: nil)
//        if comingFromCreateEvent {
//            onAddedEvent(evt: newEventFromCreateEventView)
//        }
        
    }
    
    
    func reloadData(user:User?) {
        user?.delegate = self
        MBProgressHUD.showAdded(to: self.view, animated: true)
        user?.getInvitedEvents();
    }
    
    func reloadTable() {
        
        self.eventsTable.reloadData()
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    
    func onAddedEvent(evt:Event) {
        var eventArray = events[0] as! [Event]
        print("Count \(eventArray.count)")
        eventArray.append(evt)
        events[0] = eventArray
    }

    func loadEvents(searchTerm:String? ) {
        if(category?.code == "watch" && (subCategory?.code == "movies" || subCategory?.code == "tvshows")) {
            locCell  = true
        }
        sections = [0:"This Week"]
        
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
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let indexPath = sender as! IndexPath
        let currEvents = events[indexPath.section] as! [Event]
        let evt = currEvents[indexPath.row]
        let vc = segue.destination as! EventDetailsViewController
        vc.event = evt
    }
 

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
            let arr = events[section] as! [Event]
            eventCell.event = arr[row]
            return eventCell
        }else {
            let  locCell = tableView.dequeueReusableCell(withIdentifier: "loceventcell") as! LocEventCell
            let section = indexPath.section
            let row = indexPath.row
            let arr = events[section] as! [Event]

            locCell.event = arr[row]
            return locCell
        }
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currentEvents = events[section] as? [Event] {
            return currentEvents.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionTitle = sections[section]
        return sectionTitle
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: Clozer.Segues.toDetail, sender: indexPath)
        eventsTable.deselectRow(at: indexPath, animated: true)

    }
    
    
    
    
}
