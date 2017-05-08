//
//  File.swift
//  Clozr
//
//  Created by CK on 5/6/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import Foundation
import UIKit

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
}



