//
//  EventDetailsViewController.swift
//  Clozr
//
//  Created by Fateh Singh on 4/27/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var eventDetailsTableView: UITableView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var respondButton: UIBarButtonItem!
    
    let alert = UIAlertController(title: "Your response", message: nil, preferredStyle: .actionSheet)
    weak var event:Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventDetailsTableView.dataSource = self
        eventDetailsTableView.delegate   = self
        eventDetailsTableView.rowHeight  = UITableViewAutomaticDimension
        eventDetailsTableView.estimatedRowHeight = 100
        eventDetailsTableView.separatorStyle = .none
        
        
        alert.addAction(UIAlertAction(title: "Accept!", style: .default) { action in
//            self.respondButton.isEnabled = false
//            self.respondButton.title = ""
            self.saveResponse(true)
            self.eventDetailsTableView.reloadData()
        })
        alert.addAction(UIAlertAction(title: "Reject!", style: .default) { action in
//            self.respondButton.isEnabled = false
//            self.respondButton.title = ""
            self.saveResponse(false)
            self.eventDetailsTableView.reloadData()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { action in
        })

    }
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            let cell = eventDetailsTableView.dequeueReusableCell(withIdentifier: "EventDetailsDescriptionCell", for: indexPath) as! EventDetailsDescriptionCell
            cell.event = self.event
            return cell
        } else if indexPath.section == 1 {
            let cell = eventDetailsTableView.dequeueReusableCell(withIdentifier: "EventDetailsFriendsListCell", for: indexPath) as! EventDetailsFriendsListCell
            cell.event = self.event
            return cell
        } else if indexPath.section == 2{
            let cell = eventDetailsTableView.dequeueReusableCell(withIdentifier: "EventDetailsMapCell", for: indexPath) as! EventDetailsMapCell
            cell.event = self.event
            return cell
        } else {
            let cell = eventDetailsTableView.dequeueReusableCell(withIdentifier: "EventDetailsMessagesCell", for: indexPath) as! EventDetailsMessagesCell
            cell.event = self.event
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventDetailsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func onRespondClick(_ sender: Any) {
        self.present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mapsVC = segue.destination as? MapsViewController
        if mapsVC == nil {
            let messagesVC = segue.destination as! MessagesViewController
            messagesVC.event = event
        } else {
            mapsVC?.event = event
        }
    }
    
    func saveResponse(_ response:Bool) {
        
        var index = 0
        var selectedIndex = 0
        if let invitedUsers = event.invitedUserIds as? [[String:Bool]] {
            for dict in invitedUsers {
                let allKeys = dict.keys
                for usr in allKeys {
                    if(usr == User.currentLoginUserId()) {
                        selectedIndex = index
                    }
                    
                }
                index = index + 1
            }
        }
        
        event.invitedUserIds.remove(at: selectedIndex)
        event.invitedUserIds.append([User.currentLoginUserId()! : response])
        
        Event.updateChildValues(eventId: event.id, vals: ["invitedUserIds" : event.invitedUserIds ])
    }

}
