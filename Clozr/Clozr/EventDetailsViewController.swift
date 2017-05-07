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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventDetailsTableView.dataSource = self
        eventDetailsTableView.delegate   = self
        eventDetailsTableView.rowHeight  = UITableViewAutomaticDimension
        eventDetailsTableView.estimatedRowHeight = 100

    }
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 {
            let cell = eventDetailsTableView.dequeueReusableCell(withIdentifier: "EventDetailsDescriptionCell", for: indexPath)
            return cell
        } else if indexPath.row == 1 {
            let cell = eventDetailsTableView.dequeueReusableCell(withIdentifier: "EventDetailsFriendsListCell", for: indexPath)
            return cell
        } else if indexPath.row == 2{
            let cell = eventDetailsTableView.dequeueReusableCell(withIdentifier: "EventDetailsMapCell", for: indexPath)
            return cell
        } else {
            let cell = eventDetailsTableView.dequeueReusableCell(withIdentifier: "EventDetailsMessagesCell", for: indexPath)
            return cell
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}
