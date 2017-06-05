//
//  Channel.swift
//  Clozr
//
//  Created by Fateh Singh on 6/4/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import Foundation
import Firebase
import AFNetworking

public class Channel:NSObject {
    
    static var channels = database.reference().child("channels")
    
    public var id : String!
    
    var snapshot: DataSnapshot! = nil

    init(snapshot: DataSnapshot) {
        self.snapshot = snapshot
        super.init()
        setAllValues(dictionary: snapshot.value as? [String:Any])
    }
    
    required public init?(dictionary: [String:Any]) {
        super.init()
        setAllValues(dictionary: dictionary)
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.id, forKey: "id")
        return dictionary
    }
    
    func setAllValues(dictionary:[String:Any]?) {
        id = dictionary?["id"] as? String
    }

    class func createOrUpdateChannelInFirebase(channel:Channel?, eventDt: String? = nil , eventTm: String? = nil) {
        let uniqueId = (channel?.id)!
        let dictionary = (channel?.dictionaryRepresentation() as! [String:Any])
        channels.child("/\(uniqueId)").setValue(dictionary)
    }
    
    
    class func getChannelFromFirebase(uniqueId: String,completion: @escaping (Channel?, Error?) -> Void){
        let channelRef = channels.child("/\(uniqueId)")
        channelRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let channel = Channel(snapshot: snapshot)
            completion(channel,nil)
        })
    }
    
    
    
}
