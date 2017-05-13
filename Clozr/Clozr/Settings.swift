//
//  Settings.swift
//  Clozr
//
//  Created by CK on 5/7/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import Foundation



public class Settings {
    public var name : String?
    public var icon : String?
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [Settings]
    {
        var models:[Settings] = []
        for item in array
        {
            models.append(Settings(dictionary: item as! [String:String])!)
        }
        return models
    }
    
    required public init?(dictionary: [String:String]) {
        
        name = dictionary["name"] as! String
        icon = dictionary["icon"] as! String
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.icon, forKey: "icon")
        
        return dictionary
    }
    
    
    class func  getSettings(forSection:String) -> [Settings]{
        var results = [Settings]()
        var loc = Settings(dictionary: ["name" : "Location" , "icon": "locationicon"])
        var se = Settings(dictionary: ["name" : "Show All My Events" , "icon": "showeventsicon"])

        results.append(loc!)
        results.append(se!)
        return results
    }
    
}
