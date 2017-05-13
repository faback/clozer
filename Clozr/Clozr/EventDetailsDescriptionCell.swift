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
    
    weak var event: Event! {
        didSet {
            titleLabel.text = event.name ?? ""
            descriptionLabel.text = event.summary ?? ""
            timeLabel.text = event.time ?? ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if event != nil {
            titleLabel.text = event.name ?? ""
            descriptionLabel.text = event.summary ?? ""
            timeLabel.text = event.time ?? ""
            
        } else {
            // Throw an exception. Event should never be nil
            
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }

}
