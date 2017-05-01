//
//  LiveEvent.swift
//  Clozr
//
//  Created by CK on 4/30/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import Foundation


public class LiveEvent {
    public var eventRef : Event?
    public var hostedBy : String?
    public var numberOfInterestedFromFriends : Int?
    public var joiningUsers : Array<String>?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let liveEvent = LiveEvent(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of LiveEvent Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [LiveEvent]
    {
        var models:[LiveEvent] = []
        for item in array
        {
            models.append(LiveEvent(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let liveEvent = LiveEvent(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: LiveEvent Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        eventRef = dictionary["eventRef"] as? Event
        hostedBy = dictionary["hostedBy"] as? String
        numberOfInterestedFromFriends = dictionary["numberOfInterestedFromFriends"] as? Int
        if (dictionary["joiningUsers"] != nil) {
            joiningUsers = dictionary["joiningUsers"] as? Array<String>
        }
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.eventRef, forKey: "eventRef")
        dictionary.setValue(self.hostedBy, forKey: "hostedBy")
        dictionary.setValue(self.numberOfInterestedFromFriends, forKey: "numberOfInterestedFromFriends")
        
        return dictionary
    }
    
}
