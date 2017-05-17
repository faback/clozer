//
//  EventTableCell.swift
//  Clozr
//
//  Created by CK on 5/6/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit
import FlatUIKit
class EventTableCell: UITableViewCell {
    
    @IBOutlet weak var statusCountsLabel: UILabel!
    
    @IBOutlet weak var friendsCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    
    @IBOutlet weak var joinDeclineButton: FUIButton!
    
    @IBOutlet weak var friendsCollectionWidth: NSLayoutConstraint!
    @IBOutlet weak var friendsCollectionTable: UICollectionView!
    
    var indexRow:Int?
    var users = [(User,Int)]()
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
        
        
        joinDeclineButton.buttonColor = UIColor.belizeHole()
        joinDeclineButton.shadowColor = UIColor.white
        joinDeclineButton.shadowHeight = 1.0
        joinDeclineButton.cornerRadius = 2.0
        joinDeclineButton.setTitleColor(UIColor.white, for: .normal)
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func onJoin(_ sender: Any) {
        
        var index = 0
        var selectedIndex = 0
        if let invitedUsers = event.invitedUserIds as? [[String:Bool]] {
            for dict in invitedUsers {
                let allKeys = dict.keys
                for usr in allKeys {
                    if(usr == User.currentLoginUserId()) {
                        selectedIndex = index
                    }
                    
                }
                index = index + 1
            }
        }
        
        event.invitedUserIds.remove(at: selectedIndex)
        event.invitedUserIds.append([User.currentLoginUserId()! : true])
        
        Event.updateChildValues(eventId: event.id, vals: ["invitedUserIds" : event.invitedUserIds ])
        disableJoinButton()
        
    }
    
    func disableJoinButton() {
        var buttonLabel = "Joined"
        if(event.createdBy == User.currentLoginUserId()) {
            buttonLabel = "You are Hosting this event"
        }
        joinDeclineButton.setTitle(buttonLabel, for: .normal)
        joinDeclineButton.setTitleColor(UIColor.greenSea(), for: .disabled)
        joinDeclineButton.isEnabled = false
        joinDeclineButton.disabledColor = UIColor.white
        //        reloadFriends()
        
    }
    
    func reloadFriends() {
        inviteUsers()
        
    }
    
    func layoutEvent() {
        //        eventImage.image = UIImage(named: event.image!)
        eventTitle.text = event.name
        eventTime.text = event.time ?? "11:30 AM May 31 , 2017"
        eventLocation.text = event.address
        if let imgUrl = event.image {
            var imageUrl = "\(MovieDB.sharedInstance.highResolutionUrl())/\(imgUrl)"

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
        
        if let cby = event.createdBy {
            let lusr = User.currentLoginUserId()
            if( cby == lusr) {
                disableJoinButton()
            }
        }
        friendsCollectionTable.delegate = self
        statusCountsLabel.textColor = UIColor.gray
    }
    
    func inviteUsers() {
        self.users =  [(User,Int)]()
        
        var totalCount:Int = 0
        var acceptedCount:Int = 0
        
        if let evt = event , let invitedUsers = event.invitedUserIds as? [[String:Bool]] {
            self.count = 0
            for dict in invitedUsers {
                let allKeys = dict.keys
                for usr in allKeys {
                    let accepted = dict[usr]
                    var acc = 0
                    if(accepted!){
                        acc = 1
                        acceptedCount = acceptedCount + 1
                        if(usr == User.currentLoginUserId()){
                            disableJoinButton()
                        }
                    }
                    User.getUserFromFirebase(usrId: usr, completion: { (usrF, error) in
                        self.appendUsers(usrTuple: (usrF!,acc))
                        self.count += 1;
                        var constraintConstant = CGFloat((self.count * 50 ) + 7 )
                        if(constraintConstant > 150) {
                            constraintConstant = 150
                        }
                        self.friendsCollectionWidth.constant = constraintConstant
                        //                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.friendsCollectionTable.reloadData()
                        //                        }
                    })
                }
            }
        }
        if let evt = event {
            totalCount = event.invitedUserIds.count
            statusCountsLabel.text = "\(acceptedCount) of \(totalCount) friends attending"
        }
    }
    
    func appendUsers(usrTuple:(User,Int)) {
        var exists:Bool = false
        for existingUser in self.users {
            if(existingUser.0.userId == usrTuple.0.userId) {
                exists = true
            }
        }
        
        if(!exists) {
            self.users.append(usrTuple)
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
            cell.acc = connectedUser.1
            cell.profileUrl = connectedUser.0.profilePictureURLString
            
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
