//
//  FriendEventsViewController.swift
//  Clozr
//
//  Created by CK on 5/5/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit

class FriendEventsViewController: UIViewController {

    
    var friends = [User]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        friends = (FBClient.friends)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



extension FriendEventsViewController: UICollectionViewDelegate , UICollectionViewDataSource   {

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friends.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendsCell", for: indexPath) as! FriendCollectionCell
        if(!friends.isEmpty) {
            let connectedUser = friends[indexPath.row]
            cell.friend = connectedUser
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
