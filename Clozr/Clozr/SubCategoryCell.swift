//
//  SubCategoryCell.swift
//  Clozr
//
//  Created by CK on 5/6/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import UIKit

class SubCategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    
    
    var indexRow:Int?
    
    var category:Category!  {
        didSet {
            if(category != nil) {
                layoutCategory()
            }
        }
        
    }
    
    func layoutCategory() {
        
        categoryTitle.text = category.name
        if(indexRow == 0) {
           tintImage()
        }
        else{
           unTintImage()
        }
    }
    
    func tintImage() {
        let origImage = UIImage(named: category.imageUrl!)
        var tintedImage = origImage?.withRenderingMode(.alwaysOriginal)

        if(category.code != "local") {
            tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        }
        categoryIcon.image = tintedImage
        categoryIcon.tintColor = UIColor(red: 57.0/255.0, green: 101.0/255.0, blue: 169.0/255.0, alpha:1)

    }
    
    func unTintImage() {
        let origImage = UIImage(named: category.imageUrl!)
        categoryIcon.image = origImage
        categoryIcon.tintColor = UIColor.black
        
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

    func selectedIndex(index:Int?){
        indexRow = index
    }
    
    
    override func prepareForReuse() {
        category = nil
       
    }
    
}

    




