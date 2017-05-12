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
        event.invitedUserIds.append([User.currentLoginUserId() : true])
        
        Event.createOrUpdateEventInFirebase(event: event)
        disableJoinButton()
        
    }
    
    func disableJoinButton() {
        joinDeclineButton.setTitle("Joined", for: .normal)
        joinDeclineButton.setTitleColor(UIColor.greenSea(), for: .disabled)
        joinDeclineButton.isEnabled = false
        joinDeclineButton.disabledColor = UIColor.white

    }
  
    func layoutEvent() {
        //        eventImage.image = UIImage(named: event.image!)
        eventTitle.text = event.name
        eventTime.text = event.time ?? "11:30 AM May 31 , 2017"
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
        print("count of users \(event.invitedUserIds.count)")
        var processedUsers = [String]()
        if let invitedUsers = event.invitedUserIds as? [[String:Bool]] {
            self.count = 0
            for dict in invitedUsers {
                let allKeys = dict.keys
                for usr in allKeys {
                    let accepted = dict[usr]
                    var acc = 0
                    if(accepted!){
                        acc = 1
                    }
                        User.getUserFromFirebase(usrId: usr, completion: { (usrF, error) in
                            
                            self.users.append((usrF! , acc))
                                self.count += 1;
                                self.friendsCollectionWidth.constant = CGFloat((self.count * 50 ) + 7 )
                        })
                }
          }
        }
        let when = DispatchTime.now() + 4 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.friendsCollectionTable.reloadData()
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

