//
//  CreateEventView.swift
//  Clozr
//
//  Created by Tummala, Balaji on 5/3/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit

@objc protocol CreateEventViewDelegate {
    func performSegueToListEventsController(event: Event)
}

class CreateEventView: UIView, UITableViewDelegate, UITableViewDataSource, CreateEventViewControllerDelegate {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var createEventView: UIView!
    @IBOutlet weak var creaeEventLabel: UILabel!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var reviewImageView: UIImageView!
    @IBOutlet weak var cuisineTypeLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var businessPhoneNumberLabel: UILabel!
    @IBOutlet weak var phoneImageView: UIImageView!
    @IBOutlet weak var createEventLabel: UILabel!
    
    @IBOutlet weak var tapToEditLabel: UILabel!
    @IBOutlet weak var displayDateLabel: UILabel!
    @IBOutlet weak var displayTimeLabel: UILabel!
    @IBOutlet weak var addDateView: UIView!
    @IBOutlet weak var addDateandTimelabel: UILabel!
    @IBOutlet weak var friendsTableView: UITableView!
    var eventDate: String!
    var eventTime: String!
    var dateFormat = "HH:mm MM/dd/YYYY"
    var event:Event!
    var friends : [ClozrUser]!
    var invitedFriends = [ClozrUser]()
    var delegate: CreateEventViewDelegate!
    var selectedIndexPaths = [IndexPath: Bool]()
    var clozrFriends = [ClozrUser]()
    var showTime: String!
    var selectedMovieDate: Date!
    var theaterName: String!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
    }
    
    func appendUsers(usr:ClozrUser) {
        var exists:Bool = false
        for existingUser in self.clozrFriends {
            if(existingUser.userId == usr.userId) {
                exists = true
            }
        }
        
        if(!exists) {
            self.clozrFriends.append(usr)
        }
        
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
        
        self.plusImageView.isHidden = false
        self.addDateandTimelabel.isHidden = false
        self.tapToEditLabel.isHidden = true
        self.displayDateLabel.isHidden = true
        displayTimeLabel.isHidden = true
        
        var once:Int = 0
        
        ClozrUser.getAllUserFromFirebase { (allFriends, error) in
            if(once == 0) {
                
                once = 1
                self.clozrFriends = [ClozrUser]()
                for usr in allFriends! {
                    if(usr.isClozerUser) {
//                        if !self.clozrFriends.contains(usr){
//                            self.clozrFriends.append(usr)
//                        }
                        self.appendUsers(usr: usr)
                    }
                }
                self.friends = self.clozrFriends
                self.friendsTableView.reloadData()
                //                MBProgressHUD.hide(for: self.view, animated: true)
                
            }
        }
        

        if showTime != nil {
            self.phoneImageView.isHidden = true
            self.businessPhoneNumberLabel.isHidden = true
            let formatter = DateFormatter()
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = self.dateFormat
            //let timeDate = timeFormatter.string(from: selectedMovieDate)
            formatter.dateStyle = .medium //self.dateFormat
            self.addDateView.backgroundColor = UIColor(red: 57.0/255.0, green: 101.0/255.0, blue: 169.0/255.0, alpha:1)
            self.plusImageView.isHidden = true
            self.addDateandTimelabel.isHidden = true
            self.displayDateLabel.isHidden = false
            self.displayTimeLabel.isHidden = false
            //let index = timeDate.index(timeDate.startIndex, offsetBy: 5)
            self.displayTimeLabel.text = showTime
            self.eventTime = showTime
            print(theaterName)
            self.addressLabel.text = theaterName
            self.displayDateLabel.textColor = UIColor.white
            self.displayDateLabel.text = formatter.string(from: selectedMovieDate)
            self.eventDate = formatter.string(from: selectedMovieDate)
            self.createEventView.backgroundColor = UIColor(red: 57.0/255.0, green: 101.0/255.0, blue: 169.0/255.0, alpha:0.8)
            self.createEventView.isUserInteractionEnabled = true
            self.mainView.bringSubview(toFront: createEventView)

        }
        else {
            self.mainView.bringSubview(toFront: createEventView)
            self.createEventView.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
            self.createEventView.isUserInteractionEnabled = false
        
            let dateAndTimeTap = UITapGestureRecognizer(target: self, action: #selector(showDateTime(sender:)))
            addDateView.addGestureRecognizer(dateAndTimeTap)
        }
        
        let createEventTap = UITapGestureRecognizer(target: self, action: #selector(createEvent(sender:)))
        createEventView.addGestureRecognizer(createEventTap)
        if let evt = self.event {
            businessNameLabel.text = evt.name
            distanceLabel.text = evt.distance
            addressLabel.text = evt.address
            //            reviewImageView.setImageWith(business.ratingImageURL!)
            //            cuisineTypeLabel.text = business.categories
            //            reviewCountLabel.text = "\(business.reviewCount!) Reviews"
            businessPhoneNumberLabel.text = evt.phone ?? "408-637-1726"
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
        //        addDateView.layer.shadowColor = UIColor.black.cgColor
        //        addDateView.layer.shadowOpacity = 1
        //        addDateView.layer.shadowOffset = CGSize.zero
        //        addDateView.layer.shadowRadius = 5
        //        addDateView.layer.shadowPath = UIBezierPath(rect: addDateView.bounds).cgPath
        //        addDateView.layer.shouldRasterize = true
        //
        //        createEventView.layer.shadowColor = UIColor.black.cgColor
        //        createEventView.layer.shadowOpacity = 1
        //        createEventView.layer.shadowOffset = CGSize.zero
        //        createEventView.layer.shadowRadius = 5
        //        createEventView.layer.shadowPath = UIBezierPath(rect: addDateView.bounds).cgPath
        //        createEventView.layer.shouldRasterize = true
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
            picker.highlightColor = UIColor(red: 57.0/255.0, green: 101.0/255.0, blue: 169.0/255.0, alpha:1)
            picker.completionHandler = { date in
                // do something after tapping done
                let formatter = DateFormatter()
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = self.dateFormat
                let timeDate = timeFormatter.string(from: date)
                formatter.dateStyle = .medium //self.dateFormat
                self.addDateView.backgroundColor = UIColor(red: 57.0/255.0, green: 101.0/255.0, blue: 169.0/255.0, alpha:1)
                self.plusImageView.isHidden = true
                self.addDateandTimelabel.isHidden = true
                self.displayDateLabel.isHidden = false
                self.tapToEditLabel.isHidden = false
                self.displayTimeLabel.isHidden = false
                let index = timeDate.index(timeDate.startIndex, offsetBy: 5)
                self.displayTimeLabel.text = timeDate.substring(to: index)
                self.eventTime = timeDate.substring(to: index)
                self.displayDateLabel.textColor = UIColor.white
                self.displayDateLabel.text = formatter.string(from: date)
                self.eventDate = formatter.string(from: date)
                self.createEventView.backgroundColor = UIColor(red: 57.0/255.0, green: 101.0/255.0, blue: 169.0/255.0, alpha:0.8)
                self.createEventView.isUserInteractionEnabled = true
            
        }
        
    }
    
    func createEvent(sender: UIView?=nil){
        
        
        ClozrUser.getUserFromFirebase(usrId: ClozrUser.currentLoginUserId()!) { (usr, error) in
            currentLoggedInUser = usr
            let uuid = UUID().uuidString
            self.event.id = uuid

            if let uid = usr?.userId {
                let me = usr
                me?.addEvent(evt: self.event.id!)
                ClozrUser.createOrUpdateUserInFirebase(user: me)
            }else {
                let me = usr
                me?.addEvent(evt: self.event.id!)
                ClozrUser.createOrUpdateUserInFirebase(user: me)
            }
            self.event.createdBy = ClozrUser.currentLoginUserId()
            var oneSignalIds:[String]  = [String]()
//            if let os  = currentLoggedInUser?.oneSignalId {
//                oneSignalIds.append(os)
//            }
            for friend in self.invitedFriends{
                print(friend.name!)
                if let osid = friend.oneSignalId {
                    if(currentLoggedInUser?.userId != friend.userId) {
                        oneSignalIds.append(osid)
                    }
                }
                friend.setUserId()
                var accepted:Bool = false
                if(currentLoggedInUser?.userId == friend.userId) {
                    accepted = true
                }
                friend.addEvent(evt: self.event.id)
                ClozrUser.createOrUpdateUserInFirebase(user: friend)
                self.event.inviteUser(userId: (friend.userId)!, accepted: accepted)
            }
            
            self.event.inviteUser(userId: (currentLoggedInUser?.userId)! , accepted: true)
            Event.createOrUpdateEventInFirebase(event: self.event, eventDt: self.eventDate, eventTm: self.eventTime)
            
            // Create chat channel for this event.
            let dictionary = NSMutableDictionary()
            dictionary.setValue(self.event.id, forKey: "id")
            let channel:Channel = Channel(dictionary: ["id" : self.event.id])!
            Channel.createOrUpdateChannelInFirebase(channel: channel)
            
            var message = "Event notification"
            if let uname = currentLoggedInUser?.name , let ename = self.event.name ,let cat = self.event.category {
                message = "\(uname) has invited you to \(ename). Check it out!"
            }
            Clozer.sendMessage(mess: message, oneSignalIds: oneSignalIds)
        }
        //TODO:Balaji loop all users  call invite.
        //Then save event.
        delegate?.performSegueToListEventsController(event: event)
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
        cell.isSelected = selectedIndexPaths[indexPath] ?? false
        cell.selectionStyle = .none
        cell.accessoryType = cell.isSelected ? .checkmark : .none
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.invitedFriends.append(self.friends[indexPath.row])
        if let cell = friendsTableView.cellForRow(at: indexPath){
            cell.selectionStyle = .none
            cell.accessoryType = .checkmark
            selectedIndexPaths[indexPath] = true
        }
        //print(self.friends[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.invitedFriends.remove(at: self.invitedFriends.index(of: self.friends[indexPath.row])!)
        if let cell = friendsTableView.cellForRow(at: indexPath){
            selectedIndexPaths[indexPath] = false
            cell.accessoryType = .none
        }
        //print(self.friends[indexPath.row])
    }
    
    func setEvent(event: Event){
        self.event = event
    }
    
    
}
