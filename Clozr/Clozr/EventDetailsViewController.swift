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
    weak var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if event != nil {
            
        } else {
            // Throw an exception.. This should never happen.
            // For now make a test Event.
        }
        
        eventDetailsTableView.dataSource = self
        eventDetailsTableView.delegate   = self
        eventDetailsTableView.rowHeight  = UITableViewAutomaticDimension
        eventDetailsTableView.estimatedRowHeight = 100
        
        
        alert.addAction(UIAlertAction(title: "Accept!", style: .default) { action in
            self.respondButton.isEnabled = false
            self.respondButton.title = ""
            
            // Tell the server that the user accepted.
            
        })
        alert.addAction(UIAlertAction(title: "Reject!", style: .default) { action in
            self.respondButton.isEnabled = false
            self.respondButton.title = ""
            
            // Tell the server that the user rejected.
            
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { action in
        })

    }
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 {
            let cell = eventDetailsTableView.dequeueReusableCell(withIdentifier: "EventDetailsDescriptionCell", for: indexPath) as! EventDetailsDescriptionCell
            cell.setSelected(false, animated: false)
            cell.event = self.event
            return cell
        } else if indexPath.row == 1 {
            let cell = eventDetailsTableView.dequeueReusableCell(withIdentifier: "EventDetailsFriendsListCell", for: indexPath) as! EventDetailsFriendsListCell
            cell.event = self.event
            return cell
        } else if indexPath.row == 2{
            let cell = eventDetailsTableView.dequeueReusableCell(withIdentifier: "EventDetailsMapCell", for: indexPath) as! EventDetailsMapCell
            cell.event = self.event
            cell.setSelected(false, animated: true)
            return cell
        } else {
            let cell = eventDetailsTableView.dequeueReusableCell(withIdentifier: "EventDetailsMessagesCell", for: indexPath) as! EventDetailsMessagesCell
            cell.event = self.event
            return cell
        }
        
    }
    
    @IBAction func onRespondClick(_ sender: Any) {
        self.present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}
