//
//  InfiniteScroll.swift
//  Clozr
//
//  Created by Tummala, Balaji on 6/3/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class InfiniteScrollView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    //var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    var activityIndicatorView: NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRect(x:0.0, y:0.0, width:40.0, height:40.0), type: .ballScaleRippleMultiple, color: UIColor(red: 57.0/255.0, green: 101.0/255.0, blue: 169.0/255.0, alpha:1))
    
    static let defaultHeight:CGFloat = 60.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupActivityIndicator()
    }
    
    override init(frame aRect: CGRect) {
        super.init(frame: aRect)
        setupActivityIndicator()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicatorView.center = CGPoint(x: self.bounds.size.width/2 + 15, y: self.bounds.size.height/2)
    }
    
    func setupActivityIndicator() {
       // activityIndicatorView.activityIndicatorViewStyle = .gray
       // activityIndicatorView.hidesWhenStopped = true
        self.addSubview(activityIndicatorView)
    }
    
    func stopAnimating() {
        self.activityIndicatorView.stopAnimating()
        self.isHidden = true
    }
    
    func startAnimating() {
        self.isHidden = false
        self.activityIndicatorView.startAnimating()
    }


}
