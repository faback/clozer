
//
//  Integrations.swift
//  Clozr
//
//  Created by CK on 4/30/17.
//  Copyright © 2017 Faback. All rights reserved.
//


import Foundation
 

public class Integration {
	public var name : String?
	public var auth : String?
	public var clientkey : String?
	public var clientsecret : String?
	public var servingcategory : String?
	public var expiryDate : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let integration = Integration.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Integration Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Integration]
    {
        var models:[Integration] = []
        for item in array
        {
            models.append(Integration(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let integrations = Integrations(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Integrations Instance.
*/
	required public init?(dictionary: NSDictionary) {

		name = dictionary["name"] as? String
		auth = dictionary["auth"] as? String
		clientkey = dictionary["clientkey"] as? String
		clientsecret = dictionary["clientsecret"] as? String
		servingcategory = dictionary["servingcategory"] as? String
		expiryDate = dictionary["expiryDate"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.name, forKey: "name")
		dictionary.setValue(self.auth, forKey: "auth")
		dictionary.setValue(self.clientkey, forKey: "clientkey")
		dictionary.setValue(self.clientsecret, forKey: "clientsecret")
		dictionary.setValue(self.servingcategory, forKey: "servingcategory")
		dictionary.setValue(self.expiryDate, forKey: "expiryDate")

		return dictionary
	}

}
