//
//  MovieDB.swift
//  Clozr
//
//  Created by CK on 5/6/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import Foundation

//
//  MovieDB.swift
//  fliCKr
//
//  Created by CK on 4/1/17.
//  Copyright © 2017 CK. All rights reserved.
//

import Foundation


import AFNetworking


protocol MovieAddedTheaters  {
    func reloadTable(event:Event)
}



class MovieDB {
    
    let apiKey = "64fbef25d73629486460569cef65ac57"
    let apiBaseUrl = "https://api.themoviedb.org/3"
    let lowRes = "w45"
    let highRes = "original"
    let posterSuffix = "w342"
    let imageBaseUrl = "https://image.tmdb.org/t/p/"
    var currentPage:Int = 1
    var delegate:MovieAddedTheaters?

    //    https://api.themoviedb.org/3/movie/top_rated?api_key=64fbef25d73629486460569cef65ac57&page=1
    
    static let sharedInstance: MovieDB = { MovieDB() }()
    
    init() {
    }
    
    
//    id = dictionary["id"] as? String
//    name = dictionary["name"] as? String
//    type = dictionary["type"] as? String
//    category = dictionary["category"] as? String
//    source = dictionary["source"] as? String
//    sourceId = dictionary["sourceId"] as? Int
//    image = dictionary["image"] as? String
//    video = dictionary["video"] as? String
//    time = dictionary["time"] as? String
    
    func withMovies(endPoint:String , completionHandler:@escaping ([Event])->()) {
        
        let moviesUrl = "\(apiBaseUrl)/movie/\(endPoint)?api_key=\(apiKey)&page=\(currentPage)"
        var request = URLRequest(url: URL(string:moviesUrl)!)
        
        //Forces requests not to be cached - to simulate network error.
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        print("Calling for movies for page \(self.currentPage) ")
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        let eventResults = responseDictionary["results"] as! [Dictionary<String,Any>]
                        var eventArray = [Event]()
                        for m in eventResults {
                            var eventDict = [String:Any]()
                            eventDict["name"] = m["title"] as! String
                            eventDict["category"] = "movies"
                            eventDict["source"] = "tmdb"
                            eventDict["summary"] = m["overview"] as! String
                            eventDict["image"] = m["poster_path"] as! String

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
    
    
     func getCinemas(completionHandler:@escaping ([[String:Any]])->()) {
        
        var movieLat = 37.785771
        var movieLon = -122.406165
        if let latt = currentLatitude ,let lonn = currentLongitude{
            movieLat = latt
            movieLon = lonn
        }else{
            movieLat = Clozer.getPreferenceDouble(key: Clozer.Preferences.lastLatitude)
            movieLon = Clozer.getPreferenceDouble(key: Clozer.Preferences.lastLongitude)
        }
        var location = "37.785771,-122.406165"
        location = "\(movieLat),\(movieLon)"
        //cinemas
        let showtimesUrl = "https://api.cinepass.de/v4/cinemas?countries=US&location=\(location)&radius=1"
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = AFJSONRequestSerializer.init()
        manager.requestSerializer.setValue("UVFfr7DSh85JN3I207j9kAEw8CHa5cBc", forHTTPHeaderField: "X-API-Key")
        
        manager.get(showtimesUrl, parameters: nil, success: { (task, response) in
            
            let cinemaResults = response as! [String:Any]
            let results = cinemaResults["cinemas"] as! [[String:Any]]
            completionHandler(results)
        }) { (task, error) in
            
            print(error.localizedDescription)
        }
    }
    
    
    func withTVShows(endPoint:String , completionHandler:@escaping ([Event])->()) {
        
        let moviesUrl = "\(apiBaseUrl)/tv/\(endPoint)?api_key=\(apiKey)&page=\(currentPage)"
        var request = URLRequest(url: URL(string:moviesUrl)!)
        
        //Forces requests not to be cached - to simulate network error.
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        print("Calling for movies for page \(self.currentPage) ")
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        let eventResults = responseDictionary["results"] as! [Dictionary<String,Any>]
                        var eventArray = [Event]()
                        for m in eventResults {
                            var eventDict = [String:Any]()
                            eventDict["name"] = m["name"] as! String
                            eventDict["category"] = "movies"
                            eventDict["source"] = "tmdb"
                            eventDict["summary"] = m["overview"] as! String
                            eventDict["image"] = m["poster_path"] as! String
                            eventArray.append(Event(dictionary: eventDict)!)
                        }
                        
                        completionHandler(eventArray)
                    }
                }else {
                    completionHandler([])
                }
        });
        task.resume()
    }
    //This monitoring - does not work correctly.. even after startmonitoring. Probably use Reachability from Apple.
    func connected()->Bool  {
        return AFNetworkReachabilityManager.shared().isReachable
    }
    
    func movieVideoDetails(id:Int,completionHandler:@escaping (String)->()) {
        
        let moviesUrl = "\(apiBaseUrl)/movie/\(id)/videos?api_key=\(apiKey)"
        let request = URLRequest(url: URL(string:moviesUrl)!)
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
                        let movieResults = responseDictionary["results"] as! [Dictionary<String,Any>]
                        var youTubeKey  = ""
                        for m in movieResults {
                            youTubeKey = m["key"] as! String
                        }
                        completionHandler(youTubeKey)
                    }
                }
        });
        task.resume()
    }
    
    
    func highResolutionUrl()-> String {
        return "\(imageBaseUrl)\(highRes)"
    }
    
    func lowResolutionUrl()-> String {
        return "\(imageBaseUrl)\(lowRes)"
    }
    
    func posterUrl()-> String {
        return "\(imageBaseUrl)\(posterSuffix)"
    }
    
}

