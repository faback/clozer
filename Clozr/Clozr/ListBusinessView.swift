//
//  ListBusinessView.swift
//  Clozr
//
//  Created by Tummala, Balaji on 5/3/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit
import MapKit

@objc protocol ListBusinessViewDelegate {
    func performSeguetoCreateEvent(business: Business)
}

class ListBusinessView: UIView, UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var businessMapView: MKMapView!
    @IBOutlet weak var businessTableView: UITableView!
    var businesses: [Business]!
    var delegate: ListBusinessViewDelegate!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
    }
    
    func initSubView() {
        let nib = UINib(nibName: "ListBusinessView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        mainView.frame = bounds
        addSubview(mainView)
        businessTableView.delegate = self
        businessTableView.dataSource = self
        
        let businessCellNib = UINib(nibName: "CustomCell", bundle: nil)
        businessTableView.register(businessCellNib, forCellReuseIdentifier: "CustomCell")
        businessTableView.rowHeight = UITableViewAutomaticDimension
        businessTableView.estimatedRowHeight = 100
        
        
        let location = CLLocationCoordinate2DMake(37.361893,-122.024229)
        businessMapView.setRegion(MKCoordinateRegionMakeWithDistance(location, 2000, 2000), animated: true)
        let pin = PinAnnotation(title: "Test Restuarant", coordinate: location)
        businessMapView.addAnnotation(pin)
        Business.searchWithTerm(term: "Restuarants", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
         //   self.filteredBusinesses = businesses
            self.businessTableView.reloadData()
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                    
                }
            }
            
        }
        )
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = businessTableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! BusinessTableCell
        cell.business = businesses[indexPath.row]
        return cell
    }
    
  /*  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        businessCellNib.instantiate(withOwner: self, options: nil)
    }*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let businesses = businesses {
            return businesses.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.performSeguetoCreateEvent(business: businesses[indexPath.row])
    }
    

}
