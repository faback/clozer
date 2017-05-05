//
//  CreateEventView.swift
//  Clozr
//
//  Created by Tummala, Balaji on 5/3/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit
import DateTimePicker

class CreateEventView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var eventImageView: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventAddressLabel: UILabel!
    
    @IBOutlet weak var addDateView: UIView!
    @IBOutlet weak var addDateandTimelabel: UILabel!
    @IBOutlet weak var friendsTableView: UITableView!
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
                return cell
    }
    
    /*  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     businessCellNib.instantiate(withOwner: self, options: nil)
     }*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }


}
