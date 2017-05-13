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
    var clozrFriends = [User]()
    var nonClozrFriends = [User]()
    var sections = ["Clozr Friends", "Invite Your Friends"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
//        let flowLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        flowLayout.minimumLineSpacing = 10
//        flowLayout.minimumLineSpacing = 10
//        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        flowLayout.itemSize = CGSize(width: 145, height: 90)
//        flowLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
//        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
//        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
//        

        
        collectionView.register(FriendsSectionView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "sectionHeader")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        if let collectionViewFlowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewFlowLayout.minimumInteritemSpacing = 3
        }
        
        var once:Int = 0
        User.getAllUserFromFirebase { (allFriends, error) in
            if(once == 0) {
            self.friends = allFriends!
            self.clozrFriends = [User]()
            self.nonClozrFriends = [User]()
            for usr in allFriends! {
                if(usr.isClozerUser) {
                    self.clozrFriends.append(usr)
                }else{
                    self.nonClozrFriends.append(usr)
                }
            }
            once = 1
            self.collectionView.reloadData()
            }

        }
        
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
        if(section == 0) {
            return clozrFriends.count
        }else {
            return nonClozrFriends.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendsCell", for: indexPath) as! FriendCollectionCell
        
        if(indexPath.section == 0) {
            if(!clozrFriends.isEmpty) {
                let connectedUser = clozrFriends[indexPath.row]
                cell.friend = connectedUser
                cell.eventCount.text = "\(connectedUser.invitedEvents.count) Events"
            }
        }else{
            if(!nonClozrFriends.isEmpty) {
                let connectedUser = nonClozrFriends[indexPath.row]
                cell.friend = connectedUser
                cell.eventCount.text = ""
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeaderView: FriendsSectionView = self.collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as! FriendsSectionView
        if(indexPath.section == 0 ) {
            sectionHeaderView.titleLabel?.text = "Friends on Clozer"
        }else{
            sectionHeaderView.titleLabel?.text = "Invite Your Friends"
        }
        
        return sectionHeaderView
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
