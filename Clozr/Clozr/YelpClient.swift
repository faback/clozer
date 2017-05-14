//
//  YelpClient.swift
//  Clozr
//
//  Created by CK on 5/6/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import Foundation


import UIKit

import AFNetworking
import BDBOAuth1Manager

// You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
let yelpConsumerKey = "vxKwwcR_NMQ7WaEiQBK_CA"
let yelpConsumerSecret = "33QCvh5bIF5jIHR5klQr7RtBDhQ"
let yelpToken = "uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV"
let yelpTokenSecret = "mqtKIxMIR4iBtBPZCmCLEb-Dz3Y"

var currentLatitude:Double?
var currentLongitude:Double?
enum YelpSortMode: Int {
    case bestMatched = 0, distance, highestRated
    //    var sortModes:[String] = ["Best Match" ,"Distance" ,  "Highest Rated"]
    
    func toSortby() -> String {
        switch self {
        case .bestMatched:
            return "Best Match"
        case .distance:
            return "Distance"
        case .highestRated:
            return "Highest Rated"
        }
    }
}

enum YelpDistance: Double  {
    case auto = 0 , point3 = 0.3  , onemile = 1 , five = 5.0 , twenty = 20
    
    //    var distances:[String] =  ["Auto" ,"0.3 miles" ,"1 mile" , "5 miles" , "20 miles"]
    
    func toDistance() -> String {
        switch self {
        case .auto:
            return "Auto"
        case .point3:
            return "0.3 miles"
        case .onemile:
            return "1 mile"
        case .five:
            return "5 miles"
        case .twenty:
            return "20 miles"
        }
    }
}


class YelpClient: BDBOAuth1RequestOperationManager {
    var accessToken: String!
    var accessSecret: String!
    
    //MARK: Shared Instance
    
    static let sharedInstance = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        let baseUrl = URL(string: "https://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        
        let token = BDBOAuth1Credential(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    var limit = 20
    var offset = 0
    
    
    func yelpSearch(_ searchTerm: String, subCat:String , completion: @escaping ([Event]?, Error?) -> Void) -> AFHTTPRequestOperation {
        
        let distance = 5.0
        let term = searchTerm
        //        let sort  = 0
        var yelplat = 37.785771
        var yelplon = -122.406165
        if let latt = currentLatitude ,let lonn = currentLongitude{
            yelplat = latt
            yelplon = lonn
        }else{
            yelplat = Clozer.getPreferenceDouble(key: Clozer.Preferences.lastLatitude)
            yelplon = Clozer.getPreferenceDouble(key: Clozer.Preferences.lastLongitude)
        }
        YelpSettings.centeredLatitude = yelplat
        YelpSettings.centerdLongitude = yelplon
        var parameters: [String : AnyObject] = ["term": term as AnyObject, "ll": "\(YelpSettings.centeredLatitude),\(YelpSettings.centerdLongitude)" as AnyObject]
        //        parameters["sort"] = sort as AnyObject?
        parameters["radius_filter"] = (distance*1609.34) as AnyObject?
        parameters["limit"] = limit as AnyObject?
        parameters["offset"] = offset as AnyObject?
        
        return self.get("search", parameters: parameters,
                        success: { (operation: AFHTTPRequestOperation, response: Any) -> Void in
                            if let response = response as? [String: Any]{
                                let dictionaries = response["businesses"] as? [NSDictionary]
                                
                                if dictionaries != nil {
                                    
                                    
                                    var eventArray = [Event]()
                                    for m in dictionaries! {
                                        //------------------------------
                                        let location = m["location"] as? NSDictionary
                                        var address = ""
                                        var lat = 37.785771
                                        var lon = -122.406165

                                        var fullAddress = ""
                                        if location != nil {
                                            let addressArray = location!["address"] as? NSArray
                                            if addressArray != nil && addressArray!.count > 0 {
                                                address = addressArray![0] as! String
                                            }
                                            
                                            let neighborhoods = location!["neighborhoods"] as? NSArray
                                            if neighborhoods != nil && neighborhoods!.count > 0 {
                                                if !address.isEmpty {
                                                    address += ", "
                                                }
                                                address += neighborhoods![0] as! String
                                            }
                                            let coordinates = location!["coordinate"] as? NSDictionary
                                            if(coordinates != nil) {
                                                lat = coordinates!["latitude"] as! Double
                                                lon = coordinates!["longitude"] as! Double
                                            }
                                            
                                            if let displayAddress = location!["display_address"]  {
                                                let arr = displayAddress as! NSArray
                                                for lineOf in arr {
                                                    fullAddress = fullAddress + (lineOf as! String)
                                                }
                                            }
                                        }
                                        var eventDict = [String:Any]()
                                        eventDict["name"] =  m["name"] as? String
                                        eventDict["category"] = subCat
                                        eventDict["source"] = "yelp"
                                        eventDict["summary"] =  m["name"] as? String
                                        eventDict["image"] =  m["image_url"] as? String
                                        eventDict["address"] = address
                                        eventDict["latitude"] = lat
                                        eventDict["longitude"] = lon
                                        let distance: String?
                                        let distanceMeters = m["distance"] as? NSNumber
                                        if distanceMeters != nil {
                                            let milesPerMeter = 0.000621371
                                            distance = String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
                                        } else {
                                            distance = nil
                                        }
                                        let phNumber = m["display_phone"] as? String
                                        let index = phNumber?.index((phNumber?.startIndex)!, offsetBy: 3)
                                        
                                        eventDict["distance"] = distance
                                        eventDict["phone"] = phNumber?.substring(from: index!)
                                        //-----------------------------
                                        eventArray.append(Event(dictionary: eventDict)!)
                                    }
                                    
                                    completion(eventArray, nil)
                                    
                                }
                            }
        },
                        failure: { (operation: AFHTTPRequestOperation?, error: Error) -> Void in
                            completion(nil, error)
        })!
    }
}
