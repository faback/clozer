//
//  CreateEventView.swift
//  Clozr
//
//  Created by Tummala, Balaji on 5/3/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit

class CreateEventView: UIView, UITableViewDelegate, UITableViewDataSource, CreateEventViewControllerDelegate {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var reviewImageView: UIImageView!
    @IBOutlet weak var cuisineTypeLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var businessPhoneNumberLabel: UILabel!

    @IBOutlet weak var addDateView: UIView!
    @IBOutlet weak var addDateandTimelabel: UILabel!
    @IBOutlet weak var friendsTableView: UITableView!
    var dateFormat = "HH:mm MM/dd/YYYY"
    var event:Event!
    var friends : [User]!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
    }
    
    func initSubView() {
        
        let nib = UINib(nibName: "CreateEventView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        mainView.frame = bounds
        addSubview(mainView)
        
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        let FriendTableCellNib = UINib(nibName: "FriendTableCell", bundle: nil)
        friendsTableView.register(FriendTableCellNib, forCellReuseIdentifier: "FriendTableCell")
        friendsTableView.rowHeight = UITableViewAutomaticDimension
        friendsTableView.estimatedRowHeight = 70
        
         let dateAndTimeTap = UITapGestureRecognizer(target: self, action: #selector(showDateTime(sender:)))
        addDateView.addGestureRecognizer(dateAndTimeTap)
        self.friends = User.me?.friends
        if let evt = self.event {
            businessNameLabel.text = evt.name
//            distanceLabel.text = business.distance
            addressLabel.text = evt.address
//            reviewImageView.setImageWith(business.ratingImageURL!)
//            cuisineTypeLabel.text = business.categories
//            reviewCountLabel.text = "\(business.reviewCount!) Reviews"
            businessPhoneNumberLabel.text = evt.phone
            if let imgUrl = evt.image {
                var imageUrl = "\(MovieDB.sharedInstance.posterUrl())/\(imgUrl)"
                if(event.category != "movies") {
                    imageUrl = imgUrl
                }
                let imageNetworkUrl:URLRequest = URLRequest(url:URL(string:imageUrl)!)
                backgroundImageView.setImageWith(imageNetworkUrl, placeholderImage: nil, success: {( req, res, result) -> Void in
                    if res != nil {
                        self.backgroundImageView.alpha = 0.5
                        self.backgroundImageView.image = result
                        UIView.animate(withDuration: 3.0, animations: { () -> Void in
                            self.backgroundImageView.alpha = 0.4
                        })
                    }else{
                        self.backgroundImageView.image = result
                    }
                }, failure: {(req, res, result) -> Void in
                    
                })
            }
        }
        addDateView.layer.shadowColor = UIColor.black.cgColor
        addDateView.layer.shadowOpacity = 1
        addDateView.layer.shadowOffset = CGSize.zero
        addDateView.layer.shadowRadius = 10
        addDateView.layer.shadowPath = UIBezierPath(rect: addDateView.bounds).cgPath
        addDateView.layer.shouldRasterize = true
    }
    
    func showDateTime(sender: UIView?=nil){
        
        //let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView()
        blurEffectView.frame = mainView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        UIView.animate(withDuration: 0.6) {
            blurEffectView.effect = UIBlurEffect(style: UIBlurEffectStyle.light)
        }
        self.mainView.addSubview(blurEffectView)
        
        let picker = DateTimePicker.show(view: self.mainView, blurView: blurEffectView)
            picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
            picker.completionHandler = { date in
                // do something after tapping done
                let formatter = DateFormatter()
                formatter.dateFormat = self.dateFormat
                self.addDateandTimelabel.text = formatter.string(from: date)

            
            }
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendsTableView.dequeueReusableCell(withIdentifier: "FriendTableCell", for: indexPath) as! FriendTableCell
        cell.friend = self.friends[indexPath.row]
        return cell
    }
    
    /*  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     businessCellNib.instantiate(withOwner: self, options: nil)
     }*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.friends != nil) {
            return self.friends.count
        }
        else {
            return 0
        }
    }
    
    func setEvent(event: Event){
        self.event = event
    }


}
