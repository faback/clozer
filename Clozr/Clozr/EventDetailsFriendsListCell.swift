//
//  EventDetailsFriendsListCell.swift
//  Clozr
//
//  Created by Fateh Singh on 5/6/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit

class EventDetailsFriendsListCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var friendListCollectionView: UICollectionView!
    
    weak var event: Event! {
        didSet {
            friendListCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        friendListCollectionView.dataSource = self
        friendListCollectionView.delegate   = self
        
        let friendListCellNib = UINib(nibName: "FriendListCell", bundle: nil)
        friendListCollectionView.register(friendListCellNib, forCellWithReuseIdentifier: "FriendListCell")
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if event == nil {
            return 0;
        } else {
            return event.invitedUserIds.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = friendListCollectionView.dequeueReusableCell(withReuseIdentifier: "FriendListCell", for: indexPath) as! FriendListCellCollectionViewCell
        if let invitedUsers = event.invitedUserIds as? [[String:Bool]] {
            for (index, dict) in invitedUsers.enumerated() {
                if index == indexPath.row {
                    let allKeys = dict.keys
                    for usr in allKeys {
                        let accepted = dict[usr]
                        cell.accepted = accepted ?? false
                        cell.user = usr
                    }
                }
            }
        }
        
        return cell
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }

}
