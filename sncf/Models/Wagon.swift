//
//  Wagon.swift
//  sncf
//
//  Created by Martin Voigt on 30.10.20.
//

import Foundation
import RealmSwift

class Wagon: Object {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var wagonNumber = 0
    @objc dynamic var hasWifi = false
    
    let train = LinkingObjects(fromType: Train.self, property: "wagons")
    let placesToSit = List<PlaceToSit>()

    override static func primaryKey() -> String? {
        return "_id"
    }
}
