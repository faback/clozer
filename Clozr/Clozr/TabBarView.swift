//
//  TabBarView.swift
//  Clozr
//
//  Created by Fateh Singh on 4/27/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit

class TabBarView: UIView {

    @IBOutlet var contentView: UIView!

    required init?(coder aDecoder: NSCoder) {
        //        code
        super.init(coder: aDecoder)
        initSubView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
    }
    
    func initSubView() {
        let nib = UINib(nibName: "TabBar", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame =  bounds
        addSubview(contentView)
    }

}
