//
//  friendsSmallCell.swift
//  Clozr
//
//  Created by CK on 5/6/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit

class FriendsSmallCell: UICollectionViewCell {
    @IBOutlet weak var friendsImage: UIImageView!
    
    
    var profileUrl:String!  {
        didSet {
            if(profileUrl != nil) {
            
                layoutFriend()
            }
        }
        
    }
    
    func layoutFriend() {
        if let imgUrl = profileUrl {
            let imageNetworkUrl:URLRequest = URLRequest(url:URL(string:imgUrl)!)
            friendsImage.setImageWith(imageNetworkUrl, placeholderImage: nil, success: {( req, res, result) -> Void in
                if res != nil {
                    self.friendsImage.alpha = 0.0
                    self.friendsImage.image = result
                    UIView.animate(withDuration: 3.0, animations: { () -> Void in
                        self.friendsImage.alpha = 1.2
                    })
                }else{
                    self.friendsImage.image = result
                }
                self.friendsImage.layer.cornerRadius = 19
                self.friendsImage.layer.masksToBounds = true
                
                self.friendsImage.layoutIfNeeded()
            }, failure: {(req, res, result) -> Void in
                
            })
        }
        
    }
}
