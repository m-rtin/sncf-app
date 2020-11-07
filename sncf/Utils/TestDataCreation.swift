//
//  testData.swift
//  sncf
//
//  Created by Martin Voigt on 06.11.20.
//

import Foundation
import RealmSwift

func createTestData(tickets: RealmSwift.List<Ticket>) {
    guard let realm = tickets.realm else {
        return
    }
    
    // create journey
    let journey1 = Journey()
    let journey2 = Journey()
    let journey3 = Journey()
    journey1.price = 22.35
    journey2.price = 50.62
    journey3.price = 34.89
    
    try! realm.write {
        realm.add(journey1)
        realm.add(journey2)
        realm.add(journey3)
    }
    
    // create places to sit
    for i in 1..<101 {
        let place = PlaceToSit()
        place.placeNumber = i
        if i % 2 == 0 {
            place.windowPlace = true
        } else {
            place.windowPlace = false
        }
        try! realm.write {
            realm.add(place)
        }
    }
    
    // create wagons
    let wagon1 = Wagon()
    wagon1.hasWifi = true
    wagon1.wagonNumber = 42
    let wagon2 = Wagon()
    wagon2.hasWifi = false
    wagon2.wagonNumber = 43
    
    for place in realm.objects(PlaceToSit.self) {
        if place.placeNumber <= 50 {
            wagon1.placesToSit.append(place)
        } else {
            wagon2.placesToSit.append(place)
        }
    }
    
    try! realm.write {
        realm.add(wagon1)
        realm.add(wagon2)
    }
    
    // create train
    let train = Train()
    train.trainName = "Direct TGV INOUI"
    train.wagons.append(wagon1)
    train.wagons.append(wagon2)
    train.journies.append(journey1)
    train.journies.append(journey2)
    
    let train2 = Train()
    train2.trainName = "Direct TER"
    train2.wagons.append(wagon1)
    train2.journies.append(journey3)
    
    try! realm.write {
        realm.add(train)
        realm.add(train2)
    }
    
    // create fromStations
    let marseille = FromStation()
    marseille.city = "Marseille"
    marseille.stationName = "Marseille Saint Charles"
    marseille.latitude = 43.303056
    marseille.longitude = 5.381111
    
    let paris = FromStation()
    paris.city = "Paris"
    paris.stationName = "Paris Gare du Nord"
    paris.latitude = 48.8809
    paris.longitude = 2.3553
    
    // create to Station
    let lyon = ToStation()
    lyon.city = "Lyon"
    lyon.stationName = "Lyon Part Dieu"
    lyon.latitude = 45.760556
    lyon.longitude = 4.859444
    
    marseille.journies.append(journey1)
    lyon.journies.append(journey1)
    
    paris.journies.append(journey2)
    lyon.journies.append(journey2)
    
    paris.journies.append(journey3)
    lyon.journies.append(journey3)
    
    
    try! realm.write {
        realm.add(marseille)
        realm.add(paris)
        realm.add(lyon)
    }
    
}
