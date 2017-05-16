//
//  BusinessTableCell.swift
//  Clozr
//
//  Created by Tummala, Balaji on 5/3/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit

class BusinessTableCell: UITableViewCell {

    
    @IBOutlet weak var businessCellMainView: UIView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var ratingsCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var CuisineTypeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var dollarLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    var event: Event!{
        didSet{
            nameLabel.text = event.name
            if let imgUrl = event.image {
                var imageUrl = "\(MovieDB.sharedInstance.posterUrl())/\(imgUrl)"
                if(event.category != "movies") {
                    imageUrl = imgUrl
                }
                let imageNetworkUrl:URLRequest = URLRequest(url:URL(string:imageUrl)!)
                thumbImageView.setImageWith(imageNetworkUrl, placeholderImage: nil, success: {( req, res, result) -> Void in
                    if res != nil {
                        self.thumbImageView.alpha = 0.0
                        self.thumbImageView.image = result
                        UIView.animate(withDuration: 3.0, animations: { () -> Void in
                            self.thumbImageView.alpha = 1.2
                        })
                    }else{
                        self.thumbImageView.image = result
                    }
                }, failure: {(req, res, result) -> Void in
                    
                })
            }
            


            addressLabel.text = event.address
            distanceLabel.text = event.distance
            phoneNumberLabel.text = event.phone
//            ratingsCountLabel.text = "\(business.reviewCount!) Reviews"
//            ratingImageView.setImageWith(business.ratingImageURL!)
//            CuisineTypeLabel.text = business.categories

        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        addressLabel.text = nil
        distanceLabel.text = nil
        phoneNumberLabel.text = nil
        nameLabel.text = nil
        thumbImageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbImageView.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
