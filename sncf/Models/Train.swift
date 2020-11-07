//
//  Train.swift
//  sncf
//
//  Created by Martin Voigt on 30.10.20.
//

import Foundation
import RealmSwift

class Train: Object {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var trainName = ""
    
    let wagons = List<Wagon>()
    let journies = List<Journey>()
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}
