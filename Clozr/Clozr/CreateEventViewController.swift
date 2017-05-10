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

class CreateEventViewController: UIViewController {

    @IBOutlet var mainView: UIView!
    var businessdelegate: CreateEventViewControllerDelegate!
    @IBOutlet weak var createEventView: CreateEventView!
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createEventView.event = self.event
        //TODO:Balaji loop all users  call invite.
        event.inviteUser(userId: (User.me?.userId)!, accepted: false)
        
        //Then save event.
        Event.createOrUpdateEventInFirebase(event: event)
        User.me?.addEvent(evt: event.id!)
        User.createOrUpdateUserInFirebase(user: User.me)
        createEventView.initSubView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
