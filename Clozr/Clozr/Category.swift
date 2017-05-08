//
//  Category.swift
//  Clozr
//
//  Created by CK on 5/6/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import Foundation

class Category {
    
    var name:String?
    var imageUrl:String?
    var subCategories = [Category]()
    var code:String?
    
    static var mainCategory = Category()
    static var subCategory = Category()
    
    class func getPlay()->Category {
        let sportsCategory = Category()
        sportsCategory.name = "Play"
        sportsCategory.code = "play"
        sportsCategory.imageUrl = "sports"
        let subCatNames = ["Baseball","Basketball","Football","Ice Hockey", "Bowling","Pool","Badminton","Soccer","Ping Pong","Tennis"]
        for subCat in subCatNames {
            let sub = Category()
            var replaced = subCat.replacingOccurrences(of: " ", with: "")
            replaced = replaced.lowercased()
            sub.name = subCat
            sub.imageUrl = replaced
            sub.code = replaced
            sportsCategory.subCategories.append(sub)
        }
        return sportsCategory
    }
    
    
    class func getWatch()->Category {
        let sportsCategory = Category()
        sportsCategory.name = "Watch"
        sportsCategory.code = "watch"
        sportsCategory.imageUrl = "watch"
        let subCatNames = ["Movies","TV Shows","Game Time"]
        for subCat in subCatNames {
            let sub = Category()
            var replaced = subCat.replacingOccurrences(of: " ", with: "")
            replaced = replaced.lowercased()
            sub.name = subCat
            sub.imageUrl = replaced
            sub.code = replaced
            sportsCategory.subCategories.append(sub)
        }
        return sportsCategory
    }

    
    class func getCatchup()->Category {
        let sportsCategory = Category()
        sportsCategory.name = "Catchup"
        sportsCategory.code = "catchup"
        sportsCategory.imageUrl = "catchup"
        let subCatNames = ["Shopping","Cafe","Restaurants","Gym"]
        for subCat in subCatNames {
            let sub = Category()
            var replaced = subCat.replacingOccurrences(of: " ", with: "")
            replaced = replaced.lowercased()
            sub.name = subCat
            sub.imageUrl = replaced
            sub.code = replaced
            sportsCategory.subCategories.append(sub)
        }
        return sportsCategory
    }
}
