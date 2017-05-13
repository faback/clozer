//
//  FriendsSectionView.swift
//  Clozr
//
//  Created by CK on 5/13/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit

class FriendsSectionView: UICollectionReusableView {
    
    var titleLabel:UILabel?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSubViews()
        self.autoLayoutSubViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubViews()
        self.autoLayoutSubViews()

    }
    
    func setupSubViews() {
        self.titleLabel = UILabel()
        self.titleLabel!.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel!.font = UIFont.systemFont(ofSize: 12.0)
        self.titleLabel!.textColor = UIColor.greenSea()
        self.addSubview(titleLabel!)
    }
    
    func autoLayoutSubViews(){
        self.titleLabel!.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        self.titleLabel!.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        self.titleLabel!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        self.titleLabel!.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true

    }
}
