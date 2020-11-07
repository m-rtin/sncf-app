//
//  Reduction.swift
//  sncf
//
//  Created by Martin Voigt on 31.10.20.
//

import Foundation
import RealmSwift

class Reduction: Object {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var reductionName = ""
    @objc dynamic var percentage = 0
    
    let clients = List<Client>()

    override static func primaryKey() -> String? {
        return "_id"
    }
}

