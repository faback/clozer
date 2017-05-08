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

//MARK: - Localizable Strings for our ViewController
 struct Strings {
    static let btnOK = NSLocalizedString("OK",comment: "OK button title")
    
    static let errorGraphRequestTitle = NSLocalizedString("Something went wrong", comment: "This is the alert title shown to the user if an error happens during a request to get data from Facebook")
    static let errorGraphRequestMessage = NSLocalizedString("An Error occured trying to get data from Facebook\nError:%@\n\nHit ok to try again", comment: "This is the alert message shown to the user if an error happens during a request to get data from Facebook")
    
    static let errorAbortTitle = NSLocalizedString("Houston we have a problem", comment: "This is the alert title shown to the user if we are unable to get the Facebook data of the user or his friends")
    static let errorAbortMessage = NSLocalizedString("It seems that we can't get the data from Facebook right now.\nPlease try logging in again through Facebook and make sure you are connected to the interent!", comment: "This is the alert message shown to the user if we are unable to get the Facebook data of the user or his friends")
    static let errorUserDataMissingMessage = NSLocalizedString("It seems that some of your user Data is missing from Facebook\nPlease try logging in again through Facebook\nIf this error persists, please let us know!", comment: "This is the alert message shown to the user if we are unable to get the users basic information from Facebook")
}

