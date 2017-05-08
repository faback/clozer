//
//  BusinessViewController.swift
//  Clozr
//
//  Created by Tummala, Balaji on 5/3/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit

class BusinessViewController: UIViewController, ListBusinessViewDelegate  {

    @IBOutlet weak var contentView: ListBusinessView!
    
    var category:Category?
    var subCategory:Category?
    var event: Event!
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.delegate = self
        
//        let picker = DateTimePicker.show(view: contentView)
//        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
//        picker.completionHandler = { date in
//            // do something after tapping done
//            
//        }


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
    func performSeguetoCreateEvent(event: Event) {
        self.event = event
        performSegue(withIdentifier: "BusinessToCreateEvent", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let createEventViewController = segue.destination as! CreateEventViewController
        createEventViewController.event = self.event
    }
    

}
