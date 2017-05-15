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
    func onAddedEvent(evt:Event?,show:Bool)
    func reloadTable(show:Bool)
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
    var oneSignalId: String! = nil
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
    static var current:User?
    
    init(snapshot: FIRDataSnapshot) {
        
        self.snapshot = snapshot
        
        super.init()
        
       setAllValues(dictionaryArg: (snapshot.value as? [String:Any]))
    }
    
    static let currentUserDataKey = "com.clozr.loggedinuser"
    static let currentUserDataKeyId = "com.clozr.loggedinuserid"
    
    
    
    func setAllValues(dictionaryArg:[String:Any]?) {
        if let dictionary = dictionaryArg {
            name = dictionary["name"] as? String
            id = dictionary["id"] as? String
            about = dictionary["about"] as? String
            address = dictionary["address"] as? String
            profilePictureURLString = (dictionary["profilePictureURLString"] as? String)!
            email = dictionary["email"] as? String
            lastName = dictionary["lastName"] as? String
            relationshipStatus = dictionary["relationshipStatus"] as? String
            latitude = dictionary["latitude"] as? Double
            longitude = dictionary["longitude"] as? Double
            firId = dictionary["firId"] as? String
            userRawContent = dictionary["userRawContent"] as? [String:Any]
            if let pl = dictionary["previousLocations"] as? [String] {
                previousLocations = pl
            }
            userId = dictionary["userId"] as? String
            locDict = dictionary["locDict"] as? [String:Any]
            isClozerUser = (dictionary["isClozerUser"] as? Bool)!
            if let ie =  dictionary["invitedEvents"] as? [String]{
                invitedEvents = ie
            }
            oneSignalId = dictionary["oneSignalId"] as? String
        }
    }
    
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
        dictionary.setValue(self.oneSignalId, forKey: "oneSignalId")
        dictionary.setValue(self.locDict, forKey: "locDict")
        dictionary.setValue(self.isClozerUser, forKey: "isClozerUser")
        dictionary.setValue(self.previousLocations, forKey: "previousLocations")
        return dictionary
    }
    
    
    init?(dictionary: [String : Any] ) {
        
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
        self.oneSignalId = dictionary["oneSignalId"] as? String

        self.locDict = dictionary["location"] as? [String: Any]
    }
    
    func setUserId() {
        if let mail = self.email {
            self.userId = User.getEmailStripped(mailID:mail )
        }else{
            if let fname = firstName , let lname = lastName {
                self.userId = fname + lname
                
            }
            else {
                if let nm = self.name {
                   self.userId = nm.replacingOccurrences(of: " ", with: "")
                }
                else {
                    print("there shouldnt be usr")
                }
            
            }
        }
        self.userRawContent["userId"] = self.userId
    }
    
    
    
    func getInvitedEvents()  {
        let count = invitedEvents.count
        var checker:Int = 0
        if(invitedEvents.count > 0 ){
            for ev in invitedEvents {
                Event.getEventFromFirebase(uniqueId: ev, completion: { (evt, error) in

                      self.delegate?.onAddedEvent(evt: evt!, show: true)
                      checker = checker + 1
                })
            }
        }else{
            self.delegate?.onAddedEvent(evt: nil,show: true)
        }
//        let when = DispatchTime.now() + 4 // change 2 to desired number of seconds
//        DispatchQueue.main.asyncAfter(deadline: when) {
//            self.delegate?.reloadTable(show:true)
//        }
        
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
            fbuser.setUserId()
            if let usrId = fbuser.userId {
                var dictionary = fbuser.dictionaryRepresentation() as! [String:Any]

                if( fbuser.invitedEvents != nil &&  (fbuser.invitedEvents.count) > 0 ) {
                    dictionary["invitedEvents"] = fbuser.invitedEvents
                }
                users.child("/\(usrId)").setValue(dictionary)
                
            }
        }
    }
    
    
    class func createOrUpdateUserInFirebase(user:User?) {
        user?.setUserId()
        var dictionary = user?.dictionaryRepresentation() as! [String:Any]
        if( user?.invitedEvents != nil &&  (user?.invitedEvents.count)! > 0 ) {
            dictionary["invitedEvents"] = user?.invitedEvents
        }
        if let usrId  = user?.userId {
            users.child("/\(usrId)").setValue(dictionary)
        }
        
        if(user?.userId == User.currentLoginUserId())  {
            User.current = current
        }
    }
    
    
    class func updateChildValues(userId:String , vals:[String:Any]) {
        let usrRef = users.child("/\(userId)")
        usrRef.updateChildValues(vals)
    }
    
    class func tryAndCreate(user:User?) {
        var dictionary = user?.dictionaryRepresentation() as! [String:Any]
        user?.setUserId()
        
        if let usrId  = user?.userId {
            getUserFromFirebase(usrId: usrId) { (usr, error) in

                if(error != nil) {
                    dictionary["invitedEvents"] = user?.invitedEvents
                    dictionary["isClozerUser"] = false
                }else{
                    if(usr?.isClozerUser)! {
                        if( user?.invitedEvents != nil &&  (user?.invitedEvents.count)! > 0 ) {
                            dictionary["invitedEvents"] = user?.invitedEvents
                        }
                        users.child("/\(usrId)").setValue(dictionary)
                    }
                }
                 users.child("/\(usrId)").setValue(dictionary)
            }
        }
  
    }
    
    
    class func getEmailStripped(mailID:String)->String {
        var newmail = mailID.replacingOccurrences(of: "@", with: "", options: .literal, range: nil)
        newmail =  newmail.replacingOccurrences(of: ".", with: "", options: .literal, range: nil)
        return newmail
        
    }
    
    

    class func getUserFromFirebase(usrId: String,completion: @escaping (User?, Error?) -> Void){
        let usrRef = users.child("/\(usrId)")
        
        usrRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let usr = User(snapshot: snapshot)
            completion(usr,nil)
            usrRef.removeAllObservers()
        })
    }

    
    class func getAllUserFromFirebase(completion: @escaping ([User]?, Error?) -> Void){
        
        var usrArray = [User]()
        let usrRef = users

        usrRef.queryOrderedByKey().observe(.value, with: { (snapshot) in
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    let u = User(snapshot: snap)
                    usrArray.append(u)
                }
            }
           
        })
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when) {
            completion(usrArray, nil)
        }
        
        
    }

    
    class func currentLoginUserId() -> String? {
        if let defaultStored = defaults.string(forKey: currentUserDataKeyId) {
            return defaultStored
        }
        return nil
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

