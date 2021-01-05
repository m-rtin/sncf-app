//
//  queries.swift
//  sncf
//
//  Created by Martin Voigt on 30.10.20.
//

import Foundation
import RealmSwift

func getFromCities(tickets: RealmSwift.List<Ticket>) -> [String] {
    var fromCities = [""]
    guard let realm = tickets.realm else {
        return fromCities
    }
    let fromStations = realm.objects(FromStation.self)
    
    for fromStation in fromStations {
        fromCities.append(fromStation.city)
    }
    return fromCities
}

func getToCities(tickets: RealmSwift.List<Ticket>) -> [String] {
    var toCities = [""]
    guard let realm = tickets.realm else {
        return toCities
    }
    let toStations = realm.objects(ToStation.self)
    
    for toStation in toStations {
        toCities.append(toStation.city)
    }
    return toCities
}

func getGivenNameOfClient(tickets: RealmSwift.List<Ticket>) -> String {
    guard let realm = tickets.realm else {
        return ""
    }
    if let user = app.currentUser {
        return realm.objects(Client.self).filter("userId == %@", user.id)[0].givenName
    } else {
        return ""
    }
}

func getNameOfClient(tickets: RealmSwift.List<Ticket>) -> String {
    guard let realm = tickets.realm else {
        return ""
    }
    if let user = app.currentUser {
        return realm.objects(Client.self).filter("userId == %@", user.id)[0].name
    } else {
        return ""
    }
}

func isClientAdult(tickets: RealmSwift.List<Ticket>) -> Bool {
    guard let realm = tickets.realm else {
        return true
    }
    if let user = app.currentUser {
        return realm.objects(Client.self).filter("userId == %@", user.id)[0].adult
    } else {
        return true
    }
    
}

func reductionPercentageOfClient(tickets: RealmSwift.List<Ticket>) -> Int {
    guard let realm = tickets.realm else {
        return 0
    }
    if let user = app.currentUser {
        return realm.objects(Client.self).filter("userId == %@", user.id)[0].reduction[0].percentage
    } else {
        return 0
    }
}

func getAvailableJournies(tickets: RealmSwift.List<Ticket>, fromCity: String, toCity: String) -> Results<Journey> {
    let realm = tickets.realm
    
    let results = realm!.objects(Journey.self).filter("(ANY fromStation.city = '\(fromCity)') AND (ANY toStation.city = '\(toCity)')")
    return results
}

// Count how many free places are left
func getNumberOfDisponiblePlaces(journey: Journey) -> Int {
    var numberOfPlaces = 0
    
    for wagon in journey.train[0].wagons {
        placeLoop: for place in wagon.placesToSit {
            // there is no ticket associated with this place, so it can be used
            if place.tickets.count == 0 {
                numberOfPlaces += 1
            } else {
                for ticket in place.tickets {
                    // this place is already booked for this journey
                    if ticket.journey[0]._id == journey._id {
                        continue placeLoop
                    }
                }
                // this place is already booked for other journies but not for this one, so it can be used
                numberOfPlaces += 1
            }
        }
    }
    
    return numberOfPlaces
}

// A train has wifi if one of his wagons has wifi
func trainHasWifi(train: Train) -> Bool {
    var hasWifi = false
    for wagon in train.wagons {
        if wagon.hasWifi {
            hasWifi = true
        }
    }
    return hasWifi
}

// Apply reduction
func calculateNewPrice(oldPrice: Double, tickets: RealmSwift.List<Ticket>) -> Double {
    guard let realm = tickets.realm else {
        return 0.0
    }
    let reductionPercentage = realm.objects(Client.self).filter("userId == %@", app.currentUser!.id)[0].reduction[0].percentage
    return oldPrice - Double(reductionPercentage)/100.0*oldPrice
}
