//
//  CreateEventViewController.swift
//  Clozr
//
//  Created by Tummala, Balaji on 5/6/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit

@objc protocol CreateEventViewControllerDelegate {
    func setBusiness(business: Business)
}

class CreateEventViewController: UIViewController {

    @IBOutlet var mainView: UIView!
    var businessdelegate: CreateEventViewControllerDelegate!
    @IBOutlet weak var createEventView: CreateEventView!
    var business: Business!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createEventView.business = self.business
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
