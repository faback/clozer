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
    
    @IBOutlet weak var v1: UIView!
    @IBOutlet weak var v2: UIView!
    @IBOutlet weak var v3: UIView!
    @IBOutlet weak var v4: UIView!
    
    @IBOutlet weak var v5: UIView!
    
    var buttonTag:[Int:UIButton] = [Int:UIButton]()
    var navArray:[Int:String] = [Int:String]()
    var navButtonArray:[String:UIButton] = [String:UIButton]()
    var navName:String?
    override func viewDidLoad() {
        //menu
        var tagCounter:Int  = 1

        navArray = [1:Clozer.Nav.homeNav,2:Clozer.Nav.liveEventNav, 3:Clozer.Nav.eventDetailNav,4:Clozer.Nav.friendsNav,5:Clozer.Nav.settingsNav]
        navButtonArray = [Clozer.Nav.homeNav:hb,Clozer.Nav.liveEventNav:mb, Clozer.Nav.eventDetailNav:mapB,Clozer.Nav.friendsNav:fb,Clozer.Nav.settingsNav:sb]
        let allButtons = [hb,fb,mapB,sb,mb]
        for ab in allButtons {
            ab?.tag = tagCounter
            buttonTag[tagCounter] = ab
            tagCounter  = tagCounter + 1
        }
        tagCounter = 1
        let tabViews = [v1,v2,v3,v4,v5]
        
        for tv in tabViews {
            tv?.isUserInteractionEnabled = true
            tv?.tag = tagCounter
            tagCounter  = tagCounter + 1
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
            tv?.addGestureRecognizer(tapGesture)
        }
        
        if let selectedNav = navName {
            otherAlpha(curr: navButtonArray[selectedNav]!)
            loadNavInContent(navName: selectedNav)
        }
        else{
            otherAlpha(curr: hb)
            loadNavInContent(navName: Clozer.Nav.homeNav)
        }
    }
    
    func didTap(sender: UITapGestureRecognizer) {
        
        let tag = sender.view?.tag
        tapAction(tag:tag!)
    }

    
    
    func tapAction(tag:Int) {
        let curr = buttonTag[tag]
        let allButtons = [hb,fb,mapB,sb,mb]
        curr?.alpha = 1
        for b in allButtons {
            if(b != curr) {
                b?.alpha = 0.4
            }
        }
        loadNavInContent(navName: navArray[tag]!)
    }
    
    
    func otherAlpha(curr:UIButton) {
        let allButtons = [hb,fb,mapB,sb,mb]
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
    
    
     func loadLiveEvents(from:UIViewController) {
        otherAlpha(curr: hb)
        loadNavInContent(navName: Clozer.Nav.liveEventNav)
      }
    

    @IBAction func homeButton(_ sender: UIButton) {
        otherAlpha(curr: sender)
        loadNavInContent(navName: Clozer.Nav.homeNav)
    }
    
    
    @IBAction func myButton(_ sender: UIButton) {
        otherAlpha(curr: sender)
        loadNavInContent(navName: Clozer.Nav.liveEventNav)

        
    }
    
    @IBAction func mapButton(_ sender: UIButton) {
        
        otherAlpha(curr: sender)
        loadNavInContent(navName: Clozer.Nav.eventDetailNav)
    }
    
    
    @IBAction func friendsButton(_ sender: UIButton) {
        otherAlpha(curr: sender)
        loadNavInContent(navName: Clozer.Nav.friendsNav)
    }
    
    
    @IBAction func settingsButton(_ sender: UIButton) {
        otherAlpha(curr: sender)
        loadNavInContent(navName: Clozer.Nav.settingsNav)
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
