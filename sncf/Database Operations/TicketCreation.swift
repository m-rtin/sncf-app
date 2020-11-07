//
//  ticketCreation.swift
//  sncf
//
//  Created by Martin Voigt on 31.10.20.
//

import Foundation
import RealmSwift

func createNewTicket(journey: Journey, tickets: RealmSwift.List<Ticket>) {
    guard let realm = tickets.realm else {
        return
    }
    let newTicket = Ticket()
    newTicket.price = calculateNewPrice(oldPrice: journey.price, tickets: tickets)
    
    try! realm.write {
        journey.tickets.append(newTicket)
        tickets.realm?.objects(Client.self).filter("userId == %@", app.currentUser!.id)[0].tickets.append(newTicket)
    }
    
    // We search a place for this ticket
    outerLoop: for wagon in journey.train[0].wagons {
        placeLoop: for place in wagon.placesToSit {
            // this place isn't associated with any journey, so we can use it
            if place.tickets.count == 0 {
                try! realm.write {
                    place.tickets.append(newTicket)
                }
                break outerLoop
            } else {
                for ticket in place.tickets {
                    // this place is already booked for this journey
                    if ticket.journey[0]._id == journey._id {
                        continue placeLoop
                    }
                }
                // this place is already booked for other journies but not for this one, so it can be used
                try! realm.write {
                    place.tickets.append(newTicket)
                }
                // we have found a place so we can stop searching
                break outerLoop
            }
        }
    }
    
    try! realm.write {
        realm.add(newTicket)
    }
}

