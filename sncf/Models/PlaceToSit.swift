//
//  PlaceToSit.swift
//  sncf
//
//  Created by Martin Voigt on 30.10.20.
//

import Foundation
import RealmSwift

class PlaceToSit: Object {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var placeNumber = 0
    @objc dynamic var windowPlace = false
    
    let tickets = List<Ticket>()
    let wagon = LinkingObjects(fromType: Wagon.self, property: "placesToSit")
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}
