//
//  Theater.swift
//  Clozr
//
//  Created by CK on 5/13/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import Foundation

import Firebase
import AFNetworking

public class Theater:NSObject {
    
    
    
    public var name : String?
    public var showtimes : [String]?
    public var location:String?
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.location, forKey: "location")
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.showtimes, forKey: "showtimes")

        return dictionary
    }
    

    
    required public init?(dictionary: [String:Any]) {
        super.init()
        setAllValues(dictionary: dictionary)
    }
    
    func setAllValues(dictionary:[String:Any]) {
        
        name = dictionary["name"] as? String
        location = dictionary["location"] as? String
        showtimes = dictionary["showtimes"] as? [String]
    }
    
}
