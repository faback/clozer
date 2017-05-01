
//
//  Notifications.swift
//  Clozr
//
//  Created by CK on 4/30/17.
//  Copyright © 2017 Faback. All rights reserved.
//


import Foundation
 

public class Notifications {
	public var friendInterestInEvent : String?
	public var friendStartingtoSameEvent : String?
	public var turnOffNotifications : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let notifications_list = Notifications.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Notifications Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Notifications]
    {
        var models:[Notifications] = []
        for item in array
        {
            models.append(Notifications(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let notifications = Notifications(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Notifications Instance.
*/
	required public init?(dictionary: NSDictionary) {

		friendInterestInEvent = dictionary["friendInterestInEvent"] as? String
		friendStartingtoSameEvent = dictionary["friendStartingtoSameEvent"] as? String
		turnOffNotifications = dictionary["turnOffNotifications"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.friendInterestInEvent, forKey: "friendInterestInEvent")
		dictionary.setValue(self.friendStartingtoSameEvent, forKey: "friendStartingtoSameEvent")
		dictionary.setValue(self.turnOffNotifications, forKey: "turnOffNotifications")

		return dictionary
	}

}
