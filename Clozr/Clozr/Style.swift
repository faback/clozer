//
//  File.swift
//  Clozr
//
//  Created by CK on 5/6/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

extension UIColor {
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let color = coreImageColor
        return (color.red, color.green, color.blue, color.alpha)
    }
}



class Styles {
    
    class func styleNav(controller:UIViewController) {
        controller.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        controller.navigationItem.backBarButtonItem?.tintColor = UIColor.red
        controller.navigationController?.navigationBar.backgroundColor = UIColor.red
        controller.navigationItem.backBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.white]
            , for: UIControlState.normal)
        controller.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.white]
            , for: UIControlState.normal)
    }
    
    
    class func darkerColorForColor(c:UIColor) -> UIColor
    {
        let redColor = c.components.red
        let greenColor = c.components.green
        let blueColor = c.components.blue
        let alpha = c.components.alpha
        return UIColor(colorLiteralRed: max(Float(redColor) - 0.2,0.0), green: max(Float(greenColor) - 0.2,0.0), blue: max(Float(blueColor) - 0.2,0.0), alpha: Float(alpha))
    }
    
    class func activityIndicatorBig()->NVActivityIndicatorView {
        
        return NVActivityIndicatorView(frame: CGRect(x:0.0, y:0.0, width:80, height:80), type: .ballScaleMultiple, color: UIColor(red: 57.0/255.0, green: 101.0/255.0, blue: 169.0/255.0, alpha:1))

    }
    
    class func startAnimating(inView:UIView,indicator:NVActivityIndicatorView)->UIView {
        indicator.startAnimating()
        return showDimLayer(inView: inView)
    }
    
    class func stopAnimating(coverView:UIView,indicator:NVActivityIndicatorView) {
      coverView.removeFromSuperview()
      indicator.stopAnimating()
    }

    
    class func setupActivityIndicator(indicator:NVActivityIndicatorView, inView:UIView){
        indicator.center = CGPoint(x: inView.bounds.size.width/2 , y:inView.bounds.size.height/2 - 60)
        inView.addSubview(indicator)
        
    }
    
    class func showDimLayer(inView:UIView) -> UIView{
        let screenRect:CGRect = UIScreen.main.bounds
        let coverView = UIView(frame: screenRect)
        coverView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        inView.addSubview(coverView)
        return coverView
    }
}



