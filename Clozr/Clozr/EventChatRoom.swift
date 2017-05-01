//
//  EventChatRoom.swift
//  Clozr
//
//  Created by CK on 4/30/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import Foundation



public class EventChatRoom {
    public var _id : String?
    public var channel_id : String?
    public var owners : Array<String>?
    public var members : Array<String>?
    public var title : String?
    public var type : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let evtRoom = EventChatRoom(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of EventChatRoom Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [EventChatRoom]
    {
        var models:[EventChatRoom] = []
        for item in array
        {
            models.append(EventChatRoom(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let evtnChat = EventChatRoom(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: EventChatRoom Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        _id = dictionary["_id"] as? String
        channel_id = dictionary["channel_id"] as? String
        if (dictionary["owners"] != nil) { owners = dictionary["owners"] as? Array<String> }
        if (dictionary["members"] != nil) { members = dictionary["members"] as?  Array<String> }
        title = dictionary["title"] as? String
        type = dictionary["type"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.channel_id, forKey: "channel_id")
        dictionary.setValue(self.title, forKey: "title")
        dictionary.setValue(self.type, forKey: "type")
        
        return dictionary
    }
    
}
