//
//  Client.swift
//  sncf
//
//  Created by Martin Voigt on 30.10.20.
//

import Foundation
import RealmSwift

class Client: Object {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var userId = ""
    @objc dynamic var name = ""
    @objc dynamic var givenName = ""
    @objc dynamic var adult = true
    
    let reduction = LinkingObjects(fromType: Reduction.self, property: "clients")
    let tickets = List<Ticket>()
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}
