//
//  EventTableCell.swift
//  Clozr
//
//  Created by CK on 5/6/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit

class EventTableCell: UITableViewCell {

    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    
    
    @IBOutlet weak var friendsCollectionTable: UICollectionView!
    
    var indexRow:Int?
    var users = [User]()
    var count = 0
    var event:Event!  {
        didSet {
            if(event != nil) {
                layoutEvent()
            }
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        friendsCollectionTable.delegate = self
        friendsCollectionTable.dataSource = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    func layoutEvent() {
        //        eventImage.image = UIImage(named: event.image!)
        eventTitle.text = event.name
        eventTime.text = event.time
        eventLocation.text = event.address
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
            }, failure: {(req, res, result) -> Void in
                
            })
        }
        
        
        friendsCollectionTable.delegate = self
        for usersInvited in event.invitedUserIds {
            for (k,v) in usersInvited {
                let usrId = k
                let accepted = v
                
                User.getUserFromFirebase(mail: usrId, completion: { (usr, error) in
                    self.users.append(usr!)
                    self.count += 1;
                    self.friendsCollectionTable.reloadData()
                    self.setNeedsLayout()
                })
                
                
                
            }
        }

        
    }

    
    override func prepareForReuse() {
        event = nil
        eventImage.image = #imageLiteral(resourceName: "noimage.png")
        eventTitle.text = ""
        eventLocation.text = ""
    }
    
    
    
}


extension EventTableCell: UICollectionViewDelegate , UICollectionViewDataSource   {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendssmallcell", for: indexPath) as! FriendsSmallCell
        if(!users.isEmpty) {
            let connectedUser = users[indexPath.row]
            cell.profileUrl = connectedUser.profilePictureURLString
        }
        return cell
    }
    
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //       //todo
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    //        let cell = collectionView.cellForItem(at: indexPath) as! SubCategoryCell
    //        cell.unTintImage()
    //    }
    //    
    
    
}

