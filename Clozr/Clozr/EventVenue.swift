//
//  EventVenue.swift
//  Clozr
//
//  Created by CK on 4/30/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import Foundation
 

public class EventVenue {
	public var lat : Double?
	public var lon : Double?
	public var address : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let eventVenue_list = EventVenue.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of EventVenue Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [EventVenue]
    {
        var models:[EventVenue] = []
        for item in array
        {
            models.append(EventVenue(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let eventVenue = EventVenue(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: EventVenue Instance.
*/
	required public init?(dictionary: NSDictionary) {

		lat = dictionary["lat"] as? Double
		lon = dictionary["lon"] as? Double
		address = dictionary["address"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.lat, forKey: "lat")
		dictionary.setValue(self.lon, forKey: "lon")
		dictionary.setValue(self.address, forKey: "address")

		return dictionary
	}

}
