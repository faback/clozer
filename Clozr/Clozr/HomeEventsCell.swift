//
//  HomeEventsCell.swift
//  Clozr
//
//  Created by CK on 5/6/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit

class HomeEventsCell: UITableViewCell {
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var time: UILabel!

    
    var indexRow:Int?
    
    var event:Event!  {
        didSet {
            if(event != nil) {
                layoutEvent()
            }
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization c ode
        self.eventImage.layer.cornerRadius = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  
    
    func layoutEvent() {
//        eventImage.image = UIImage(named: event.image!)
        eventTitle.text = event.name
        eventDescription.text = event.summary
        time.text = event.time
        location.text = event.address
        if let imgUrl = event.image {
            var imageUrl = "\(MovieDB.sharedInstance.posterUrl())/\(imgUrl)"
            if(event.category != "movies") {
                imageUrl = imgUrl
            }
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
                self.eventImage.layer.cornerRadius = 5

            }, failure: {(req, res, result) -> Void in
                
            })
        }
        
    }
    
    
    override func prepareForReuse() {
        event = nil
//        eventImage.image = #imageLiteral(resourceName: "noimage.png")
        eventTitle.text = ""
        eventDescription.text = ""
        location.text = ""
        time.text = ""
        
    }
}
