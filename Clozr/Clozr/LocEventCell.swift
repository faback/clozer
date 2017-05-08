//
//  LocEventCell.swift
//  Clozr
//
//  Created by CK on 5/6/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit

class LocEventCell: UITableViewCell {
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventTime: UILabel!

    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    var indexRow:Int?
    
    var event:Event!  {
        didSet {
            if(event != nil) {
                layoutEvent()
            }
        }
        
    }

    
    
    
    func layoutEvent() {
        //        eventImage.image = UIImage(named: event.image!)
        eventTitle.text = event.name
        eventTime.text = event.time
        eventLocation.text = event.address
        if let imgUrl = event.image {
            let imageUrl = "\(MovieDB.sharedInstance.posterUrl())/\(imgUrl)"
            let imageNetworkUrl:URLRequest = URLRequest(url:URL(string:imageUrl)!)
            eventImage.setImageWith(imageNetworkUrl, placeholderImage: nil, success: {( req, res, result) -> Void in
                if res != nil {
                    self.eventImage.alpha = 0.0
                    self.eventImage.image = result
                    UIView.animate(withDuration: 3.0, animations: { () -> Void in
                        self.eventImage.alpha = 1.2
                    })
                }else{
                    self.eventImage.image = result
                }
            }, failure: {(req, res, result) -> Void in
                
            })
        }
        
    }

}
