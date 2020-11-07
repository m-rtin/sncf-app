//
//  AvailableTrainsView.swift
//  sncf
//
//  Created by Martin Voigt on 29.10.20.
//

import SwiftUI
import RealmSwift

struct AvailableTrainsView: View {
    var tickets: RealmSwift.List<Ticket>
    var journies: Results<Journey>
    
    @State var showReservationSheet = false
    
    var body: some View {
        List {
            ForEach(journies, id: \.self) { journey in
                Button(action: {
                    if getNumberOfDisponiblePlaces(journey: journey) > 0 {
                        self.showReservationSheet.toggle()
                    }
                }) {
                    TicketInformationView(journey: journey)
                }.sheet(isPresented: $showReservationSheet) {
                    ReservationView(tickets: tickets, journey: journey)
                }
            }
        }
        .navigationBarTitle(Text("Résultats aller"))

    }
}

