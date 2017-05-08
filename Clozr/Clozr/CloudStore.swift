//
//  FireBaseClient.swift
//  Clozr
//
//  Created by CK on 5/2/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import Foundation
import Firebase

let base = "https://clozer-ebbea.firebaseio.com"
var database: FIRDatabase = FIRDatabase.database()

class CloudStore {
    
    static let shared = CloudStore()
    
    private var app = database.reference().child("app")
    private var users = database.reference().child("users")
    private var events = database.reference().child("events")
    private var liveEvents = database.reference().child("liveevents")
    
    //chat related
    private var message = database.reference().child("message")
    private var chatRoom = database.reference().child("chatroom")
    
    //settings
    private var settings = database.reference().child("settings")
    
    
    func createOrUpdateUser(userUid:FIRUser , user:User?) {
        if let fbuser = user  {
            user?.firId = userUid.uid
            user?.isClozerUser = true
            user?.userRawContent?["firId"] = userUid.uid
            user?.userRawContent?["isClozerUser"] = true
            users.child("/\(fbuser.id!)").setValue(user?.userRawContent)
        }
    }
    
    
    func createOrUpdateEvent(evt:Event?) {
        if evt != nil  {
            
        }
    }
    
    
    func createOrUpdateLiveEvent(evt:LiveEvent?) {
        if let event = evt  {
            
        }
    }
    
    
    
    func createOrUpdateLiveEvent(msg:Message?) {
        if let message = msg  {
            
        }
    }
    
    
}