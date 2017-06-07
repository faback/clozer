//
//  FriendListCellCollectionViewCell.swift
//  Clozr
//
//  Created by Fateh Singh on 4/30/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit

class FriendListCellCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var ResponseImage: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    
    var accepted: Bool = false
    var user: String! {
        didSet {
            setProfileImage()
            friendImage.layer.borderWidth = 3
            if accepted {
                ResponseImage.image = UIImage(named:"icons8-checked")
                friendImage.layer.borderColor =  UIColor.greenSea().withAlphaComponent(0.6).cgColor
            } else {
                ResponseImage.image = UIImage(named:"icons8-cancel")
                friendImage.layer.borderColor =  UIColor.red.withAlphaComponent(0.6).cgColor
            }
            
        }
    }
    
    func setProfileImage() {
        self.friendImage.image = nil
        ClozrUser.getUserFromFirebase(usrId: user, completion: { (usrF, error) in
            if let usrF = usrF {
                var fullNameArr = usrF.name.components(separatedBy: " ")
                let firstName: String = fullNameArr[0]
                self.friendName.text = firstName
                
                let imageNetworkUrl:URLRequest = URLRequest(url:URL(string:usrF.profilePictureURLString)!)
                self.friendImage.setImageWith(imageNetworkUrl, placeholderImage: nil, success: {( req, res, result) -> Void in
                    if res != nil {
                        self.friendImage.alpha = 0.0
                        self.friendImage.image = result
                        UIView.animate(withDuration: 3.0, animations: { () -> Void in
                            self.friendImage.alpha = 1.2
                        })
                    }else{
                        self.friendImage.image = result
                    }
                    self.friendImage.layer.cornerRadius = 37.5
                    self.friendImage.layer.masksToBounds = true
                    
                    self.friendImage.layoutIfNeeded()
                }, failure: {(req, res, result) -> Void in
                    
                })
            }
        })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        friendName.text = ""
        friendImage.layer.cornerRadius = 37.5
        friendImage.layer.masksToBounds = true
        friendImage.layoutIfNeeded()
    }
}
