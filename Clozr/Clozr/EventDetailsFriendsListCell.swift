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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        friendListCollectionView.dataSource = self
        friendListCollectionView.delegate   = self
        
        let friendListCellNib = UINib(nibName: "FriendListCell", bundle: nil)
        friendListCollectionView.register(friendListCellNib, forCellWithReuseIdentifier: "FriendListCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = friendListCollectionView.dequeueReusableCell(withReuseIdentifier: "FriendListCell", for: indexPath) as! FriendListCellCollectionViewCell
        return cell
    }

}
