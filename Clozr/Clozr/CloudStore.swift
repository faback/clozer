//
//  FireBaseClient.swift
//  Clozr
//
//  Created by CK on 5/2/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import Foundation
import Firebase
class CloudStore {
    
    static let shared = CloudStore()
    
    private var app = database.reference().child("app")
    private var users = database.reference().child("users")
    private var events = database.reference().child("events")
    private var liveEvents = database.reference().child("liveevents")
    
    //chat related
    private var channel = database.reference().child("channels")
    
    //settings
    private var settings = database.reference().child("settings")
    
       

    
    func createOrUpdateEvent(evt:Event?) {
        if evt != nil  {
            
        }
    }
    
    
    func createOrUpdateLiveEvent(evt:LiveEvent?) {
        if let event = evt  {
            
        }
    }
    
    
    
}
