//
//  User.swift
//  Clozr
//
//  Created by CK on 4/30/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import Foundation


class User:NSObject {
    
    let id: String?
    let about:String?
    let birthday: String?
    let profilePictureURLString: String?
    let email: String?
    let firstName: String?
    let lastName: String?
    let name: String?
    let relationshipStatus: String?
    let location: Location?
    var friends = [User]()
    var isClozerUser:Bool = false
    private static var _current: User?
    static let defaults = UserDefaults.standard
    var userRawContent:[String:Any]?
    var firId:String?
    
    // referrence: https://developers.facebook.com/docs/graph-api/reference/user
    
    static let currentUserDataKey = "com.clozr.loggedinuser"

    class var me: User? {
        get{
            if _current == nil {
                let userData =  defaults.object(forKey: currentUserDataKey) as? Data
                if let userData = userData {
                    let dictionary = NSKeyedUnarchiver.unarchiveObject(with: userData)
                    if(dictionary != nil){
                        _current = User.init(dictionary: dictionary as! [String:Any])
                    }
                }
            }
            return _current
        }
        set(user){
            _current = user
            if let user = user {
                let data = NSKeyedArchiver.archivedData(withRootObject: user.userRawContent!)
                defaults.set(data, forKey: currentUserDataKey)
                
            }
            else {
                defaults.set(nil, forKey: currentUserDataKey)
            }
            
            defaults.synchronize()
        }
    }
    
    
    init?(dictionary: [String : Any]) {
        self.userRawContent = dictionary
        guard let name = dictionary["name"] as? String,
            let id = dictionary["id"] as? String else {
                return nil
        }
        self.name = name
        self.id = id
        self.firId = nil
        
        //if we don't have a value we assign an empty string to our object
        self.firstName = dictionary["first_name"] as? String
        self.lastName = dictionary["last_name"] as? String
        self.about = dictionary["about"] as? String ?? ""
        self.birthday = dictionary["birthday"] as? String ?? ""
        self.email = dictionary["email"] as? String
        self.relationshipStatus = dictionary["relationship_status"] as? String ?? ""
        
        //get the user's profile picture....
        if let pictureobj = dictionary["picture"] as? [String: Any] {
            let picdata = pictureobj["data"] as? [String: Any]
            let url = picdata?["url"] as? String
            self.profilePictureURLString = url
        
        }
        else {
            self.profilePictureURLString = nil
        }
        
        //get the user's location if we have the data for it
        if let locationDict = dictionary["location"] as? [String: Any] {
            self.location = Location(dict: locationDict)
        }
        else {
            self.location = nil
        }
        self.isClozerUser = true
        
    }
   
    
}


struct Coordinate {
    let latitude: Double
    let longitude: Double
}

extension Coordinate: CustomStringConvertible {
    var description: String {
        return "\(latitude),\(longitude)"
    }
}

//Everything here is an optional, we populate whatever we can
struct Location {
    let city: String?
    let country: String?
    let state: String?
    let street: String?
    let zip: String?
    let coordinate: Coordinate?
    
    init?(dict: [String : Any]) {
        
        if let latitude = dict["latitude"] as? Double, let longitude = dict["longitude"] as? Double {
            coordinate = Coordinate(latitude: latitude, longitude: longitude)
        } else {
            coordinate = nil
        }
        
        self.city = dict["city"] as? String
        self.country = dict["country"] as? String
        self.state = dict["state"] as? String
        self.street = dict["street"] as? String
        self.zip = dict["zip"] as? String
    }
}

