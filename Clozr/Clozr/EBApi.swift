//
//  EBApi.swift
//  Clozr
//
//  Created by CK on 6/4/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import Foundation

//4BKVKBFUNVEBZOQF5D


import AFNetworking




class EBApi {
    
    let apiBaseUrl = "https://www.eventbriteapi.com/v3/events/search?token=NL7GKTLCWEFDKJ2BOHIN"
//    https://www.eventbriteapi.com/v3/events/search?token=NL7GKTLCWEFDKJ2BOHIN&location.latitude=37.3541&location.longitude=-121.9552
    let defaultLatitude = "37.3541"
    let defaultLongitude = "-121.9552"
    static let sharedInstance: EBApi = { EBApi() }()
    
    init() {
    }
    
    
    func withEvents(completionHandler:@escaping ([Event])->()) {
        
        var latitude = defaultLatitude
        var longitude = defaultLongitude
        if let cuser = currentLoggedInUser {
             latitude = "\(cuser.latitude!)"
            longitude = "\(cuser.longitude!)"
        }
        let eventsUrl = "\(apiBaseUrl)&location.latitude=\(latitude)&location.longitude=\(longitude)"
        var request = URLRequest(url: URL(string:eventsUrl)!)
        
        //Forces requests not to be cached - to simulate network error.
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        let eventResults = responseDictionary["events"] as! [Dictionary<String,Any>]
                        var eventArray = [Event]()
                        for m in eventResults {
                            var eventDict = [String:Any]()
                            let name = m["name"] as! [String:Any]
                            eventDict["name"] = name["text"] as! String
                            eventDict["category"] = "catchup"
                            eventDict["source"] = "eventbrite"
                            eventDict["summary"] = name["text"] as! String
                            
                            let logo = m["logo"] as? [String:Any]
                            if let log = logo  {
                                let original = log["original"] as! [String:Any]
                                eventDict["image"] = original["url"] as! String
                            }
                            
                            let newEvent = Event(dictionary: eventDict)!
                            
                            eventArray.append(newEvent)
                        }
                        
                        completionHandler(eventArray)
                        
                        
                        
                        
                    }
                }else {
                    completionHandler([])
                }
        });
        task.resume()
    }
    
    
    
}

