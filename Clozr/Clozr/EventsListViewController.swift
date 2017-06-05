//
//  EventsListViewController.swift
//  Clozr
//
//  Created by CK on 5/5/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit
//import MBProgressHUD
import DGElasticPullToRefresh
import RSLoadingView

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
    var currentUser :ClozrUser?
    var comingFromCreate:Bool?
    var eventFromCreate:Event?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        category = Category.mainCategory
        subCategory = Category.subCategory
        events[0] = [Event]()
        events[1] = [Event]()
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        eventsTable.delegate = self
        eventsTable.dataSource = self
        eventsTable.rowHeight = UITableViewAutomaticDimension
        eventsTable.estimatedRowHeight = 100
        
        // HACK! Remove the black line at the end of Nav bar.
        let view = UIView()
        view.backgroundColor = self.navigationController!.navigationBar.barTintColor
        var rect = view.frame
        rect.origin.x = 0
        rect.origin.y = self.navigationController!.navigationBar.frame.size.height
        rect.size.width = self.navigationController!.navigationBar.frame.size.width
        rect.size.height = 1
        view.frame = rect
        self.navigationController!.navigationBar.addSubview(view)
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = .white
        eventsTable.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.refreshEnded()
            self?.eventsTable.dg_stopLoading()
            }, loadingView: loadingView)
        eventsTable.dg_setPullToRefreshFillColor(self.navigationController!.navigationBar.barTintColor!)
        eventsTable.dg_setPullToRefreshBackgroundColor(eventsTable.backgroundColor!)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        Styles.styleNav(controller: self)
        if comingFromCreateEvent {
            comingFromCreate = true
        }else{
            comingFromCreate = false
        }
        
        if(!comingFromCreate!) {
            reloadEvents(show:true)
        }else{
            self.refreshEnded()
            
            //            reloadEvents(show:false)
        }
        
    }
    
    func reloadEvents(show:Bool) {
        events = [Int:Any]()
        if(!comingFromCreate!) {//
            events[0] = [Event]()
            events[1] = [Event]()
        }//
        
        if let fetchingUser = currentUser {
            ClozrUser.getUserFromFirebase(usrId: fetchingUser.userId!) { (userFetched, error) in
                self.currentUser = userFetched
                self.reloadData(user: fetchingUser,show: show)
            }
            if let fullname = fetchingUser.name {
                var fullNameArr = fullname.components(separatedBy: " ")
                let firstName: String = fullNameArr[0]
                self.navigationItem.title = "\(firstName)'s Events"
            }
            
            if fetchingUser.userId == ClozrUser.currentLoginUserId()! {
                self.navigationItem.title = "My Events"
            }
            
        }else {

                ClozrUser.getUserFromFirebase(usrId: ClozrUser.currentLoginUserId()!) { (loggedInUser, error) in
                    currentLoggedInUser = loggedInUser
                    self.currentUser = loggedInUser
                    
                    self.reloadData(user: self.currentUser,show: show)
                    
                }
            
            self.navigationItem.title = "My Events"
        }
        //  comingFromCreate = false
        // comingFromCreateEvent = false
        
        
        
    }
    
    func refreshEnded() {
        sleep(1)
        self.reloadEvents(show: false)
    }
    
    
    func reloadData(user:ClozrUser? , show:Bool) {
        
        user?.delegate = self
        if(show) {
            var rsLoadingView = RSLoadingView()
            rsLoadingView.shouldTapToDismiss = true
            rsLoadingView.variantKey = "inAndOut"
            rsLoadingView.speedFactor = 3.0
            rsLoadingView.lifeSpanFactor = 1.0
            rsLoadingView.mainColor = UIColor.midnightBlue()
            rsLoadingView.dimBackgroundColor = UIColor.black.withAlphaComponent(0.2)

            rsLoadingView.showOnKeyWindow()
//            loadingView = true

        }
        user?.getInvitedEvents();
    }
    
    func reloadTable(show:Bool) {
        
        self.eventsTable.reloadData()
        if(show) {
//            MBProgressHUD.hide(for: self.view, animated: true)
            RSLoadingView.hideFromKeyWindow()
        }
    }
    
    
    func onAddedEvent(evt:Event? ,show:Bool) {
        var eventArray = events[0] as? [Event]
        if let arr = eventArray ,  let e = evt {
            eventArray?.insert(e, at: 0)
            events[0] = eventArray!
        }else{
            events[0] = [Event]()
            if let e = evt {
                eventArray?.insert(e, at: 0)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.reloadTable(show: show)
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
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}


extension EventsListViewController: UITableViewDelegate , UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(!locCell) {
            let  eventCell = tableView.dequeueReusableCell(withIdentifier: "eventTableCell") as! EventTableCell
            let section = indexPath.section
            let row = indexPath.row
            let arr = events[section] as? [Event]
            if let arrUnwrapped = arr {
                if((arrUnwrapped.count)>0){
                    eventCell.event = arrUnwrapped[row]
                }
                eventCell.enableJoinButton()
                eventCell.reloadFriends()
                //            }
            }
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
