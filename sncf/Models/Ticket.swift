//
//  Ticket.swift
//  sncf
//
//  Created by Martin Voigt on 30.10.20.
//

import Foundation
import RealmSwift

class Ticket: Object {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var price = 0.0
    
    let journey = LinkingObjects(fromType: Journey.self, property: "tickets")
    let placesToSit = LinkingObjects(fromType: PlaceToSit.self, property: "tickets")
    let client = LinkingObjects(fromType: Client.self, property: "tickets")
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}
