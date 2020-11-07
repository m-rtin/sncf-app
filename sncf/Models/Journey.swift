//
//  Ticket.swift
//  sncf
//
//  Created by Martin Voigt on 29.10.20.
//

import Foundation
import RealmSwift

class Journey: Object {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var fromDate = Date()
    @objc dynamic var toDate = Date()
    @objc dynamic var price = 0.0
    
    let train = LinkingObjects(fromType: Train.self, property: "journies")
    let fromStation = LinkingObjects(fromType: FromStation.self, property: "journies")
    let toStation = LinkingObjects(fromType: ToStation.self, property: "journies")
    
    let tickets = List<Ticket>()
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}


