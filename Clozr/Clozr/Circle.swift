//
//  Circle.swift
//  Clozr
//
//  Created by CK on 4/30/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import Foundation



public class Circle {
    public var name : String?
    public var createdBy : String?
    public var joinedUsers : String?
    public var invitedUsers : String?
    public var belongs : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let circle = Circle.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Circle Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Circle]
    {
        var models:[Circle] = []
        for item in array
        {
            models.append(Circle(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let circle = Circle(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Circle Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        name = dictionary["name"] as? String
        createdBy = dictionary["createdBy"] as? String
        joinedUsers = dictionary["joinedUsers"] as? String
        invitedUsers = dictionary["invitedUsers"] as? String
        belongs = dictionary["belongs"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.createdBy, forKey: "createdBy")
        dictionary.setValue(self.joinedUsers, forKey: "joinedUsers")
        dictionary.setValue(self.invitedUsers, forKey: "invitedUsers")
        dictionary.setValue(self.belongs, forKey: "belongs")
        
        return dictionary
    }
    
}
