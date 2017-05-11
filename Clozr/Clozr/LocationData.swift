//
//  LocationData.swift
//  Clozr
//
//  Created by CK on 5/10/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import Foundation

/*******************************************************************************************************************
 |   File: LocationData.swift
 |   Proyect: swiftLocations cordova plugin
 |
 |   Description: - LocationData class. Object representation of the location records stored in NSUserDefault,
 |   conforms to the NSCoding protocol.
 *******************************************************************************************************************/

import Foundation
import CoreData

@objc class LocationData : NSObject, NSCoding {
    
    // =====================================     INSTANCE VARIABLES / PROPERTIES      ============================//
    var latitude : NSNumber!
    var longitude: NSNumber!
    var timestamp: NSDate!
    
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.latitude, forKey: "latitude")
        aCoder.encode(self.longitude, forKey:"longitude")
        aCoder.encode(self.timestamp, forKey:"timestamp")
    }


    // =====================================     NSCoding PROTOCOL METHODS            ============================//
    required convenience init?(coder aDecoder: NSCoder) {
        
        self.init()
        
        self.latitude  = aDecoder.decodeObject(forKey: "latitude") as! NSNumber?
        self.longitude = aDecoder.decodeObject(forKey: "longitude") as! NSNumber?
        self.timestamp = aDecoder.decodeObject(forKey: "timestamp") as! NSDate?
    }
    
 
}
