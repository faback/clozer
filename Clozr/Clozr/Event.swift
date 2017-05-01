//
//  Event.swift
//  Clozr
//
//  Created by CK on 4/30/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import Foundation


public class Event {
    public var eventId : Int?
    public var eventName : String?
    public var eventType : String?
    public var category : String?
    public var eventIntegrationSource : String?
    public var eventIntegrationSourceId : Int?
    public var eventMainImageUrl : String?
    public var eventVideoUrl : String?
    public var eventTime : String?
    public var eventVenue : Array<EventVenue>?
    public var globalInterestCount : Int?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let evt = Event(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Event Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Event]
    {
        var models:[Event] = []
        for item in array
        {
            models.append(Event(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let evt = EventVenue.swift(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: EventVenue.swift Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        eventId = dictionary["eventId"] as? Int
        eventName = dictionary["eventName"] as? String
        eventType = dictionary["eventType"] as? String
        category = dictionary["category"] as? String
        eventIntegrationSource = dictionary["eventIntegrationSource"] as? String
        eventIntegrationSourceId = dictionary["eventIntegrationSourceId"] as? Int
        eventMainImageUrl = dictionary["eventMainImageUrl"] as? String
        eventVideoUrl = dictionary["eventVideoUrl"] as? String
        eventTime = dictionary["eventTime"] as? String
        if (dictionary["eventVenue"] != nil) { eventVenue = EventVenue.modelsFromDictionaryArray(array: dictionary["eventVenue"] as! NSArray) }
        globalInterestCount = dictionary["globalInterestCount"] as? Int
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.eventId, forKey: "eventId")
        dictionary.setValue(self.eventName, forKey: "eventName")
        dictionary.setValue(self.eventType, forKey: "eventType")
        dictionary.setValue(self.category, forKey: "category")
        dictionary.setValue(self.eventIntegrationSource, forKey: "eventIntegrationSource")
        dictionary.setValue(self.eventIntegrationSourceId, forKey: "eventIntegrationSourceId")
        dictionary.setValue(self.eventMainImageUrl, forKey: "eventMainImageUrl")
        dictionary.setValue(self.eventVideoUrl, forKey: "eventVideoUrl")
        dictionary.setValue(self.eventTime, forKey: "eventTime")
        dictionary.setValue(self.globalInterestCount, forKey: "globalInterestCount")
        
        return dictionary
    }
    
}
