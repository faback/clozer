//
//  EventDetailsDescriptionCell.swift
//  Clozr
//
//  Created by Fateh Singh on 5/6/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit

class EventDetailsDescriptionCell: UITableViewCell {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var hostedByLable: UILabel!
    
    weak var event: Event! {
        didSet {
            titleLabel.text = event.name ?? "Event"
            descriptionLabel.text = event.summary ?? "No description present"
            
            let time:String = event.time ?? "May 31, 2017 at 11:30 AM"
            timeLabel.text = time
            //monthLabel.text = event.
            hostedByLable.text = ""
            if event.userId != nil {
                User.getUserFromFirebase(usrId: event.userId!, completion: { (usrF, error) in
                    if let usrF = usrF {
                        self.hostedByLable.text = "Hosted by: \(usrF.name)"
                    }
                })
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if event != nil {
            titleLabel.text = event.name ?? ""
            descriptionLabel.text = event.summary ?? ""
            timeLabel.text = event.time ?? ""
            
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }

}
