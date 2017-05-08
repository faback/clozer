//
//  YelpSettings.swift
//  Clozr
//
//  Created by CK on 5/6/17.
//  Copyright © 2017 Faback. All rights reserved.
//
//
//  YelpSettings.swift
//  Yelp
//
//  Created by CK on 4/7/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class YelpSettings: NSObject {
    static var shared: YelpSettings = { YelpSettings.init() }()
    
    
    
    var offset:Int = 0
    var limit:Int = 20
    static var defaultLatitude = 37.785771
    static var defaultLongitude = -122.406165
    
    static var centeredLatitude = defaultLatitude
    static var centerdLongitude = defaultLongitude
    
    
    
    var selectedDistance:YelpDistance = YelpDistance.auto
    var selectedCategories:[String] = []
    var selectedSortBy:YelpSortMode = YelpSortMode.bestMatched
    var searchTerm:String! = ""
    
     override init() {
//        sectionCounts = [0:1 , 1:distances.count , 2:sortModes.count , 3: YelpSettings.categories.count]
    }
    
 
    
    func firstPage() {
        offset = 0
        limit = 20
    }
    
    func nextPage() {
        offset = offset + limit
        limit = 20
    }
    

    
    class func resetLocation() {
        centerdLongitude = defaultLongitude
        centeredLatitude = defaultLatitude
    }
    func startLocationTracking() {
        
    }
    
}
