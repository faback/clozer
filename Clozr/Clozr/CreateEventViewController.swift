//
//  CreateEventViewController.swift
//  Clozr
//
//  Created by Tummala, Balaji on 5/6/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit

protocol CreateEventViewControllerDelegate {
    func setEvent(event: Event)
}

class CreateEventViewController: UIViewController, CreateEventViewDelegate {

    @IBOutlet var mainView: UIView!
    var businessdelegate: CreateEventViewControllerDelegate!
    @IBOutlet weak var createEventView: CreateEventView!
    var event: Event!
    var showTime: String!
    var eventFromCreateEventViewToListEventsVC: Event!
    override func viewDidLoad() {
        super.viewDidLoad()
        createEventView.event = self.event
//         User.getUserFromFirebase(mail: User.currentLoginUserId()) { (usr, error) in
//                self.event.inviteUser(userId: (usr?.userId)! , accepted: false)
//            currentLoggedInUser = usr
//                if let uid = usr?.userId {
//                    let me = usr
//                    me?.addEvent(evt: self.event.id!)
//                    User.createOrUpdateUserInFirebase(user: me)
//                }else {
//                    let me = usr
//                    me?.addEvent(evt: self.event.id!)
//                    User.createOrUpdateUserInFirebase(user: me)
//                }
//            Event.createOrUpdateEventInFirebase(event: self.event)
//        }
//        //TODO:Balaji loop all users  call invite.
//        
//        
//        //Then save event.
        
        
        createEventView.delegate = self
        createEventView.initSubView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func performSegueToListEventsController(event: Event) {
        self.eventFromCreateEventViewToListEventsVC = event
        performSegue(withIdentifier: "fromCreateEventToListEvents", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! EventsListViewController
        vc.newEventFromCreateEventView = self.eventFromCreateEventViewToListEventsVC
        vc.comingFromCreateEvent = true
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
