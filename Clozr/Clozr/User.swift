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
var currentLoggedInUser:User?
public protocol UserInviteDelegate: class {
    func passEvent(event:Event)
}


protocol UserChangesProtocol  {
    func onAddedEvent(evt:Event)
}


class User:NSObject {
    
    static var users = database.reference().child("users")
    static var events = database.reference().child("events")
    var delegate:UserChangesProtocol?
    var id: String! = nil
    var about:String! = nil
    var birthday: String! = nil
    var profilePictureURLString: String! = nil
    var email: String! = nil
    var firstName: String! = nil
    var lastName: String! = nil
    var name: String! = nil
    var relationshipStatus: String! = nil
    var friends = ([User]())
    var isClozerUser:Bool = false
    private static var _current: User! = nil
    var firId:String! = nil
    var invitedEvents:[String]! = [String]()
    public var address : String?
    public var latitude:Double?
    public var longitude:Double?
    public var locDict:[String:Any]?
    static let defaults = UserDefaults.standard
    var previousLocations:[String] = [String]()
    var userRawContent:[String:Any]! = [String:Any]()

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
    static let currentUserDataKeyId = "com.clozr.loggedinuserid"
    
    
    
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.about, forKey: "about")
        dictionary.setValue(self.profilePictureURLString, forKey: "profilePictureURLString")
        dictionary.setValue(self.email, forKey: "email")
        dictionary.setValue(self.lastName, forKey: "lastName")
        dictionary.setValue(self.relationshipStatus, forKey: "relationshipStatus")
        dictionary.setValue(self.latitude, forKey: "latitude")
        dictionary.setValue(self.longitude, forKey: "longitude")
        dictionary.setValue(self.firId, forKey: "firId")
        dictionary.setValue(self.address, forKey: "address")
        dictionary.setValue(self.invitedEvents, forKey: "invitedEvents")
        dictionary.setValue(self.userRawContent, forKey: "userRawContent")
        dictionary.setValue(self.userId, forKey: "userId")
        dictionary.setValue(self.locDict, forKey: "locDict")
        dictionary.setValue(self.isClozerUser, forKey: "isClozerUser")
        dictionary.setValue(self.previousLocations, forKey: "previousLocations")
        return dictionary
    }
    
    
    init?(dictionary: [String : Any]) {
        
        self.userRawContent = dictionary
        if let usrid = dictionary["userId"] {
            self.userId = usrid as! String
        }
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
        

        self.locDict = dictionary["location"] as? [String: Any]
        self.isClozerUser = true
        
        
       
    }
    
    func setUserId() {
        if let mail = self.email {
            self.userId = User.getEmailStripped(mailID:mail )
        }else{
            if let fname = firstName , let lname = lastName {
                self.userId = fname + lname
                
            }
        }
        self.userRawContent["userId"] = self.userId
    }
    

    
    func getInvitedEvents()  {
        for ev in invitedEvents {
            Event.getEventFromFirebase(uniqueId: ev, completion: { (evt, error) in

                  self.delegate?.onAddedEvent(evt: evt!)
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
            users.child("/\(uniqueId)").setValue(user?.dictionaryRepresentation())
        }
    }
    
    
    class func createOrUpdateUserInFirebase(user:User?) {
        let uniqueId = getEmailStripped(mailID: (user?.email)!)
        var dictionary = user?.dictionaryRepresentation() as! [String:Any]
        dictionary["invitedEvents"] = user?.invitedEvents
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

    

    
    class func currentLoginUserId() -> String {
        return defaults.string(forKey: currentUserDataKeyId)!
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

