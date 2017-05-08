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
    override func viewDidLoad() {
        super.viewDidLoad()
        displayTheatrersTableView.delegate = self
        displayTheatrersTableView.dataSource = self
        
        movieImageView.alpha = 0.4
        
  //       displayTheatrersTableView.rowHeight = UITableViewAutomaticDimension
 //      displayTheatrersTableView.estimatedRowHeight = 150
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
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
        return "TheaterName"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let cell = displayTheatrersTableView.dequeueReusableCell(withIdentifier: "MovieDisplayCell", for: indexPath) as! MovieDisplayCell
//        print(cell.movieTimingsCollectionVIew.frame.size.height)
//        return cell.movieTimingsCollectionVIew.frame.size.height
        return UITableViewAutomaticDimension
 //       return 120
    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
