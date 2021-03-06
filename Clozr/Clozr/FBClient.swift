//
//  FBClient.swift
//  Clozr
//
//  Created by CK on 5/7/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import Foundation

import FBSDKLoginKit
import FirebaseAuth

class FBClient {
    static var currentFacebookUser:ClozrUser!
    static var friends:[ClozrUser]!
    
    class func getUsersFriends(completionHandler:((Any?, Error?) -> ())? = nil) {
        if(friends == nil) {
            let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me/taggable_friends?limit=100", parameters:["fields":"id,name,picture.width(500).height(500)"])
            graphRequest.start(completionHandler: { (connection, result, error) -> Void in
                if error != nil {
                    print("Error in getting friends list \(error.debugDescription)")
                }
                else {
                    if let data:[String:AnyObject] = result as? [String : AnyObject] {
                        self.getFriendsList(data)
                    }
                    else {
                        print("Error in getting friends list - no data")
                    }
                }
                completionHandler?(result,error)
        })
        }
    }
    
    class func getFriendsList(_ data:[String : AnyObject]) {
        var friendsArray : [ClozrUser] = []
        var friendsUserIds :[String] = []
        //try to parse friends
        if let data = data["data"] as? [[String: AnyObject]] {
            for userData:[String: AnyObject] in data {
                if let friend = ClozrUser(dictionary: userData) {
                    friend.setUserId()
                    friendsArray.append(friend)
                    friendsUserIds.append(friend.id!)
                    ClozrUser.tryAndCreate(user: friend)
                }
            }
            currentFacebookUser.friends = friendsArray
            friends = friendsArray
            currentFacebookUser.userRawContent?["friends"] = friendsUserIds

            print("Friends count \(friendsArray.count)")
//            LoadingOverlay.shared.hideOverlayView()
           
        }
    }
    
    
    
    
    
}
