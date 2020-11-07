//
//  Station.swift
//  sncf
//
//  Created by Martin Voigt on 30.10.20.
//

import Foundation
import RealmSwift

class ToStation: Object {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var stationName = ""
    @objc dynamic var city = ""
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    
    let journies = List<Journey>()
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}

