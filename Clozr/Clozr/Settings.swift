//
//  Settings.swift
//  Clozr
//
//  Created by CK on 4/30/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import Foundation


public class Settings {
    public var trackLocation : String?
    public var forUser : String?
    public var notifications : Array<Notifications>?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let settings = Settings.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Settings Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Settings]
    {
        var models:[Settings] = []
        for item in array
        {
            models.append(Settings(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let settings = Settings(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Settings Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        trackLocation = dictionary["trackLocation"] as? String
        forUser = dictionary["forUser"] as? String
        if (dictionary["notifications"] != nil) { notifications = Notifications.modelsFromDictionaryArray(array: dictionary["notifications"] as! NSArray) }
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.trackLocation, forKey: "trackLocation")
        dictionary.setValue(self.forUser, forKey: "forUser")
        
        return dictionary
    }
    
}
