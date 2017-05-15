//
//  Event.swift
//  Clozr
//
//  Created by CK on 4/30/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import Foundation
import Firebase
import AFNetworking

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
    public var selectedTheater:String?
    public var theaters:[Theater]?
    
    var snapshot: FIRDataSnapshot! = nil
    var key: String { return snapshot.key }
    var ref: FIRDatabaseReference { return snapshot.ref }
    var userId:String?
    
    static var liveEvent:Event?
    
    init(snapshot: FIRDataSnapshot?) {
        self.snapshot = snapshot
        super.init()
        if let s = snapshot , let _ = snapshot?.value {
            setAllValues(dictionaryArg: (s.value as? [String:Any]))
        }
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
        dictionary.setValue(self.selectedTheater, forKey: "selectedTheater")
        
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
        setAllValues(dictionaryArg: dictionary)
    }
    
    func setAllValues(dictionaryArg:[String:Any]?) {
        if let dictionary = dictionaryArg {
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
            selectedTheater = dictionary["selectedTheater"] as? String
            theaters = [Theater]()
            if let iu = dictionary["invitedUserIds"] as? [[String:Bool]] {
                invitedUserIds = iu
            }
            if let eventID = (Event.getSpaceStripped(val: name!)) {
            id = eventID + source
            }
        }
    }

    
    class func getSpaceStripped(val:String)->String? {
        let newval = val.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        return newval
    }

    func inviteUser(userId:String,accepted:Bool){
        var exists:Bool = false
        for alreadyinvited in invitedUserIds  {
            let uids = alreadyinvited.keys
            for k in uids {
                if(k == userId) {
                    exists = true
                }
            }
        }
    
        if(!exists) {
            invitedUserIds.append([userId:accepted])
        }
    }
    
    
    class func createOrUpdateEventInFirebase(event:Event?, eventDt: String? = nil , eventTm: String? = nil) {
        let uniqueId = (event?.id)!
        var dictionary = (event?.dictionaryRepresentation() as! [String:Any])
        dictionary["createdBy"] = User.currentLoginUserId()
        if let date = eventDt{
            dictionary["eventDate"] = date
        }
        //print(eventDt)
        //print(eventTm)
        if let time = eventTm {
            dictionary["eventTime"] = time
        }
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
        if(mainCategory == "watch"  && subCategory == "tvshows") {

            MovieDB.sharedInstance.withTVShows(endPoint: "on_the_air") { (movieEvents) in
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
//            getInternationalMovieTimes()
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
    
    
    class func getShowTimes() {
        var location = "37.785771,-122.406165"
        if let usr = User.current  {
            if let lat = usr.latitude , let lon = usr.longitude {
                location = "\(lat),\(lon)"
            }
        }

        let showtimesUrl = "https://api.cinepass.de/v4/showtimes?countries=US&location=\(location)&radius=3"
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer.init()
        manager.requestSerializer.setValue("UVFfr7DSh85JN3I207j9kAEw8CHa5cBc", forHTTPHeaderField: "X-API-Key")
        
       manager.get(showtimesUrl, parameters: nil, success: { (task, response) in
        
            print(response)
            if let response = response as? [String: Any]{
                let dictionaries = response["showtimes"] as? [NSDictionary]
                print("CKKKKKKKKKK  -> Showtimes : \(dictionaries)")

            }
        
       }) { (task, error) in
        
        
        }
    }
    
    
    class func getMovies(completionHandler:@escaping ([Event])->()) {
        var location = "37.785771,-122.406165"
        if let usr = User.current  {
            if let lat = usr.latitude , let lon = usr.longitude {
                location = "\(lat),\(lon)"
            }
        }
        //cinemas
        let showtimesUrl = "https://api.cinepass.de/v4/movies?countries=US&location=\(location)&radius=3"
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer.init()
        manager.requestSerializer.setValue("UVFfr7DSh85JN3I207j9kAEw8CHa5cBc", forHTTPHeaderField: "X-API-Key")
        
        manager.get(showtimesUrl, parameters: nil, success: { (task, response) in
            
//            print(response)
            if let responseDict = response as? [String: Any]{
                let movies = responseDict["movies"] as! [[String:Any]]
                var eventArray = [Event]()
                for m in movies {
                    var eventDict = [String:Any]()
                    let title = m["title"] as? String
                    eventDict["name"] = title
                    eventDict["category"] = "movies"
                    eventDict["source"] = "ishowtimes"
//                    eventDict["summary"] = m["overview"] as! String
                    eventDict["image"] = m["poster_image_thumbnail"] as? String
                    print(eventDict)
                    if let titlePresence = title {
                        eventArray.append(Event(dictionary: eventDict)!)
                    }
                    
                }
                completionHandler(eventArray)
            }
            
        }) { (task, error) in
            
            print(error.localizedDescription)
            
        }
    }
    
   
    
//    class func getMoviesForCinema(cinemaId:String,completionHandler:@escaping ([String:Any])->())  {
//        var location = "37.785771,-122.406165"
//        if let usr = User.current  {
//            if let lat = usr.latitude , let lon = usr.longitude {
//                location = "\(lat),\(lon)"
//            }
//        }
//        let showtimesUrl = "https://api.cinepass.de/movies?cinema_id=\(cinemaId)"
//        let manager = AFHTTPSessionManager()
//        manager.requestSerializer = AFJSONRequestSerializer.init()
//        manager.requestSerializer.setValue("UVFfr7DSh85JN3I207j9kAEw8CHa5cBc", forHTTPHeaderField: "X-API-Key")
//        
//        manager.get(showtimesUrl, parameters: nil, success: { (task, response) in
//            
//              if let response = response as? [String: Any]{
//                completionHandler(response)
//            }
//            
//        }) { (task, error) in
//            
//            print(error.localizedDescription)
//            
//        }
//    }
//    
//    
//    class func getCinemaDetails(cinemaID:String,completionHandler:@escaping ([String:Any])->())  {
//        let cinemaUrl = "https://api.cinepass.de/v4/cinemas/\(cinemaID)"
//        let manager = AFHTTPSessionManager()
//        manager.requestSerializer = AFJSONRequestSerializer.init()
//        manager.requestSerializer.setValue("UVFfr7DSh85JN3I207j9kAEw8CHa5cBc", forHTTPHeaderField: "X-API-Key")
//        
//        manager.get(cinemaUrl, parameters: nil, success: { (task, response) in
//            
//            if let response = response as? [String: Any]{
//                completionHandler(response)
//            }
//            
//        }) { (task, error) in
//            
//            print(error.localizedDescription)
//            
//        }
//    }
//    
//    
}

protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}

extension Dictionary : URLQueryParameterStringConvertible {
    /**
     This computed property returns a query parameters string from the given NSDictionary. For
     example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
     string will be @"day=Tuesday&month=January".
     @return The computed parameters string.
     */
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                              String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                              String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
    
}

extension URL {
    /**
     Creates a new URL by adding the given query parameters.
     @param parametersDictionary The query parameter dictionary to add.
     @return A new URL.
     */
    func appendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {
        let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
}

