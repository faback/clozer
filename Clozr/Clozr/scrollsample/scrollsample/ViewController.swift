//
//  ViewController.swift
//  scrollsample
//
//  Created by CK on 5/3/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bigLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bigLabel.text = "asdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfasasdfassadfas"
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidLayoutSubviews()
    {
        let scrollViewBounds = scrollView.bounds
        let containerViewBounds = contentView.bounds
        
        var scrollViewInsets = UIEdgeInsets.zero
        scrollViewInsets.top = scrollViewBounds.size.height/2.0;
        scrollViewInsets.top -= contentView.bounds.size.height/2.0;
        
        scrollViewInsets.bottom = scrollViewBounds.size.height/2.0
        scrollViewInsets.bottom -= contentView.bounds.size.height/2.0;
        scrollViewInsets.bottom += 1
        
        scrollView.contentInset = scrollViewInsets
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

