//
//  Clozer.swift
//  Clozr
//
//  Created by CK on 5/7/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import Foundation
import OneSignal

class Clozer {
   static var deviceToken:String?

    struct Preferences {
        static let trackLocation = "com.clozr.tracklocation"
        static let showEvents = "com.clozr.showEvents"
        static let lastLatitude = "com.clozr.lastlatitude"
        static let lastLongitude = "com.clozr.lastlongitude"
    }
    
    struct Nav {
        
        static let eventDetailNav = "eventDetailNav"
        static let homeNav = "homeNav"
        static let liveEventNav = "liveEventNav"
        static let friendsNav = "friendsNav"
        static let settingsNav = "settingsNav"
        
    }
    
    struct Vc {
        
        
        
    }
    
    
    struct Segues {
        
        static let movieDetail = "movieDetail"
        static let moreBusinesses = "moreBusinesses"
        static let createEventSegue = "createEventSegue"
        static let toDetail = "toDetail"
        static let friendsToLive = "friendsToLive"
    }
    
    class func savePreference(name:String, val:Bool){
        let defaults = UserDefaults.standard
        defaults.set(val, forKey: name)
    }
    
    class func savePreferenceDouble(name:String, val:Double){
        let defaults = UserDefaults.standard
        defaults.set(val, forKey: name)
    }
    
    class func initPreferences() {
        savePreference(name: Clozer.Preferences.trackLocation, val: true)
        savePreference(name: Clozer.Preferences.showEvents, val: true)
    }
    
    class func trackLocation()-> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: Clozer.Preferences.trackLocation)
    }
    
    
    
    class func showAllEvents()-> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: Clozer.Preferences.showEvents)
    }
    
    class func getPreferenceDouble(key:String)->Double {
        let defaults = UserDefaults.standard
        return defaults.double(forKey:key)
    }
    
    
    class func sendMessage(mess:String ,oneSignalIds:[String]) {
        OneSignal.postNotification(["contents": ["en": mess], "include_player_ids": oneSignalIds])

    }
    
}
