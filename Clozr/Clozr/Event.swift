//
//  Event.swift
//  Clozr
//
//  Created by CK on 4/30/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import Foundation
import Firebase


public class Event:NSObject {
    
    static var users = database.reference().child("users")
    static var events = database.reference().child("events")

    public var id : String!
    public var name : String?
    public var type : String?
    public var category : String?
    public var summary : String?
    public var source : String = "none"
    public var sourceId : Int?
    public var image : String?
    public var video : String?
    public var time : String?
    public var address : String?
    public var latitude:Double?
    public var longitude:Double?
    public var eventRawContent:[String:Any]?
    public var distance:String?
    public var phone:String?
    public var epoch:CLong?
    public var createdBy:String?
    public var invitedUserIds:[[String:Bool]] = [[String:Bool]]()
    
    var snapshot: FIRDataSnapshot! = nil
    var key: String { return snapshot.key }
    var ref: FIRDatabaseReference { return snapshot.ref }
    var userId:String?
    
    static var liveEvent:Event?
    
    init(snapshot: FIRDataSnapshot) {
        self.snapshot = snapshot
        super.init()
        setAllValues(dictionary: snapshot.value as! [String:Any])
    }

    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.type, forKey: "type")
        dictionary.setValue(self.category, forKey: "category")
        dictionary.setValue(self.source, forKey: "source")
        dictionary.setValue(self.sourceId, forKey: "sourceId")
        dictionary.setValue(self.image, forKey: "image")
        dictionary.setValue(self.video, forKey: "video")
        dictionary.setValue(self.time, forKey: "time")
        dictionary.setValue(self.summary, forKey: "summary")
        dictionary.setValue(self.address, forKey: "address")
        dictionary.setValue(self.latitude, forKey: "latitude")
        dictionary.setValue(self.longitude, forKey: "longitude")
        dictionary.setValue(self.distance, forKey: "distance")
        dictionary.setValue(self.phone, forKey: "phone")
        dictionary.setValue(self.phone, forKey: "epoch")
        dictionary.setValue(self.invitedUserIds , forKey: "invitedUserIds")
        return dictionary
    }
    

    public class func modelsFromDictionaryArray(array:NSArray) -> [Event]
    {
        var models:[Event] = []
        for item in array
        {
            models.append(Event(dictionary: item as! [String : Any] )!)
        }
        return models
    }

    required public init?(dictionary: [String:Any]) {
        super.init()
        setAllValues(dictionary: dictionary)
    }
    
    func setAllValues(dictionary:[String:Any]) {
    
        name = dictionary["name"] as? String
        type = dictionary["type"] as? String
        category = dictionary["category"] as? String
        address = dictionary["address"] as? String
        source = (dictionary["source"] as? String)!
        sourceId = dictionary["sourceId"] as? Int
        image = dictionary["image"] as? String
        video = dictionary["video"] as? String
        time = dictionary["time"] as? String
        summary = dictionary["summary"] as? String
        latitude = dictionary["latitude"] as? Double
        longitude = dictionary["longitude"] as? Double
        distance = dictionary["distance"] as? String
        phone = dictionary["phone"] as? String
        epoch = dictionary["epoch"] as? CLong
        createdBy = dictionary["createdBy"] as? String
        if(dictionary["invitedUserIds"] != nil){
        invitedUserIds = (dictionary["invitedUserIds"] as? [[String:Bool]])!
        }
        if let eventID = (Event.getSpaceStripped(val: name!)) {
        id = eventID + source
        }
    }

    
    class func getSpaceStripped(val:String)->String? {
        let newval = val.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        return newval
    }

    func inviteUser(userId:String,accepted:Bool){
        invitedUserIds.append([userId:accepted])
    }
    
    
    class func createOrUpdateEventInFirebase(event:Event?) {
        let uniqueId = (event?.id)!
        var dictionary = (event?.dictionaryRepresentation() as! [String:Any])
        dictionary["createdBy"] = User.currentLoginUserId()
        events.child("/\(uniqueId)").setValue(dictionary)
    }
    
    
    class func getEventFromFirebase(uniqueId: String,completion: @escaping (Event?, Error?) -> Void){
        let uniqueId:String? = getSpaceStripped(val: uniqueId)
        
        if let uid = uniqueId {
            let eventRef = events.child("/\(uid)")
        eventRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let usr = Event(snapshot: snapshot)
            completion(usr,nil)
        })
        }
    }
    
    
    
    class func getEvents(mainCategory:String , subCategory:String , completionHandler:@escaping ([Event])->()){
        
        if(mainCategory == "watch"  && subCategory == "movies") {
            MovieDB.sharedInstance.withMovies(endPoint: "now_playing") { (movieEvents) in
                completionHandler(movieEvents)
            }
        }
        
        if(mainCategory == "play" || mainCategory == "catchup") {
            YelpClient.sharedInstance.yelpSearch(subCategory, subCat: subCategory, completion: { (results, error) in
                if error != nil  {
                     completionHandler([])
                }
                else{
                    completionHandler(results!)
                }
                
            })
        }
    }
    
    
    
    class func getEventsBySection(mainCategory:String , subCategory:String ,section:String ,completionHandler:@escaping ([Event])->()){
        
        if(mainCategory == "watch"  && subCategory == "movies") {
            MovieDB.sharedInstance.withMovies(endPoint: "now_playing") { (movieEvents) in
                completionHandler(movieEvents)
            }
        }
        
        if(mainCategory == "play" || mainCategory == "catchup") {
            YelpClient.sharedInstance.yelpSearch(subCategory, subCat: subCategory, completion: { (results, error) in
                if error != nil  {
                    completionHandler([])
                }
                else{
                    completionHandler(results!)
                }
                
            })
        }
    }
    
}
