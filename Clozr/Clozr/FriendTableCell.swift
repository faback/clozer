//
//  FriendTableCell.swift
//  Clozr
//
//  Created by Tummala, Balaji on 5/3/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit

class FriendTableCell: UITableViewCell {

//    @IBOutlet weak var friendNameLabel: UILabel!
//    @IBOutlet weak var friendImageView: UIImageView!
//    @IBOutlet weak var friendPhoneNoLabel: UILabel!
    @IBOutlet weak var friendImageView: UIImageView!
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var friendPhoneNoLabel: UILabel!
    var friend: ClozrUser!{
        didSet{
            friendNameLabel.text = friend.name!
            if let profilePic = friend.profilePictureURLString{
            friendImageView.setImageWith(URL(string: profilePic)!)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        friendImageView.layer.cornerRadius = 3
        friendImageView.clipsToBounds = true

    }
    
    override func prepareForReuse() {
       friendNameLabel.text = nil
       friendImageView.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
