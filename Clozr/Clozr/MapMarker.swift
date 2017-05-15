//
//  MapMarker.swift
//  Clozr
//
//  Created by CK on 5/15/17.
//  Copyright © 2017 Faback. All rights reserved.
//

import Foundation

import MapKit

class MapMarker:MKPointAnnotation {
    
    var user:User?

    init(user:User ) {
        self.user = user

    }
}
