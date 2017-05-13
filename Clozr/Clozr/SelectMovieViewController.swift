//
//  SelectMovieViewController.swift
//  Clozr
//
//  Created by Tummala, Balaji on 5/7/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit

class SelectMovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var displayTheatrersTableView: UITableView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var moveiNameLabel: UILabel!
    
    var event:Event?
    override func viewDidLoad() {
        super.viewDidLoad()
        displayTheatrersTableView.delegate = self
        displayTheatrersTableView.dataSource = self
        getTheaters()
        
        
        
        renderMovieView()
        
//        movieImageView.alpha = 0.4
        
  //       displayTheatrersTableView.rowHeight = UITableViewAutomaticDimension
 //      displayTheatrersTableView.estimatedRowHeight = 150
        // Do any additional setup after loading the view.
    }

    func getTheaters() {
    
    MovieDB.sharedInstance.getCinemas(completionHandler: { (theaters) in
            var count = 0
            var theaterArray = [Theater]()

                for theater in theaters  {
                    if(count < 7) {
                        var tDictionary = [String:Any]()
                        tDictionary["name"] = theater["name"]
                        let loc = tDictionary["location"] as? [String:Any]
                        let addr = loc?["address"] as? [String:Any]
                        let addrText = addr?["display_text"]
                        tDictionary["location"] = addrText
                        tDictionary["showtimes"] = ["10:00 AM","1:00 PM", "3:00 AM","6:30 PM"]
                        let theater = Theater(dictionary: tDictionary)
                        theaterArray.append(theater!)
                    }
                    count = count + 1
                }
            self.event?.theaters = theaterArray
            self.displayTheatrersTableView.reloadData()
            })
    }
    
    
    func renderMovieView() {
        moveiNameLabel.text = event?.name

        if let imgUrl = event?.image {
            var imageUrl = "\(MovieDB.sharedInstance.posterUrl())/\(imgUrl)"
            if(event?.category != "movies") {
                imageUrl = imgUrl
            }
            let imageNetworkUrl:URLRequest = URLRequest(url:URL(string:imageUrl)!)
            movieImageView.setImageWith(imageNetworkUrl, placeholderImage: nil, success: {( req, res, result) -> Void in
                if res != nil {
                    self.movieImageView.alpha = 1
                    self.movieImageView.image = result
                    UIView.animate(withDuration: 3.0, animations: { () -> Void in
                        self.movieImageView.alpha = 0.4
                    })
                }else{
                    self.movieImageView.image = result
                    self.movieImageView.alpha = 0.4
                }
            }, failure: {(req, res, result) -> Void in
                
            })
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (event?.theaters!.count)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = displayTheatrersTableView.dequeueReusableCell(withIdentifier: "MovieDisplayCell", for: indexPath) as! MovieDisplayCell
        print(cell.movieTimingsCollectionVIew.frame.size.height)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return event?.theaters?[section].name
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
////        let cell = displayTheatrersTableView.dequeueReusableCell(withIdentifier: "MovieDisplayCell", for: indexPath) as! MovieDisplayCell
////        print(cell.movieTimingsCollectionVIew.frame.size.height)
////        return cell.movieTimingsCollectionVIew.frame.size.height
//        return UITableViewAutomaticDimension
// //       return 120
//    
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
