//
//  File.swift
//  Clozr
//
//  Created by CK on 4/30/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import Foundation



public class Message {
    public var _id : String?
    public var author : String?
    public var channel_id : String?
    public var created_at : String?
    public var markdown : String?
    public var type : String?

    public class func modelsFromDictionaryArray(array:NSArray) -> [Message]
    {
        var models:[Message] = []
        for item in array
        {
            models.append(Message(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Message Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        _id = dictionary["_id"] as? String
        author = dictionary["author"] as? String
        channel_id = dictionary["channel_id"] as? String
        created_at = dictionary["created_at"] as? String
        markdown = dictionary["markdown"] as? String
        type = dictionary["type"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self._id, forKey: "_id")
        dictionary.setValue(self.author, forKey: "author")
        dictionary.setValue(self.channel_id, forKey: "channel_id")
        dictionary.setValue(self.created_at, forKey: "created_at")
        dictionary.setValue(self.markdown, forKey: "markdown")
        dictionary.setValue(self.type, forKey: "type")
        
        return dictionary
    }
    
}
