//
//  EventDetailsView.swift
//  Clozr
//
//  Created by Fateh Singh on 4/30/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit
import MapKit

class EventDetailsView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, MKMapViewDelegate {

    @IBOutlet weak var friendListCollectionView: UICollectionView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var smallMapView: MKMapView!
    @IBOutlet weak var smallChatView: UIView!
    @IBOutlet weak var smallMessagesView: UIView!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
        
    }
    
    func initSubView() {
        let nib = UINib(nibName: "EventDetails", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame =  bounds
        addSubview(contentView)
        
        friendListCollectionView.dataSource = self
        friendListCollectionView.delegate   = self
        
        let friendListCellNib = UINib(nibName: "FriendListCell", bundle: nil)
        friendListCollectionView.register(friendListCellNib, forCellWithReuseIdentifier: "FriendListCell")
        
        smallMapView.delegate = self
        
        // Set the location of the event here.
        let mapCenter = CLLocationCoordinate2D(latitude: 37.3549144, longitude: -122.0035661)
        let mapSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: mapCenter, span: mapSpan)
        // Set animated property to true to animate the transition to the region
        smallMapView.setRegion(region, animated: false)
        print(smallChatView.frame.size)
        
        
        print("         XIB HEIGHT IS \(contentView.frame)")

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = friendListCollectionView.dequeueReusableCell(withReuseIdentifier: "FriendListCell", for: indexPath) as! FriendListCellCollectionViewCell
        return cell
    }

}
