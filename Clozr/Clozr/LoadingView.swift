//
//  LoadingView.swift
//  Clozr
//
//  Created by CK on 5/2/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import Foundation



import UIKit

//creates a custom overlay view, used as a loading animation
public class LoadingOverlay {
    
    var overlayView : UIView!
    var activityIndicator : UIActivityIndicatorView!
    var titleLabel : UILabel!
    
    static let shared = LoadingOverlay()
    
    init(){
        self.overlayView = UIView()
        self.activityIndicator = UIActivityIndicatorView()
        self.titleLabel = UILabel()
        
        overlayView.frame = CGRect(x: 0, y: 0, width: 300, height: 140)
        overlayView.backgroundColor = UIColor.customRedColor()
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 5
        overlayView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        overlayView.layer.zPosition = 10000
        
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(activityIndicator)
        
        //center the activity indicator in the overlay view (centerY is a bit to the top)
        NSLayoutConstraint(item:activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: overlayView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item:activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: overlayView, attribute: .centerY, multiplier: 1, constant: -10).isActive = true
        
        //set the titlelabel attributes
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.appFont()
        titleLabel.numberOfLines = 0
        titleLabel.text = Strings.loadingTitle
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(titleLabel)
        
        //use VFL to adjust the label (pinned right & left horizontally with the default margin)
        let horizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[label]-|", options:[] , metrics:nil, views:Dictionary(dictionaryLiteral:("label",titleLabel!)))
        //vertically pinned to the bottom of the view with 10 pixels margin
        let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:[label]-10-|", options:[] , metrics:nil, views:Dictionary(dictionaryLiteral:("label",titleLabel!)))
        overlayView.addConstraints(verticalConstraint)
        overlayView.addConstraints(horizontalConstraint)
    }
    
    public func showOverlay(view: UIView) {
        overlayView.center = view.center
        view.addSubview(overlayView)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.overlayView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion:{ _ in
            self.activityIndicator.startAnimating()
        })
        
    }
    
    public func hideOverlayView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.overlayView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }, completion:{ _ in
            self.activityIndicator.stopAnimating()
            self.overlayView.removeFromSuperview()
        })
    }
    
    struct Strings {
        static let loadingTitle = NSLocalizedString("Please Wait\nLoading Data...",comment: "Loading message shown while fetching Data")
    }
}

extension UIColor {
    
    ///Convenience initializer with hex values
    ///Taken from http://stackoverflow.com/a/24263296/312312
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex:Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
    
    class func customBlueColor() -> UIColor {
        return UIColor(hex: 0x1BA3EA)
    }
    
    class func customRedColor() -> UIColor {
        return UIColor(hex: 0xD32F2F)
    }
    
    class func customDarkGray() -> UIColor {
        return UIColor(hex: 0x353535)
    }
    
    class func customLightGray() -> UIColor {
        return UIColor(hex: 0x888888)
    }
    
}

extension UIFont {
    class func appFont() -> UIFont {
        return UIFont(name: "AvenirNext-DemiBold", size: 14.0)!
    }
    class func smallAppFont() -> UIFont {
        return UIFont(name: "AvenirNext-DemiBold", size: 11.0)!
    }
}


extension UIColor {

    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
            
        )
    }
}
