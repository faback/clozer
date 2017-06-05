//
//  Clozer.swift
//  Clozr
//
//  Created by CK on 5/7/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import Foundation
import OneSignal
import UIKit
class Clozer {
   static var deviceToken:String?

    static var currentLiveEvent:Event?
    
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
//
//
//extension UITabBarController {
//    override open func viewDidLoad() {
//        super.viewDidLoad()
//        
//        tabBar.items?.forEach({ (item) -> () in
//            item.selectedImage?.renderingMode = .alwaysOriginal
//            item.image = item.selectedImage
//        })
//    }
//}

extension String {
    func index(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    func endIndex(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    func indexes(of string: String, options: CompareOptions = .literal) -> [Index] {
        var result: [Index] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range.lowerBound)
            start = range.upperBound
        }
        return result
    }
    func ranges(of string: String, options: CompareOptions = .literal) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range)
            start = range.upperBound
        }
        return result
    }
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                substring(with: substringFrom..<substringTo)
            }
        }
    }
}
