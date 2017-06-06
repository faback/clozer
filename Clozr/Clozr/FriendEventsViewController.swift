//
//  FriendEventsViewController.swift
//  Clozr
//
//  Created by CK on 5/5/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit
//import MBProgressHUD
import NVActivityIndicatorView
class FriendEventsViewController: UIViewController {

    
    var friends = [ClozrUser]()
    var clozrFriends = [ClozrUser]()
    var nonClozrFriends = [ClozrUser]()
    var sections = ["Clozr Friends", "Invite Your Friends"]
    var loadingView:Bool = false
    var activityIndicatorView: NVActivityIndicatorView = Styles.activityIndicatorBig()

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        collectionView.register(FriendsSectionView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "sectionHeader")
        collectionView.delegate = self
        collectionView.dataSource = self
        if let collectionViewFlowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewFlowLayout.minimumInteritemSpacing = 3
        }
        
//        MBProgressHUD.showAdded(to: self.view, animated: true)
        setupActivityIndicator()
        loadingView = true
        activityIndicatorView.startAnimating()
        var once:Int = 0
        ClozrUser.getAllUserFromFirebase { (allFriends, error) in
            if(once == 0) {
                self.friends = allFriends!
                self.clozrFriends = [ClozrUser]()
                self.nonClozrFriends = [ClozrUser]()
                for usr in allFriends! {
                    if(usr.isClozerUser) {
                        if(!self.valContains(existing: usr, inArry: self.clozrFriends)){
                        
                            self.clozrFriends.append(usr)
                        }
                    }else{
                        if(!self.valContains(existing: usr, inArry: self.nonClozrFriends)){
                                self.nonClozrFriends.append(usr)
                        }
                    }
                }
                once = 1

                self.collectionView.reloadData()
                self.activityIndicatorView.stopAnimating()

            }
        }
        // Do any additional setup after loading the view.
    }
    
    func valContains(existing:ClozrUser ,inArry:[ClozrUser])->Bool {
        existing.setUserId()
        for usr in inArry {
            usr.setUserId()
            
            if usr.userId == existing.userId {
                return true
            }
        }
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setupActivityIndicator(){
        activityIndicatorView.center = CGPoint(x: self.view.bounds.size.width/2 , y: self.view.bounds.size.height/2 - 60)
        self.view.addSubview(activityIndicatorView)

    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let indexPath = sender as! IndexPath
        let vc = segue.destination as! EventsListViewController
        vc.currentUser = clozrFriends[indexPath.row]
    }
 

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
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.section == 0 ) {
            self.performSegue(withIdentifier: Clozer.Segues.friendsToLive, sender: indexPath)
        }
    }
//
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as! SubCategoryCell
//        cell.unTintImage()
//    }
//    
    
    
}
