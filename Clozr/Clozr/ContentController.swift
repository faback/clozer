//
//  ContentController.swift
//  Clozr
//
//  Created by CK on 5/7/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit

//
//  ContentController.swift
//  Twitterr
//
//  Created by CK on 4/21/17.
//  Copyright © 2017 CK. All rights reserved.
//

import UIKit

class ContentController: UIViewController {
    

    @IBOutlet weak var contentView: UIView!
    var currrent:UIViewController?
    var viewControllerWidth: CGFloat!
    
    var currentUser: User!
    var beginningMargin: CGFloat!
    var trailingMargin: CGFloat!
    
    @IBOutlet weak var hb: UIButton!
    @IBOutlet weak var mb: UIButton!
    @IBOutlet weak var mapB: UIButton!
    @IBOutlet weak var fb: UIButton!
    @IBOutlet weak var sb: UIButton!
    
    
    override func viewDidLoad() {
        //menu
        
        
        //home
        if let currentContent = currrent  {
            print("No content")
        }else{
            loadNavInContent(navName: "homeNav")
        }
    }
    
    
    func otherAlpha(curr:UIButton) {
        var allButtons = [hb,fb,mapB,sb,mb]
        curr.alpha = 1
        for b in allButtons {
            if(b != curr) {
                b?.alpha = 0.4
            }
        }
    }
    
    
    //MARK : Hide and show content.
    
    func showController(controller:UIViewController ,inContentVew:UIView , ofController: UIViewController)  {
        ofController.view.layoutIfNeeded()
        ofController.addChildViewController(controller)
        controller.view.frame = inContentVew.bounds
        inContentVew.addSubview(controller.view)
        controller.didMove(toParentViewController: ofController)
        
    }
    
    func hideController(controller:UIViewController) {
        controller.willMove(toParentViewController: nil)
        controller.view.removeFromSuperview()
        controller.didMove(toParentViewController: nil)
    }
    
    func loadNavInContent(navName:String) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        currrent = storyboard.instantiateViewController(withIdentifier: navName) as! UINavigationController //
         showController(controller: currrent!, inContentVew: contentView, ofController: self)
    }
    
    

    @IBAction func homeButton(_ sender: UIButton) {
        otherAlpha(curr: sender)
        loadNavInContent(navName: "homeNav")
    }
    
    
    @IBAction func myButton(_ sender: UIButton) {
        otherAlpha(curr: sender)
        loadNavInContent(navName: "businessViewNav")

        
    }
    
    @IBAction func mapButton(_ sender: UIButton) {
        
        otherAlpha(curr: sender)
        loadNavInContent(navName: "eventDetailNav")
    }
    
    
    @IBAction func friendsButton(_ sender: UIButton) {
        otherAlpha(curr: sender)
        loadNavInContent(navName: "friendsNav")
    }
    
    
    @IBAction func settingsButton(_ sender: UIButton) {
        otherAlpha(curr: sender)
        loadNavInContent(navName: "settingsNav")
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
