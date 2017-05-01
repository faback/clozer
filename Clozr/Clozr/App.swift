//
//  App.swift
//  Clozr
//
//  Created by CK on 4/30/17.
//  Copyright © 2017 Faback. All rights reserved.
//


import Foundation
 


public class App {
	public var id : String?
	public var app : String?
	public var theme : String?
	public var version : Double?
	public var bundle : String?
	public var integrations : Array<Integration>?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let app = App.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of App Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [App]
    {
        var models:[App] = []
        for item in array
        {
            models.append(App(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let app = App(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: App Instance.
*/
	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? String
		app = dictionary["app"] as? String
		theme = dictionary["theme"] as? String
		version = dictionary["version"] as? Double
		bundle = dictionary["bundle"] as? String
		if (dictionary["integrations"] != nil) { integrations = dictionary["integrations"] as? Array<Integration> }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.app, forKey: "app")
		dictionary.setValue(self.theme, forKey: "theme")
		dictionary.setValue(self.version, forKey: "version")
		dictionary.setValue(self.bundle, forKey: "bundle")

		return dictionary
	}

}
