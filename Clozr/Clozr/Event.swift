//
//  Event.swift
//  Clozr
//
//  Created by CK on 4/30/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import Foundation


public class Event {
    public var id : String?
    public var name : String?
    public var type : String?
    public var category : String?
    public var summary : String?
    public var source : String?
    public var sourceId : Int?
    public var image : String?
    public var video : String?
    public var time : String?
    public var address : String?
    public var latitude:Double?
    public var longitude:Double?
    public var eventRawContent:[String:Any]?

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
        
        id = dictionary["id"] as? String
        name = dictionary["name"] as? String
        type = dictionary["type"] as? String
        category = dictionary["category"] as? String
        address = dictionary["address"] as? String
        source = dictionary["source"] as? String
        sourceId = dictionary["sourceId"] as? Int
        image = dictionary["image"] as? String
        video = dictionary["video"] as? String
        time = dictionary["time"] as? String
        summary = dictionary["summary"] as? String
        latitude = dictionary["latitude"] as? Double
        longitude = dictionary["longitude"] as? Double
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
        
        return dictionary
    }
    
    
    
    class func getFavEvents(mainCategory:String , subCategory:String , completionHandler:@escaping ([Event])->()){
        
        if(mainCategory == "watch"  && subCategory == "movies") {
            MovieDB.sharedInstance.withMovies(endPoint: "now_playing") { (movieEvents) in
                completionHandler(movieEvents)
            }
        }
        
        if(mainCategory == "play" || mainCategory == "catchup") {
            YelpClient.sharedInstance.yelpSearch(subCategory, subCat: subCategory, completion: { (results, error) in
                if let err = error  {
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
                if let err = error  {
                    completionHandler([])
                }
                else{
                    completionHandler(results!)
                }
                
            })
        }
    }
    
}
