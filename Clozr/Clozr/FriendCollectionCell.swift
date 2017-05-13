//
//  FriendCollectionCell.swift
//  Clozr
//
//  Created by CK on 5/6/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit

class FriendCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var online: UIImageView!
    @IBOutlet weak var near: UIImageView!
    @IBOutlet weak var eventCount: UILabel!
    
    var indexRow:Int?
    
    var friend:User!  {
        didSet {
            if(friend != nil) {
                layoutFriend()
            }
        }
        
    }
    
    override func awakeFromNib() {
        self.friendImage.layer.cornerRadius = 19
        self.friendImage.layoutIfNeeded()
    }
    
    
    func layoutFriend() {
        //        eventImage.image = UIImage(named: event.image!)
        friendName.text = friend.name
        eventCount.text = "3 events"
        if let imgUrl = friend.profilePictureURLString {
            let imageNetworkUrl:URLRequest = URLRequest(url:URL(string:imgUrl)!)
            friendImage.setImageWith(imageNetworkUrl, placeholderImage: nil, success: {( req, res, result) -> Void in
                if res != nil {
                    self.friendImage.alpha = 0.0
                    self.friendImage.image = result
                    UIView.animate(withDuration: 3.0, animations: { () -> Void in
                        self.friendImage.alpha = 1.2
                    })
                }else{
                    self.friendImage.image = result
                }
                self.friendImage.layer.cornerRadius = 19
                self.friendImage.layer.masksToBounds = true

                self.friendImage.layoutIfNeeded()
            }, failure: {(req, res, result) -> Void in
                
            })
        }
        
    }
    
    
    override func prepareForReuse() {
        friend = nil
        friendImage.image = #imageLiteral(resourceName: "noimage.png")
        friendName.text = ""
        eventCount.text = ""
    }
}
