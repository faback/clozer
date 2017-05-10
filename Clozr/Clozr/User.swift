//
//  User.swift
//  Clozr
//
//  Created by CK on 4/30/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import Foundation
import Firebase

let base = "https://clozer-ebbea.firebaseio.com"
var database: FIRDatabase = FIRDatabase.database()

public protocol UserInviteDelegate: class {
    func passEvent(event:Event)
}


class User:NSObject {
    
    static var users = database.reference().child("users")
    static var events = database.reference().child("events")
    
    var id: String! = nil
    var about:String! = nil
    var birthday: String! = nil
    var profilePictureURLString: String! = nil
    var email: String! = nil
    var firstName: String! = nil
    var lastName: String! = nil
    var name: String! = nil
    var relationshipStatus: String! = nil
    var location: Location! = nil
    var friends = ([User]())
    var isClozerUser:Bool = false
    private static var _current: User! = nil
    static let defaults = UserDefaults.standard
    var userRawContent:[String:Any]! = [String:Any]()
    var firId:String! = nil
    var invitedEvents:[String]! = [String]()
    
    // referrence: https://developers.facebook.com/docs/graph-api/reference/user
    
    var snapshot: FIRDataSnapshot! = nil
    var key: String { return snapshot.key }
    var ref: FIRDatabaseReference { return snapshot.ref }
    var userId:String?
    
    var myCurrentEventInvites = [Event]()
    
    init(snapshot: FIRDataSnapshot) {
        
        self.snapshot = snapshot
        
        super.init()
        
        for child in snapshot.children.allObjects as? [FIRDataSnapshot] ?? [] {
            if responds(to: Selector(child.key)) {
                setValue(child.value, forKey: child.key)
            }
        }
    }
    
    static let currentUserDataKey = "com.clozr.loggedinuser"
    
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
        let mailId = dictionary["email"] as? String
        self.email = mailId
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
        if let mailNotNil = mailId {
            self.userId = User.getEmailStripped(mailID:mailNotNil )
        }else{
            if let fname = firstName , let lname = lastName {
                self.userId = fname + lname
            }
        }
        
//        subScribeToInviteUsers(forOperation: "subscribe.to.invites")
    }
    
    func subScribeToInviteUsers(forOperation:String){
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: forOperation), object: nil, queue: OperationQueue.main) { (Notification) in
            if let userInfo  = Notification.userInfo {
                let evt = userInfo["invitedEvent"] as! Event
                self.myCurrentEventInvites.append(evt)
            }
        }
    }
    
    func getInvitedEvents()  {
        for ev in invitedEvents {
            Event.getEventFromFirebase(uniqueId: ev, completion: { (evt, error) in
                if(error != nil) {
                    let nc = NotificationCenter.default
                    nc.post(name:NSNotification.Name(rawValue: "subscribe.to.invites"),
                            object: nil,
                            userInfo:["invitedEvent":evt!])
                }
            })
        }
    }
    
    
    func addEvent(evt:String) {
        invitedEvents.append(evt)
    }
    
    class func createMe(userUid:FIRUser? , user:User?) {
        if let fbuser = user  {
            if let firebaseDetails = userUid {
                fbuser.firId = firebaseDetails.uid
                fbuser.isClozerUser = true
                fbuser.userRawContent?["firId"] = firebaseDetails.uid
                fbuser.userRawContent?["isClozerUser"] = true
            }
            let uniqueId = getEmailStripped(mailID: (user?.email)!)
            users.child("/\(uniqueId)").setValue(user?.userRawContent)
        }
    }
    
    
    class func createOrUpdateUserInFirebase(user:User?) {
        let uniqueId = getEmailStripped(mailID: (user?.email)!)
        var dictionary = user?.userRawContent
        dictionary?["invitedEvents"] = user?.invitedEvents
        users.child("/\(uniqueId)").setValue(dictionary)
    }
    
    
    class func getUserFromFirebase(mail: String,completion: @escaping (User?, Error?) -> Void){
        let uniqueId = getEmailStripped(mailID: mail)
        let usrRef = users.child("/\(uniqueId)")
        
        usrRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let usr = User(snapshot: snapshot)
            completion(usr,nil)
        })
    }
    
    
    class func getEmailStripped(mailID:String)->String {
        var newmail = mailID.replacingOccurrences(of: "@", with: "", options: .literal, range: nil)
        newmail =  newmail.replacingOccurrences(of: ".", with: "", options: .literal, range: nil)
        return newmail
        
    }

    
    
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

